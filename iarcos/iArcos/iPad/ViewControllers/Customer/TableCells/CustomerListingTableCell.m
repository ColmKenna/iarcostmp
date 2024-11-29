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
@synthesize locationCodeLabel = _locationCodeLabel;
@synthesize dateLabel = _dateLabel;
@synthesize contactLabel = _contactLabel;
@synthesize memoTextView = _memoTextView;
@synthesize weekDayCallNumberLabel = _weekDayCallNumberLabel;

- (void)dealloc {
    self.nameLabel = nil;
    self.addressLabel = nil;
    self.locationStatusButton = nil;
    self.creditStatusButton = nil;
    self.locationCodeLabel = nil;
    self.dateLabel = nil;
    self.contactLabel = nil;
    self.memoTextView = nil;
    self.weekDayCallNumberLabel = nil;
    
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

- (void)configCallInfoWithCallHeader:(OrderHeader*)anCallHeader {
    
}

@end
