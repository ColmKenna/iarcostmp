//
//  GetRecordGenericBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"

@implementation GetRecordGenericBaseTableViewCell
@synthesize delegate = _delegate;
@synthesize fieldDesc = _fieldDesc;
@synthesize indexPath = _indexPath;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize cellData = _cellData;

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
    self.indexPath = nil;
    self.cellData = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aData {
    self.cellData = aData;
    self.fieldDesc.text = [aData objectForKey:@"fieldDesc"];
}

@end
