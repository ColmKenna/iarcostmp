//
//  UIButtonStyleHelper.m
//  iArcos
//
//  Created by Colm Kenna on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIButtonStyleHelper.h"

@implementation UIButtonStyleHelper

+ (void)setBorderForButton:(UIButton *)button withHexColor:(NSString *)hexColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    // Convert hex color string to UIColor
    UIColor *borderColor = [self colorFromHexString:hexColor];
    if (!borderColor) return;

    // Set the button border properties
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = borderWidth;
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
}


+ (void)setBlueBorderedButton:(UIButton *)button {
    // Set default "blue" border style
    NSString *blueHexColor = @"#7D9DD6";
    CGFloat defaultBorderWidth = 1.0f;
    CGFloat defaultCornerRadius = 5.0f;

    [self setBorderForButton:button
                 withHexColor:blueHexColor
                 borderWidth:defaultBorderWidth
                 cornerRadius:defaultCornerRadius];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // Bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0
                            blue:(rgbValue & 0x0000FF) / 255.0
                           alpha:1.0];
}

@end
