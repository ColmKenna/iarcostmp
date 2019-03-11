//
//  MeetingAttendeesOthersItemTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttendeesOthersItemTableViewCell.h"
#import "MeetingAttendeesOthersItemTableViewControllerDelegate.h"

@interface MeetingAttendeesOthersItemTableViewController : UITableViewController <MeetingAttendeesOthersItemTableViewCellDelegate> {
    id<MeetingAttendeesOthersItemTableViewControllerDelegate> _actionDelegate;
    NSMutableArray* _displayList;
}

@property(nonatomic, assign) id<MeetingAttendeesOthersItemTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;

@end

