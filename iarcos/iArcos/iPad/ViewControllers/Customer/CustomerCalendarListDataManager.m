//
//  CustomerCalendarListDataManager.m
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerCalendarListDataManager.h"

@implementation CustomerCalendarListDataManager
@synthesize calendarUtilityDataManager = _calendarUtilityDataManager;
@synthesize displayList = _displayList;
@synthesize locationIURList = _locationIURList;
@synthesize locationIURHashMap = _locationIURHashMap;
@synthesize currentStartDate = _currentStartDate;
@synthesize currentEndDate = _currentEndDate;
@synthesize statusItems = _statusItems;
@synthesize startDatePointer = _startDatePointer;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.calendarUtilityDataManager = [[[CalendarUtilityDataManager alloc] init] autorelease];
        self.statusItems = [NSArray arrayWithObjects:@"<<", @"<", @"-", @">", @">>", nil];
    }
    return self;
}

- (void)dealloc {
    self.calendarUtilityDataManager = nil;
    self.displayList = nil;
    self.locationIURList = nil;
    self.locationIURHashMap = nil;
    self.currentStartDate = nil;
    self.currentEndDate = nil;
    self.statusItems = nil;
    self.startDatePointer = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    NSDictionary* eventDict = [self.displayList objectAtIndex:anIndexPath.row];
    NSNumber* auxLocationIUR = [self.calendarUtilityDataManager retrieveLocationIURWithEventDict:eventDict];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:auxLocationIUR];
    if ([objectArray count] > 0) {
        return [NSMutableDictionary dictionaryWithDictionary:[objectArray objectAtIndex:0]];
    }
    return nil;
}

@end
