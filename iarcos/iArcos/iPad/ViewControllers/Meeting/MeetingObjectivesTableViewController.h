//
//  MeetingObjectivesTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 08/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingObjectivesDataManager.h"
#import "MeetingMainTableCellFactory.h"

@interface MeetingObjectivesTableViewController : UITableViewController <MeetingBaseTableViewCellDelegate> {
    MeetingObjectivesDataManager* _meetingObjectivesDataManager;
    MeetingMainTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingObjectivesDataManager* meetingObjectivesDataManager;
@property(nonatomic, retain) MeetingMainTableCellFactory* tableCellFactory;

@end

