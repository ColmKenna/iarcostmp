//
//  DetailingCalendarEventBoxViewDataManager.m
//  iArcos
//
//  Created by Richard on 26/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxViewDataManager.h"

@implementation DetailingCalendarEventBoxViewDataManager
@synthesize journeyDateData = _journeyDateData;
@synthesize nextAppointmentData = _nextAppointmentData;
@synthesize calendarDateData = _calendarDateData;
@synthesize originalEventDataDict = _originalEventDataDict;
//@synthesize acctNotSignInMsg = _acctNotSignInMsg;
@synthesize listingDisplayList = _listingDisplayList;
@synthesize ownLocationDisplayList = _ownLocationDisplayList;
@synthesize suggestedAppointmentText = _suggestedAppointmentText;
@synthesize nextAppointmentText = _nextAppointmentText;
@synthesize eventForCurrentLocationFoundFlag = _eventForCurrentLocationFoundFlag;
@synthesize journeyForCurrentLocationFoundFlag = _journeyForCurrentLocationFoundFlag;
@synthesize journeyDateForCurrentLocation = _journeyDateForCurrentLocation;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.originalEventDataDict = nil;
//        self.acctNotSignInMsg = @"Please SIGN IN to OUTLOOK to save Next Appointment";
        self.suggestedAppointmentText = @"Suggested Appointment";
        self.nextAppointmentText = @"New Appointment";
        self.eventForCurrentLocationFoundFlag = NO;
        self.journeyForCurrentLocationFoundFlag = NO;
        self.journeyDateForCurrentLocation = nil;
    }
    
    return self;
}

- (void)dealloc {    
    self.journeyDateData = nil;
    self.nextAppointmentData = nil;
    self.calendarDateData = nil;
    self.originalEventDataDict = nil;
//    self.acctNotSignInMsg = nil;
    self.listingDisplayList = nil;
    self.ownLocationDisplayList = nil;
    self.suggestedAppointmentText = nil;
    self.nextAppointmentText = nil;
    self.journeyDateForCurrentLocation = nil;
    
    [super dealloc];
}

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate locationName:(NSString*)aLocationName {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,isAllDay&$top=1000&startdatetime=%@&enddatetime=%@&$filter=location/displayName eq '%@'&$orderby=start/dateTime asc", aStartDate, anEndDate, aLocationName];
}

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,isAllDay&$top=1000&startdatetime=%@&enddatetime=%@&$orderby=start/dateTime asc", aStartDate, anEndDate];
}

- (NSMutableDictionary*)retrieveEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR {
    
    NSMutableDictionary* eventDict = [[[NSMutableDictionary alloc] init] autorelease];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aContactName] forKey:@"subject"];
    
    NSMutableDictionary* locationResultDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [locationResultDict setObject:[ArcosUtils convertNilToEmpty:aLocationName] forKey:@"displayName"];
    [locationResultDict setObject:[NSString stringWithFormat:@"%d:%d", [aLocationIUR intValue], [aContactIUR intValue]] forKey:@"locationUri"];
    [eventDict setObject:locationResultDict forKey:@"location"];
    
    
    NSString* allDayResultData = @"false";
    [eventDict setObject:allDayResultData forKey:@"isAllDay"];
    
    NSString* startResultData = [ArcosUtils stringFromDate:self.calendarDateData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
    NSMutableDictionary* startResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [startResultDict setObject:startResultData forKey:@"dateTime"];
    [startResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];
    [eventDict setObject:startResultDict forKey:@"start"];
    
    NSString* endResultData = [ArcosUtils stringFromDate:self.calendarDateData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    NSMutableDictionary* endResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [endResultDict setObject:endResultData forKey:@"dateTime"];
    [endResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];
    [eventDict setObject:endResultDict forKey:@"end"];
    
//    NSLog(@"eventDict %@", eventDict);
    return eventDict;
}

- (NSMutableDictionary*)retrieveEditEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR {
    NSMutableDictionary* eventDict = [[[NSMutableDictionary alloc] init] autorelease];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aContactName] forKey:@"subject"];
    
    NSMutableDictionary* locationResultDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [locationResultDict setObject:[ArcosUtils convertNilToEmpty:aLocationName] forKey:@"displayName"];
    [locationResultDict setObject:[NSString stringWithFormat:@"%d:%d", [aLocationIUR intValue], [aContactIUR intValue]] forKey:@"locationUri"];
    [eventDict setObject:locationResultDict forKey:@"location"];
    
    NSString* allDayResultData = @"false";
    [eventDict setObject:allDayResultData forKey:@"isAllDay"];
    
    NSString* startResultData = [ArcosUtils stringFromDate:self.calendarDateData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
    NSMutableDictionary* startResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [startResultDict setObject:startResultData forKey:@"dateTime"];
    [startResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];
    [eventDict setObject:startResultDict forKey:@"start"];
    
    NSString* endResultData = [ArcosUtils stringFromDate:self.calendarDateData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    NSMutableDictionary* endResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [endResultDict setObject:endResultData forKey:@"dateTime"];
    [endResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];
    [eventDict setObject:endResultDict forKey:@"end"];    
    
    return eventDict;
}

- (NSMutableDictionary*)createEventDataWithId:(NSString*)anId subject:(NSString*)aSubject location:(NSString*)aLocation startDate:(NSDate*)aStartDate locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR locationUri:(NSString*)aLocationUri {
    NSMutableDictionary* eventDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:anId] forKey:@"Id"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aSubject] forKey:@"Subject"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocation] forKey:@"Location"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:aStartDate] forKey:@"StartDate"];
    [eventDict setObject:[ArcosUtils convertNilToZero:aLocationIUR] forKey:@"LocationIUR"];
    [eventDict setObject:[ArcosUtils convertNilToZero:aContactIUR] forKey:@"ContactIUR"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocationUri] forKey:@"LocationUri"];
    
    return eventDict;
}

