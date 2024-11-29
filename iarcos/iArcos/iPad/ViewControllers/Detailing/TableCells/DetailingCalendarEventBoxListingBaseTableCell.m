//
//  DetailingCalendarEventBoxListingBaseTableCell.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBaseTableCell.h"

@implementation DetailingCalendarEventBoxListingBaseTableCell
@synthesize actionDelegate = _actionDelegate;
@synthesize myIndexPath = _myIndexPath;
@synthesize myCellData = _myCellData;
@synthesize fieldValueLabel = _fieldValueLabel;
@synthesize locationStatusButton = _locationStatusButton;
@synthesize creditStatusButton = _creditStatusButton;

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
    self.myCellData = nil;
    self.fieldValueLabel = nil;
    self.locationStatusButton = nil;
    self.creditStatusButton = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.myCellData = aCellData;
}

- (void)configCellLocationCreditStatusButtonWithObject:(LocationCreditStatusDataManager*)aLocationCreditStatusDataManager {
    [self.locationStatusButton setImage:nil forState:UIControlStateNormal];
    [self.creditStatusButton setImage:nil forState:UIControlStateNormal];
}

@end
