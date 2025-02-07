//
//  FormRowsKeyboardTableViewCell.m
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsKeyboardTableViewCell.h"

@implementation FormRowsKeyboardTableViewCell
@synthesize myDelegate = _myDelegate;
@synthesize detailsLabel = _detailsLabel;
@synthesize qtyTextField = _qtyTextField;
@synthesize bonusTextField = _bonusTextField;
@synthesize discountTextField = _discountTextField;
@synthesize textFieldList = _textFieldList;
//@synthesize currentTextFieldIndex = _currentTextFieldIndex;
@synthesize myIndexPath = _myIndexPath;
//@synthesize currentTextFieldHighlightedFlag = _currentTextFieldHighlightedFlag;

- (void)dealloc {
    
    self.detailsLabel = nil;
    self.qtyTextField = nil;
    self.bonusTextField = nil;
    self.discountTextField = nil;
    self.textFieldList = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aData {
    self.textFieldList = [NSMutableArray arrayWithObjects:self.qtyTextField, self.bonusTextField, self.discountTextField, nil];
//    self.currentTextFieldHighlightedFlag = NO;
    self.detailsLabel.text = [aData objectForKey:@"Details"];
    self.qtyTextField.text = [ArcosUtils convertZeroToBlank:[[aData objectForKey:@"Qty"] stringValue]];
    self.bonusTextField.text = [ArcosUtils convertZeroToBlank:[[aData objectForKey:@"Bonus"] stringValue]];
    self.discountTextField.text = [ArcosUtils convertZeroToBlank:[[aData objectForKey:@"Discount"] stringValue]];
    NSLog(@"myIndexPath %d-", [ArcosUtils convertNSIntegerToInt:self.myIndexPath.row]);
    for (int i = 0; i < [self.textFieldList count]; i++) {
        UITextField* tmpTextField = [self.textFieldList objectAtIndex:i];
        NSLog(@"innter tag %d", [ArcosUtils convertNSIntegerToInt:tmpTextField.tag]);
        tmpTextField.textColor = [UIColor blackColor];
    }
    if (self.myIndexPath.row == [self.myDelegate retrieveGlobalCurrentIndexPath].row) {
        NSLog(@"same myIndexPath");
        if ([self.myDelegate retrieveGlobalCurrentTextFieldHighlightedFlag]) {
            UITextField* tmpTextField = [self.textFieldList objectAtIndex:[self.myDelegate retrieveGlobalCurrentTextFieldIndex]];
            tmpTextField.textColor = [UIColor redColor];
            NSLog(@"textfield highlighted");
        }
    }    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing %d - %@", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text);
//    self.currentTextFieldIndex = [ArcosUtils convertNSIntegerToInt:textField.tag];
    [self.myDelegate configGlobalCurrentTextFieldIndex:[ArcosUtils convertNSIntegerToInt:textField.tag]];
    [self.myDelegate configGlobalCurrentIndexPath:self.myIndexPath];
    NSLog(@"cc %d", [[self.myDelegate retrieveCurrentTextFieldValueWithIndex:[ArcosUtils convertNSIntegerToInt:textField.tag] forIndexPath:self.myIndexPath] intValue]);
    if ([[self.myDelegate retrieveCurrentTextFieldValueWithIndex:[ArcosUtils convertNSIntegerToInt:textField.tag] forIndexPath:self.myIndexPath] intValue] > 0) {
//        self.currentTextFieldHighlightedFlag = YES;
        [self.myDelegate configGlobalCurrentTextFieldHighlightedFlag:YES];
        textField.textColor = [UIColor redColor];
    } else {
//        self.currentTextFieldHighlightedFlag = NO;
        [self.myDelegate configGlobalCurrentTextFieldHighlightedFlag:NO];
        textField.textColor = [UIColor blackColor];
    }
    NSLog(@"highlighted flag %d", [self.myDelegate retrieveGlobalCurrentTextFieldHighlightedFlag]);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"shouldChangeCharactersInRange %d - %@ - %@", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text, string);
//    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
    
    NSString* assembledString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"assembledString %@", assembledString);
    BOOL integerFlag = [ArcosValidator isInteger:assembledString];
    if ((integerFlag && [self.myDelegate retrieveGlobalCurrentTextFieldHighlightedFlag] && ![string isEqualToString:@""])) {
        textField.text = @"";
//        self.currentTextFieldHighlightedFlag = NO;
        [self.myDelegate configGlobalCurrentTextFieldHighlightedFlag:NO];
        textField.textColor = [UIColor blackColor];
    } else if ([textField.text isEqualToString:@"0"] && [ArcosValidator isInteger:string]) {
        textField.text = @"";
        return YES;
    }
    return (integerFlag || [assembledString isEqualToString:@""]);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing - %d - %@", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text);
    [self.myDelegate inputFinishedWithData:textField.text forIndexPath:self.myIndexPath];
//    self.currentTextFieldHighlightedFlag = NO;
    [self.myDelegate configGlobalCurrentTextFieldHighlightedFlag:NO];
    textField.textColor = [UIColor blackColor];
}

@end
