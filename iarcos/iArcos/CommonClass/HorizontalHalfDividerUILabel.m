//
//  HorizontalHalfDividerUILabel.m
//  iArcos
//
//  Created by David Kilmartin on 02/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "HorizontalHalfDividerUILabel.h"

@implementation HorizontalHalfDividerUILabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    
    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
