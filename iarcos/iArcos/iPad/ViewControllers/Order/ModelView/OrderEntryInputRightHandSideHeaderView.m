//
//  OrderEntryInputRightHandSideHeaderView.m
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputRightHandSideHeaderView.h"

@implementation OrderEntryInputRightHandSideHeaderView
@synthesize orderDate = _orderDate;
@synthesize inStock = _inStock;
@synthesize foc = _foc;
@synthesize balance = _balance;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.orderDate = nil;    
    self.inStock = nil;
    self.foc = nil;
    self.balance = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
