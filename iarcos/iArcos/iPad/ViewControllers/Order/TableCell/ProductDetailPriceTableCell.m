//
//  ProductDetailPriceTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 13/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "ProductDetailPriceTableCell.h"

@implementation ProductDetailPriceTableCell
@synthesize priceTitle = _priceTitle;
@synthesize priceValue = _priceValue;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.priceTitle = nil;
    self.priceValue = nil;
    
    [super dealloc];
}

@end
