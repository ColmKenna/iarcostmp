//
//  DetailingCalendarEventBoxBorderUIButton.m
//  iArcos
//
//  Created by Richard on 15/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxBorderUIButton.h"

@implementation DetailingCalendarEventBoxBorderUIButton

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
    self.layer.borderColor = [[UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0] CGColor];
    [self.layer setCornerRadius:10.0f];
    
}

@end
