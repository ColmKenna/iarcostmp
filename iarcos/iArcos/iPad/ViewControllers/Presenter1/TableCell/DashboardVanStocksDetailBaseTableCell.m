//
//  DashboardVanStocksDetailBaseTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDetailBaseTableCell.h"

@implementation DashboardVanStocksDetailBaseTableCell
@synthesize actionDelegate = _actionDelegate;
@synthesize cellData = _cellData;
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
    self.cellData = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    
}

@end
