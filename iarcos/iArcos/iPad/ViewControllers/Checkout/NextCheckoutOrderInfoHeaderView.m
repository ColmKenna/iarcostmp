//
//  NextCheckoutOrderInfoHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 26/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutOrderInfoHeaderView.h"

@implementation NextCheckoutOrderInfoHeaderView
@synthesize myLabel = _myLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.myLabel = nil;
    
    [super dealloc];
}

@end
