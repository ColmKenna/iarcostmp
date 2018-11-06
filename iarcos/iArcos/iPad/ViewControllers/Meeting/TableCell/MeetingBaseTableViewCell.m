//
//  MeetingBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"

@implementation MeetingBaseTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize meetingCellKeyDefinition = _meetingCellKeyDefinition;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.meetingCellKeyDefinition = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.meetingCellKeyDefinition = [[[MeetingCellKeyDefinition alloc] init] autorelease];
}

@end
