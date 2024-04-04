//
//  CustomerJourneyDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDataManager.h"

@implementation CustomerJourneyDataManager
@synthesize groupName = _groupName;
@synthesize displayList = _displayList;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize sectionTitleTextList = _sectionTitleTextList;
@synthesize locationListDict = _locationListDict;
@synthesize orderQtyListDict = _orderQtyListDict;
@synthesize currentJourneyDict = _currentJourneyDict;
@synthesize journeyDictHashMap = _journeyDictHashMap;

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    if (self.groupName != nil) { self.groupName = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }
    if (self.sectionTitleTextList != nil) { self.sectionTitleTextList = nil; }    
    if (self.locationListDict != nil) { self.locationListDict = nil; }
    if (self.orderQtyListDict != nil) { self.orderQtyListDict = nil; }
    self.currentJourneyDict = nil;
    self.journeyDictHashMap = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aJourneyList {
    self.displayList = [NSMutableArray arrayWithCapacity:[aJourneyList count]];
    [self.displayList addObject:[self createAllJourneyDictObject]];
    [self processRawDataProcessor:aJourneyList];
}

- (void)processRawDataProcessor:(NSMutableArray*)aJourneyList {
    NSDate* journeyStartDate = [self getJourneyStartDate];
    for (int i = 0; i < [aJourneyList count]; i++) {
        NSMutableDictionary* journeyDict = [aJourneyList objectAtIndex:i];
        NSMutableDictionary* newJourneyDict = [NSMutableDictionary dictionaryWithDictionary:journeyDict];
        NSNumber* weekNumber = [journeyDict objectForKey:@"WeekNumber"];
        NSNumber* dayNumber = [journeyDict objectForKey:@"DayNumber"];
        int addDays = ([weekNumber intValue] - 1) * 7 + ([dayNumber intValue] - 1);
        NSDate* currentJourneyDate = [ArcosUtils addDays:addDays date:journeyStartDate];
        [newJourneyDict setObject:[ArcosUtils stringFromDate:currentJourneyDate format:@"dd/MM/yyyy"] forKey:@"JourneyDate"];
        [newJourneyDict setObject:[ArcosUtils stringFromDate:currentJourneyDate format:@"EEEE dd MMMM yyyy"] forKey:@"JourneyDateText"];
        [newJourneyDict setObject:currentJourneyDate forKey:@"JourneyActualDate"];
        [self.displayList addObject:newJourneyDict];
    }
}

-(NSDate*)getJourneyStartDate {
//    [[ArcosCoreData sharedArcosCoreData] editEmployeeWithIUR:[SettingManager employeeIUR] journeyStartDate:[ArcosUtils dateFromString:@"01/10/2012 00:00:00" format:@"dd/MM/yyyy HH:mm:ss"]];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    if (employeeDict != nil) {
        return [ArcosUtils addHours:1 date:[employeeDict objectForKey:@"JourneyStartDate"]];
    }    
    return nil;
}

- (NSMutableDictionary*)createAllJourneyDictObject {
    NSMutableDictionary* allJourneyDictObject = [NSMutableDictionary dictionary];
    [allJourneyDictObject setObject:@"All" forKey:@"JourneyDate"];
    [allJourneyDictObject setObject:[NSNumber numberWithInt:-1]  forKey:@"WeekNumber"];
    [allJourneyDictObject setObject:[NSNumber numberWithInt:-1]  forKey:@"DayNumber"];
    [allJourneyDictObject setObject:@"All" forKey:@"JourneyDateText"];
    [allJourneyDictObject setObject:[NSDate date] forKey:@"JourneyActualDate"];
    return allJourneyDictObject;
}

- (void)getLocationsWithJourneyDict:(NSMutableDictionary*)aJourneyDict {
    self.currentJourneyDict = aJourneyDict;
    self.orderQtyListDict = [NSMutableDictionary dictionary];
    self.locationListDict = [NSMutableDictionary dictionary];
    self.sectionTitleList = [NSMutableArray array];
    self.sectionTitleTextList = [NSMutableArray array];
    NSNumber* weekNumber = [aJourneyDict objectForKey:@"WeekNumber"];
    
    if ([weekNumber isEqualToNumber:[NSNumber numberWithInt:-1]]) {
        if ([self.displayList count] > 1) {
            for (int i = 1; i < [self.displayList count]; i++) {
                NSMutableDictionary* journeyDict = [self.displayList objectAtIndex:i];
                [self processJourneyData:journeyDict];
            } 
        }        
        return;
    }
    [self processJourneyData:aJourneyDict];
//    NSLog(@"orderQtyListDict is: %@", self.orderQtyListDict);
}

