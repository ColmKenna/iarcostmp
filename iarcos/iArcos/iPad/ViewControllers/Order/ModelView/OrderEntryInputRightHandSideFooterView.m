//
//  OrderEntryInputRightHandSideFooterView.m
//  iArcos
//
//  Created by Apple on 03/07/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputRightHandSideFooterView.h"

@implementation OrderEntryInputRightHandSideFooterView
@synthesize totalLabel = _totalLabel;
@synthesize totalInStock = _totalInStock;
@synthesize totalFoc = _totalFoc;
@synthesize cellSeparator = _cellSeparator;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.totalLabel = nil;
    self.totalInStock = nil;
    self.totalFoc = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
