//
//  ArcosCustomiseAnimation.h
//  Arcos
//
//  Created by David Kilmartin on 19/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ArcosUtils.h"
@protocol ArcosCustomiseAnimationDelegate <NSObject>
@optional
- (void)dismissPushViewCallBack;
@end

@interface ArcosCustomiseAnimation : NSObject {
    id<ArcosCustomiseAnimationDelegate> _delegate;
}

@property(nonatomic, assign) id<ArcosCustomiseAnimationDelegate> delegate;

-(void)addPushViewAnimation:(UIViewController*)rootView withController:(UINavigationController*) globalNavigationController;
-(void)dismissPushViewAnimation:(UIViewController*)rootView withController:(UINavigationController*) globalNavigationController;


@end
