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
#import "MeetingMainTableCellFactory.h"

@interface MeetingAttendeesTableViewController : UITableViewController <MeetingAttendeesEmployeesHeaderViewControllerDelegate, MeetingAttendeesContactsHeaderViewControllerDelegate, MeetingBaseTableViewCellDelegate> {
    MeetingAttendeesDataManager* _meetingAttendeesDataManager;
    MeetingAttendeesEmployeesHeaderViewController* _meetingAttendeesEmployeesHeaderViewController;
    MeetingAttendeesContactsHeaderViewController* _meetingAttendeesContactsHeaderViewController;
    MeetingMainTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingAttendeesDataManager* meetingAttendeesDataManager;
@property(nonatomic, retain) MeetingAttendeesEmployeesHeaderViewController* meetingAttendeesEmployeesHeaderViewController;
@property(nonatomic, retain) MeetingAttendeesContactsHeaderViewController* meetingAttendeesContactsHeaderViewController;
@property(nonatomic, retain) MeetingMainTableCellFactory* tableCellFactory;

- (void)reloadCustomiseTableView;

@end

