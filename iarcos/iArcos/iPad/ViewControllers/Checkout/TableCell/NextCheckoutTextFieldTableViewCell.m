//
//  NextCheckoutTextFieldTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutTextFieldTableViewCell.h"

@implementation NextCheckoutTextFieldTableViewCell
@synthesize fieldValueTextField = _fieldValueTextField;

- (void)dealloc {
    self.fieldValueTextField = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldData"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableDictionary* myOrderHeader = [self.baseDelegate retrieveOrderHeaderData];
    [myOrderHeader setObject:textField.text forKey:[self.cellData objectForKey:@"CellKey"]];
    
    //check the Geo location
//    [self stampLocation];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    return newLength <= [GlobalSharedClass shared].customerRefMaxLength;
}

@end
