//
//  DetailingCalendarEventBoxListingHeaderTableCell.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingHeaderTableCell.h"

@implementation DetailingCalendarEventBoxListingHeaderTableCell
@synthesize fieldDescLabel = _fieldDescLabel;
@synthesize dividerLabel = _dividerLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldDescLabel = nil;
    self.dividerLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSDate* currentDate = [aCellData objectForKey:@"FieldDesc"];
    self.fieldDescLabel.text = [ArcosUtils stringFromDate:currentDate format:[GlobalSharedClass shared].hourMinuteFormat];
}

@end
