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
@synthesize bgView = _bgView;
@synthesize titleLabel = _titleLabel;
@synthesize locationLabel = _locationLabel;

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
    self.bgView = nil;
    self.titleLabel = nil;
    self.locationLabel = nil;
    
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
    self.titleLabel.text = [cellData objectForKey:@"Subject"];
    self.locationLabel.text = [cellData objectForKey:@"Name"];
    NSNumber* tmpLocationIUR = [cellData objectForKey:@"LocationIUR"];
    if ([tmpLocationIUR intValue] != 0 && [tmpLocationIUR isEqualToNumber:[self.actionDelegate retrieveDetailingCalendarEventBoxListingTableCellLocationIUR]]) {
        self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
        self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.locationLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    } else {
//        self.fieldValueLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.titleLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.locationLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    }
    
}

@end
