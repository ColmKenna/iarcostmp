//
//  DetailingTreeBaseTableCell.m
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTreeBaseTableCell.h"

@implementation DetailingTreeBaseTableCell
@synthesize descLabel = _descLabel;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.descLabel = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aData {
    self.descLabel.text = [aData objectForKey:@"Desc"];
    
}

@end
