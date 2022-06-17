//
//  ArcosCalendarEventEntryDetailBaseTableViewCell.m
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailBaseTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize myIndexPath = _myIndexPath;
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
    self.myIndexPath = nil;
    self.cellData = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.cellData = aCellData;
}

@end
