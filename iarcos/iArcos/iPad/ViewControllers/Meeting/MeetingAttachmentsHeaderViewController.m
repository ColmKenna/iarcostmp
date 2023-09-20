//
//  MeetingAttachmentsHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsHeaderViewController.h"

@interface MeetingAttachmentsHeaderViewController ()

@end

@implementation MeetingAttachmentsHeaderViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize addButton = _addButton;
@synthesize imagePicker = _imagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.addButton = nil;
    self.imagePicker = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    [FileCommon createFolder:@"photos"];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[GlobalSharedClass shared].errorTitle
//                                                        message:@"No camera available"
//                                                       delegate:nil cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        [ArcosUtils showDialogBox:@"No camera available" title:[GlobalSharedClass shared].errorTitle target:self handler:nil];
        return;
    }
    // Create image picker controller
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    
    // Set source to the camera
    self.imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    self.imagePicker.delegate = self;
    
    // Allow editing of image ?
    self.imagePicker.allowsEditing = NO;
    
    // Show image picker
    [[self.actionDelegate retrieveParentViewController] presentViewController:self.imagePicker animated:YES completion:nil];
//    [imagePicker release];
}

#pragma mark image piker delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter Tag for Photo\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self.actionDelegate retrieveParentViewController].view endEditing:YES];
        UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
        [self processTextFieldFileName:myTextField.text didFinishPickingMediaWithInfo:info];
//        [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [tmpDialogBox addAction:cancelAction];
    [tmpDialogBox addAction:okAction];
    [tmpDialogBox addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Allows HQ to Filter Photos";
        textField.delegate = self;
    }];
    [picker presentViewController:tmpDialogBox animated:YES completion:nil];
    // Access the uncropped image from info dictionary
    
    
}

- (void)processTextFieldFileName:(NSString*)aTextFieldFileName didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    BOOL alertShowedFlag = NO;
    @try {
        NSNumber* fileSequenceNumber = [GlobalSharedClass shared].currentTimeStamp;
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", fileSequenceNumber];
        if (![aTextFieldFileName isEqualToString:@""]) {
            fileName = [NSString stringWithFormat:@"%@_%@.jpg", aTextFieldFileName, fileSequenceNumber];
        }
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon meetingPath],fileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self.actionDelegate addMeetingAttachmentsRecordWithFileName:fileName];
        } else {
//            [ArcosUtils showMsg:-1 message:@"The photo has not been saved." delegate:nil];
            alertShowedFlag = YES;
            [ArcosUtils showDialogBox:@"The photo has not been saved." title:[ArcosUtils retrieveTitleWithCode:-1] target:self.imagePicker handler:^(UIAlertAction *action) {
                [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }
    @catch (NSException *exception) {
//        [ArcosUtils showMsg:[exception reason] delegate:nil];
        alertShowedFlag = YES;
        [ArcosUtils showDialogBox:[exception reason] title:@"" target:self.imagePicker handler:^(UIAlertAction *action) {
            [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (!alertShowedFlag) {
        [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    NSCharacterSet* nonLetterSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    return ([string stringByTrimmingCharactersInSet:nonLetterSet].length > 0 || [string isEqualToString:@""]) && newLength <= [GlobalSharedClass shared].customerRefMaxLength;
}



@end
