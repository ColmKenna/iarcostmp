//
//  MeetingAttachmentsTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttachmentsDataManager.h"
#import "MeetingAttachmentsHeaderViewController.h"
#import "MeetingAttachmentsTableViewCell.h"

@interface MeetingAttachmentsTableViewController : UITableViewController {
    MeetingAttachmentsDataManager* _meetingAttachmentsDataManager;
    MeetingAttachmentsHeaderViewController* _meetingAttachmentsHeaderViewController;
}

@property(nonatomic, retain) MeetingAttachmentsDataManager* meetingAttachmentsDataManager;
@property(nonatomic, retain) MeetingAttachmentsHeaderViewController* meetingAttachmentsHeaderViewController;

- (void)reloadCustomiseTableView;

@end


