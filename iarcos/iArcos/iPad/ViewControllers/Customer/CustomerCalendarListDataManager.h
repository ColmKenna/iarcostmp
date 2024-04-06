//
//  CustomerCalendarListDataManager.h
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarUtilityDataManager.h"
#import "ArcosCoreData.h"

@interface CustomerCalendarListDataManager : NSObject {
    CalendarUtilityDataManager* _calendarUtilityDataManager;
    NSMutableArray* _displayList;
    NSMutableArray* _locationIURList;
    NSMutableDictionary* _locationIURHashMap;
    NSDate* _currentStartDate;
    NSDate* _currentEndDate;
    NSArray* _statusItems;
    NSDate* _startDatePointer;
}

@property(nonatomic,retain) CalendarUtilityDataManager* calendarUtilityDataManager;
@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* locationIURList;
@property(nonatomic,retain) NSMutableDictionary* locationIURHashMap;
@property(nonatomic,retain) NSDate* currentStartDate;
@property(nonatomic,retain) NSDate* currentEndDate;
@property(nonatomic,retain) NSArray* statusItems;
@property(nonatomic,retain) NSDate* startDatePointer;

- (NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath;

@end

