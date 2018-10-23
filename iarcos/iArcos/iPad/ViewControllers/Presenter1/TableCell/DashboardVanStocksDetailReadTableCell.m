//
//  DashboardVanStocksDetailReadTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDetailReadTableCell.h"

@implementation DashboardVanStocksDetailReadTableCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueTextField = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.fieldNameLabel.text = [aDataDict objectForKey:@"FieldName"];
    self.fieldValueTextField.text = [ArcosUtils convertNumberToIntString:[aDataDict objectForKey:@"FieldData"]];
}



@end
