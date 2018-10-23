//
//  DashboardStockoutHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardStockoutHeaderView.h"

@implementation DashboardStockoutHeaderView
@synthesize productCodeLabel = _productCodeLabel;
@synthesize descLabel = _descLabel;
@synthesize productSizeLabel = _productSizeLabel;
@synthesize onOrderLabel = _onOrderLabel;
@synthesize dueDateLabel = _dueDateLabel;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.productCodeLabel = nil;
    self.descLabel = nil;
    self.productSizeLabel = nil;
    self.onOrderLabel = nil;
    self.dueDateLabel = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
