//
//  CustomerPhotoSlideViewController.m
//  Arcos
//
//  Created by David Kilmartin on 13/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerPhotoSlideViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ArcosRootViewController.h"
@interface CustomerPhotoSlideViewController ()
- (void)alignSubviews;
- (void)redisplayPhoto;
- (BOOL)validateHiddenPopovers;
- (void)alertViewCallBack;
@end

@implementation CustomerPhotoSlideViewController
@synthesize delegate = _delegate;
@synthesize animateDelegate = _animateDelegate;
@synthesize customerPhotoSlideDataManager = _customerPhotoSlideDataManager;
@synthesize locationIUR = _locationIUR;
@synthesize myScrollView = _myScrollView;
@synthesize emailButton = _emailButton;
@synthesize trashButton = _trashButton;
@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize mailController = _mailController;
@synthesize trashPopover = _trashPopover;
@synthesize cameraRollButton = _cameraRollButton;
@synthesize cameraRollPopover = _cameraRollPopover;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.customerPhotoSlideDataManager != nil) { self.customerPhotoSlideDataManager = nil; }
    if (self.myScrollView != nil) { self.myScrollView = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.trashButton != nil) { self.trashButton = nil; }    
    if (self.emailPopover != nil) { self.emailPopover = nil; }   
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.mailController != nil) { self.mailController = nil; }
    if (self.trashPopover != nil) { self.trashPopover = nil; }
    if (self.cameraRollButton != nil) { self.cameraRollButton = nil; }
    if (self.cameraRollPopover != nil) { self.cameraRollPopover = nil; }
    self.globalNavigationController = nil;
    self.rootView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.#d3d7dd
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
//    self.emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(emailButtonPressed:)];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    
    self.trashButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonPressed:)] autorelease];
    
    self.cameraRollButton = [[[UIBarButtonItem alloc] initWithTitle:@"Camera Roll" style:UIBarButtonItemStylePlain target:self action:@selector(cameraRollPressed:)] autorelease];
    [rightButtonList addObject:self.trashButton];
    [rightButtonList addObject:self.emailButton];
    [rightButtonList addObject:self.cameraRollButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    
    self.customerPhotoSlideDataManager = [[[CustomerPhotoSlideDataManager alloc] initWithLocationIUR:self.locationIUR] autorelease];
    [self.customerPhotoSlideDataManager createPhotoSlideBasicData];
    if ([self.customerPhotoSlideDataManager.displayList count] > 0) {
        [self.customerPhotoSlideDataManager createPhotoSlideViewItemData];
    }
    
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.locationIUR = self.locationIUR;
    emailRecipientTableViewController.requestSource = EmailRequestSourcePhoto;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];
    [emailRecipientTableViewController release];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    CustomerPhotoDeleteActionViewController* cpdavc = [[CustomerPhotoDeleteActionViewController alloc] initWithNibName:@"CustomerPhotoDeleteActionViewController" bundle:nil];
    cpdavc.actionDelegate = self;
    self.trashPopover = [[[UIPopoverController alloc] initWithContentViewController:cpdavc] autorelease];
    self.trashPopover.popoverContentSize = cpdavc.view.frame.size;
    [cpdavc release];
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.rootView = [ArcosUtils getRootView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.trashButton != nil) { self.trashButton = nil; }    
    if (self.emailPopover != nil) { self.emailPopover = nil; }   
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.mailController != nil) { self.mailController = nil; }
    if (self.trashPopover != nil) { self.trashPopover = nil; }
    if (self.customerPhotoSlideDataManager != nil) { self.customerPhotoSlideDataManager = nil; }    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.customerPhotoSlideDataManager.displayList count] == 0) {
        [ArcosUtils showDialogBox:@"No data found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        return;
    }
    for (int i = 0; i < [self.customerPhotoSlideDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerPhotoSlideDataManager.slideViewItemList objectAtIndex:i];
        [self.myScrollView addSubview:aPSVIC.view];
        [self.customerPhotoSlideDataManager fillPhotoSlideViewItem:aPSVIC index:i];
    }
    
    [self alignSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUInteger length = [[self.myScrollView subviews] count];
//    NSLog(@"self.myScrollView length: %d", length);
    for (int i = 0; i < length; i++) {
        UIView* tmpView = [[self.myScrollView subviews] lastObject];
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < [self.customerPhotoSlideDataManager.slideViewItemList count]; i++) {
        [self.customerPhotoSlideDataManager emptyPhotoSlideViewItemWithIndex:i];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
//    NSLog(@"%@",NSStringFromCGRect(self.myScrollView.bounds));
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
	self.myScrollView.contentOffset = CGPointMake(self.customerPhotoSlideDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}

-(void)backPressed:(id)sender {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//    }
    [self validateHiddenPopovers];
//    [self.delegate didDismissPresentView];
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (BOOL)validateHiddenPopovers {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return NO;
    }
    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
        [self.trashPopover dismissPopoverAnimated:YES];
        return NO;
    }
    if (self.cameraRollPopover != nil && [self.cameraRollPopover isPopoverVisible]) {
        [self.cameraRollPopover dismissPopoverAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)alignSubviews {
	// Position all the content views at their respective page positions
//    self.myScrollView.frame = self.view.frame;
//    NSLog(@"allign self frame is %f  %f  %f  %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//    NSLog(@"allign subview scrolling view bound is %f  %f  %f  %f",self.myScrollView.bounds.origin.x,self.myScrollView.bounds.origin.y,self.myScrollView.bounds.size.width,self.myScrollView.bounds.size.height);
//    NSLog(@"alignSubviews: %d,%d", [self.customerPhotoSlideDataManager.displayList count], [self.customerPhotoSlideDataManager.slideViewItemList count]);
	self.myScrollView.contentSize = CGSizeMake([self.customerPhotoSlideDataManager.displayList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    for (int i = 0; i < [self.customerPhotoSlideDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerPhotoSlideDataManager.slideViewItemList objectAtIndex:i];
        aPSVIC.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0, self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{    
//    self.customerPhotoSlideDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
//    
//    NSLog(@"current page is %d",self.customerPhotoSlideDataManager.currentPage);
//    NSLog(@"scrollViewDidScroll %@",NSStringFromCGPoint(self.myScrollView.contentOffset));
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDragging %@",NSStringFromCGPoint(self.myScrollView.contentOffset));
//    NSLog(@"scrollViewWillBeginDragging: %d",self.customerPhotoSlideDataManager.currentPage);
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating %@",NSStringFromCGPoint(self.myScrollView.contentOffset));
    self.customerPhotoSlideDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
    
//    NSLog(@"current page is %d",self.customerPhotoSlideDataManager.currentPage);
//    NSLog(@"scrollViewDidEndDecelerating: %d",self.customerPhotoSlideDataManager.currentPage);
}

-(void)emailButtonPressed:(id)sender {
//    NSLog(@"emailButtonPressed");
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
    if (![self validateHiddenPopovers]) return;
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)trashButtonPressed:(id)sender {
//    NSLog(@"trashButtonPressed");
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    if (self.trashPopover != nil && [self.trashPopover isPopoverVisible]) {
//        [self.trashPopover dismissPopoverAnimated:YES];
//        return;
//    }
    if (![self validateHiddenPopovers]) return;
    [self.trashPopover presentPopoverFromBarButtonItem:self.trashButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)cameraRollPressed:(id)sender {
//    if (self.cameraRollPopover != nil && [self.cameraRollPopover isPopoverVisible]) {
//        [self.cameraRollPopover dismissPopoverAnimated:YES];
//        return;
//    }
    if (![self validateHiddenPopovers]) return;
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
    }
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    self.cameraRollPopover = [[[UIPopoverController alloc] initWithContentViewController:imagePickerController] autorelease];
    [imagePickerController release];
    [self.cameraRollPopover presentPopoverFromBarButtonItem:self.cameraRollButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [FileCommon createFolder:@"photos"];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    @try {
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg",[GlobalSharedClass shared].currentTimeStamp];
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon photosPath],fileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
            [[ArcosCoreData sharedArcosCoreData] insertCollectedWithLocationIUR:self.locationIUR comments:fileName iUR:[NSNumber numberWithInt:0] date:[NSDate date]];
            [ArcosUtils showDialogBox:@"The photo has been saved." title:@"" delegate:self target:self.cameraRollPopover.contentViewController tag:88 handler:^(UIAlertAction *action) {
                [self.cameraRollPopover dismissPopoverAnimated:YES];
            }];
            [self redisplayPhoto];
        } else {
            [ArcosUtils showDialogBox:@"The photo has not been saved." title:[GlobalSharedClass shared].errorTitle delegate:self target:self.cameraRollPopover.contentViewController tag:88 handler:^(UIAlertAction *action) {
                [self.cameraRollPopover dismissPopoverAnimated:YES];
                self.cameraRollPopover = nil;
            }];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:[GlobalSharedClass shared].errorTitle delegate:self target:self.cameraRollPopover.contentViewController tag:88 handler:^(UIAlertAction *action) {
            [self.cameraRollPopover dismissPopoverAnimated:YES];
            self.cameraRollPopover = nil;
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.cameraRollPopover dismissPopoverAnimated:YES];
    self.cameraRollPopover = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)redisplayPhoto {
    NSUInteger length = [[self.myScrollView subviews] count];
    for (int i = 0; i < length; i++) {
        UIView* tmpView = [[self.myScrollView subviews] lastObject];
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < [self.customerPhotoSlideDataManager.slideViewItemList count]; i++) {
        [self.customerPhotoSlideDataManager emptyPhotoSlideViewItemWithIndex:i];
    }
    
    self.customerPhotoSlideDataManager = [[[CustomerPhotoSlideDataManager alloc] initWithLocationIUR:self.locationIUR] autorelease];
    [self.customerPhotoSlideDataManager createPhotoSlideBasicData];
    if ([self.customerPhotoSlideDataManager.displayList count] > 0) {
        [self.customerPhotoSlideDataManager createPhotoSlideViewItemData];
    }
    
    if ([self.customerPhotoSlideDataManager.displayList count] == 0) {
        return;
    }
    for (int i = 0; i < [self.customerPhotoSlideDataManager.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerPhotoSlideDataManager.slideViewItemList objectAtIndex:i];
        [self.myScrollView addSubview:aPSVIC.view];
        [self.customerPhotoSlideDataManager fillPhotoSlideViewItem:aPSVIC index:i];
    }
    
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointZero;
}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSString* email = [cellData objectForKey:@"Email"];
    NSMutableArray* toRecipients = [NSMutableArray array];
    if (email != nil && ![[ArcosUtils trim:email] isEqualToString:@""]) {
        toRecipients = [NSMutableArray arrayWithObjects:email, nil];
    }
    NSMutableArray* dataList = [NSMutableArray array];
    if ([self.customerPhotoSlideDataManager.displayList count] > 0) {
        NSDictionary* collectedDict = [self.customerPhotoSlideDataManager.displayList objectAtIndex:self.customerPhotoSlideDataManager.currentPage];
        NSString* fileName = [collectedDict objectForKey:@"Comments"];
        NSString* filePath = [self.customerPhotoSlideDataManager getFilePathWithFileName:fileName];
        if ([FileCommon fileExistAtPath:filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:filePath];
            if (data != nil) {
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                    [dataList addObject:[ArcosAttachmentContainer attachmentWithData:data fileName:fileName]];
                } else {
                    [dataList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
                }
                
            }            
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = self.title;
        if ([dataList count] > 0) {
            amwvc.attachmentList = dataList;
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            [self.emailPopover dismissPopoverAnimated:YES];
        }];
        return;
    }
    
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
//    [self.emailPopover dismissPopoverAnimated:YES];
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    @try {
//        if ([self.customerPhotoSlideDataManager.displayList count] > 0) {
//            NSDictionary* collectedDict = [self.customerPhotoSlideDataManager.displayList objectAtIndex:self.customerPhotoSlideDataManager.currentPage];
//            NSString* fileName = [collectedDict objectForKey:@"Comments"];
//            NSString* filePath = [self.customerPhotoSlideDataManager getFilePathWithFileName:fileName];
//            if ([FileCommon fileExistAtPath:filePath]) {
//                NSData* data = [NSData dataWithContentsOfFile:filePath];
//                [self.mailController addAttachmentData:data mimeType:@"image/png" fileName:fileName];
//            }
//        }
        if ([dataList count] > 0) {
            for (int i = 0; i < [dataList count]; i++) {
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                    ArcosAttachmentContainer* auxAttachmentContainer = [dataList objectAtIndex:i];
                    [self.mailController addAttachmentData:auxAttachmentContainer.fileData mimeType:@"image/png" fileName:auxAttachmentContainer.fileName];
                } else {
                    MCOAttachment* auxAttachment = [dataList objectAtIndex:i];
                    [self.mailController addAttachmentData:auxAttachment.data mimeType:@"image/png" fileName:auxAttachment.filename];
                }
            }
        }
        [self.mailController setToRecipients:toRecipients];
        [self.mailController setSubject:self.title];
        [self.emailPopover.contentViewController presentViewController:self.mailController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:self target:self.emailPopover.contentViewController tag:99 handler:^(UIAlertAction *action) {
            [self.emailPopover dismissPopoverAnimated:YES];
        }];
    }
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = @"";
    NSString* title = @"";
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
            title = @"App Email";
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            title = [GlobalSharedClass shared].errorTitle;
        }
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    if (result != MFMailComposeResultFailed) {
        [self alertViewCallBack];
    } else {
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:0 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertViewCallBack {
    [self.emailPopover.contentViewController dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
        [self.emailPopover dismissPopoverAnimated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        [self.emailPopover dismissPopoverAnimated:YES];
    } else if (alertView.tag == 88) {
        [self.cameraRollPopover dismissPopoverAnimated:YES];
    } else {
        [self alertViewCallBack];
    }
    
}

#pragma mark - CustomerPhotoDeleteActionViewControllerDelegate
- (void)didPressDeleteButton:(int)aTag {
//    NSLog(@"didPressDeleteButton: %d", aTag);
    [self.trashPopover dismissPopoverAnimated:YES];
    if ([self.customerPhotoSlideDataManager.displayList count] > 0) {
        NSUInteger displayListCount = [self.customerPhotoSlideDataManager.displayList count];
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.customerPhotoSlideDataManager.slideViewItemList objectAtIndex:self.customerPhotoSlideDataManager.currentPage];
        [UIView beginAnimations:@"CurlUp" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.myScrollView cache:YES];
        [aPSVIC.view removeFromSuperview];
        [UIView commitAnimations];
        [self.customerPhotoSlideDataManager deleteCollectedRecordWithCurrentPage:self.customerPhotoSlideDataManager.currentPage];        
        [self.customerPhotoSlideDataManager.slideViewItemList removeObjectAtIndex:self.customerPhotoSlideDataManager.currentPage];
        [self.customerPhotoSlideDataManager deleteCollectedFileWithCurrentPage:self.customerPhotoSlideDataManager.currentPage];
        [self.customerPhotoSlideDataManager updateResponseRecordWithCurrentPage:self.customerPhotoSlideDataManager.currentPage];
        [self.customerPhotoSlideDataManager.displayList removeObjectAtIndex:self.customerPhotoSlideDataManager.currentPage];
        [self alignSubviews];        
        if (self.customerPhotoSlideDataManager.currentPage == displayListCount - 1) {
            self.customerPhotoSlideDataManager.currentPage--; 
        }
    }
}

@end
