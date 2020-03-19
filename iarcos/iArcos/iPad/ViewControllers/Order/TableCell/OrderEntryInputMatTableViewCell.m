//
//  OrderEntryInputMatTableViewCell.m
//  iArcos
//
//  Created by Apple on 14/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputMatTableViewCell.h"

@implementation OrderEntryInputMatTableViewCell
@synthesize monthDesc = _monthDesc;
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
    self.monthDesc = nil;
    self.qty = nil;
    self.bon = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
