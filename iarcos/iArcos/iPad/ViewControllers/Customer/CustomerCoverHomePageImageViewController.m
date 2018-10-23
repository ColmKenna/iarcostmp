//
//  CustomerCoverHomePageImageViewController.m
//  iArcos
//
//  Created by David Kilmartin on 26/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerCoverHomePageImageViewController.h"

@interface CustomerCoverHomePageImageViewController ()

@end

@implementation CustomerCoverHomePageImageViewController
@synthesize myImageButton = _myImageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:];
    UIImage* anImage = nil;
    anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    [self.myImageButton setImage:anImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myImageButton = nil;
    
    [super dealloc];
}



@end
