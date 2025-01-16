//
//  CalendarUtilityDataManager.m
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CalendarUtilityDataManager.h"

@implementation CalendarUtilityDataManager
@synthesize bodyCellType = _bodyCellType;
@synthesize bodyTemplateCellType = _bodyTemplateCellType;
@synthesize headerCellType = _headerCellType;
@synthesize headerForPopOutType = _headerForPopOutType;
@synthesize bodyForPopOutCellType = _bodyForPopOutCellType;
@synthesize bodyJourneyCellType = _bodyJourneyCellType;
@synthesize bodyJourneyForPopOutCellType = _bodyJourneyForPopOutCellType;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bodyCellType = [NSNumber numberWithInt:2];
        self.bodyTemplateCellType = [NSNumber numberWithInt:4];
        self.headerCellType = [NSNumber numberWithInt:1];
        self.headerForPopOutType = [NSNumber numberWithInt:6];
        self.bodyForPopOutCellType = [NSNumber numberWithInt:7];
        self.bodyJourneyCellType = [NSNumber numberWithInt:5];
        self.bodyJourneyForPopOutCellType = [NSNumber numberWithInt:8];
    }
    return self;
}

- (void)dealloc {
    self.bodyCellType = nil;
    self.bodyTemplateCellType = nil;
    self.headerCellType = nil;
    self.headerForPopOutType = nil;
    self.bodyForPopOutCellType = nil;
    self.bodyJourneyCellType = nil;
    self.bodyJourneyForPopOutCellType = nil;
    
    [super dealloc];
}

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,isAllDay&$top=1000&startdatetime=%@&enddatetime=%@&$orderby=start/dateTime asc", aStartDate, anEndDate];
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

- (NSMutableArray*)processDataListWithDateFormatText:(NSString*)aDateFormatText journeyDictList:(NSMutableArray*)aJourneyDictList eventDictList:(NSMutableArray*)anEventDictList bodyCellType:(NSNumber*)aBodyCellType bodyJourneyCellType:(NSNumber*)aBodyJourneyCellType {
    NSMutableArray* displayList = [NSMutableArray arrayWithCapacity:([aJourneyDictList count] + [anEventDictList count])];
    NSDate* beginDate = [ArcosUtils dateFromString:[NSString stringWithFormat:@"%@ 09:00:00", aDateFormatText] format:[GlobalSharedClass shared].datetimeFormat];
    int minutesInterval = 60;
    if ([aJourneyDictList count] > 9) {
        minutesInterval = 30;
    }
    for (int i = 0; i < [aJourneyDictList count]; i++) {
        NSDictionary* locationDict = [aJourneyDictList objectAtIndex:i];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dataDict setObject:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]] forKey:@"Name"];
        [dataDict setObject:[ArcosUtils addMinutes:i * minutesInterval date:beginDate] forKey:@"Date"];
        NSString* tmpAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address1"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address2"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address3"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address4"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address5"]]];
        [dataDict setObject:tmpAddress forKey:@"Address"];
        [dataDict setObject:aBodyJourneyCellType forKey:@"CellType"];//[NSNumber numberWithInt:5]
        [dataDict setObject:[NSNumber numberWithInt:[[locationDict objectForKey:@"lsiur"] intValue]] forKey:@"lsiur"];
        [dataDict setObject:[NSNumber numberWithInt:[[locationDict objectForKey:@"CSiur"] intValue]] forKey:@"CSiur"];
        [displayList addObject:dataDict];
    }
    
    for (int i = 0; i < [anEventDictList count]; i++) {
        NSMutableDictionary* eventDict = [anEventDictList objectAtIndex:i];
//        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:5];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:eventDict];
//        NSString* subjectStr = [ArcosUtils convertNilToEmpty:[eventDict objectForKey:@"Subject"]];
        NSString* locationStr = [ArcosUtils convertNilToEmpty:[eventDict objectForKey:@"Location"]];
        [dataDict setObject:locationStr forKey:@"Name"];
        [dataDict setObject:[eventDict objectForKey:@"StartDate"] forKey:@"Date"];
//        [dataDict setObject:subjectStr forKey:@"Subject"];
        [dataDict setObject:aBodyCellType forKey:@"CellType"];
        [dataDict setObject:[ArcosUtils convertNilToZero:[eventDict objectForKey:@"LocationIUR"]] forKey:@"LocationIUR"];
        [displayList addObject:dataDict];
    }
    if ([displayList count] > 1) {
        NSSortDescriptor* dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Date" ascending:YES selector:@selector(compare:)] autorelease];
        [displayList sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor, nil]];
    }
    return displayList;
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
