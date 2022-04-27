//
//  ArcosCalendarEventEntryTableViewCell.m
//  iArcos
//
//  Created by Richard on 11/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryTableViewCell.h"

@implementation ArcosCalendarEventEntryTableViewCell
@synthesize subjectLabel = _subjectLabel;
@synthesize startDateLabel = _startDateLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.subjectLabel = nil;
    self.startDateLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    self.subjectLabel.text = [aCellData objectForKey:@"Subject"];
    NSDate* startDate = [aCellData objectForKey:@"StartDate"];
    if ([aCellData objectForKey:@"StartDate"] == [NSNull null]) {
        self.startDateLabel.text = @"";
    } else {
        self.startDateLabel.text = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].hourMinuteFormat];
    }
}

@end
