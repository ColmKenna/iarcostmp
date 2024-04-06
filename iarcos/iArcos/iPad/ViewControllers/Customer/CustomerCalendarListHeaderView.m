//
//  CustomerCalendarListHeaderView.m
//  iArcos
//
//  Created by Richard on 05/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerCalendarListHeaderView.h"

@implementation CustomerCalendarListHeaderView
@synthesize startdatePointerLabel = _startdatePointerLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.startdatePointerLabel = nil;
    
    [super dealloc];
}

@end
