//
//  LeftBorderUILabel.m
//  Arcos
//
//  Created by David Kilmartin on 08/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LeftBorderUILabel.h"

@implementation LeftBorderUILabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
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
