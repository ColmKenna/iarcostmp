//
//  LeftLightBlueBorderUIView.m
//  iArcos
//
//  Created by Richard on 28/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "LeftLightBlueBorderUIView.h"

@implementation LeftLightBlueBorderUIView

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
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:209.0/255.0f green:224.0/255.0f blue:251.0/255.0f alpha:1.0f].CGColor);
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    
    CGContextAddLineToPoint(context, 0, rect.size.height); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
