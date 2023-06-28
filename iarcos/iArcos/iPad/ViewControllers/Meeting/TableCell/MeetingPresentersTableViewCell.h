//
//  MeetingPresentersTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 12/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosPresenterForMeeting.h"
#import "ArcosPresenter.h"
#import "ArcosUtils.h"
#import "MeetingPresentersBaseTableViewCell.h"

@interface MeetingPresentersTableViewCell : MeetingPresentersBaseTableViewCell {
    
    UIImageView* _myImageView;
//    UILabel* _fullTitleLabel;
    UILabel* _memoDetailsLabel;
    UIButton* _shownButton;
    UIButton* _shownActiveButton;
//    NSIndexPath* _myIndexPath;
}

@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* memoDetailsLabel;
@property(nonatomic, retain) IBOutlet UIButton* shownButton;
@property(nonatomic, retain) IBOutlet UIButton* shownActiveButton;
//@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithArcosPresenterForMeeting:(ArcosPresenterForMeeting*)anArcosPresenterForMeeting;
- (IBAction)shownButtonPressed:(id)sender;
- (IBAction)shownActiveButtonPressed:(id)sender;


@end

