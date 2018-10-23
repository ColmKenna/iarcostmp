//
//  LeftRightInsetUILabel.m
//  iArcos
//
//  Created by David Kilmartin on 31/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "LeftRightInsetUILabel.h"

@implementation LeftRightInsetUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0.0f, 2.0f, 0.0f, 2.0f};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
