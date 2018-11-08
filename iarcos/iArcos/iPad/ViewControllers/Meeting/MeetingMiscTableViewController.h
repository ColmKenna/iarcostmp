//
//  MeetingMiscTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingMiscDataManager.h"
#import "MeetingMainSectionViewFactory.h"
#import "MeetingMainTableCellFactory.h"

@interface MeetingMiscTableViewController : UITableViewController <MeetingBaseTableViewCellDelegate> {
    MeetingMiscDataManager* _meetingMiscDataManager;
    MeetingMainSectionViewFactory* _sectionViewFactory;
    MeetingMainTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) MeetingMiscDataManager* meetingMiscDataManager;
@property(nonatomic, retain) MeetingMainSectionViewFactory* sectionViewFactory;
@property(nonatomic, retain) MeetingMainTableCellFactory* tableCellFactory;

@end

