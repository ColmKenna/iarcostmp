//
//  ArcosGrayBorderUIButton.m
//  iArcos
//
//  Created by David Kilmartin on 06/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "ArcosGrayBorderUIButton.h"

@implementation ArcosGrayBorderUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0] CGColor];
    [self.layer setCornerRadius:4.0f];
}

@end
