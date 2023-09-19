//
//  PresenterURLViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "PresenterURLViewController.h"
#import "ArcosRootViewController.h"
@interface PresenterURLViewController ()
- (void)resetIndicatorViewPositionWillAppear;
- (void)resetIndicatorViewPosition;
@end

@implementation PresenterURLViewController
@synthesize urlView = _urlView;
//@synthesize indicatorView = _indicatorView;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize isDoingPopAction = _isDoingPopAction;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize HUD = _HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.urlView.delegate = nil;
    [self.urlView stopLoading];
    if (self.urlView != nil) { self.urlView = nil; }
//    if (self.indicatorView != nil) { self.indicatorView = nil; }
    self.arcosRootViewController = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
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
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [rightButtonList addObject:[[[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStylePlain target:self action:@selector(forwardPressed)] autorelease]];
    [rightButtonList addObject:[[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)] autorelease]];
    
    self.navigationItem.rightBarButtonItems = rightButtonList;
    
    for (NSMutableDictionary* dict in self.files) {     
        //assaign current file
        self.currentFile = dict;
    }
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView]; 
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.urlView != nil) { self.urlView = nil; }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;    
    [self resetIndicatorViewPositionWillAppear];
//    self.indicatorView.hidden = NO;
//    [self.indicatorView startAnimating];
    self.HUD.labelText = @"Loading";    
    [self.HUD show:YES];    
    NSURL* myURL = nil;
    NSString* myURLString = [self.currentFile objectForKey:@"URL"];
    if ([myURLString hasPrefix:@"https://"]) {
        myURL = [NSURL URLWithString:myURLString];
    } else if ([myURLString hasPrefix:@"http://"]) {
        myURL = [NSURL URLWithString:myURLString];
    } else {
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
    }
    [self.urlView loadRequest:[NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isDoingPopAction) {
        [self.urlView stopLoading];
        [self.urlView loadHTMLString:@"" baseURL:nil];
    }
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

- (void)forwardPressed {
    [self.urlView goForward];
}

- (void)backPressed {
    [self.urlView goBack];
}

- (void)resetIndicatorViewPositionWillAppear {
//    float tmpWidth = self.arcosRootViewController.selectedRightViewController.view.frame.size.width / 2 - self.indicatorView.frame.size.width / 2;
//    float tmpHeight = self.arcosRootViewController.selectedRightViewController.view.frame.size.height / 2 - self.indicatorView.frame.size.height / 2;
//    self.indicatorView.frame = CGRectMake(tmpWidth, tmpHeight, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
    self.HUD.frame = self.navigationController.view.bounds;
}

- (void)resetIndicatorViewPosition {
//    float tmpWidth = self.view.frame.size.width / 2 - self.indicatorView.frame.size.width / 2;
//    float tmpHeight = self.view.frame.size.height / 2 - self.indicatorView.frame.size.height / 2;
//    self.indicatorView.frame = CGRectMake(tmpWidth, tmpHeight, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
    self.HUD.frame = self.navigationController.view.bounds;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.indicatorView stopAnimating];
    [self.HUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self.indicatorView stopAnimating];
    [self.HUD hide:YES];
    if ([error code] != NSURLErrorCancelled) {
//        [ArcosUtils showMsg:[error localizedDescription] delegate:nil];
        [ArcosUtils showDialogBox:[error localizedDescription] title:@"" target:self handler:nil];
    }    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        self.isDoingPopAction = YES;
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {    
    if (parent == nil) {
//        NSLog(@"count:%d", [[self.urlView subviews] count]);
//        NSLog(@"abc");
//        [self.urlView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
//        [self.urlView loadHTMLString:@"" baseURL:nil];
    }
}

@end
