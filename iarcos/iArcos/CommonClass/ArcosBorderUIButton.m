//
//  ArcosBorderUIButton.m
//  iArcos
//
//  Created by David Kilmartin on 22/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "ArcosBorderUIButton.h"

@implementation ArcosBorderUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor];
    [self.layer setCornerRadius:4.0f];
    
}



@end
