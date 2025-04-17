//
//  UIColor+Hex.m
//  iArcos
//
//  Created by Colm Kenna on 05/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    // Remove leading '#' if present
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }

    // Ensure the string is 6 or 8 characters long
    if (hexString.length != 6 && hexString.length != 8) {
        return nil; // Invalid hex string
    }

    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];

    CGFloat alpha, red, green, blue;
    if (hexString.length == 6) {
        alpha = 1.0;
        red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
        green = ((rgbValue & 0x00FF00) >> 8) / 255.0;
        blue = (rgbValue & 0x0000FF) / 255.0;
    } else {
        alpha = ((rgbValue & 0xFF000000) >> 24) / 255.0;
        red = ((rgbValue & 0x00FF0000) >> 16) / 255.0;
        green = ((rgbValue & 0x0000FF00) >> 8) / 255.0;
        blue = (rgbValue & 0x000000FF) / 255.0;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIColor *)backgroundColor {
    return [self colorFromHexString:@"#D1E0FA"];
}

+ (UIColor *)borderColor {
    return [self colorFromHexString:@"#4472C4"];
}

+ (UIColor *)headerLabelColor {
    return [self colorFromHexString:@"#4472C4"];
}


+ (UIColor *)statusBarColor {
    return [self colorFromHexString:@"#199DD5"];
}

//

@end
