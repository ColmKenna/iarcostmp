//
//  MeetingAttendeesTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 05/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesTableViewCell.h"

@implementation MeetingAttendeesTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize nameLabel = _nameLabel;
@synthesize organisationLabel = _organisationLabel;
@synthesize informedButton = _informedButton;
@synthesize confirmedButton = _confirmedButton;
@synthesize attendedButton = _attendedButton;
@synthesize removedButton = _removedButton;

@synthesize informedActiveButton = _informedActiveButton;
@synthesize confirmedActiveButton = _confirmedActiveButton;
@synthesize attendedActiveButton = _attendedActiveButton;
@synthesize removedActiveButton = _removedActiveButton;

@synthesize myIndexPath = _myIndexPath;
@synthesize myArcosAttendeeWithDetails = _myArcosAttendeeWithDetails;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.actionDelegate = nil;
    self.nameLabel = nil;
    self.organisationLabel = nil;
    self.informedButton = nil;
    self.confirmedButton = nil;
    self.attendedButton = nil;
    self.removedButton = nil;
    
    self.informedButton = nil;
    self.confirmedActiveButton = nil;
    self.attendedActiveButton = nil;
    self.removedActiveButton = nil;
    
    self.myIndexPath = nil;
    self.myArcosAttendeeWithDetails = nil;
    
    [super dealloc];
}

- (IBAction)informedButtonPressed:(id)sender {
    [self configHideInformedButtonWithFlag:YES];
    [self.actionDelegate meetingAttendeesInformedFlag:YES atIndexPath:self.myIndexPath];
}
- (IBAction)informedActiveButtonPressed:(id)sender {
    [self configHideInformedButtonWithFlag:NO];
    [self.actionDelegate meetingAttendeesInformedFlag:NO atIndexPath:self.myIndexPath];
}
- (IBAction)confirmedButtonPressed:(id)sender {
    [self configHideConfirmedButtonWithFlag:YES];
    [self.actionDelegate meetingAttendeesConfirmedFlag:YES atIndexPath:self.myIndexPath];
}
- (IBAction)confirmedActiveButtonPressed:(id)sender {
    [self configHideConfirmedButtonWithFlag:NO];
    [self.actionDelegate meetingAttendeesConfirmedFlag:NO atIndexPath:self.myIndexPath];
}
- (IBAction)attendedButtonPressed:(id)sender {
    [self configHideAttendedButtonWithFlag:YES];
    [self.actionDelegate meetingAttendeesAttendedFlag:YES atIndexPath:self.myIndexPath];
}
- (IBAction)attendedActiveButtonPressed:(id)sender {
    [self configHideAttendedButtonWithFlag:NO];
    [self.actionDelegate meetingAttendeesAttendedFlag:NO atIndexPath:self.myIndexPath];
}
- (IBAction)removedButtonPressed:(id)sender {
    self.myArcosAttendeeWithDetails.COiur = 0;
    [self.actionDelegate meetingAttendeeRevertDeleteActionWithIndexPath:self.myIndexPath];
}
- (IBAction)removedActiveButtonPressed:(id)sender {
    [self.actionDelegate meetingAttendeeSelectFinishedWithData:self.myArcosAttendeeWithDetails indexPath:self.myIndexPath];
}

- (void)configCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
    self.myArcosAttendeeWithDetails = anArcosAttendeeWithDetails;
    self.nameLabel.text = [ArcosUtils convertNilToEmpty:self.myArcosAttendeeWithDetails.Name];
    self.organisationLabel.text = [ArcosUtils convertNilToEmpty:self.myArcosAttendeeWithDetails.Organisation];
    [self configHideInformedButtonWithFlag:anArcosAttendeeWithDetails.Informed];
    [self configHideConfirmedButtonWithFlag:anArcosAttendeeWithDetails.Confirmed];
    [self configHideAttendedButtonWithFlag:anArcosAttendeeWithDetails.Attended];
    [self configHideRemovedButtonWithCOiur:anArcosAttendeeWithDetails.COiur];
}

- (void)configHideInformedButtonWithFlag:(BOOL)anInformedHideFlag {
    self.informedButton.hidden = anInformedHideFlag;
    self.informedActiveButton.hidden = !anInformedHideFlag;
}

- (void)configHideConfirmedButtonWithFlag:(BOOL)aConfirmedHideFlag {
    self.confirmedButton.hidden = aConfirmedHideFlag;
    self.confirmedActiveButton.hidden = !aConfirmedHideFlag;
}

- (void)configHideAttendedButtonWithFlag:(BOOL)anAttendedHideFlag {
    self.attendedButton.hidden = anAttendedHideFlag;
    self.attendedActiveButton.hidden = !anAttendedHideFlag;
}

- (void)configHideRemovedButtonWithCOiur:(int)aCOiur {
    BOOL aRemovedHideFlag = YES;
    if (aCOiur == -999) {
        aRemovedHideFlag = NO;
    }
    self.removedButton.hidden = aRemovedHideFlag;
    self.removedActiveButton.hidden = !aRemovedHideFlag;
}

@end
