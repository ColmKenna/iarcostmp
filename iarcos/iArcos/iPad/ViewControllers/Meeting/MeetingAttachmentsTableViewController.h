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
#import "CallGenericServices.h"
#import "MeetingAttachmentsFileViewController.h"
#import "MeetingAttachmentsTableViewControllerDelegate.h"

@interface MeetingAttachmentsTableViewController : UITableViewController<MeetingAttachmentsTableViewCellDelegate, ModalPresentViewControllerDelegate, MeetingAttachmentsHeaderViewControllerDelegate> {
    id<MeetingAttachmentsTableViewControllerDelegate> _actionDelegate;
    MeetingAttachmentsDataManager* _meetingAttachmentsDataManager;
    MeetingAttachmentsHeaderViewController* _meetingAttachmentsHeaderViewController;
    CallGenericServices* _callGenericServices;
}

@property(nonatomic, assign) id<MeetingAttachmentsTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) MeetingAttachmentsDataManager* meetingAttachmentsDataManager;
@property(nonatomic, retain) MeetingAttachmentsHeaderViewController* meetingAttachmentsHeaderViewController;
@property(nonatomic, retain) CallGenericServices* callGenericServices;

- (void)reloadCustomiseTableView;

@end


