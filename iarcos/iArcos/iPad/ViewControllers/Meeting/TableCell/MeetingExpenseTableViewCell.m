//
//  MeetingExpenseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseTableViewCell.h"

@implementation MeetingExpenseTableViewCell
@synthesize dateLabel = _dateLabel;
@synthesize detailsLabel = _detailsLabel;
@synthesize commentsLabel = _commentsLabel;
@synthesize amountLabel = _amountLabel;

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
    self.detailsLabel = nil;
    self.commentsLabel = nil;
    self.amountLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    
}

@end
