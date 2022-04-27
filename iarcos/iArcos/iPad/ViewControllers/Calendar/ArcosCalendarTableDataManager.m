//
//  ArcosCalendarTableDataManager.m
//  iArcos
//
//  Created by Richard on 16/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarTableDataManager.h"

@implementation ArcosCalendarTableDataManager
@synthesize sunWeekday = _sunWeekday;
@synthesize monWeekday = _monWeekday;
@synthesize tueWeekday = _tueWeekday;
@synthesize wedWeekday = _wedWeekday;
@synthesize thuWeekday = _thuWeekday;
@synthesize friWeekday = _friWeekday;
@synthesize satWeekday = _satWeekday;
@synthesize weekdaySeqList = _weekdaySeqList;
@synthesize matrixDataList = _matrixDataList;
@synthesize currentThirdDayOfMonthDate = _currentThirdDayOfMonthDate;
@synthesize todayDate = _todayDate;
@synthesize dayWeekOfMonthIndexHashMap = _dayWeekOfMonthIndexHashMap;
@synthesize dayWeekDayIndexHashMap = _dayWeekDayIndexHashMap;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sunWeekday = [NSNumber numberWithInt:1];
        self.monWeekday = [NSNumber numberWithInt:2];
        self.tueWeekday = [NSNumber numberWithInt:3];
        self.wedWeekday = [NSNumber numberWithInt:4];
        self.thuWeekday = [NSNumber numberWithInt:5];
        self.friWeekday = [NSNumber numberWithInt:6];
        self.satWeekday = [NSNumber numberWithInt:7];
        self.weekdaySeqList = [NSMutableArray arrayWithObjects:self.monWeekday, self.tueWeekday, self.wedWeekday, self.thuWeekday, self.friWeekday, self.satWeekday, self.sunWeekday, nil];
        [self createBasicData];
        self.todayDate = [self createThirdDayNoonDateWithDate:[NSDate date] thirdDayFlag:NO];
    }
    return self;
}

- (void)dealloc {
    self.sunWeekday = nil;
    self.monWeekday = nil;
    self.tueWeekday = nil;
    self.wedWeekday = nil;
    self.thuWeekday = nil;
    self.friWeekday = nil;
    self.satWeekday = nil;
    self.weekdaySeqList = nil;
    self.matrixDataList = nil;
    self.currentThirdDayOfMonthDate = nil;
    self.todayDate = nil;
    self.dayWeekOfMonthIndexHashMap = nil;
    self.dayWeekDayIndexHashMap = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    [self createCurrentDate];
    [self calculateCalendarData:self.currentThirdDayOfMonthDate];
}

- (void)createCalendarTemplateData {
    self.matrixDataList = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        NSMutableDictionary* weekDataDict = [NSMutableDictionary dictionaryWithCapacity:7];
        [self.matrixDataList addObject:weekDataDict];
    }
    self.dayWeekOfMonthIndexHashMap = [NSMutableDictionary dictionaryWithCapacity:31];
    self.dayWeekDayIndexHashMap = [NSMutableDictionary dictionaryWithCapacity:31];
}

- (void)createCurrentDate {
    self.currentThirdDayOfMonthDate = [self createThirdDayNoonDateWithDate:[NSDate date] thirdDayFlag:YES];
}

- (NSDate*)createThirdDayNoonDateWithDate:(NSDate*)aDate thirdDayFlag:(BOOL)aFlag {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
       
    if (aFlag) {
        [yearComponents setDay:3];
    }
    [yearComponents setHour:12];
    [yearComponents setMinute:0];
    [yearComponents setSecond:0];
    return [gregorian dateFromComponents:yearComponents];
}

- (void)calculateCalendarData:(NSDate*)aCurrentCalculatedDate {
    [self createCalendarTemplateData];
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    gregorian.minimumDaysInFirstWeek = 1;
    gregorian.firstWeekday = [self.monWeekday intValue];
    NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:aCurrentCalculatedDate];
    for (int i = 1; i <= monthRange.length; i++) {
        NSDateComponents* yearComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aCurrentCalculatedDate];
        [yearComponents setDay:i];
        [yearComponents setHour:12];
        [yearComponents setMinute:0];
        [yearComponents setSecond:0];
        NSDate* auxDate = [gregorian dateFromComponents:yearComponents];
