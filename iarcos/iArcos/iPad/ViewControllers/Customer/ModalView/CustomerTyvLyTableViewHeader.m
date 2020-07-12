//
//  CustomerTyvLyTableViewHeader.m
//  iArcos
//
//  Created by Apple on 06/07/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "CustomerTyvLyTableViewHeader.h"

@implementation CustomerTyvLyTableViewHeader
@synthesize details = _details;
@synthesize inStock = _inStock;
@synthesize lYQty = _lYQty;
@synthesize lYBonus = _lYBonus;
@synthesize lYValue = _lYValue;
@synthesize lYTDQty = _lYTDQty;
@synthesize lYTDBonus = _lYTDBonus;
@synthesize lYTDValue = _lYTDValue;
@synthesize tYTDQty = _tYTDQty;
@synthesize tYTDBonus = _tYTDBonus;
@synthesize tYTDValue = _tYTDValue;
@synthesize qty = _qty;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.details = nil;
    self.inStock = nil;
    self.lYQty = nil;
    self.lYBonus = nil;
    self.lYValue = nil;
    self.lYTDQty = nil;
    self.lYTDBonus = nil;
    self.lYTDValue = nil;
    self.tYTDQty = nil;
    self.tYTDBonus = nil;
    self.tYTDValue = nil;
    self.qty = nil;
    
    [super dealloc];
}

@end
