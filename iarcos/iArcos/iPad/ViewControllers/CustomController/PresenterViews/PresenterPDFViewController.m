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
@end
