//
//  MeetingAttachmentsFileViewController.m
//  iArcos
//
//  Created by David Kilmartin on 19/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsFileViewController.h"

@interface MeetingAttachmentsFileViewController ()

@end

@implementation MeetingAttachmentsFileViewController
@synthesize modalDelegate = _modalDelegate;
@synthesize myWebView = _myWebView;
//@synthesize fileName = _fileName;
@synthesize filePath = _filePath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [ArcosUtils configEdgesForExtendedLayout:self];
    
//    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath], self.fileName];
    NSURL* fileURL = [NSURL fileURLWithPath:self.filePath];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
}

- (void)dealloc {
    self.myWebView = nil;
//    self.fileName = nil;
    self.filePath = nil;
    
    [super dealloc];
}

- (void)backButtonPressed {
    [self.modalDelegate didDismissModalPresentViewController];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
    }
}

@end
