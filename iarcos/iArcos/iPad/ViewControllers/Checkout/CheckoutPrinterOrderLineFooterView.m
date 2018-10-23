//
//  CheckoutPrinterOrderLineFooterView.m
//  iArcos
//
//  Created by David Kilmartin on 15/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPrinterOrderLineFooterView.h"

@implementation CheckoutPrinterOrderLineFooterView
@synthesize desc = _desc;
@synthesize totalQty = _totalQty;
@synthesize totalBon = _totalBon;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.desc = nil;
    self.totalQty = nil;
    self.totalBon = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}


@end
