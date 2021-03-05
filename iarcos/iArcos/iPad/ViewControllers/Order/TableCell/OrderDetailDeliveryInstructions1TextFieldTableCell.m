//
//  OrderDetailDeliveryInstructions1TextFieldTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 15/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "OrderDetailDeliveryInstructions1TextFieldTableCell.h"
#import "ArcosConfigDataManager.h"

@implementation OrderDetailDeliveryInstructions1TextFieldTableCell
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
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueTextField != nil) { self.fieldValueTextField = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    self.fieldValueTextField.text = [theData objectForKey:@"FieldData"];
    if (self.isNotEditable) {
        self.fieldValueTextField.textColor = [UIColor blackColor];
        self.fieldValueTextField.enabled = NO;
    } else {
        self.fieldValueTextField.textColor = [UIColor blueColor];
        self.fieldValueTextField.enabled = YES;
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showDeliveryInstructionsFlag]) {
            self.fieldValueTextField.textColor = [UIColor blackColor];
            self.fieldValueTextField.enabled = NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:[ArcosUtils trim:textField.text] forIndexpath:self.indexPath];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    return newLength <= [GlobalSharedClass shared].deliveryInstructions1MaxLength;
}

@end
