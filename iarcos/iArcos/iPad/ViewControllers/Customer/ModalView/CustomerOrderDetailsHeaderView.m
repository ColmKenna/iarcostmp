//
//  CustomerOrderDetailsHeaderView.m
//  iArcos
//
//  Created by Apple on 06/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "CustomerOrderDetailsHeaderView.h"

@implementation CustomerOrderDetailsHeaderView
@synthesize qtyLabel = _qtyLabel;
@synthesize bonusLabel = _bonusLabel;
@synthesize inStockLabel = _inStockLabel;
@synthesize focLabel = _focLabel;
@synthesize testersLabel = _testersLabel;
@synthesize discountPercentLabel = _discountPercentLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize unitPriceLabel = _unitPriceLabel;
@synthesize lineValueLabel = _lineValueLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    self.qtyLabel = nil;
    self.bonusLabel = nil;
    self.inStockLabel = nil;
    self.focLabel = nil;
    self.testersLabel = nil;
    self.discountPercentLabel = nil;
    self.descriptionLabel = nil;
    self.unitPriceLabel = nil;
    self.lineValueLabel = nil;
    
    [super dealloc];
}

@end