- (NSMutableDictionary*)populateCalendarEventEntryWithData:(NSDictionary*)aDataDict {
    NSDictionary* startDict = [aDataDict objectForKey:@"start"];
    NSString* startDateStr = [startDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    
    NSDictionary* locationDict = [aDataDict objectForKey:@"location"];
    NSString* locationStr = [locationDict objectForKey:@"displayName"];
    
    NSString* locationUriStr = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]];
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    NSNumber* contactIUR = [NSNumber numberWithInt:0];
    NSArray* locationUriArray = [locationUriStr componentsSeparatedByString:@":"];
    if ([locationUriArray count] == 2) {
        NSString* tmpLocationIURStr = [locationUriArray objectAtIndex:0];
        NSString* tmpContactIURStr = [locationUriArray objectAtIndex:1];
        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
        contactIUR = [ArcosUtils convertStringToNumber:tmpContactIURStr];
    }
    return [self createEventDataWithId:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"id"]] subject:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"subject"]] location:[ArcosUtils convertNilToEmpty:locationStr] startDate:startDate locationIUR:locationIUR contactIUR:contactIUR locationUri:locationUriStr];
}

- (NSMutableDictionary*)createEditEventEntryDetailTemplateData:(NSDictionary*)aDataDict {
    NSDictionary* startDict = [aDataDict objectForKey:@"start"];
    NSString* startDateStr = [startDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    NSDictionary* endDict = [aDataDict objectForKey:@"end"];
    NSString* endDateStr = [endDict objectForKey:@"dateTime"];
    NSDate* endDate = [ArcosUtils dateFromString:endDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    NSDictionary* locationDict = [aDataDict objectForKey:@"location"];
    NSString* locationStr = [locationDict objectForKey:@"displayName"];
    NSString* locationUriStr = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]];
    return [self createEventDataWithId:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"id"]] subject:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"subject"]] bodyPreview:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"bodyPreview"]] location:[ArcosUtils convertNilToEmpty:locationStr] startDate:startDate endDate:endDate isAllDay:[ArcosUtils convertNilToEmpty:[ArcosUtils convertIntToString:[[aDataDict objectForKey:@"isAllDay"] intValue]]] locationUri:locationUriStr];
}

- (NSMutableDictionary*)createEventDataWithId:(NSString*)anId subject:(NSString*)aSubject
                                  bodyPreview:(NSString*)aBodyPreview location:(NSString*)aLocation
                                    startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate isAllDay:(NSString*)anIsAllDay locationUri:(NSString*)aLocationUri {
    NSMutableDictionary* eventDict = [NSMutableDictionary dictionaryWithCapacity:7];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:anId] forKey:@"Id"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aSubject] forKey:@"Subject"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aBodyPreview] forKey:@"BodyPreview"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocation] forKey:@"Location"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:aStartDate] forKey:@"StartDate"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:anEndDate] forKey:@"EndDate"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:anIsAllDay] forKey:@"IsAllDay"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocationUri] forKey:@"LocationUri"];
    
    return eventDict;
}

