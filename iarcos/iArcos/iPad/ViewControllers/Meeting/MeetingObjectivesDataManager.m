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

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
//    [self createDataObjectDict];
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* meetingDict = [self createDefaultIURDict];
    NSString* preMeetDetails = @"";
    NSString* postMeetDetails = @"";
    NSString* agendaDetails = @"";
    if (anArcosMeetingWithDetailsDownload != nil) {
        meetingDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.MOiur] title:anArcosMeetingWithDetailsDownload.MODetails];
        preMeetDetails = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.PreMeetingDetails];
        postMeetDetails = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.PostMeetingDetails];
        agendaDetails = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.AgendaDetails];
    }
    [self.displayList addObject:[self createIURCellWithFieldName:@"Meeting" cellKey:self.meetingCellKeyDefinition.meetingMOKey fieldData:meetingDict descrTypeCode:@"MO"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Pre-Meet" cellKey:self.meetingCellKeyDefinition.preMeetingKey fieldData:preMeetDetails]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Post-Meet" cellKey:self.meetingCellKeyDefinition.postMeetingKey fieldData:postMeetDetails]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Agenda" cellKey:self.meetingCellKeyDefinition.agendaKey fieldData:agendaDetails]];
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

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    @try {
        NSMutableDictionary* resMeetingMODict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.meetingMOKey];
        anArcosMeetingWithDetailsDownload.MOiur = [[resMeetingMODict objectForKey:@"DescrDetailIUR"] intValue];
        NSString* preMeetDetails = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.preMeetingKey];
        NSString* postMeetDetails = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.postMeetingKey];
        NSString* agendaDetails = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.agendaKey];
        anArcosMeetingWithDetailsDownload.PreMeetingDetails = [ArcosUtils wrapStringByCDATA:preMeetDetails];
        anArcosMeetingWithDetailsDownload.PostMeetingDetails = [ArcosUtils wrapStringByCDATA:postMeetDetails];
        anArcosMeetingWithDetailsDownload.AgendaDetails = [ArcosUtils wrapStringByCDATA:agendaDetails];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

@end
