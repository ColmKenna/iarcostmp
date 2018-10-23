//
//  FormPlanogramViewController.m
//  iArcos
//
//  Created by David Kilmartin on 11/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "FormPlanogramViewController.h"
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface FormPlanogramViewController ()

@end

@implementation FormPlanogramViewController
@synthesize myWebView = _myWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    if ([OrderSharedClass sharedOrderSharedClass].currentFormIUR == nil) return;
    NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSNumber* presenterIUR = [currentFormDetailDict objectForKey:@"FontSize"];
    if ([presenterIUR intValue] == 0) return;
    NSString* fileName = @"";
    NSDictionary* presenterDict = [[ArcosCoreData sharedArcosCoreData] presenterWithIUR:presenterIUR];
    if (presenterDict == nil) return;
    fileName = [ArcosUtils convertNilToEmpty:[presenterDict objectForKey:@"Name"]];
    
    NSString* filepath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], fileName];
    NSURL* fileURL = [NSURL fileURLWithPath:filepath];    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)dealloc {
    self.myWebView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


@end
