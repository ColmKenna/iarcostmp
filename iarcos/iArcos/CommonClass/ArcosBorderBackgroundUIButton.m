//
//  ArcosBorderBackgroundUIButton.m
//  iArcos
//
//  Created by David Kilmartin on 22/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "ArcosBorderBackgroundUIButton.h"

@implementation ArcosBorderBackgroundUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4.0f, 4.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [maskLayer release];
}

@end
