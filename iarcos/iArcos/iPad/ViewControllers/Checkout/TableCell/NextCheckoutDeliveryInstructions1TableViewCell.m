//
//  NextCheckoutDeliveryInstructions1TableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 14/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutDeliveryInstructions1TableViewCell.h"

@implementation NextCheckoutDeliveryInstructions1TableViewCell
@synthesize fieldValueTextField = _fieldValueTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.fieldValueTextField = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldData"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableDictionary* myOrderHeader = [self.baseDelegate retrieveOrderHeaderData];
    [myOrderHeader setObject:textField.text forKey:[self.cellData objectForKey:@"CellKey"]];
    
    
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    return newLength <= [GlobalSharedClass shared].deliveryInstructions1MaxLength;
}

@end
