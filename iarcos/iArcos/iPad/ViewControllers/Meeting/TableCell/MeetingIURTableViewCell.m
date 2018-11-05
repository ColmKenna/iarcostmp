//
//  MeetingIURTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingIURTableViewCell.h"

@implementation MeetingIURTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
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
    self.fieldNameLabel = nil;
    self.fieldValueLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
}

@end
