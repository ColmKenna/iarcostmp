//
//  OrderPadFooterViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/09/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "OrderPadFooterViewCell.h"

@implementation OrderPadFooterViewCell
//@synthesize totalBonusTitle = _totalBonusTitle;
@synthesize totalBonusValue = _totalBonusValue;
@synthesize totalTradeTitle = _totalTradeTitle;
@synthesize totalTradeValue = _totalTradeValue;
//@synthesize percentageLabel = _percentageLabel;

- (void)dealloc {
//    self.totalBonusTitle = nil;
    self.totalBonusValue = nil;
    self.totalTradeTitle = nil;
    self.totalTradeValue = nil;
//    self.percentageLabel = nil;
    
    [super dealloc];
}

@end
