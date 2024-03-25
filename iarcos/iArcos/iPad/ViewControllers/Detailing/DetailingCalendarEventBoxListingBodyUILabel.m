//
//  DetailingCalendarEventBoxListingBodyUILabel.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyUILabel.h"

@implementation DetailingCalendarEventBoxListingBodyUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
//    [self.layer setBorderColor:[UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor];
//    [self.layer setBorderWidth:0.5];
//    [self.layer setCornerRadius:5.0f];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(6.0f, 6.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [maskLayer release];
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0.0f, 6.0f, 0.0f, 6.0f};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
