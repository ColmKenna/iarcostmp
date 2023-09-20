//
//  CustomerAccountOverviewViewController.m
//  Arcos
//
//  Created by David Kilmartin on 10/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerAccountOverviewViewController.h"
#import "ArcosRootViewController.h"

@interface CustomerAccountOverviewViewController ()
- (void)alertViewCallBack;
- (void)alignSubviews;
@end

@implementation CustomerAccountOverviewViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize locationIUR = _locationIUR;
@synthesize locationCode = _locationCode;
@synthesize myWebView = _myWebView;
@synthesize callGenericServices = _callGenericServices;
//@synthesize fileName = _fileName;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
//@synthesize filePath = _filePath;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
//@synthesize emailPopover = _emailPopover;
@synthesize emailButton = _emailButton;
@synthesize mailController = _mailController;
@synthesize myRootViewController = _myRootViewController;
@synthesize myScrollView = _myScrollView;
@synthesize displayList = _displayList;
@synthesize viewItemControllerList = _viewItemControllerList;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize currentPage = _currentPage;
@synthesize rowPointer = _rowPointer;
@synthesize overviewFolderName = _overviewFolderName;
@synthesize globalNavigationController = _globalNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.locationIUR = nil;
    self.locationCode = nil;
    self.myWebView = nil;
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
//    self.fileName = nil;
//    self.filePath = nil;
    if (self.emailRecipientTableViewController != nil) { self.emailRecipientTableViewController = nil; }
//    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.mailController != nil) { self.mailController = nil; }
    for (int i = 0; i < [self.viewItemControllerList count]; i++) {
        UIViewController* myViewController = [self.viewItemControllerList objectAtIndex:i];
        [myViewController willMoveToParentViewController:nil];
        [myViewController.view removeFromSuperview];
        [myViewController removeFromParentViewController];
    }
    self.myRootViewController = nil;
    self.myScrollView = nil;
    self.displayList = nil;
    self.viewItemControllerList = nil;
    self.arcosRootViewController = nil;
    self.overviewFolderName = nil;
    self.globalNavigationController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.overviewFolderName = @"overview";
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [ArcosUtils configEdgesForExtendedLayout:self];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
//    self.fileName = [NSString stringWithFormat:@"%@.pdf", self.locationIUR];
//    self.filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon overviewPath], self.fileName];
    [FileCommon createFolder:self.overviewFolderName];
//    [FileCommon removeFileAtPath:self.filePath];
    
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.emailButton;
    self.displayList = [NSMutableArray array];  
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)displayFileOnCanvas {
    self.viewItemControllerList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        GenericWebViewItemViewController* gwvivc = [[GenericWebViewItemViewController alloc] initWithNibName:@"GenericWebViewItemViewController" bundle:nil];        
        [self.viewItemControllerList addObject:gwvivc];
        [self.myScrollView addSubview:gwvivc.view];
        NSString* fileName = [self.displayList objectAtIndex:i];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon overviewPath], fileName];
        [gwvivc loadContentWithPath:filePath];
        [gwvivc didMoveToParentViewController:self];
        [gwvivc release];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self alignSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if ([self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.isNotRecursion = NO;
    self.rowPointer = 0;
    [self.callGenericServices genericGet_Resource_FilenamesByLocation:[self.locationIUR intValue] locationCode:self.locationCode action:@selector(setGenericGet_Resource_FilenamesByLocationResult:) target:self];
}

- (void)setGenericGet_Resource_FilenamesByLocationResult:(id)aResult {
    aResult = [self.callGenericServices handleResultErrorProcess:aResult];
    if (aResult == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }    
    self.displayList = [NSMutableArray array];
    NSMutableArray* resultList = (NSMutableArray*)aResult;
    for (int i = 0; i < [resultList count]; i++) {
        [self.displayList addObject:[NSString stringWithFormat:@"%@.pdf", [resultList objectAtIndex:i]]];
    }
    if (self.rowPointer >= [self.displayList count]) {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showDialogBox:@"No data found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    [self downloadFileFromServer];
}

- (void)downloadFileFromServer {
    NSString* auxFileName = [self.displayList objectAtIndex:self.rowPointer];
    [self.callGenericServices genericGetFromResourcesWithFileName:auxFileName action:@selector(setGenericGetFromResourcesResult:) target:self];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.currentPage * self.myScrollView.bounds.size.width, 0);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self alignSubviews];
}

