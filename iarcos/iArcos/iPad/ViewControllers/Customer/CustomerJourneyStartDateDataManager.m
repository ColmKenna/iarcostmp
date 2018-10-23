//
//  CustomerJourneyStartDateDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyStartDateDataManager.h"

@implementation CustomerJourneyStartDateDataManager
@synthesize displayList = _displayList;
@synthesize changedDataList = _changedDataList;
@synthesize employeeIUR = _employeeIUR;
@synthesize changedJourneyStartDate = _changedJourneyStartDate;

- (id)init {
    self = [super init];
    if (self != nil) {
        [self createJourneyStartDateData];
        self.employeeIUR = [SettingManager employeeIUR];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.changedJourneyStartDate != nil) { self.changedJourneyStartDate = nil; }
    if (self.changedDataList != nil) { self.changedDataList = nil; }
    if (self.employeeIUR != nil) { self.employeeIUR = nil; }

    
    [super dealloc];
}

- (void)createJourneyStartDateData {
    self.displayList = [NSMutableArray arrayWithCapacity:1];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    if (employeeDict == nil) return;
    
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:@"Journey Start Date" forKey:@"FieldNameLabel"];
    NSDate* journeyStartDateObj = [employeeDict objectForKey:@"JourneyStartDate"];
    
    [cellDataDict setObject:[ArcosUtils addHours:0 date:journeyStartDateObj] forKey:@"FieldData"];
    [cellDataDict setObject:[NSNumber numberWithInt:2] forKey:@"WriteType"];
    [cellDataDict setObject:[ArcosUtils addHours:0 date:journeyStartDateObj] forKey:@"OriginalJourneyStartDate"];
    [self.displayList addObject:cellDataDict];
}

- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:theIndexpath.row];
    [cellDataDict setObject:data forKey:@"FieldData"];    
}

- (void)getChangedDataList {
    self.changedDataList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:i];
        NSDate* originalJourneyStartDate = [cellDataDict objectForKey:@"OriginalJourneyStartDate"];
        NSDate* journeyStartDate = [cellDataDict objectForKey:@"FieldData"];
        if ([ArcosUtils compareDate:originalJourneyStartDate endDate:journeyStartDate] != NSOrderedSame) {
            [self.changedDataList addObject:cellDataDict];
        }
    }
}

@end
