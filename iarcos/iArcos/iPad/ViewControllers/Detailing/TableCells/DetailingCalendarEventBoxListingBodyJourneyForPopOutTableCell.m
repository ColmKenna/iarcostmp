//
//  DetailingCalendarEventBoxListingBodyJourneyForPopOutTableCell.m
//  iArcos
//
//  Created by Richard on 26/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyJourneyForPopOutTableCell.h"

@implementation DetailingCalendarEventBoxListingBodyJourneyForPopOutTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellLocationCreditStatusButtonWithObject:(LocationCreditStatusDataManager*)aLocationCreditStatusDataManager {
    [super configCellLocationCreditStatusButtonWithObject:aLocationCreditStatusDataManager];
    
    NSMutableDictionary* cellData = [self.myCellData objectForKey:@"FieldValue"];
//    NSLog(@"myCellData %@", self.myCellData);
    [aLocationCreditStatusDataManager configImageWithLocationStatusButton:self.locationStatusButton creditStatusButton:self.creditStatusButton lsiur:[ArcosUtils convertNilToZero:[cellData objectForKey:@"lsiur"]] csiur:[ArcosUtils convertNilToZero:[cellData objectForKey:@"CSiur"]]];
}

@end
