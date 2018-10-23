//
//  AccountNumberTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 15/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "AccountNumberTableCell.h"

@implementation AccountNumberTableCell
@synthesize delegate = _delegate;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize indexPath = _indexPath;

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
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:textField.text forIndexpath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
}

@end