- (void)processJourneyData:(NSMutableDictionary*)aJourneyDict {
    NSNumber* weekNumber = [aJourneyDict objectForKey:@"WeekNumber"];
    NSNumber* dayNumber = [aJourneyDict objectForKey:@"DayNumber"];
    NSString* journeyDate = [aJourneyDict objectForKey:@"JourneyDate"];
    
    [self.sectionTitleList addObject:journeyDate];
    [self.sectionTitleTextList addObject:[aJourneyDict objectForKey:@"JourneyDateText"]];
    NSMutableArray* journeyList = [[ArcosCoreData sharedArcosCoreData] journeyWithWeekNumber:weekNumber dayNumber:dayNumber];
    NSMutableArray* locationList = [NSMutableArray arrayWithCapacity:[journeyList count]];
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[journeyList count]];
    NSMutableArray* orderQtyList = [NSMutableArray arrayWithCapacity:[journeyList count]];
    for (int i = 0; i < [journeyList count]; i++) {
        NSMutableDictionary* journeyDict = [journeyList objectAtIndex:i];        
        @try {
            [locationIURList addObject:[journeyDict objectForKey:@"LocationIUR"]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        } 
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@", locationIURList];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] getLocationsWithPredicate:predicate];
    locationList = objectsArray;
//    if ([locationIURList count] == [objectsArray count]) {
//        locationList = objectsArray;
//    } else {//duplicate location iur scenario or else
//        NSLog(@"duplicate location iur scenario happens.");
//        for (int i = 0; i < [locationIURList count]; i++) {
//            NSNumber* journeyLocationIUR = [locationIURList objectAtIndex:i];
//            for (int j = 0; j < [objectsArray count]; j++) {
//                NSDictionary* locationDict = [objectsArray objectAtIndex:j];
//                if ([journeyLocationIUR isEqualToNumber:[locationDict objectForKey:@"LocationIUR"]] ) {
//                    [locationList addObject:locationDict];
//                    break;
//                }
//            }
//        }
//    }
    NSMutableArray* resultLocationList = [NSMutableArray arrayWithCapacity:[locationList count]];
    NSMutableDictionary* locationDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[locationList count]];
    for (int i = 0; i < [locationList count]; i++) {
        NSDictionary* tmpLocationDict = [locationList objectAtIndex:i];
        [locationDictHashMap setObject:tmpLocationDict forKey:[tmpLocationDict objectForKey:@"LocationIUR"]];
    }
    for (int i = 0; i < [journeyList count]; i++) {
        NSDictionary* tmpJourneyDict = [journeyList objectAtIndex:i];
        NSDictionary* tmpLocationDict = [locationDictHashMap objectForKey:[tmpJourneyDict objectForKey:@"LocationIUR"]];
        if (tmpLocationDict != nil) {
            NSMutableDictionary* resultLocationDict = [NSMutableDictionary dictionaryWithDictionary:tmpLocationDict];
            [resultLocationDict setObject:[ArcosUtils convertNilToZero:[tmpJourneyDict objectForKey:@"WeekNumber"]] forKey:@"WeekNumber"];
            [resultLocationDict setObject:[ArcosUtils convertNilToZero:[tmpJourneyDict objectForKey:@"DayNumber"]] forKey:@"DayNumber"];
            [resultLocationDict setObject:[ArcosUtils convertNilToZero:[tmpJourneyDict objectForKey:@"CallNumber"]] forKey:@"CallNumber"];
            [resultLocationDict setObject:[ArcosUtils convertNilToZero:[tmpJourneyDict objectForKey:@"IUR"]] forKey:@"JourneyIUR"];
            [resultLocationList addObject:resultLocationDict];
        }
    }
//    NSLog(@"locationList and count is %d", [locationList count]);
    NSDate* journeyDateObj = [ArcosUtils addHours:1 date:[ArcosUtils dateFromString:journeyDate format:@"dd/MM/yyyy"]];
    NSDate* startDate = [ArcosUtils beginOfDay:[ArcosUtils addDays:-5 date:journeyDateObj]];
    NSDate* endDate = [ArcosUtils endOfDay:[ArcosUtils addDays:5 date:journeyDateObj]];
//    NSLog(@"%@ separator %@ separator %@",journeyDateObj , startDate, endDate);
    for (int i = 0; i < [resultLocationList count]; i++) {
        NSMutableDictionary* resultLocation = [resultLocationList objectAtIndex:i];
        //0:no order 1:call 2:order
        NSNumber* orderQty = [NSNumber numberWithInt:0];
        NSMutableArray* orderHeaderList = [[ArcosCoreData sharedArcosCoreData] ordersWithLocationIUR:[resultLocation objectForKey:@"LocationIUR"] startDate:startDate endDate:endDate];
        if (orderHeaderList != nil && [orderHeaderList count] > 0) {
            orderQty = [NSNumber numberWithInt:1];
            for (int j = 0; j < [orderHeaderList count]; j++) {
                NSDictionary* orderHeader = [orderHeaderList objectAtIndex:j];
                if ([[orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
                    orderQty = [NSNumber numberWithInt:2];
                    break;
                }
            }
        }
        [orderQtyList addObject:orderQty];
    }
    [self.locationListDict setObject:resultLocationList forKey:journeyDate];
    [self.orderQtyListDict setObject:orderQtyList forKey:journeyDate];
}

- (int)getIndexWithDate:(NSDate*)aDate {
    NSString* dateString = [ArcosUtils stringFromDate:aDate format:@"dd/MM/yyyy"];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* journeyDict = [self.displayList objectAtIndex:i];
        NSString* journeyDate = [journeyDict objectForKey:@"JourneyDate"];
        if ([dateString isEqualToString:journeyDate]) {
            return i;
        }
    }
    return -1;
}

- (int)getSectionIndexWithDate:(NSDate*)aDate {
    NSString* dateString = [ArcosUtils stringFromDate:aDate format:@"dd/MM/yyyy"];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* sectionTitle = [self.sectionTitleList objectAtIndex:i];
        if ([dateString isEqualToString:sectionTitle]) {
            return i;
        }
    }
    return -1;
}

