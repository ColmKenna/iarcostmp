//
//  MeetingAttendeesTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttendeesDataManager.h"
#import "MeetingAttendeesEmployeesHeaderViewController.h"
#import "MeetingAttendeesContactsHeaderViewController.h"
#import "MeetingAttendeesOthersHeaderViewController.h"
#import "MeetingMainTableCellFactory.h"
#import "MeetingAttendeesTableViewCell.h"

@interface MeetingAttendeesTableViewController : UITableViewController <MeetingAttendeesEmployeesHeaderViewControllerDelegate, MeetingAttendeesContactsHeaderViewControllerDelegate, MeetingBaseTableViewCellDelegate, MeetingAttendeesOthersHeaderViewControllerDelegate, MeetingAttendeesTableViewCellDelegate> {
    MeetingAttendeesDataManager* _meetingAttendeesDataManager;
    MeetingAttendeesEmployeesHeaderViewController* _meetingAttendeesEmployeesHeaderViewController;
    MeetingAttendeesContactsHeaderViewController* _meetingAttendeesContactsHeaderViewController;
    MeetingAttendeesOthersHeaderViewController* _meetingAttendeesOthersHeaderViewController;
    MeetingMainTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingAttendeesDataManager* meetingAttendeesDataManager;
@property(nonatomic, retain) MeetingAttendeesEmployeesHeaderViewController* meetingAttendeesEmployeesHeaderViewController;
@property(nonatomic, retain) MeetingAttendeesContactsHeaderViewController* meetingAttendeesContactsHeaderViewController;
@property(nonatomic, retain) MeetingAttendeesOthersHeaderViewController* meetingAttendeesOthersHeaderViewController;
@property(nonatomic, retain) MeetingMainTableCellFactory* tableCellFactory;

- (void)reloadCustomiseTableView;

@end

