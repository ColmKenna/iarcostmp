//
//  CustomerJourneyDetailDateDataManager.h
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "ArcosCoreData.h"

@interface CustomerJourneyDetailDateDataManager : NSObject {
    NSMutableArray* _weekNumberDisplayList;
    NSMutableArray* _dayNumberDisplayList;
    NSMutableArray* _callNumberDisplayList;
    NSMutableDictionary* _journeyLocationDict;
    NSDate* _journeyStartDate;
    int _rowPointer;
    NSMutableArray* _fieldNameList;
    NSMutableArray* _fieldValueList;
    NSNumber* _currentSelectedWeekNumber;
    NSNumber* _currentSelectedDayNumber;
    NSNumber* _currentSelectedCallNumber;
}

@property(nonatomic, retain) NSMutableArray* weekNumberDisplayList;
@property(nonatomic, retain) NSMutableArray* dayNumberDisplayList;
@property(nonatomic, retain) NSMutableArray* callNumberDisplayList;
@property(nonatomic, retain) NSMutableDictionary* journeyLocationDict;
@property(nonatomic, retain) NSDate* journeyStartDate;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSMutableArray* fieldNameList;
@property(nonatomic, retain) NSMutableArray* fieldValueList;
@property(nonatomic, retain) NSNumber* currentSelectedWeekNumber;
@property(nonatomic, retain) NSNumber* currentSelectedDayNumber;
@property(nonatomic, retain) NSNumber* currentSelectedCallNumber;

- (void)prepareFieldValueListWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber callNumber:(NSNumber*)aCallNumber;
- (void)updateJourneyWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber callNumber:(NSNumber*)aCallNumber IUR:(NSNumber*)anIUR;
- (void)removeJourneyWithIUR:(NSNumber*)anIUR;

@end


