//
//  CheckoutPrinterOrderLineHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 12/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPrinterOrderLineHeaderView.h"

@implementation CheckoutPrinterOrderLineHeaderView
@synthesize desc = _desc;
@synthesize qty = _qty;
@synthesize bon = _bon;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.desc = nil;
    self.qty = nil;
    self.bon = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
