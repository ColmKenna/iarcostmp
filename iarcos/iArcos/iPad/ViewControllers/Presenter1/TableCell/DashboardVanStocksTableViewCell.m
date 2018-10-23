//
//  DashboardVanStocksTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 16/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksTableViewCell.h"

@implementation DashboardVanStocksTableViewCell
@synthesize productCodeLabel = _productCodeLabel;
@synthesize descLabel = _descLabel;
@synthesize productSizeLabel = _productSizeLabel;
@synthesize stockOnOrderLabel = _stockOnOrderLabel;
@synthesize stockOnHandLabel = _stockOnHandLabel;
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
    self.productCodeLabel = nil;
    self.descLabel = nil;
    self.productSizeLabel = nil;
    self.stockOnOrderLabel = nil;
    self.stockOnHandLabel = nil;
    self.cellSeparator = nil;
    
    [super dealloc];
}

@end
