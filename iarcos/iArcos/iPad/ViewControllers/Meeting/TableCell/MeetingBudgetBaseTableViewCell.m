//
//  MeetingBudgetBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBudgetBaseTableViewCell.h"

@implementation MeetingBudgetBaseTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize myIndexPath = _myIndexPath;

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
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldValue"];
}

@end
