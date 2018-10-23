//
//  HorizontalBlueSeparatorUILabel.m
//  iArcos
//
//  Created by David Kilmartin on 08/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "HorizontalBlueSeparatorUILabel.h"

@implementation HorizontalBlueSeparatorUILabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f].CGColor);
    
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, rect.size.width);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
