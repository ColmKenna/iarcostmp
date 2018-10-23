//
//  OrderDetailNumberTextFieldTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderDetailNumberTextFieldTableCell.h"

@implementation OrderDetailNumberTextFieldTableCell
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

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
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
    self.fieldValueTextField.text = [ArcosUtils convertZeroToBlank:[theData objectForKey:@"FieldData"]];
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
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
}

@end
