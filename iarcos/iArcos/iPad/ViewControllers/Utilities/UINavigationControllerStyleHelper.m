//
//  UINavigationControllerStyleHelper.m
//  iArcos
//
//  Created by Colm Kenna on 06/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UINavigationControllerStyleHelper.h"

#import "UINavigationControllerStyleHelper.h"
#import "UIColor+Hex.h"

@implementation UINavigationControllerStyleHelper

+ (void)setBorderForNavigationController:(UINavigationController *)navigationController withBorderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    // Convert hex color string to UIColor
    UIColor *borderColor = [UIColor borderColor];
    if (!borderColor) return;

    // Set the navigation controller border properties
    navigationController.view.layer.borderColor = borderColor.CGColor;
    navigationController.view.layer.borderWidth = borderWidth;
    navigationController.view.layer.cornerRadius = cornerRadius;
    navigationController.view.layer.masksToBounds = YES;

}

@end
