//
//  PriceChangeWritableTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeWritableTableCell.h"

@implementation PriceChangeWritableTableCell
@synthesize fieldDataTextField = _fieldDataTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.fieldDataTextField = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    [super configCellWithData:aDataDict];
    self.fieldDataTextField.text = [aDataDict objectForKey:@"FieldData"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:textField.text forIndexPath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* assembledString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return ([ArcosValidator isInputDecimalWithTwoPlaces:assembledString] || [assembledString isEqualToString:@""]);
}

@end
