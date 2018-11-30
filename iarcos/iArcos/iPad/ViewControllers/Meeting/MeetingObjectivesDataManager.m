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
//    [self createDataObjectDict];
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

- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpDataDict setObject:aData forKey:@"FieldData"];
}

- (void)displayListHeadOfficeAdaptor {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:4];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:i];
        NSString* auxCellKey = [cellDataDict objectForKey:@"CellKey"];
        [self.headOfficeDataObjectDict setObject:[cellDataDict objectForKey:@"FieldData"] forKey:auxCellKey];
    }
}

- (void)populateArcosMeetingBO:(ArcosMeetingBO*)anArcosMeetingBO {
    @try {
        NSMutableDictionary* resMeetingMODict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.meetingMOKey];
        anArcosMeetingBO.MOIUR = [[resMeetingMODict objectForKey:@"IUR"] intValue];
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

@end
