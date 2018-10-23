//
//  BorderedUITextView.m
//  iArcos
//
//  Created by David Kilmartin on 26/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "BorderedUITextView.h"

@implementation BorderedUITextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:5.0f];
}


@end
