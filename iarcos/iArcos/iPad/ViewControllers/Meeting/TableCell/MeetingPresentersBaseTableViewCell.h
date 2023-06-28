//
//  MeetingPresentersBaseTableViewCell.h
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingPresentersCompositeObject.h"
#import "MeetingPresentersTableViewCellDelegate.h"

@interface MeetingPresentersBaseTableViewCell : UITableViewCell {
    id<MeetingPresentersTableViewCellDelegate> _actionDelegate;
    UILabel* _fullTitleLabel;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<MeetingPresentersTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* fullTitleLabel;
@property(nonatomic, retain) NSIndexPath* myIndexPath;


- (void)configCellWithMeetingPresentersCompositeObject:(MeetingPresentersCompositeObject*)aMeetingPresentersCompositeObject;

@end


