//
//  CustomerSurveyPreviewPhotoViewController.m
//  iArcos
//
//  Created by David Kilmartin on 27/04/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyPreviewPhotoViewController.h"

@interface CustomerSurveyPreviewPhotoViewController ()

- (NSString*)filePathWithFileName:(NSString*)aFileName;
- (void)alignSubviews;
- (void)redisplayPhoto;
@end

@implementation CustomerSurveyPreviewPhotoViewController
@synthesize myDelegate = _myDelegate;
@synthesize actionDelegate = _actionDelegate;
@synthesize myImageView = _myImageView;
@synthesize myFileNamesStr = _myFileNamesStr;
@synthesize myIndexPath = _myIndexPath;
@synthesize deleteBarButton = _deleteBarButton;
//@synthesize trashPopover = _trashPopover;
@synthesize cpdavc = _cpdavc;
@synthesize myScrollView = _myScrollView;
@synthesize myFileNameList = _myFileNameList;
@synthesize customerSurveyPreviewDataManager = _customerSurveyPreviewDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.customerSurveyPreviewDataManager = [[[CustomerSurveyPreviewDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    [ArcosUtils configEdgesForExtendedLayout:self];
//    self.myImageView.image = [UIImage imageWithContentsOfFile:[self filePathWithFileName:self.myFileName]];
    UIBarButtonItem* doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.leftBarButtonItem = doneBarButton;
    [doneBarButton release];
    
    NSMutableArray* buttonList = [NSMutableArray arrayWithCapacity:2];
    self.deleteBarButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonPressed:)] autorelease];
    [buttonList addObject:self.deleteBarButton];
    UIBarButtonItem* cameraBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(cameraButtonPressed:)];
    [buttonList addObject:cameraBarButton];
    [cameraBarButton release];
    self.navigationItem.rightBarButtonItems = buttonList;
    
    self.cpdavc = [[[CustomerPhotoDeleteActionViewController alloc] initWithNibName:@"CustomerPhotoDeleteActionViewController" bundle:nil] autorelease];
    self.cpdavc.actionDelegate = self;
    self.cpdavc.preferredContentSize = self.cpdavc.view.frame.size;
//    self.trashPopover = [[[UIPopoverController alloc] initWithContentViewController:cpdavc] autorelease];
//    self.trashPopover.popoverContentSize = cpdavc.view.frame.size;
//    [cpdavc release];
    [self.customerSurveyPreviewDataManager createPhotoSlideBasicDataWithAnswer:self.myFileNamesStr];
    [self.customerSurveyPreviewDataManager createPhotoSlideViewItemData];
}

