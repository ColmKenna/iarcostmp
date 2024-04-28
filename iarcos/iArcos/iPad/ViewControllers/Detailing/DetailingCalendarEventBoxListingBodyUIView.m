//
//  DetailingCalendarEventBoxListingBodyUIView.m
//  iArcos
//
//  Created by Richard on 17/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyUIView.h"

@implementation DetailingCalendarEventBoxListingBodyUIView

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
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [maskLayer release];
}

@end
