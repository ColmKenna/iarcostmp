//
//  MeetingPresentersTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 12/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersTableViewCell.h"

@implementation MeetingPresentersTableViewCell
@synthesize myImageView = _myImageView;
@synthesize memoDetailsLabel = _memoDetailsLabel;
@synthesize shownButton = _shownButton;
@synthesize shownActiveButton = _shownActiveButton;
//@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myImageView = nil;
    self.memoDetailsLabel = nil;
    self.shownButton = nil;
    self.shownActiveButton = nil;
//    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithMeetingPresentersCompositeObject:(MeetingPresentersCompositeObject*)aMeetingPresentersCompositeObject {
    [self configCellWithArcosPresenterForMeeting:aMeetingPresentersCompositeObject.presenterData];
}

- (void)configCellWithArcosPresenterForMeeting:(ArcosPresenterForMeeting*)anArcosPresenterForMeeting {
    int auxImageIUR = anArcosPresenterForMeeting.ImageIUR;
    self.myImageView.image = [ArcosUtils genericImageWithIUR:[NSNumber numberWithInt:auxImageIUR]];
    self.fullTitleLabel.text = [ArcosUtils convertNilToEmpty:anArcosPresenterForMeeting.Title];
    self.memoDetailsLabel.text = [ArcosUtils convertNilToEmpty:anArcosPresenterForMeeting.MemoDetails];
    [self configHideShownButtonWithFlag:anArcosPresenterForMeeting.Shown];
    if (anArcosPresenterForMeeting.Active) {
        self.memoDetailsLabel.textColor = [UIColor darkTextColor];
    } else {
        self.memoDetailsLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1.0];
    }
}

- (void)configHideShownButtonWithFlag:(BOOL)aShownButtonHideFlag {
    self.shownButton.hidden = aShownButtonHideFlag;
    self.shownActiveButton.hidden = !aShownButtonHideFlag;
}

- (IBAction)shownButtonPressed:(id)sender {
    [self configHideShownButtonWithFlag:YES];
    [self.actionDelegate meetingPresentersLinkToMeeting:YES atIndexPath:self.myIndexPath];
}

- (IBAction)shownActiveButtonPressed:(id)sender {
    [self configHideShownButtonWithFlag:NO];
    [self.actionDelegate meetingPresentersLinkToMeeting:NO atIndexPath:self.myIndexPath];
}

@end
