//
//  GenericWebViewItemViewController.m
//  iArcos
//
//  Created by David Kilmartin on 18/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "GenericWebViewItemViewController.h"

@interface GenericWebViewItemViewController ()

@end

@implementation GenericWebViewItemViewController
@synthesize myWebView = _myWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myWebView = nil;
    
    [super dealloc];
}

- (void)loadContentWithPath:(NSString*)aPath {
    NSURL* fileURL = [NSURL fileURLWithPath:aPath];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
