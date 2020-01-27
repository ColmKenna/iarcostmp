//
//  UtilitiesSignOutViewController.m
//  iArcos
//
//  Created by Apple on 30/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "UtilitiesSignOutViewController.h"

@interface UtilitiesSignOutViewController ()

@end

@implementation UtilitiesSignOutViewController
@synthesize delegate = _delegate;
@synthesize myWebView = _myWebView;
@synthesize layoutDict = _layoutDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithCapacity:3];
        UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
        [leftButtonList addObject:closeButton];
        [closeButton release];
        [self.navigationItem setLeftBarButtonItems:leftButtonList];
        WKWebViewConfiguration* theConfiguration = [[[WKWebViewConfiguration alloc] init] autorelease];
        self.myWebView = [[[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration] autorelease];
        self.layoutDict = @{@"AuxWebView" : self.myWebView};
    //    self.myWebView.navigationDelegate = self;
        NSURL* nsurl = [NSURL URLWithString:@"https://www.office.com/"];
        NSURLRequest* nsrequest = [NSURLRequest requestWithURL:nsurl];
        [self.myWebView loadRequest:nsrequest];
        [self.view addSubview:self.myWebView];
        [self.myWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxWebView]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxWebView]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    
    
}

- (void)dealloc {
    [self.myWebView removeFromSuperview];
    self.myWebView = nil;
    self.layoutDict = nil;
    
    [super dealloc];
}

- (void)closePressed:(id)sender {
    [self.delegate didDismissModalPresentViewController];
}

@end
