//
//  UIViewController+ArcosStackedController.h
//  iArcos
//
//  Created by David Kilmartin on 11/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ArcosStackedGlobalVariable.h"
@class ArcosStackedViewController;


@interface UIViewController (ArcosStackedController)

- (ArcosStackedViewController *)rcsStackedController;

@end
