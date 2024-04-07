//
//  CustomerJourneyDetailDateDataManager.m
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailDateDataManager.h"

@implementation CustomerJourneyDetailDateDataManager
@synthesize weekNumberDisplayList = _weekNumberDisplayList;
@synthesize dayNumberDisplayList = _dayNumberDisplayList;
@synthesize callNumberDisplayList = _callNumberDisplayList;
@synthesize journeyLocationDict = _journeyLocationDict;
@synthesize journeyStartDate = _journeyStartDate;
@synthesize rowPointer = _rowPointer;
@synthesize fieldNameList = _fieldNameList;
@synthesize fieldValueList = _fieldValueList;
@synthesize currentSelectedWeekNumber = _currentSelectedWeekNumber;
@synthesize currentSelectedDayNumber = _currentSelectedDayNumber;
@synthesize currentSelectedCallNumber = _currentSelectedCallNumber;

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
        int mergeIdValue = [[employeeDict objectForKey:@"MergeID"] intValue];
        int weekNumberCount = 1;
        if (mergeIdValue > 1) {
            weekNumberCount = mergeIdValue;
        }
        self.journeyStartDate = nil;
        if (employeeDict != nil) {
            NSDate* tmpJourneyStartDate = [employeeDict objectForKey:@"JourneyStartDate"];
            if (tmpJourneyStartDate != nil) {
                self.journeyStartDate = [ArcosUtils addHours:1 date:tmpJourneyStartDate];
            }            
        }
        self.weekNumberDisplayList = [NSMutableArray arrayWithCapacity:weekNumberCount];
        self.dayNumberDisplayList = [NSMutableArray arrayWithCapacity:5];
        self.callNumberDisplayList = [NSMutableArray arrayWithCapacity:25];
        for (int i = 0; i < weekNumberCount; i++) {
            [self.weekNumberDisplayList addObject:[NSNumber numberWithInt:i + 1]];
        }
        for (int i = 0; i < 5; i++) {
            [self.dayNumberDisplayList addObject:[NSNumber numberWithInt:i + 1]];
        }
        for (int i = 0; i < 25; i++) {
            [self.callNumberDisplayList addObject:[NSNumber numberWithInt:i + 1]];
        }
        self.fieldNameList = [NSMutableArray arrayWithObjects:@"WeekNumber", @"DayNumber", @"CallNumber", nil];
    }
    return self;
}

- (void)dealloc {
    self.weekNumberDisplayList = nil;
    self.dayNumberDisplayList = nil;
    self.callNumberDisplayList = nil;
    self.journeyLocationDict = nil;
    self.journeyStartDate = nil;
    self.fieldNameList = nil;
    self.fieldValueList = nil;
    self.currentSelectedWeekNumber = nil;
    self.currentSelectedDayNumber = nil;
    self.currentSelectedCallNumber = nil;
    
    [super dealloc];
}

- (void)prepareFieldValueListWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber callNumber:(NSNumber*)aCallNumber {
    self.fieldValueList = [NSMutableArray arrayWithObjects:aWeekNumber, aDayNumber, aCallNumber, nil];
}

- (void)updateJourneyWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber callNumber:(NSNumber*)aCallNumber IUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [anIUR intValue]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Journey" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        for (Journey* aJourney in objectArray) {
            aJourney.WeekNumber = aWeekNumber;
            aJourney.DayNumber = aDayNumber;
            aJourney.CallNumber = aCallNumber;
            [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        }
    }
}

- (void)removeJourneyWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [anIUR intValue]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Journey" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        for (Journey* aJourney in objectArray) {
            [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:aJourney];
            [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        }
    }
}

@end
