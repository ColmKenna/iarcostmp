//
//  OrderDetailInvoiceValueTableCell.m
//  iArcos
//
//  Created by Richard on 14/12/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "OrderDetailInvoiceValueTableCell.h"

@implementation OrderDetailInvoiceValueTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueLabel = _fieldValueLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.fieldNameLabel != nil) { self.fieldNameLabel = nil; }
    if (self.fieldValueLabel != nil) { self.fieldValueLabel = nil; }
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.fieldNameLabel.text = [theData objectForKey:@"FieldNameLabel"];
    self.fieldValueLabel.text = [theData objectForKey:@"FieldData"];
    
    NSNumber* fieldDataNumber = [ArcosUtils convertStringToFloatNumber:[theData objectForKey:@"FieldData"]];
    if ([fieldDataNumber floatValue] < 0) {
        self.fieldValueLabel.textColor = [UIColor redColor];
    } else {
        self.fieldValueLabel.textColor = [UIColor blackColor];
    }
}

@end
