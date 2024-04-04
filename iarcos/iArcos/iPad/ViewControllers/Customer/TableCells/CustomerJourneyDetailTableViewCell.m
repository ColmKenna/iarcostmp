//
//  CustomerJourneyDetailTableViewCell.m
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailTableViewCell.h"

@implementation CustomerJourneyDetailTableViewCell
@synthesize weekDayCallNumberLabel = _weekDayCallNumberLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.weekDayCallNumberLabel = nil;
    
    [super dealloc];
}

@end
