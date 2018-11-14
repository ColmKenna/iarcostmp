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
    [self.displayList addObject:[self createIURCellWithFieldName:@"Meeting"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Pre-Meet"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Post-Meet"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Agenda"]];
}

- (void)createDataObjectDict {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:11];
    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.meetingMOKey];
}

@end
