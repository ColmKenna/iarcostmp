//
//  UIImage+Resize.m
//  Arcos
//
//  Created by David Kilmartin on 26/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)thumbnailWithSize:(CGSize)aNewSize {
    UIGraphicsBeginImageContext(aNewSize);
    [self drawInRect:CGRectMake(0, 0, aNewSize.width, aNewSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
