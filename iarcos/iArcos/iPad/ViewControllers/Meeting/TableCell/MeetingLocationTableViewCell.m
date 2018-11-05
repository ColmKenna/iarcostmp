//
//  MeetingLocationTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingLocationTableViewCell.h"

@implementation MeetingLocationTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize searchButton = _searchButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueTextField = nil;
    self.searchButton = nil;
    
    [super dealloc];
}

@end
