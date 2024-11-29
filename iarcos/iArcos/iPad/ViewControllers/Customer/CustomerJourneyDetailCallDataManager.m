//
//  CustomerJourneyDetailCallDataManager.m
//  iArcos
//
//  Created by Richard on 28/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailCallDataManager.h"

@implementation CustomerJourneyDetailCallDataManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        UIViewController* arcosRootViewController = [ArcosUtils getRootView];
        float width = arcosRootViewController.view.frame.size.width > arcosRootViewController.view.frame.size.height ? arcosRootViewController.view.frame.size.width : arcosRootViewController.view.frame.size.height;
        self.textViewContentWidth = (width - [GlobalSharedClass shared].mainMasterWidth) / 2.0 - 1 - 19 - 10;
//        NSLog(@"CustomerJourneyDetailCallDataManager textViewContentWidth aa %f", self.textViewContentWidth);
    }
    return self;
}

@end
