//
//  ArcosCalendarTableDataManager.h
//  iArcos
//
//  Created by Richard on 16/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface ArcosCalendarTableDataManager : NSObject {
    NSNumber* _sunWeekday;
    NSNumber* _monWeekday;
    NSNumber* _tueWeekday;
    NSNumber* _wedWeekday;
    NSNumber* _thuWeekday;
    NSNumber* _friWeekday;
    NSNumber* _satWeekday;
    NSMutableArray* _weekdaySeqList;
    NSMutableArray* _matrixDataList;
    NSDate* _currentThirdDayOfMonthDate;
    NSDate* _todayDate;
    NSMutableDictionary* _dayWeekOfMonthIndexHashMap;
    NSMutableDictionary* _dayWeekDayIndexHashMap;
}

@property(nonatomic, retain) NSNumber* sunWeekday;
@property(nonatomic, retain) NSNumber* monWeekday;
@property(nonatomic, retain) NSNumber* tueWeekday;
@property(nonatomic, retain) NSNumber* wedWeekday;
@property(nonatomic, retain) NSNumber* thuWeekday;
@property(nonatomic, retain) NSNumber* friWeekday;
@property(nonatomic, retain) NSNumber* satWeekday;
@property(nonatomic, retain) NSMutableArray* weekdaySeqList;
@property(nonatomic, retain) NSMutableArray* matrixDataList;
@property(nonatomic, retain) NSDate* currentThirdDayOfMonthDate;
@property(nonatomic, retain) NSDate* todayDate;
@property(nonatomic, retain) NSMutableDictionary* dayWeekOfMonthIndexHashMap;
@property(nonatomic, retain) NSMutableDictionary* dayWeekDayIndexHashMap;

- (void)calculateCalendarData:(NSDate*)aCurrentCalculatedDate;
- (NSDate*)createThirdDayNoonDateWithDate:(NSDate*)aDate thirdDayFlag:(BOOL)aFlag;
- (NSDate*)beginDayOfMonthWithDate:(NSDate*)aDate;
- (NSDate*)endDayOfMonthWithDate:(NSDate*)aDate;
- (NSString*)retrieveCalendarURIWithDate:(NSDate*)aDate;
- (void)populateCalendarEntryWithData:(NSDictionary*)aDataDict;

@end

