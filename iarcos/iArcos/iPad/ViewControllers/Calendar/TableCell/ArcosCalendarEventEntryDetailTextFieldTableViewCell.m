//
//  ArcosCalendarEventEntryDetailTextFieldTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailTextFieldTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailTextFieldTableViewCell
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
    self.fieldValueTextField = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.fieldValueTextField.placeholder = [aCellData objectForKey:@"FieldDesc"];
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldData"];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.actionDelegate detailBaseInputFinishedWithData:textField.text atIndexPath:self.myIndexPath];
}

@end
