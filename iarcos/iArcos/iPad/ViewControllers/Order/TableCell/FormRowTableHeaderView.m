//
//  FormRowTableHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 26/09/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "FormRowTableHeaderView.h"

@implementation FormRowTableHeaderView
@synthesize descLabel = _descLabel;
@synthesize rrpLabel = _rrpLabel;
@synthesize priceLabel = _priceLabel;
@synthesize qtyLabel = _qtyLabel;
@synthesize bonusLabel = _bonusLabel;
@synthesize discountLabel = _discountLabel;
@synthesize valueLabel = _valueLabel;
@synthesize uniLabel = _uniLabel;
@synthesize udLabel = _udLabel;

- (void)dealloc {
    self.descLabel = nil;
    self.rrpLabel = nil;
    self.priceLabel = nil;
    self.qtyLabel = nil;
    self.bonusLabel = nil;
    self.discountLabel = nil;
    self.valueLabel = nil;
    self.uniLabel = nil;
    self.udLabel = nil;
    
    [super dealloc];
}

@end