//        NSRange weekOfMonthRange = [gregorian rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:auxDate];
        NSDateComponents* firstNSDateComponents = [gregorian components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:auxDate];
        int weekOfMonthIndex = [ArcosUtils convertNSUIntegerToUnsignedInt:firstNSDateComponents.weekOfMonth] - 1;
        [self.dayWeekOfMonthIndexHashMap setObject:[NSNumber numberWithInt:weekOfMonthIndex] forKey:[NSNumber numberWithInt:i]];
        [self.dayWeekDayIndexHashMap setObject:[NSNumber numberWithInt:[ArcosUtils convertNSUIntegerToUnsignedInt:firstNSDateComponents.weekday]] forKey:[NSNumber numberWithInt:i]];
        NSMutableDictionary* weekDataDict = [self.matrixDataList objectAtIndex:weekOfMonthIndex];
        NSMutableDictionary* dayDataDict = [NSMutableDictionary dictionary];
        [dayDataDict setObject:auxDate forKey:@"Date"];
        [dayDataDict setObject:[NSNumber numberWithInt:i] forKey:@"Day"];
        [weekDataDict setObject:dayDataDict forKey:[NSNumber numberWithInt:[ArcosUtils convertNSUIntegerToUnsignedInt:firstNSDateComponents.weekday]]];
        
    }

    
}

- (NSMutableDictionary*)createEventDataWithId:(NSString*)anId subject:(NSString*)aSubject
                                  bodyPreview:(NSString*)aBodyPreview location:(NSString*)aLocation
                                    startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate {
    NSMutableDictionary* eventDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:anId] forKey:@"Id"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aSubject] forKey:@"Subject"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aBodyPreview] forKey:@"BodyPreview"];
    [eventDict setObject:[ArcosUtils convertNilToEmpty:aLocation] forKey:@"Location"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:aStartDate] forKey:@"StartDate"];
    [eventDict setObject:[ArcosUtils convertNilDateToNull:anEndDate] forKey:@"EndDate"];
    
    return eventDict;
}

- (NSDate*)beginDayOfMonthWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];    
    
    [yearComponents setDay:1];
    [yearComponents setHour:1];
    [yearComponents setMinute:0];
    [yearComponents setSecond:0];
    [yearComponents setNanosecond:0];
    return [gregorian dateFromComponents:yearComponents];
}

- (NSDate*)endDayOfMonthWithDate:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSLocale* ieLocale = [[NSLocale alloc] initWithLocaleIdentifier:[GlobalSharedClass shared].ieLocale];
    gregorian.locale = ieLocale;
    [ieLocale release];
    NSDateComponents* yearComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:aDate];
    [yearComponents setDay:monthRange.length];
    [yearComponents setHour:22];
    [yearComponents setMinute:59];
    [yearComponents setSecond:59];
    [yearComponents setNanosecond:0];
    return [gregorian dateFromComponents:yearComponents];
}

- (NSString*)retrieveCalendarURIWithDate:(NSDate*)aDate {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,&$top=1000&startdatetime=%@&enddatetime=%@", [ArcosUtils stringFromDate:[self beginDayOfMonthWithDate:aDate] format:[GlobalSharedClass shared].utcDatetimeFormat], [ArcosUtils stringFromDate:[self endDayOfMonthWithDate:aDate] format:[GlobalSharedClass shared].utcDatetimeFormat]];
}

- (void)populateCalendarEntryWithData:(NSDictionary*)aDataDict {
    NSDictionary* startDict = [aDataDict objectForKey:@"start"];
    NSString* startDateStr = [startDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    NSDictionary* endDict = [aDataDict objectForKey:@"end"];
    NSString* endDateStr = [endDict objectForKey:@"dateTime"];
    NSDate* endDate = [ArcosUtils dateFromString:endDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    NSDictionary* locationDict = [aDataDict objectForKey:@"location"];
    NSString* locationStr = [locationDict objectForKey:@"displayName"];
    NSNumber* day = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils dayWithDate:startDate]]];
    NSNumber* weekOfMonthIndex = [self.dayWeekOfMonthIndexHashMap objectForKey:day];
    NSNumber* weekDayIndex = [self.dayWeekDayIndexHashMap objectForKey:day];
    NSMutableDictionary* weekDataDict = [self.matrixDataList objectAtIndex:[weekOfMonthIndex intValue]];
    NSMutableDictionary* dayDataDict = [weekDataDict objectForKey:weekDayIndex];
    NSMutableArray* eventDictList = [dayDataDict objectForKey:@"Event"];
    if (eventDictList == nil) {
        eventDictList = [NSMutableArray array];
        [dayDataDict setObject:eventDictList forKey:@"Event"];
    }
    [eventDictList addObject:[self createEventDataWithId:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"id"]] subject:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"subject"]] bodyPreview:[ArcosUtils convertNilToEmpty:[aDataDict objectForKey:@"bodyPreview"]] location:[ArcosUtils convertNilToEmpty:locationStr] startDate:startDate endDate:endDate]];
    
//    NSLog(@"parsed %@", [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].datetimeCalendarFormat]);
    
}

@end
