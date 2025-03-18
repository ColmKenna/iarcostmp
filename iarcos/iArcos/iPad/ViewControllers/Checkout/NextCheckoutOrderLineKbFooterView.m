//
//  NextCheckoutOrderLineKbFooterView.m
//  iArcos
//
//  Created by Richard on 16/03/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutOrderLineKbFooterView.h"

@implementation NextCheckoutOrderLineKbFooterView
@synthesize totalTitleLabel = _totalTitleLabel;
@synthesize totalLineLabel = _totalLineLabel;
@synthesize totalSuffixLabel = _totalSuffixLabel;
@synthesize totalQtyLabel = _totalQtyLabel;
@synthesize totalBonusLabel = _totalBonusLabel;
@synthesize totalValueLabel = _totalValueLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.totalTitleLabel = nil;
    self.totalLineLabel = nil;
    self.totalSuffixLabel = nil;
    self.totalQtyLabel = nil;
    self.totalBonusLabel = nil;
    self.totalValueLabel = nil;
    
    [super dealloc];
}

@end
