//
//  PresenterPdfLinkWebViewController.m
//  iArcos
//
//  Created by Richard on 20/04/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "PresenterPdfLinkWebViewController.h"

@interface PresenterPdfLinkWebViewController ()

@end

@implementation PresenterPdfLinkWebViewController
@synthesize urlView = _urlView;
@synthesize linkURL = _linkURL;
@synthesize HUD = _HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    [self resetIndicatorViewPosition];
    self.HUD.labelText = @"Loading";
    [self.HUD show:YES];
    
    [self.urlView loadRequest:[NSURLRequest requestWithURL:self.linkURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)dealloc {
    self.urlView.delegate = nil;
    [self.urlView stopLoading];
    self.urlView = nil;
    self.linkURL = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetIndicatorViewPosition];
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

- (void)resetIndicatorViewPosition {
    self.HUD.frame = self.navigationController.view.bounds;
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

@end
