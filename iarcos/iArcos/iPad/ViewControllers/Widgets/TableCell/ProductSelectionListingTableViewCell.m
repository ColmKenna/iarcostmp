//
//  ProductSelectionListingTableViewCell.m
//  iArcos
//
//  Created by Richard on 14/04/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ProductSelectionListingTableViewCell.h"

@implementation ProductSelectionListingTableViewCell
@synthesize productCode = _productCode;
@synthesize descriptionLabel = _descriptionLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.productCode = nil;
    self.descriptionLabel = nil;
                
    [super dealloc];
}

@end
