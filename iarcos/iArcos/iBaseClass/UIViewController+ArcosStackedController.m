//
//  UIViewController+ArcosStackedController.m
//  iArcos
//
//  Created by David Kilmartin on 11/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "UIViewController+ArcosStackedController.h"
#import "ArcosStackedViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (ArcosStackedController)

- (ArcosStackedViewController *)rcsStackedController {
    return objc_getAssociatedObject(self, kRCSAssociatedStackedControllerKey);
}

@end
