//
//  ArcosRoundedUIView.m
//  iArcos
//
//  Created by Richard on 21/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ArcosRoundedUIView.h"

@implementation ArcosRoundedUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    [self.layer setBorderColor:[[UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0] CGColor]];
//    [self.layer setBorderWidth:1.0];
//    [self.layer setCornerRadius:25.0f];
//    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4.0f, 4.0f)];
//    
//    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//    [maskLayer release];
}

@end
