//
//  CustomerListingTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 08/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerListingTableCell.h"

@implementation CustomerListingTableCell
@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize locationStatusButton = _locationStatusButton;
@synthesize creditStatusButton = _creditStatusButton;

- (void)dealloc {
    self.nameLabel = nil;
    self.addressLabel = nil;
    self.locationStatusButton = nil;
    self.creditStatusButton = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
