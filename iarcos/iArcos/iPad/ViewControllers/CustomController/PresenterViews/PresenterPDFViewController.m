//
//  PresenterPDFViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterPDFViewController.h"
#import "ArcosRootViewController.h"
@interface PresenterPDFViewController ()
- (void)resetIndicatorViewPositionWillAppear;
- (void)resetIndicatorViewPosition;
@end

@implementation PresenterPDFViewController
@synthesize pdfView;
@synthesize indicatorView = _indicatorView;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize mailController = _mailController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter.delegate=self;

    }
    return self;
}

- (void)dealloc
{
    fileDownloadCenter.delegate = nil;
    fileDownloadCenter.currentFileDownloader.delegate = nil;
    if (self.pdfView != nil) { self.pdfView = nil; }
    self.indicatorView = nil;
    self.arcosRootViewController = nil;
    self.mailController = nil;
        
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
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    // Do any additional setup after loading the view from its nib.
    self.pdfView.frame=self.view.frame;
    self.pdfView.scalesPageToFit=YES;
    self.pdfView.delegate = self;
    
    //get the pdf name
    NSString* fileName=@"";
    for (NSMutableDictionary* dict in self.files) {
        fileName=[dict objectForKey:@"Name"];
        
        //assaign current file
        self.currentFile=dict;
    }
    [self resetBarTitle:fileName];

    NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    
    //if file is not exist then download it
    if ([FileCommon fileExistAtPath:filepath]) {
        [self loadContentWithURL:fileURL];
    }else{
        [fileDownloadCenter addFileWithName:fileName];
        if (fileName != nil) {
            [self resetIndicatorViewPositionWillAppear];
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
        }
        [fileDownloadCenter startDownload];
    }
    
    //[self.pdfView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetIndicatorViewPositionWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetIndicatorViewPosition];
}


-(void)loadContentWithURL:(NSURL*)aUrl{
    [self.pdfView loadRequest:[NSURLRequest requestWithURL:aUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

-(void)setResourceName:(NSString*)aName type:(NSString*)type{

}
-(void)reloadView{
//    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:fileName   ofType:fileType];
//    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
//    [self.pdfView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self resetIndicatorViewPosition];
}

#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    if (error) {
        return;
    }
    
    NSURL    *fileURL    =   [NSURL fileURLWithPath:FC.filePath];
    if (fileURL==nil) {
        return;
    }
    [self loadContentWithURL:fileURL];
}
-(void)allFilesDownload{
    [self.indicatorView stopAnimating];
}
-(void)didFailWithError:(NSError*)anError {
    [self.indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString* auxScheme = [[[request URL] scheme] lowercaseString];
        if ([auxScheme isEqualToString:@"http"] || [auxScheme isEqualToString:@"https"]) {
            PresenterPdfLinkWebViewController* pplwvc = [[PresenterPdfLinkWebViewController alloc] initWithNibName:@"PresenterPdfLinkWebViewController" bundle:nil];
            pplwvc.linkURL = [request URL];
            [self.navigationController pushViewController:pplwvc animated:YES];
            [pplwvc release];
        } else if ([auxScheme isEqualToString:@"mailto"]) {
            NSString* emailAddress = @"";
            @try {
                emailAddress = [[[request URL] absoluteString] substringFromIndex:7];
            } @catch (NSException *exception) {
                [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
            }
            NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@", emailAddress], nil];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//                    amwvc.myDelegate = self;
                amwvc.mailDelegate = self;
                amwvc.toRecipients = toRecipients;
                amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
                self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
                CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
                self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
                [self.arcosRootViewController addChildViewController:self.globalNavigationController];
                [self.arcosRootViewController.view addSubview:self.globalNavigationController.view];
                [self.globalNavigationController didMoveToParentViewController:self.arcosRootViewController];
                [amwvc release];
                [UIView animateWithDuration:0.3f animations:^{
                    self.globalNavigationController.view.frame = parentNavigationRect;
                } completion:^(BOOL finished){
                    
                }];
            }
            if (![ArcosEmailValidator checkCanSendMailStatus:self]) return NO;
            self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
            self.mailController.mailComposeDelegate = self;
            
            [self.mailController setToRecipients:toRecipients];
            [self.arcosRootViewController presentViewController:self.mailController animated:YES completion:nil];
        } else {
            [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Invalid scheme found.\n%@", [[request URL] absoluteString]] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)loadContentWithFilePathURL:(NSURL*)aFilePathURL {
    NSString* prevString = @"<html><head><style type='text/css'>html,body {margin: 0;padding: 0;width: 100%;height: 100%;}html {display: table;}body {display: table-cell;vertical-align: middle;padding: 20px;text-align: center;-webkit-text-size-adjust: none;}</style></head><body><img src='";
    NSString* lastString = @"'></body></html>​";
    NSString* htmlString = [NSString stringWithFormat:@"%@%@%@",prevString,[aFilePathURL absoluteString],lastString];
    [self.pdfView loadHTMLString:htmlString baseURL:nil];
}

- (void)resetIndicatorViewPositionWillAppear {
    float tmpWidth = self.arcosRootViewController.selectedRightViewController.view.frame.size.width / 2 - self.indicatorView.frame.size.width / 2;
    float tmpHeight = self.arcosRootViewController.selectedRightViewController.view.frame.size.height / 2 - self.indicatorView.frame.size.height / 2;
    self.indicatorView.frame = CGRectMake(tmpWidth, tmpHeight, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
}

- (void)resetIndicatorViewPosition {
    float tmpWidth = self.view.frame.size.width / 2 - self.indicatorView.frame.size.width / 2;
    float tmpHeight = self.view.frame.size.height / 2 - self.indicatorView.frame.size.height / 2;
    self.indicatorView.frame = CGRectMake(tmpWidth, tmpHeight, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
}

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
    [self.arcosRootViewController dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}
@end
