//
//  OrderlinesIarcosTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosTableViewCell.h"

@implementation OrderlinesIarcosTableViewCell
@synthesize orderPadDetails = _orderPadDetails;
@synthesize productCode = _productCode;
@synthesize productSize = _productSize;
@synthesize description = _description;
@synthesize value = _value;
@synthesize normalQtyView = _normalQtyView;
@synthesize qtyInNormalQtyView = _qtyInNormalQtyView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.orderPadDetails = nil;
    self.productCode = nil;
    self.productSize = nil;
    self.description = nil;
    self.value = nil;
    self.qtyInNormalQtyView = nil;
    self.normalQtyView = nil;
    
    [super dealloc];
}

@end
