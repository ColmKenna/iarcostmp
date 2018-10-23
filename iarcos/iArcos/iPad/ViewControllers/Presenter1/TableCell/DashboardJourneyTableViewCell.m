//
//  DashboardJourneyTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 08/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardJourneyTableViewCell.h"

@implementation DashboardJourneyTableViewCell
@synthesize customerName = _customerName;
@synthesize customerAddress = _customerAddress;
@synthesize customerStatus = _customerStatus;
@synthesize mySeparator = _mySeparator;

- (void)dealloc {
    self.customerName = nil;
    self.customerAddress = nil;
    self.customerStatus = nil;
    self.mySeparator = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
