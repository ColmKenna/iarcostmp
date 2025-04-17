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
//@synthesize uniLabel = _uniLabel;
//@synthesize udLabel = _udLabel;
@synthesize maxLabel = _maxLabel;
@synthesize prevLabel = _prevLabel;
@synthesize prevNormalLabel = _prevNormalLabel;
@synthesize holder = _holder;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Round corners on holder
    self.holder.layer.cornerRadius = 8.0; // adjust as needed
    self.holder.layer.masksToBounds = YES; // or use clipsToBounds = YES;
}

- (void)dealloc {
    self.descLabel = nil;
    self.rrpLabel = nil;
    self.priceLabel = nil;
    self.qtyLabel = nil;
    self.bonusLabel = nil;
    self.discountLabel = nil;
    self.valueLabel = nil;
    self.maxLabel = nil;
    self.prevLabel = nil;
    self.prevNormalLabel = nil;
    self.holder = nil;

    [super dealloc];
}

@end
