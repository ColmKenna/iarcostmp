//
//  CustomerGroupWholesalerCodeTableViewCell.m
//  iArcos
//
//  Created by Apple on 05/06/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupWholesalerCodeTableViewCell.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@implementation CustomerGroupWholesalerCodeTableViewCell
@synthesize contentTextField = _contentTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.contentTextField = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.descLabel.text = [theData objectForKey:@"Title"];
    NSMutableDictionary* auxAnswerDict = [theData objectForKey:@"Answer"];
    NSString* detailContent = [auxAnswerDict objectForKey:@"Detail"];
    if ([detailContent isEqualToString:[GlobalSharedClass shared].unassignedText]) {
        self.contentTextField.text = @"";
    } else {
        self.contentTextField.text = detailContent;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.actionDelegate wholesalerCodeInputFinishedWithData:[ArcosUtils trim:textField.text] indexPath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
}

@end
