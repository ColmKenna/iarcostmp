//
//  ReportExcelViewController.m
//  Arcos
//
//  Created by David Kilmartin on 15/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportExcelViewController.h"

@interface ReportExcelViewController ()
- (void)alertViewCallBack;
@end

@implementation ReportExcelViewController
@synthesize myWebView;
@synthesize filePath;
@synthesize reporterFileManager = _reporterFileManager;
@synthesize emailButton = _emailButton;
@synthesize previewButton = _previewButton;
@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize mailController = _mailController;
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

- (void)dealloc {
    if (self.myWebView != nil) { self.myWebView = nil; }
    if (self.filePath != nil) { self.filePath = nil; }
    if (self.reporterFileManager != nil) { self.reporterFileManager = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.previewButton != nil) { self.previewButton = nil; }
    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.mailController != nil) { self.mailController = nil; }
    self.globalNavigationController = nil;
    self.rootView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    self.rootView = [ArcosUtils getRootView];
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.previewButton = [[[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(previewButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.emailButton, self.previewButton,nil];
    
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.requestSource = EmailRequestSourceReporter;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    [emailRecipientTableViewController release];
    
    
    if (self.filePath!=nil&&![self.filePath isEqualToString:@""]) {
        self.title = self.reporterFileManager.reportTitle;
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        //Load the request in the UIWebView.
        [myWebView loadRequest:requestObj];
    }else {
        NSString *HTMLData = @"<h1>The file is not found!</h1>";
        [myWebView  loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//",self.filePath]]];
    }
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[QLPreviewController class]]] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[QLPreviewController class]]] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)previewButtonPressed:(id)sender {
    QLPreviewController* myPreviewController = [[QLPreviewController alloc] init];
    myPreviewController.dataSource = self;
    myPreviewController.delegate = self;
    [self presentViewController:myPreviewController animated:YES completion:nil];
    [myPreviewController release];
}

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSString* email = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"Email"]];
    NSMutableArray* toRecipients = [NSMutableArray array];
    if (![@"" isEqualToString:email]) {
        toRecipients = [NSMutableArray arrayWithObjects:email, nil];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.subjectText = self.reporterFileManager.reportTitle;
        if ([FileCommon fileExistAtPath:self.reporterFileManager.localExcelFilePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.reporterFileManager.localExcelFilePath];
            [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:self.reporterFileManager.fileName]];            
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
    [self.emailPopover dismissPopoverAnimated:YES];
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;    
    
    [self.mailController setToRecipients:toRecipients];
    [self.mailController setSubject:self.reporterFileManager.reportTitle];
    if ([FileCommon fileExistAtPath:self.reporterFileManager.localExcelFilePath]) {
        NSData* data = [NSData dataWithContentsOfFile:self.reporterFileManager.localExcelFilePath];
        NSString* mimeTypeString = @"application/vnd.ms-excel";
        
        [self.mailController addAttachmentData:data mimeType:mimeTypeString fileName:self.reporterFileManager.fileName];
    }
    
    [self presentViewController:self.mailController animated:YES completion:nil];
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
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:99 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self alertViewCallBack];
}

- (void)alertViewCallBack {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}

#pragma mark Preview Controller
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
	return [self.reporterFileManager.previewDocumentList count];
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
//    NSString* tmpFileName = [self.reporterFileManager.previewDocumentList objectAtIndex:index];
//    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon pathWithFolder:self.reporterFileManager.reporterFolderName], tmpFileName];
    ArcosQLPreviewItem* arcosQLPreviewItem = [[[ArcosQLPreviewItem alloc] init] autorelease];
    arcosQLPreviewItem.myItemURL = [NSURL fileURLWithPath:self.reporterFileManager.localExcelFilePath];
    arcosQLPreviewItem.myItemTitle = [NSString stringWithFormat:@"%@", self.reporterFileManager.reportTitle];
    return arcosQLPreviewItem;
}


@end
