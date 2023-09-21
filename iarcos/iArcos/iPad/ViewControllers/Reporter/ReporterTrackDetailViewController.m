//
//  ReporterTrackDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterTrackDetailViewController.h"

@implementation ReporterTrackDetailViewController
@synthesize myWebView = _myWebView;
@synthesize callGenericServices = _callGenericServices;
@synthesize reportIUR = _reportIUR;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize reporterTrackDetailDataManager = _reporterTrackDetailDataManager;
@synthesize buyFlag = _buyFlag;
@synthesize levelIUR = _levelIUR;
@synthesize employeeIUR = _employeeIUR;
@synthesize configDict = _configDict;
@synthesize reporterFileManager = _reporterFileManager;
@synthesize emailButton = _emailButton;
//@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize mailController = _mailController;
@synthesize tableName = _tableName;
@synthesize selectedIUR = _selectedIUR;

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
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.reportIUR != nil) { self.reportIUR = nil; }
    if (self.startDate != nil) { self.startDate = nil; }
    if (self.endDate != nil) { self.endDate = nil; }
    if (self.reporterTrackDetailDataManager != nil) { self.reporterTrackDetailDataManager = nil; }
    if (self.levelIUR != nil) { self.levelIUR = nil; }   
    if (self.employeeIUR != nil) { self.employeeIUR = nil; }
    if (self.configDict != nil) { self.configDict = nil; }
    if (self.reporterFileManager != nil) { self.reporterFileManager = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
//    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.mailController != nil) { self.mailController = nil; }        
    if (self.tableName != nil) { self.tableName = nil; }
    if (self.selectedIUR != nil) { self.selectedIUR = nil; }
        
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
    // Do any additional setup after loading the view from its nib.
    
    self.reporterTrackDetailDataManager = [[[ReporterTrackDetailDataManager alloc] init] autorelease];
    
    if (self.callGenericServices == nil) {        
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.isNotRecursion = NO;
    }
     
    self.reporterFileManager = [[[ReporterFileManager alloc] init] autorelease];
    self.reporterFileManager.fileDelegate = self;
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.requestSource = EmailRequestSourceReporter;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];  
//    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    [emailRecipientTableViewController release];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.emailButton;
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.myWebView != nil) { self.myWebView = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    [GlobalSharedClass shared].serviceTimeoutInterval=[GlobalSharedClass shared].reporterServiceTimeoutInterval;
    [self.callGenericServices genericGetReportSubWithEmployeeiur:[self.employeeIUR intValue] reportiur:[self.reportIUR intValue]  startDate:self.startDate endDate:self.endDate type:[self.configDict objectForKey:@"DefaultDataSource"] leveliur:[self.levelIUR intValue] buy:self.buyFlag tablename:self.tableName iur:[self.selectedIUR intValue] action:@selector(setGetReportSubResult:) target:self];        
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

-(void)setGetReportSubResult:(ArcosGenericReturnObject*)result {
//    NSLog(@"finish load");
//    [self.callGenericServices.HUD hide:YES];
    [GlobalSharedClass shared].serviceTimeoutInterval = [GlobalSharedClass shared].defaultServiceTimeoutInterval;
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {     
        [self.callGenericServices.HUD hide:YES];
        
//        NSLog(@"result.ErrorModel.Code: %d", result.ErrorModel.Code);
        self.isNotFirstLoaded = YES;
        NSString* fileName = @"";
        if(self.buyFlag) {
            fileName = @"98949.xls";
        } else {
            fileName = @"98952.xls";
        }
        NSString* excelFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", self.reporterFileManager.reporterFolderName, fileName]];
        [FileCommon removeFileAtPath:excelFilePath];
        NSString* serverFilePath = [self.reporterTrackDetailDataManager createReportServerFilePath:fileName];
        NSURL* serverFileURL = [NSURL URLWithString:serverFilePath];
        [self.reporterFileManager downloadFileWithURL:serverFileURL destFolderName:self.reporterFileManager.reporterFolderName fileName:fileName];
         
    } else if(result.ErrorModel.Code <= 0) {   
        [self.callGenericServices.HUD hide:YES];
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }    
}

#pragma mark ReporterFileDelegate
- (void)didFinishLoadingReporterFileDelegate {
    [self.callGenericServices.HUD hide:YES];
    if (self.reporterFileManager.isFileNotSuccessfullyDownloaded) return;
    if ([FileCommon fileExistAtPath:self.reporterFileManager.filePath]) {
        NSURL* fileURL = [NSURL fileURLWithPath:self.reporterFileManager.filePath];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {    
    if (parent == nil) {        
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
//        self.myWebView.delegate = nil;
    }
}

- (void)didFailWithErrorReporterFileDelegate:(NSError *)anError {
    [self.callGenericServices.HUD hide:YES];
//    [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
    [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" target:self handler:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {    
    if ([error code] != NSURLErrorCancelled) {
//        [ArcosUtils showMsg:[error localizedDescription] delegate:nil];
        [ArcosUtils showDialogBox:[error localizedDescription] title:@"" target:self handler:nil];
    }    
}

-(void)emailButtonPressed:(id)sender {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.emailNavigationController.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
    self.emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.emailNavigationController.popoverPresentationController.barButtonItem = self.emailButton;
    self.emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.emailNavigationController animated:YES completion:nil];
}

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    if (![MFMailComposeViewController canSendMail]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [ArcosUtils showDialogBox:[GlobalSharedClass shared].noMailAcctMsg title:[GlobalSharedClass shared].noMailAcctTitle target:self handler:nil];
        }];
        return;
    }
//    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
//    [self.emailPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.mailController != nil) { self.mailController = nil; }    
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    NSString* email = [cellData objectForKey:@"Email"];
    if (![@"" isEqualToString:email]) {
        NSArray* toRecipients = [NSArray arrayWithObjects:email, nil];
        [self.mailController setToRecipients:toRecipients];
    }
    [self.mailController setSubject:self.title];
    if ([FileCommon fileExistAtPath:self.reporterFileManager.filePath]) {
        NSData* data = [NSData dataWithContentsOfFile:self.reporterFileManager.filePath];
        NSString* mimeTypeString = @"application/vnd.ms-excel";        
        [self.mailController addAttachmentData:data mimeType:mimeTypeString fileName:self.reporterFileManager.filePath.lastPathComponent];        
    }
    [self presentViewController:self.mailController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    NSString* message = nil;
    BOOL alertShowedFlag = NO;
//    UIAlertView* v = nil;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";            
//            v = [[UIAlertView alloc] initWithTitle:@"App Email" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [v show];
//            [v release];
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
//            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//            [v show];
//            [v release];
            alertShowedFlag = YES;
            [ArcosUtils showDialogBox:message title:@"Error !" delegate:nil target:controller tag:0 handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
    NSLog(@"Email sending error message %@ ", message);
    if (!alertShowedFlag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
