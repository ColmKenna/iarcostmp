//
//  CustomerAnalyzeModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerAnalyzeModalViewController.h"

@implementation CustomerAnalyzeModalViewController

@synthesize myWebView;
@synthesize modalDelegate;
@synthesize locationIUR;

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
    if (self.modalDelegate != nil) {
        self.modalDelegate = nil;
    }
    if (self.locationIUR != nil) {
        self.locationIUR = nil;
    }
    if (self.myWebView != nil) {
        self.myWebView = nil;
    }
    if (callGenericServices != nil) {
        [callGenericServices release];
        callGenericServices = nil;
    }    
    if (connectivityCheck != nil) { [connectivityCheck release]; 
        connectivityCheck = nil;
    }
//    if (myTimer != nil) { [myTimer release]; }        
    
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
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    
    [self.navigationItem setLeftBarButtonItem:closeButton];  
    
    [closeButton release];
//    myWebView.delegate = self;
    
//    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
//    callGenericServices.delegate = self;
    
   
//    [callGenericServices getGraph:@"TYLYLocationGraph" iur:[self.locationIUR intValue]];
    self.myWebView.scalesPageToFit = YES;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"iPADsample" ofType:@"xls"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
    
}

-(void)printingSelf {
    NSLog(@"printing myself");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.myWebView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    self.myWebView.scalesPageToFit = YES;
	return YES;
}


-(void)closePressed:(id)sender {
//    [myTimer invalidate];
    NSLog(@"closePressed is pressed");
    if (myWebView.loading) {
        NSLog(@"It is loading");
        [myWebView stopLoading];
    }
    if (self.modalDelegate != nil) {
        [self.modalDelegate didDismissModalView];
        return;
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"enter into webViewDidFinishLoad");
//    [activityIndicator stopAnimating];    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webview load error is %@.", [error description]);
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 5.0;"];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetGraphResult:(ArcosReportModel*) result {
    if (result.ErrorMsg.Code > 0) {
        NSLog(@"%@", result.ErrorMsg.Message);
        NSLog(@"url is %@", result.Url);
        SettingManager* sm = [SettingManager setting];
        NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Connection"];
        NSMutableDictionary* presenterURL = [sm getSettingForKeypath:keypath atIndex:6];
                
        self.myWebView.frame = self.view.frame;
        NSString* fullURL = [NSString stringWithFormat:@"%@%@",[presenterURL objectForKey:@"Value"],result.Url];
        
        NSLog(@"full url is %@", fullURL);
//        self.myWebView.scalesPageToFit = YES;
//        NSURL* url = [NSURL URLWithString:@"http://www.stratait.ie/downloads/Resources/testme.png"];
//        NSURLRequest* requestObj = [NSURLRequest requestWithURL:url];
//        [self.myWebView loadRequest:requestObj];
//        NSString* imageHTML = [NSString stringWithFormat:<#(NSString *), ...#>];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"xls1" ofType:@"xls"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:request];
        
/**        
        NSString* imageHTML = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=yes' /></head><body marginwidth='0' marginheight='0'><img src='%@' width='100%%' height='100%%'></body></html>", fullURL];
        NSLog(@"html is  %@", imageHTML);
        [self.myWebView loadHTMLString:imageHTML baseURL:nil];
*/        
        
        
        
        
//        NSString* imageHTML = @"<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=yes' /></head><body marginwidth='0' marginheight='0'><img src='http://strataarcos.com/copydataservice/Resources/testme.png' width='100%' height='100%'></body></html>";       
        
//        self.myWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

//        [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 5.0;"];
    } else if(result.ErrorMsg.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorMsg.Code message:result.ErrorMsg.Message delegate:self];    
    }
}

//connectivity notification back
/**
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSLog(@"enter into the check connection.");
        [check stop];        
        [[NSNotificationCenter defaultCenter]removeObserver:self];        
        [callGenericServices getGraph:@"TYLYLocationGraph" iur:[self.locationIUR intValue]];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString delegate:nil];
    }        
}
*/

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"received the rotation event.");
}

@end
