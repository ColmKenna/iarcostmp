//
//  MeetingObjectivesDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 08/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingObjectivesDataManager.h"

@implementation MeetingObjectivesDataManager
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
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Meeting" cellKey:self.meetingCellKeyDefinition.meetingMOKey fieldData:[self createDefaultIURDict] descrTypeCode:@"MO"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Pre-Meet" cellKey:self.meetingCellKeyDefinition.preMeetingKey fieldData:@""]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Post-Meet" cellKey:self.meetingCellKeyDefinition.postMeetingKey fieldData:@""]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Agenda" cellKey:self.meetingCellKeyDefinition.agendaKey fieldData:@""]];
}

- (void)createDataObjectDict {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:11];
    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.meetingMOKey];
}

@end
