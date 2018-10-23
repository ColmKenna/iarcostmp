//
//  ArcosMailSubjectTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailSubjectTableViewCell.h"

@implementation ArcosMailSubjectTableViewCell
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
    self.fieldContent.text = [aDataDict objectForKey:@"FieldData"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {    
    [self.cellData setObject:textField.text forKey:@"FieldData"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* auxText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.myDelegate updateSubjectText:auxText];
    return YES;
}



@end
