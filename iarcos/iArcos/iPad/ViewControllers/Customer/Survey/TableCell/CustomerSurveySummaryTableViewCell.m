//
//  CustomerSurveySummaryTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySummaryTableViewCell.h"

@implementation CustomerSurveySummaryTableViewCell
@synthesize dateLabel = _dateLabel;
@synthesize surveyTitleLabel = _surveyTitleLabel;
@synthesize contactNameLabel = _contactNameLabel;
@synthesize employeeNameLabel = _employeeNameLabel;
@synthesize scoreLabel = _scoreLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.dateLabel = nil;
    self.surveyTitleLabel = nil;
    self.contactNameLabel = nil;
    self.employeeNameLabel = nil;
    self.scoreLabel = nil;
    
    [super dealloc];
}

@end
