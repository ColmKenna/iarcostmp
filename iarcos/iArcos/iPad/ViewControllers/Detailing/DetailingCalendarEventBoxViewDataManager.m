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
@synthesize calendarDateData = _calendarDateData;
@synthesize originalEventDataDict = _originalEventDataDict;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.originalEventDataDict = nil;
    }
    
    return self;
}

- (void)dealloc {    
    self.journeyDateData = nil;
    self.calendarDateData = nil;
    self.originalEventDataDict = nil;
    
    [super dealloc];
}

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate locationName:(NSString*)aLocationName {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,isAllDay&$top=1000&startdatetime=%@&enddatetime=%@&$filter=location/displayName eq '%@'&$orderby=start/dateTime asc", aStartDate, anEndDate, aLocationName];
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

- (NSMutableDictionary*)createEventDataWithId:(NSString*)anId subject:(NSString*)aSubject location:(NSString*)aLocation startDate:(NSDate*)aStartDate locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR {
    NSMutableDictionary* eventDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:anId] forKey:@"Id"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aSubject] forKey:@"Subject"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocation] forKey:@"Location"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:aStartDate] forKey:@"StartDate"];
    [eventDict setObject:[ArcosUtils convertNilToZero:aLocationIUR] forKey:@"LocationIUR"];
    [eventDict setObject:[ArcosUtils convertNilToZero:aContactIUR] forKey:@"ContactIUR"];
    
    return eventDict;
}

- (NSMutableDictionary*)populateCalendarEventEntryWithData:(NSDictionary*)aDataDict {
    NSDictionary* startDict = [aDataDict objectForKey:@"start"];
    NSString* startDateStr = [startDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    
    NSDictionary* locationDict = [aDataDict objectForKey:@"location"];
    NSString* locationStr = [locationDict objectForKey:@"displayName"];
    
    NSString* locationUriStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]]];
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    NSNumber* contactIUR = [NSNumber numberWithInt:0];
    NSArray* locationUriArray = [locationUriStr componentsSeparatedByString:@":"];
    if ([locationUriArray count] == 2) {
        NSString* tmpLocationIURStr = [locationUriArray objectAtIndex:0];
        NSString* tmpContactIURStr = [locationUriArray objectAtIndex:1];
        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
        contactIUR = [ArcosUtils convertStringToNumber:tmpContactIURStr];
    }
    return [self createEventDataWithId:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"id"]] subject:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"subject"]] location:[ArcosUtils convertNilToEmpty:locationStr] startDate:startDate locationIUR:locationIUR contactIUR:contactIUR];
}

@end
