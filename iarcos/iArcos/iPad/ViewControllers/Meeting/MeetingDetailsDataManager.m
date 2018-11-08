//
//  MeetingDetailsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingDetailsDataManager.h"

@implementation MeetingDetailsDataManager
@synthesize displayList = _displayList;

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    
    
    [super dealloc];
}

- (void)createBasicData {
    [self createDataObjectDict];
    self.displayList = [NSMutableArray arrayWithCapacity:9];
    [self.displayList addObject:[self createDateTimeCell]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Code"]];
    [self.displayList addObject:[self createLocationCellWithFieldName:@"Venue"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Status"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Type"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Style"]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Title"]];
    [self.displayList addObject:[self createEmployeeCellWithFieldName:@"Operator"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Comments"]];
}

- (void)createDataObjectDict {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:11];
    [self.headOfficeDataObjectDict setObject:[NSDate date] forKey:self.meetingCellKeyDefinition.dateKey];
    [self.headOfficeDataObjectDict setObject:[NSDate date] forKey:self.meetingCellKeyDefinition.timeKey];
    [self.headOfficeDataObjectDict setObject:@"0" forKey:self.meetingCellKeyDefinition.durationKey];
    [self.headOfficeDataObjectDict setObject:@"" forKey:self.meetingCellKeyDefinition.codeKey];
    [self.headOfficeDataObjectDict setObject:@"" forKey:self.meetingCellKeyDefinition.venueKey];
    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.statusKey];
}

- (NSMutableDictionary*)createDateTimeCell {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [tmpDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    return tmpDataDict;
}



@end
