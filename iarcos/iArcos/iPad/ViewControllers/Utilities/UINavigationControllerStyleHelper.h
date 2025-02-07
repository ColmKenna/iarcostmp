//
//  UINavigationControllerStyleHelper.h
//  iArcos
//
//  Created by Colm Kenna on 06/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationControllerStyleHelper : NSObject

+ (void)setBorderForNavigationController:(UINavigationController *)navigationController withBorderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

@end