- (void)setGenericGetFromResourcesResult:(id)result {
    NSString* auxFileName = [self.displayList objectAtIndex:self.rowPointer];
    BOOL successFlag = YES;
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@ %@",[anError localizedDescription], auxFileName] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        successFlag = NO;
    } else if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@ %@",[aSoapFault faultString], auxFileName] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        successFlag = NO;
    }
    
    BOOL saveFileFlag = NO;
    if (successFlag) {
        @try {
            NSString* auxFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon overviewPath], [self.displayList objectAtIndex:self.rowPointer]];
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            saveFileFlag = [myNSData writeToFile:auxFilePath atomically:YES];
            if (saveFileFlag) {
                
            } else {
                [ArcosUtils showDialogBox:@"Unable to save the file on the iPad." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
            }
        } @catch (NSException *exception) {
            [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
//        ArcosGetFromResourcesResult* arcosGetFromResourcesResult = (ArcosGetFromResourcesResult*)result;
//        if (arcosGetFromResourcesResult.ErrorModel.Code > 0) {
//            saveFileFlag = [arcosGetFromResourcesResult.FileContents writeToFile:auxFilePath atomically:YES];
//
//        } else {
//            [ArcosUtils showDialogBox:arcosGetFromResourcesResult.ErrorModel.Message title:@"" delegate:nil target:self tag:0 handler:nil];
//        }
    } else {
    }
    self.rowPointer++;
    if (self.rowPointer >= [self.displayList count]) {
        [self displayFileOnCanvas];
        [self alignSubviews];
        [self.callGenericServices.HUD hide:YES];
    } else {
        [self downloadFileFromServer];
    }
}

-(void)closePressed:(id)sender {
    [FileCommon removeAllFileUnderFolder:self.overviewFolderName];
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)emailButtonPressed:(id)sender{
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = self.locationIUR;
    self.emailRecipientTableViewController.requestSource = EmailRequestSourceAccountOverview;
    self.emailRecipientTableViewController.recipientDelegate = self;
    UINavigationController* emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
//    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:emailNavigationController] autorelease];
    
//    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    
//    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    emailNavigationController.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
    emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    emailNavigationController.popoverPresentationController.barButtonItem = self.emailButton;
    emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:emailNavigationController animated:YES completion:nil];
}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSString* email = [cellData objectForKey:@"Email"];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:email, nil];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = self.title;
        for (int i = 0; i < [self.displayList count]; i++) {
            NSString* auxFileName = [self.displayList objectAtIndex:i];
            NSData* auxNSData = [self retrieveNSDataWithFileName:auxFileName];
            if (auxNSData == nil) continue;
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:auxNSData fileName:auxFileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:auxNSData filename:auxFileName]];
            }           
            
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.myRootViewController addChildViewController:self.globalNavigationController];
        [self.myRootViewController.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
//            if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//                [self.emailPopover dismissPopoverAnimated:YES];
//                return;
//            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    if (![MFMailComposeViewController canSendMail]) {
        [self dismissViewControllerAnimated:NO completion:^ {
            [ArcosUtils showDialogBox:[GlobalSharedClass shared].noMailAcctMsg title:[GlobalSharedClass shared].noMailAcctTitle target:self handler:nil];
        }];
        return;
    }
//    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
//    [self.emailPopover dismissPopoverAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    @try {
        for (int i = 0; i < [self.displayList count]; i++) {
            NSString* auxFileName = [self.displayList objectAtIndex:i];
//            NSString* auxFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon overviewPath], auxFileName];
//            if ([FileCommon fileExistAtPath:auxFilePath]) {
//                NSData* data = [NSData dataWithContentsOfFile:auxFilePath];
//                [self.mailController addAttachmentData:data mimeType:@"application/pdf" fileName:auxFileName];                
//            }
            NSData* data = [self retrieveNSDataWithFileName:auxFileName];
            if (data == nil) continue;
            [self.mailController addAttachmentData:data mimeType:@"application/pdf" fileName:auxFileName];
        }
        [self.mailController setToRecipients:toRecipients];
        [self.mailController setSubject:self.title];
//        [self.emailPopover.contentViewController presentViewController:self.mailController animated:YES completion:nil];
        [self presentViewController:self.mailController animated:YES completion:^ {
            
        }];        
    }
    @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:self target:self tag:99 handler:^(UIAlertAction *action) {
//            [self.emailPopover dismissPopoverAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (NSData*)retrieveNSDataWithFileName:(NSString*)aFileName {
    NSData* resultNSData = nil;
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon overviewPath],aFileName];
    if ([FileCommon fileExistAtPath:filePath]) {
        resultNSData = [NSData dataWithContentsOfFile:filePath];        
    }
    return resultNSData;
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
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
//    [self.emailPopover.contentViewController dismissViewControllerAnimated:YES completion:^ {
//        self.mailController = nil;
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }];
    [self dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}

//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 99) {
////        [self.emailPopover dismissPopoverAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self alertViewCallBack];
//    }
//}

- (void)alignSubviews {
    self.myScrollView.contentSize = CGSizeMake([self.viewItemControllerList count] * self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
    NSUInteger i = 0;
    for (UIViewController* myController in self.viewItemControllerList) {
        myController.view.frame = CGRectMake(i * self.myScrollView.bounds.size.width, 0,
                                             self.myScrollView.bounds.size.width, self.myScrollView.bounds.size.height);
        i++;
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)sender{    
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
}

@end
