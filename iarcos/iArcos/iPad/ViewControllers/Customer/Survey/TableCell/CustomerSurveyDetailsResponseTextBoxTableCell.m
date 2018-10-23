//
//  CustomerSurveyDetailsResponseTextBoxTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 29/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsResponseTextBoxTableCell.h"

@implementation CustomerSurveyDetailsResponseTextBoxTableCell
@synthesize narrative = _narrative;
@synthesize responseTextField = _responseTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.narrative = nil;
    self.responseTextField = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(ArcosGenericClass*)aCellData {
    self.cellData = aCellData;
    self.narrative.text = aCellData.Field4;
        
    self.responseTextField.text = aCellData.Field6;
    if ([[ArcosUtils convertStringToNumber:[ArcosUtils trim:aCellData.Field7]] intValue] == 0) {
        self.responseTextField.enabled = NO;
    } else {
        self.responseTextField.enabled = YES;
    }    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:self.responseTextField.text forIndexPath:self.indexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return ![string isEqualToString:@"|"];
}

@end
