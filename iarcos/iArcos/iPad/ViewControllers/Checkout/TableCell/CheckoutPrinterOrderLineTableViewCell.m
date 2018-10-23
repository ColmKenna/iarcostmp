//
//  CheckoutPrinterOrderLineTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 12/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPrinterOrderLineTableViewCell.h"

@implementation CheckoutPrinterOrderLineTableViewCell
@synthesize productCodeOrderPadDetails = _productCodeOrderPadDetails;
@synthesize productDesc = _productDesc;
@synthesize qty = _qty;
@synthesize bon = _bon;
@synthesize cellSeparator = _cellSeparator;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.productCodeOrderPadDetails = nil;
    self.productDesc = nil;
    self.qty = nil;
    self.bon = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
