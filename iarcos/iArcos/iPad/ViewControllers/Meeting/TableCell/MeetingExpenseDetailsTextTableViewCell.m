//
//  MeetingExpenseDetailsTextTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsTextTableViewCell.h"

@implementation MeetingExpenseDetailsTextTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;

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
    
    [super dealloc];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.baseDelegate inputFinishedWithData:textField.text atIndexPath:self.myIndexPath];
}



@end
