//
//  MeetingDetailsTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingDetailsDataManager.h"
#import "MeetingMainTableCellFactory.h"

@interface MeetingDetailsTableViewController : UITableViewController <MeetingBaseTableViewCellDelegate> {
    MeetingDetailsDataManager* _meetingDetailsDataManager;
    MeetingMainTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingDetailsDataManager* meetingDetailsDataManager;
@property(nonatomic, retain) MeetingMainTableCellFactory* tableCellFactory;

- (void)reloadCustomiseTableView;

@end

