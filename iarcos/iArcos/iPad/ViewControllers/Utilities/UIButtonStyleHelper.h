//
//  UIButtonStyleHelper.h
//  iArcos
//
//  Created by Colm Kenna on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonStyleHelper : NSObject

+ (void)setBorderForButton:(UIButton *)button withHexColor:(NSString *)hexColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;


+ (void)setBlueBorderedButton:(UIButton *)button;

@end
