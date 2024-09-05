//
//  LeftBorderBlackUILabel.m
//  iArcos
//
//  Created by Richard on 15/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "LeftBorderBlackUILabel.h"

@implementation LeftBorderBlackUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    
    CGContextAddLineToPoint(context, 0, rect.size.height); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0.0f, 2.0f, 0.0f, 2.0f};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