- (void)dealloc {
    self.myImageView = nil;
    self.myFileNamesStr = nil;
    self.myIndexPath = nil;
    self.deleteBarButton = nil;
//    self.trashPopover = nil;
    self.cpdavc = nil;
    self.myScrollView = nil;
    self.myFileNameList = nil;
    self.customerSurveyPreviewDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
//        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:i];        
//        [self.customerSurveyPreviewDataManager fillPhotoSlideViewItem:aPSVIC index:i];
//    }
    NSUInteger length = [[self.myScrollView subviews] count];
    for (int i = 0; i < length; i++) {
        UIView* tmpView = [[self.myScrollView subviews] lastObject];
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:i];
        [self.myScrollView addSubview:aPSVIC.view];
        [self.customerSurveyPreviewDataManager fillPhotoSlideViewItem:aPSVIC index:i];
    }
    [self alignSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSUInteger length = [[self.myScrollView subviews] count];
    for (int i = 0; i < length; i++) {
        UIView* tmpView = [[self.myScrollView subviews] lastObject];
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
        [self.customerSurveyPreviewDataManager emptyPhotoSlideViewItemWithIndex:i];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self alignSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.customerSurveyPreviewDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

- (NSString*)filePathWithFileName:(NSString*)aFileName {
    return [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], aFileName];
}

- (void)doneButtonPressed:(id)sender {
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//    }
    [self.myDelegate didDismissCustomisePresentView];
}

- (void)cameraButtonPressed:(id)sender {
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//        return;
//    }
    //check is camera avaliable
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [ArcosUtils showDialogBox:@"No camera available" title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    // Create image picker controller
    [self.actionDelegate configImagePickerDisplayFlag:YES];
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    BOOL alertShowedFlag = NO;
    // Save image
    @try {        
        NSString* auxFileName = [NSString stringWithFormat:@"%@.jpg",[GlobalSharedClass shared].currentTimeStamp];
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon surveyPath],auxFileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
//            [self.actionDelegate retakePhotoWithIndexPath:self.myIndexPath currentFileName:fileName previousFileName:self.myFileName];
//            self.myFileName = fileName;
//            self.myImageView.image = [UIImage imageWithContentsOfFile:[self filePathWithFileName:self.myFileName]];             
            [self.customerSurveyPreviewDataManager.displayList insertObject:auxFileName atIndex:0];
            NSString* auxCurrentFileName = [self.customerSurveyPreviewDataManager.displayList componentsJoinedByString:[GlobalSharedClass shared].fieldDelimiter];
            [self.actionDelegate takePhotoWithIndexPath:self.myIndexPath currentFileName:auxCurrentFileName];
            [self redisplayPhoto];
        }
    }
    @catch (NSException *exception) {
//        [ArcosUtils showMsg:[exception reason] delegate:nil];
        alertShowedFlag = YES;
        [ArcosUtils showDialogBox:[exception reason] title:@"" target:picker handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (!alertShowedFlag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void)deleteButtonPressed:(id)sender {
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    [self.trashPopover presentPopoverFromBarButtonItem:self.deleteBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.cpdavc.modalPresentationStyle = UIModalPresentationPopover;
    self.cpdavc.popoverPresentationController.barButtonItem = self.deleteBarButton;
    self.cpdavc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.cpdavc animated:YES completion:nil];
}

#pragma mark CustomerPhotoDeleteActionViewControllerDelegate
- (void)didPressDeleteButton:(int)aTag {
//    [self.trashPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.myImageView.image == nil) return;
    /*come back later
    [UIView beginAnimations:@"CurlUp" context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.myImageView cache:YES];
    self.myImageView.image = nil;
    [self.actionDelegate deletePhotoWithIndexPath:self.myIndexPath currentFileName:self.myFileName];
    [UIView commitAnimations];
    */
    if ([self.customerSurveyPreviewDataManager.displayList count] > 0) {
        int displayListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.customerSurveyPreviewDataManager.displayList count]];
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:self.customerSurveyPreviewDataManager.currentPage];
        [UIView beginAnimations:@"CurlUp" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.myScrollView cache:YES];
        [aPSVIC.view removeFromSuperview];        
        [UIView commitAnimations];
        NSString* auxFileName = [self.customerSurveyPreviewDataManager.displayList objectAtIndex:self.customerSurveyPreviewDataManager.currentPage];
        NSString* auxFilePath = [self.customerSurveyPreviewDataManager filePathWithFileName:auxFileName];
        [FileCommon removeFileAtPath:auxFilePath];
        [self.customerSurveyPreviewDataManager.slideViewItemList removeObjectAtIndex:self.customerSurveyPreviewDataManager.currentPage];
        [self.customerSurveyPreviewDataManager.displayList removeObjectAtIndex:self.customerSurveyPreviewDataManager.currentPage];
        NSString* auxCurrentFileName = [self.customerSurveyPreviewDataManager.displayList componentsJoinedByString:[GlobalSharedClass shared].fieldDelimiter];
        [self.actionDelegate deletePhotoWithIndexPath:self.myIndexPath currentFileName:auxCurrentFileName];
        [self alignSubviews];
        if (self.customerSurveyPreviewDataManager.currentPage == displayListCount - 1) {
            self.customerSurveyPreviewDataManager.currentPage--; 
        }
    }
}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.customerSurveyPreviewDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);    
    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:i];
        aPSVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    }
}

- (void)redisplayPhoto {
    NSUInteger length = [[self.myScrollView subviews] count];
    for (int i = 0; i < length; i++) {
        UIView* tmpView = [[self.myScrollView subviews] lastObject];
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
        [self.customerSurveyPreviewDataManager emptyPhotoSlideViewItemWithIndex:i];
    }
    
    [self.customerSurveyPreviewDataManager createPhotoSlideViewItemData];
//    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
//        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:i];
//        [self.customerSurveyPreviewDataManager fillPhotoSlideViewItem:aPSVIC index:i];
//    }
    for (int i = 0; i < [self.customerSurveyPreviewDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerSurveyPreviewDataManager.slideViewItemList objectAtIndex:i];
        [self.myScrollView addSubview:aPSVIC.view];
        [self.customerSurveyPreviewDataManager fillPhotoSlideViewItem:aPSVIC index:i];
    }
    
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointZero;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.customerSurveyPreviewDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
}

@end
