//
//  CustomerInfoHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoHeaderViewController.h"

@interface CustomerInfoHeaderViewController ()

@end

@implementation CustomerInfoHeaderViewController
@synthesize headerTitleLabel = _headerTitleLabel;
@synthesize headerButton = _headerButton;
@synthesize headerContentLabel = _headerContentLabel;
@synthesize headerContentValue = _headerContentValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerContentLabel.text = self.headerContentValue;
}

- (void)dealloc {
    self.headerTitleLabel = nil;
    self.headerButton = nil;
    self.headerContentLabel = nil;
    self.headerContentValue = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
