//
//  PriceChangeReadableTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeReadableTableCell.h"

@implementation PriceChangeReadableTableCell
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
    NSNumber* tmpPriceFlag = [aDataDict objectForKey:@"PriceFlag"];
    int priceFlagIntValue = [tmpPriceFlag intValue]; 
    if (priceFlagIntValue == 1) {
        self.fieldDataTextField.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        self.fieldDataTextField.font = [UIFont boldSystemFontOfSize:24.0];
        self.fieldDataTextField.backgroundColor = [UIColor yellowColor];
    } else if (priceFlagIntValue == 2) {
        self.fieldDataTextField.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
        self.fieldDataTextField.font = [UIFont boldSystemFontOfSize:24.0];
        self.fieldDataTextField.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:251.0/255.0 blue:152.0/255.0 alpha:1.0];
    } else {
        self.fieldDataTextField.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
        self.fieldDataTextField.font = [UIFont systemFontOfSize:24.0];
        self.fieldDataTextField.backgroundColor = [UIColor whiteColor];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
