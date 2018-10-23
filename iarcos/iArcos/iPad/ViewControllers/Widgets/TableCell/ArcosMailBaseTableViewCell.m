//
//  ArcosMailBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMailBaseTableViewCell.h"

@implementation ArcosMailBaseTableViewCell
@synthesize myDelegate = _myDelegate;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.cellData = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.cellData = aDataDict;
    
}

@end
