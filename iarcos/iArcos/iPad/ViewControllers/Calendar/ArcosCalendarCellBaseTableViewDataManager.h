//
//  ArcosCalendarCellBaseTableViewDataManager.h
//  iArcos
//
//  Created by Richard on 09/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCalendarEventEntryTableViewCell.h"
#import "ArcosCalendarCellBaseTableViewDataManagerDelegate.h"
#import "ArcosCalendarEventEntryView.h"

@interface ArcosCalendarCellBaseTableViewDataManager : NSObject <UITableViewDataSource, UITableViewDelegate, ArcosCalendarEventEntryTableViewCellDelegate> {
    id<ArcosCalendarCellBaseTableViewDataManagerDelegate> _actionDelegate;
    NSMutableArray* _displayList;
    NSIndexPath* _weekOfMonthIndexPath;
    int _weekdaySeqIndex;
    NSMutableDictionary* _journeyDataDict;
    NSString* _dateFormatText;
}

@property(nonatomic, assign) id<ArcosCalendarCellBaseTableViewDataManagerDelegate> actionDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSIndexPath* weekOfMonthIndexPath;
@property(nonatomic, assign) int weekdaySeqIndex;
@property(nonatomic, retain) NSMutableDictionary* journeyDataDict;
@property(nonatomic, retain) NSString* dateFormatText;

@end

