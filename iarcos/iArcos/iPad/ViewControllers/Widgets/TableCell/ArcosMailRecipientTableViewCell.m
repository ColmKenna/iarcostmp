//
//  ArcosMailRecipientTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailRecipientTableViewCell.h"

@implementation ArcosMailRecipientTableViewCell
@synthesize fieldDesc = _fieldDesc;
@synthesize fieldContent = _fieldContent;
@synthesize horizontalHalfDivider = _horizontalHalfDivider;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldDesc = nil;
    self.fieldContent = nil;
    self.horizontalHalfDivider = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    [super configCellWithData:aDataDict];
    self.fieldDesc.text = [aDataDict objectForKey:@"FieldDesc"];
    NSMutableArray* fieldDataList = [aDataDict objectForKey:@"FieldData"];
    self.fieldContent.text = [fieldDataList componentsJoinedByString:@","];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSArray* auxFieldDataList = [textField.text componentsSeparatedByString:@","];
    if ([textField.text isEqualToString:@""]) {
        auxFieldDataList = [NSArray array];
    }
    NSMutableArray* fieldDataList = [NSMutableArray arrayWithArray:auxFieldDataList];
    [self.cellData setObject:fieldDataList forKey:@"FieldData"];
}

@end
