//
//  MeetingAttendeesTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 05/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosAttendeeWithDetails.h"
#import "ArcosUtils.h"

@interface MeetingAttendeesTableViewCell : UITableViewCell {
    UILabel* _nameLabel;
    UILabel* _organisationLabel;
    UIButton* _informedButton;
    UIButton* _confirmedButton;
    UIButton* _attendedButton;
    UIButton* _removedButton;
    
    UIButton* _informedActiveButton;
    UIButton* _confirmedActiveButton;
    UIButton* _attendedActiveButton;
    
    NSIndexPath* _myIndexPath;
    ArcosAttendeeWithDetails* _myArcosAttendeeWithDetails;
}

@property(nonatomic, retain) IBOutlet UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* organisationLabel;
@property(nonatomic, retain) IBOutlet UIButton* informedButton;
@property(nonatomic, retain) IBOutlet UIButton* confirmedButton;
@property(nonatomic, retain) IBOutlet UIButton* attendedButton;
@property(nonatomic, retain) IBOutlet UIButton* removedButton;

@property(nonatomic, retain) IBOutlet UIButton* informedActiveButton;
@property(nonatomic, retain) IBOutlet UIButton* confirmedActiveButton;
@property(nonatomic, retain) IBOutlet UIButton* attendedActiveButton;

@property(nonatomic, retain) NSIndexPath* myIndexPath;
@property(nonatomic, retain) ArcosAttendeeWithDetails* myArcosAttendeeWithDetails;

- (IBAction)informedButtonPressed:(id)sender;
- (IBAction)informedActiveButtonPressed:(id)sender;
- (IBAction)confirmedButtonPressed:(id)sender;
- (IBAction)confirmedActiveButtonPressed:(id)sender;
- (IBAction)attendedButtonPressed:(id)sender;
- (IBAction)attendedActiveButtonPressed:(id)sender;

- (void)configCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails;

@end

