//
//  PriceChangeBaseTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeBaseTableCell.h"

@implementation PriceChangeBaseTableCell
@synthesize delegate = _delegate;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize indexPath = _indexPath;

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
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.fieldNameLabel.text = [aDataDict objectForKey:@"FieldName"];
}

@end
