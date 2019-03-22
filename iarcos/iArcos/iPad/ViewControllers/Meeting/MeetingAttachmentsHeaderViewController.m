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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    self.addButton = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    [FileCommon createFolder:@"photos"];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[GlobalSharedClass shared].errorTitle
                                                        message:@"No camera available"
                                                       delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    // Create image picker controller
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Allow editing of image ?
    imagePicker.allowsEditing = NO;
    
    // Show image picker
    [[self.actionDelegate retrieveParentViewController] presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

#pragma mark image piker delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter Tag for Photo\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self.actionDelegate retrieveParentViewController].view endEditing:YES];
        UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
        [self processTextFieldFileName:myTextField.text didFinishPickingMediaWithInfo:info];
        [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
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
    
    @try {
        NSNumber* fileSequenceNumber = [GlobalSharedClass shared].currentTimeStamp;
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", fileSequenceNumber];
        if (![aTextFieldFileName isEqualToString:@""]) {
            fileName = [NSString stringWithFormat:@"%@_%@.jpg", aTextFieldFileName, fileSequenceNumber];
        }
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon photosPath],fileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
            //            NSNumber* locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            NSNumber* meetingLocationIUR = [self.actionDelegate retrieveMeetingAttachmentsHeaderLocationIUR];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [[ArcosCoreData sharedArcosCoreData] insertCollectedWithLocationIUR:meetingLocationIUR comments:fileName iUR:[NSNumber numberWithInt:0] date:[NSDate date]];
            [self.actionDelegate addMeetingAttachmentsRecordWithFileName:fileName];
        } else {
            [ArcosUtils showMsg:-1 message:@"The photo has not been saved." delegate:nil];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
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
