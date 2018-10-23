//
//  ProductDetailDesignViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ProductDetailDesignViewController.h"

@interface ProductDetailDesignViewController ()

@end

@implementation ProductDetailDesignViewController
@synthesize myWebView = _myWebView;
@synthesize isPageMultipleLoaded = _isPageMultipleLoaded;
@synthesize myURLString = _myURLString;
@synthesize HUD = _HUD;
@synthesize isDoingPopAction = _isDoingPopAction;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myWebView = nil;
    self.myURLString = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isPageMultipleLoaded) return;
    self.isPageMultipleLoaded = YES;
    [self resetIndicatorViewPosition];
    self.HUD.labelText = @"Loading";
    [self.HUD show:YES];
    NSURL* myURL = nil;
    if ([self.myURLString hasPrefix:@"https://"]) {
        myURL = [NSURL URLWithString:self.myURLString];
    } else if ([self.myURLString hasPrefix:@"http://"]) {
        myURL = [NSURL URLWithString:self.myURLString];
    } else {
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.myURLString]];
    }
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isDoingPopAction) {
        [self.myWebView stopLoading];
        [self.myWebView loadHTMLString:@"" baseURL:nil];
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.HUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.HUD hide:YES];
    if ([error code] != NSURLErrorCancelled) {
        [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
    }    
}

- (void)resetIndicatorViewPosition {
    self.HUD.frame = self.navigationController.view.bounds;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        self.isDoingPopAction = YES;
    }
}

@end
