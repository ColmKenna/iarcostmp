//
//  ArcosCalendarEventEntryDetailListingTableViewCell.m
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailListingTableViewCell.h"

@implementation ArcosCalendarEventEntryDetailListingTableViewCell
@synthesize timeLabel = _timeLabel;
@synthesize nameLabel = _nameLabel;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.timeLabel = nil;
    self.nameLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aData {
    if ([aData objectForKey:@"Date"] == [NSNull null]) {
        self.timeLabel.text = @"";
    } else {
        self.timeLabel.text = [ArcosUtils stringFromDate:[aData objectForKey:@"Date"] format:[GlobalSharedClass shared].hourMinuteFormat];
    }    
    self.nameLabel.text = [aData objectForKey:@"Name"];
}

@end
