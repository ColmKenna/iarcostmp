//
//  ArcosBorderUILabel.m
//  iArcos
//
//  Created by Richard on 16/11/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosBorderUILabel.h"

@implementation ArcosBorderUILabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:5.0f];
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0.0f, 2.0f, 0.0f, 2.0f};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
