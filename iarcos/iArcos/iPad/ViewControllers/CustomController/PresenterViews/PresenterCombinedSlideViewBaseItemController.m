//
//  PresenterCombinedSlideViewBaseItemController.m
//  iArcos
//
//  Created by David Kilmartin on 28/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "PresenterCombinedSlideViewBaseItemController.h"

@interface PresenterCombinedSlideViewBaseItemController ()

@end

@implementation PresenterCombinedSlideViewBaseItemController
@synthesize itemDelegate = _itemDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContentWithPath:(NSString*)aPath {
    
}


@end
