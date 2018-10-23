//
//  DashboardPdfViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardPdfViewController.h"

@interface DashboardPdfViewController ()

@end

@implementation DashboardPdfViewController
@synthesize myWebView = _myWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], @"GDPR.pdf"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myWebView = nil;
    
    [super dealloc];
}

@end
