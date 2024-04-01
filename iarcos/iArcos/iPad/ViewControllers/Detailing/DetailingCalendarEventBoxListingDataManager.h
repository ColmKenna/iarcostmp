//
//  DetailingCalendarEventBoxListingDataManager.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "DetailingCalendarEventBoxListingTableCellFactory.h"
#import "DetailingCalendarEventBoxListingDataManagerDelegate.h"

@interface DetailingCalendarEventBoxListingDataManager : NSObject <UITableViewDelegate, UITableViewDataSource, DetailingCalendarEventBoxListingBaseTableCellDelegate> {
    id<DetailingCalendarEventBoxListingDataManagerDelegate> _actionDelegate;
    NSMutableArray* _displayList;
    NSMutableArray* _dateList;
    NSMutableDictionary* _hourHashMap;
    DetailingCalendarEventBoxListingTableCellFactory* _cellFactory;
}

@property (nonatomic, assign) id<DetailingCalendarEventBoxListingDataManagerDelegate> actionDelegate;
@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* dateList;
@property (nonatomic, retain) NSMutableDictionary* hourHashMap;
@property (nonatomic, retain) DetailingCalendarEventBoxListingTableCellFactory* cellFactory;

- (void)createBasicDataWithDataList:(NSMutableArray*)aDataList;
- (void)createBasicDataForTemplateWithDataList:(NSMutableArray*)aDataList;

@end

