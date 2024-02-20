//
//  ArcosBorderUIView.m
//  iArcos
//
//  Created by Richard on 14/02/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ArcosBorderUIView.h"

@implementation ArcosBorderUIView

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
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    
    CGContextAddLineToPoint(context, 0, rect.size.height); //draw to this point
    
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextMoveToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
