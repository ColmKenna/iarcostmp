//
//  MeetingAttendeesOthersItemTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesOthersItemTableViewCell.h"
@implementation MeetingAttendeesOthersItemTableViewCell
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
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldData"];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.actionDelegate inputFinishedWithData:textField.text atIndexPath:self.myIndexPath];
}

@end
