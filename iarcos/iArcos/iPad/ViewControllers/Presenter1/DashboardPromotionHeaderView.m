//
//  DashboardPromotionHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardPromotionHeaderView.h"

@implementation DashboardPromotionHeaderView
@synthesize productCodeLabel = _productCodeLabel;
@synthesize descLabel = _descLabel;
@synthesize productSizeLabel = _productSizeLabel;
@synthesize bonusMinimumLabel = _bonusMinimumLabel;
@synthesize bonusRequiredLabel = _bonusRequiredLabel;
@synthesize bonusGivenLabel = _bonusGivenLabel;
@synthesize cellSeparator = _cellSeparator;

- (void)dealloc {
    self.productCodeLabel = nil;
    self.descLabel = nil;
    self.productSizeLabel = nil;
    self.bonusMinimumLabel = nil;
    self.bonusRequiredLabel = nil;
    self.bonusGivenLabel = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
