//
//  MeetingPresentersBaseTableViewCell.m
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersBaseTableViewCell.h"

@implementation MeetingPresentersBaseTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize fullTitleLabel = _fullTitleLabel;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fullTitleLabel = nil;    
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithMeetingPresentersCompositeObject:(MeetingPresentersCompositeObject*)aMeetingPresentersCompositeObject {
    
}

@end
