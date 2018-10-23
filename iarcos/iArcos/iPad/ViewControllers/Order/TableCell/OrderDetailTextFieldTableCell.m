//
//  OrderDetailTextFieldTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailTextFieldTableCell.h"

@implementation OrderDetailTextFieldTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
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
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:[ArcosUtils trim:textField.text] forIndexpath:self.indexPath];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* cellKey = [self.cellData objectForKey:@"CellKey"];
    if (![cellKey isEqualToString:@"custRef"]) {
        return YES;
    }
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
//    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
//    return newLength <= [GlobalSharedClass shared].customerRefMaxLength || returnKey;
    return newLength <= [GlobalSharedClass shared].customerRefMaxLength;
}

@end