- (NSMutableArray*)retrieveTemplateListingDisplayList {
    NSMutableArray* templateListingDisplayList = [NSMutableArray arrayWithCapacity:[self.listingDisplayList count]];
    for (int i = 0; i < [self.listingDisplayList count]; i++) {
        NSMutableDictionary* resultCellDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        NSDictionary* myCellData = [self.listingDisplayList objectAtIndex:i];
        NSDictionary* myCellStartDict = [myCellData objectForKey:@"start"];
        NSString* myCellStartDateStr = [myCellStartDict objectForKey:@"dateTime"];
        NSDate* myCellStartDate = [ArcosUtils dateFromString:myCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
        [resultCellDataDict setObject:[ArcosUtils convertNilDateToNull:myCellStartDate] forKey:@"Date"];
        [resultCellDataDict setObject:[ArcosUtils convertNilToEmpty:[myCellData objectForKey:@"subject"]] forKey:@"Name"];
        NSNumber* myLocationIUR = [self retrieveLocationIURWithEventDict:myCellData];
        [resultCellDataDict setObject:[ArcosUtils convertNilToZero:myLocationIUR] forKey:@"LocationIUR"];
        [templateListingDisplayList addObject:resultCellDataDict];
    }
    return templateListingDisplayList;
}

- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict {
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    NSDictionary* locationDict = [anEventDict objectForKey:@"location"];
    NSString* locationUriStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]]];
    NSArray* locationUriChildArray = [locationUriStr componentsSeparatedByString:@":"];
    if ([locationUriChildArray count] == 2) {
        NSString* tmpLocationIURStr = [locationUriChildArray objectAtIndex:0];
        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
    }
    return locationIUR;
}

- (BOOL)calculateJourneyDateWithLocationIUR:(NSNumber*)aLocationIUR {
    self.journeyForCurrentLocationFoundFlag = NO;
    NSMutableArray* journeyList = [self retrieveJourneyWithLocationIUR:aLocationIUR];
    NSDate* journeyStartDate = [self retrieveJourneyStartDate];
    NSMutableArray* journeyDateList = [NSMutableArray arrayWithCapacity:[journeyList count]];
    NSDate* currentStartDate = [ArcosUtils beginOfDayWithZeroTime:[NSDate date]];
    if (journeyStartDate != nil) {
        for (int i = 0; i < [journeyList count]; i++) {
            NSDictionary* journeyDict = [journeyList objectAtIndex:i];
            NSNumber* weekNumber = [journeyDict objectForKey:@"WeekNumber"];
            NSNumber* dayNumber = [journeyDict objectForKey:@"DayNumber"];
            int addDays = ([weekNumber intValue] - 1) * 7 + ([dayNumber intValue] - 1);
            NSDate* currentJourneyDate = [ArcosUtils addDays:addDays date:journeyStartDate];
            [journeyDateList addObject:[ArcosUtils beginOfDayWithZeroTime:currentJourneyDate]];
        }
        for (int i = 0; i < [journeyDateList count]; i++) {
            NSDate* tmpCurrentJourneyDate = [journeyDateList objectAtIndex:i];
            NSComparisonResult tmpComparisonResult = [tmpCurrentJourneyDate compare:currentStartDate];
            if (tmpComparisonResult == NSOrderedSame || tmpComparisonResult == NSOrderedDescending) {
                NSDate* neededCurrentDate = [self retrieveNextFifteenMinutesWithDate:[NSDate date]];
                int neededHours = [ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:neededCurrentDate]];
                int neededMinutes = [ArcosUtils convertNSIntegerToInt:[ArcosUtils minuteWithDate:neededCurrentDate]];
                self.journeyDateForCurrentLocation = [ArcosUtils addHours:neededHours date:tmpCurrentJourneyDate];
                self.journeyDateForCurrentLocation = [ArcosUtils addMinutes:neededMinutes date:self.journeyDateForCurrentLocation];
                self.journeyForCurrentLocationFoundFlag = YES;
                break;
            }
        }
    }
    
    return self.journeyForCurrentLocationFoundFlag;
}

- (NSMutableArray*)retrieveJourneyWithLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [aLocationIUR intValue]];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"WeekNumber",@"DayNumber",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"WeekNumber",@"DayNumber",nil];
    
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Journey" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSDate*)retrieveJourneyStartDate {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    if (employeeDict != nil) {
        return [ArcosUtils addHours:1 date:[employeeDict objectForKey:@"JourneyStartDate"]];
    }
    return nil;
}

- (NSDate*)retrieveNextFifteenMinutesWithDate:(NSDate*)aDate {
    int tmpMinutes = [ArcosUtils convertNSIntegerToInt:[ArcosUtils minuteWithDate:aDate]];
    int tmpRemainder = tmpMinutes % 15;
    int addMinutes = 15 - tmpRemainder;
    if (tmpRemainder == 0) {
        addMinutes = 0;
    }
    return [ArcosUtils addMinutes:addMinutes date:aDate];
}

@end
