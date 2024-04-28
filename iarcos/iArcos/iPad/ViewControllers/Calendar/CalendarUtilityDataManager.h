//
//  CalendarUtilityDataManager.h
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface CalendarUtilityDataManager : NSObject

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate;
- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict;
- (NSMutableArray*)processDataListWithDateFormatText:(NSString*)aDateFormatText journeyDictList:(NSMutableArray*)aJourneyDictList eventDictList:(NSMutableArray*)anEventDictList bodyCellType:(NSNumber*)aBodyCellType;
- (NSDate*)retrieveNextFifteenMinutesWithDate:(NSDate*)aDate;

@end

