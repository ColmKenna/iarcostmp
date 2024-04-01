//
//  DetailingCalendarEventBoxListingBodyForTemplateTableCell.m
//  iArcos
//
//  Created by Richard on 29/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyForTemplateTableCell.h"

@implementation DetailingCalendarEventBoxListingBodyForTemplateTableCell
@synthesize fieldDescLabel = _fieldDescLabel;

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
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSMutableDictionary* cellData = [aCellData objectForKey:@"FieldValue"];
    if ([cellData objectForKey:@"Date"] == [NSNull null]) {
        self.fieldDescLabel.text = @"";
    } else {
        self.fieldDescLabel.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"Date"] format:[GlobalSharedClass shared].hourMinuteFormat];
    }
    self.fieldValueLabel.text = [cellData objectForKey:@"Name"];
    NSNumber* tmpLocationIUR = [cellData objectForKey:@"LocationIUR"];
    if ([tmpLocationIUR intValue] != 0 && [tmpLocationIUR isEqualToNumber:[self.actionDelegate retrieveDetailingCalendarEventBoxListingTableCellLocationIUR]]) {
        self.fieldValueLabel.backgroundColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
    } else {
        self.fieldValueLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    }
    
}

@end
