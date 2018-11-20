//
//  MeetingExpenseDetailsIURTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsIURTableViewCell.h"

@implementation MeetingExpenseDetailsIURTableViewCell
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldValueLabel = nil;
    
    [super dealloc];
}

@end
