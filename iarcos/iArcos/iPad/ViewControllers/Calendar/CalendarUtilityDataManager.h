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

@interface CalendarUtilityDataManager : NSObject {
    NSNumber* _bodyCellType;
    NSNumber* _bodyTemplateCellType;
    NSNumber* _headerCellType;
    NSNumber* _headerForPopOutType;
    NSNumber* _bodyForPopOutCellType;
    NSNumber* _bodyJourneyCellType;
    NSNumber* _bodyJourneyForPopOutCellType;
}

@property (nonatomic, retain) NSNumber* bodyCellType;
@property (nonatomic, retain) NSNumber* bodyTemplateCellType;
@property (nonatomic, retain) NSNumber* headerCellType;
@property (nonatomic, retain) NSNumber* headerForPopOutType;
@property (nonatomic, retain) NSNumber* bodyForPopOutCellType;
@property (nonatomic, retain) NSNumber* bodyJourneyCellType;
@property (nonatomic, retain) NSNumber* bodyJourneyForPopOutCellType;

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate;
- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict;
- (NSMutableArray*)processDataListWithDateFormatText:(NSString*)aDateFormatText journeyDictList:(NSMutableArray*)aJourneyDictList eventDictList:(NSMutableArray*)anEventDictList bodyCellType:(NSNumber*)aBodyCellType bodyJourneyCellType:(NSNumber*)aBodyJourneyCellType;
- (NSDate*)retrieveNextFifteenMinutesWithDate:(NSDate*)aDate;

@end

