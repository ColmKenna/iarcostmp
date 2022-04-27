//
//  ArcosCalendarTableCellDayLabel.m
//  iArcos
//
//  Created by Richard on 08/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarTableCellDayLabel.h"

@implementation ArcosCalendarTableCellDayLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0.0f, 2.0f, 0.0f, 8.0f};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
