//
//  MeetingObjectivesTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 08/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingObjectivesDataManager.h"

@interface MeetingObjectivesTableViewController : UITableViewController {
    MeetingObjectivesDataManager* _meetingObjectivesDataManager;
}

@property(nonatomic, retain) MeetingObjectivesDataManager* meetingObjectivesDataManager;

@end

