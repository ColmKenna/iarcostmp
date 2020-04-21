//
//  OrderEntryInputRightHandSideTableViewCell.m
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputRightHandSideTableViewCell.h"

@implementation OrderEntryInputRightHandSideTableViewCell
@synthesize orderDate = _orderDate;
@synthesize foc = _foc;
@synthesize inStock = _inStock;
@synthesize balance = _balance;
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
    self.orderDate = nil;
    self.foc = nil;
    self.inStock = nil;
    self.balance = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
