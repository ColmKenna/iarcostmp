//
//  MeetingPresentersTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 11/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingPresentersDataManager.h"
#import "MeetingPresentersTableViewCell.h"
#import "MeetingPresentersTableCellFactory.h"

@interface MeetingPresentersTableViewController : UITableViewController <MeetingPresentersTableViewCellDelegate> {
    MeetingPresentersDataManager* _meetingPresentersDataManager;
    MeetingPresentersTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingPresentersDataManager* meetingPresentersDataManager;
@property(nonatomic, retain) MeetingPresentersTableCellFactory* tableCellFactory;

- (void)reloadCustomiseTableView;

@end

