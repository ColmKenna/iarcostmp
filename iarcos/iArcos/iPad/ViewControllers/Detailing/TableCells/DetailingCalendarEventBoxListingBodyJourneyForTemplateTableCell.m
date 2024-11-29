//
//  DetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell.m
//  iArcos
//
//  Created by Richard on 16/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell.h"

@implementation DetailingCalendarEventBoxListingBodyJourneyForTemplateTableCell
@synthesize myImageButton = _myImageButton;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize addressLabel = _addressLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myImageButton = nil;
    self.locationNameLabel = nil;
    self.addressLabel = nil;
    
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSMutableDictionary* cellData = [aCellData objectForKey:@"FieldValue"];    
    self.locationNameLabel.text = [cellData objectForKey:@"Name"];
    self.addressLabel.text = [cellData objectForKey:@"Address"];
}

@end
