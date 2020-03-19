//
//  OrderEntryInputMatHeaderView.m
//  iArcos
//
//  Created by Apple on 15/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputMatHeaderView.h"

@implementation OrderEntryInputMatHeaderView
@synthesize qty = _qty;
@synthesize bon = _bon;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.qty = nil;
    self.bon = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}


@end
