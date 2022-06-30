//
//  ArcosCalendarEventEntryTableViewCell.m
//  iArcos
//
//  Created by Richard on 11/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryTableViewCell.h"

@implementation ArcosCalendarEventEntryTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize subjectLabel = _subjectLabel;
@synthesize startDateLabel = _startDateLabel;
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
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    self.subjectLabel = nil;
    self.startDateLabel = nil;
    self.myIndexPath = nil;
    
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
    
    for (UIGestureRecognizer* recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate eventEntryInputFinishedWithIndexPath:self.myIndexPath sourceView:self.contentView];
    }
}

@end
