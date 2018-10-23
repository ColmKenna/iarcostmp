//
//  DashboardVanStocksHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksHeaderView.h"

@implementation DashboardVanStocksHeaderView
@synthesize productCodeLabel = _productCodeLabel;
@synthesize descLabel = _descLabel;
@synthesize productSizeLabel = _productSizeLabel;
@synthesize idealLabel = _idealLabel;
@synthesize inVanLabel = _inVanLabel;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.productCodeLabel = nil;
    self.descLabel = nil;
    self.productSizeLabel = nil;
    self.idealLabel = nil;
    self.inVanLabel = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
