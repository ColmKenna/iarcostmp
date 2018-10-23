//
//  UIViewAnimationDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 16/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewAnimationDelegate <NSObject>
@optional
-(void)dismissUIViewAnimation;
-(void)dismissBottomUIViewAnimation;

@end