- (void)dashboardProcessRawData:(NSMutableArray*)aJourneyList {
    self.displayList = [NSMutableArray arrayWithCapacity:[aJourneyList count]];
    [self processRawDataProcessor:aJourneyList];
    int itemIndex = -1;
    NSString* dateString = [ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpJourneyDict = [self.displayList objectAtIndex:i];
        NSString* journeyDate = [tmpJourneyDict objectForKey:@"JourneyDate"];
        if ([dateString isEqualToString:journeyDate]) {
            itemIndex = i;
            break;
        }
    }
    if (itemIndex == -1) return;
    NSMutableDictionary* todayJourneyDict = [self.displayList objectAtIndex:itemIndex];
    [self getLocationsWithJourneyDict:todayJourneyDict];
}

- (NSMutableDictionary*)retrieveCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* locationList = [self.locationListDict objectForKey:sectionTitle];
    return [locationList objectAtIndex:anIndexPath.row];
}

- (NSNumber*)retrieveOrderQtyWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* orderQtyList = [self.orderQtyListDict objectForKey:sectionTitle];
    return [orderQtyList objectAtIndex:anIndexPath.row];
}

- (void)processCalendarJourneyData {
    NSMutableArray* journeyList = [[ArcosCoreData sharedArcosCoreData] allJourney];
    self.displayList = [NSMutableArray arrayWithCapacity:[journeyList count]];
    self.journeyDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[journeyList count]];
    [self processRawDataProcessor:journeyList];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpJourneyDict = [self.displayList objectAtIndex:i];
        NSString* tmpJourneyDate = [tmpJourneyDict objectForKey:@"JourneyDate"];
        [self.journeyDictHashMap setObject:tmpJourneyDict forKey:tmpJourneyDate];
    }
}

@end
