//
//  ArcosGenericHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/02/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ArcosGenericHeaderViewController.h"

@interface ArcosGenericHeaderViewController ()

@end

@implementation ArcosGenericHeaderViewController
@synthesize titleLabel = _titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.titleLabel = nil;
    
    [super dealloc];
}

@end
