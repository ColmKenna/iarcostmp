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
//    [self createDataObjectDict];
    self.displayList = [NSMutableArray arrayWithCapacity:9];
    [self.displayList addObject:[self createDateTimeCellWithDate:[NSDate date] time:[NSDate date] duration:@""]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Code" cellKey:self.meetingCellKeyDefinition.codeKey fieldData:@""]];
    [self.displayList addObject:[self createLocationCellWithFieldName:@"Venue" cellKey:self.meetingCellKeyDefinition.venueKey fieldData:@""]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Status" cellKey:self.meetingCellKeyDefinition.statusKey fieldData:[self createDefaultIURDict] descrTypeCode:@"MS"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Type" cellKey:self.meetingCellKeyDefinition.typeKey fieldData:[self createDefaultIURDict] descrTypeCode:@"MP"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Style" cellKey:self.meetingCellKeyDefinition.styleKey fieldData:[self createDefaultIURDict] descrTypeCode:@"MY"]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Title" cellKey:self.meetingCellKeyDefinition.titleKey fieldData:@""]];
    [self.displayList addObject:[self createEmployeeCellWithFieldName:@"Operator" cellKey:self.meetingCellKeyDefinition.operatorKey fieldData:[self createDefaultEmployeeDict]]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Comments" cellKey:self.meetingCellKeyDefinition.commentsKey fieldData:@""]];
}

- (void)createDataObjectDict {
//    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:11];
//    [self.headOfficeDataObjectDict setObject:[NSDate date] forKey:self.meetingCellKeyDefinition.dateKey];
//    [self.headOfficeDataObjectDict setObject:[NSDate date] forKey:self.meetingCellKeyDefinition.timeKey];
//    [self.headOfficeDataObjectDict setObject:@"0" forKey:self.meetingCellKeyDefinition.durationKey];
//    [self.headOfficeDataObjectDict setObject:@"" forKey:self.meetingCellKeyDefinition.codeKey];
//    [self.headOfficeDataObjectDict setObject:@"" forKey:self.meetingCellKeyDefinition.venueKey];
//    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.statusKey];
}

- (NSMutableDictionary*)createDateTimeCellWithDate:(NSDate*)aDate time:(NSDate*)aTime duration:(NSString*)aDuration {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    NSMutableDictionary* fieldDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [fieldDataDict setObject:aDate forKey:self.meetingCellKeyDefinition.dateKey];
    [fieldDataDict setObject:aTime forKey:self.meetingCellKeyDefinition.timeKey];
    [fieldDataDict setObject:aDuration forKey:self.meetingCellKeyDefinition.durationKey];
    [tmpDataDict setObject:fieldDataDict forKey:@"FieldData"];
    
    return tmpDataDict;
}

- (void)displayListHeadOfficeAdaptor {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:11];
    @try {
        NSMutableDictionary* dateTimeCellDataDict = [self.displayList objectAtIndex:0];
        NSMutableDictionary* dateTimeFieldDataDict = [dateTimeCellDataDict objectForKey:@"FieldData"];
        [self.headOfficeDataObjectDict setObject:[dateTimeFieldDataDict objectForKey:self.meetingCellKeyDefinition.dateKey] forKey:self.meetingCellKeyDefinition.dateKey];
        [self.headOfficeDataObjectDict setObject:[dateTimeFieldDataDict objectForKey:self.meetingCellKeyDefinition.timeKey] forKey:self.meetingCellKeyDefinition.timeKey];
        [self.headOfficeDataObjectDict setObject:[dateTimeFieldDataDict objectForKey:self.meetingCellKeyDefinition.durationKey] forKey:self.meetingCellKeyDefinition.durationKey];
        for (int i = 1; i < [self.displayList count]; i++) {
            NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:i];
            NSString* auxCellKey = [cellDataDict objectForKey:@"CellKey"];
            [self.headOfficeDataObjectDict setObject:[cellDataDict objectForKey:@"FieldData"] forKey:auxCellKey];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpDataDict setObject:aData forKey:@"FieldData"];
}

- (void)populateArcosMeetingBO:(ArcosMeetingBO*)anArcosMeetingBO {
    @try {
        NSDate* resDate = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.dateKey];
        NSDate* resTime = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.timeKey];
        NSString* resDateTimeStr = [NSString stringWithFormat:@"%@ %@", [ArcosUtils stringFromDate:resDate format:[GlobalSharedClass shared].dateFormat], [ArcosUtils stringFromDate:resTime format:[GlobalSharedClass shared].hourMinuteFormat]];
        NSDate* resDateTime = [ArcosUtils dateFromString:resDateTimeStr format:[GlobalSharedClass shared].datetimehmFormat];
        anArcosMeetingBO.DateTime = resDateTime;
        NSString* resDuration = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.durationKey];
        anArcosMeetingBO.Duration = [[ArcosUtils convertStringToNumber:resDuration] intValue];
        anArcosMeetingBO.Code = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.codeKey];
        anArcosMeetingBO.Venue = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.venueKey];
        NSMutableDictionary* resStatusDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.statusKey];
        anArcosMeetingBO.MSIUR = [[resStatusDict objectForKey:@"DescrDetailIUR"] intValue];
        NSMutableDictionary* resTypeDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.typeKey];
        anArcosMeetingBO.MPIUR = [[resTypeDict objectForKey:@"DescrDetailIUR"] intValue];
        NSMutableDictionary* resStyleDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.styleKey];
        anArcosMeetingBO.MYIUR = [[resStyleDict objectForKey:@"DescrDetailIUR"] intValue];
        anArcosMeetingBO.Reason = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.titleKey];//come back
        NSMutableDictionary* resOperatorDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.operatorKey];
        anArcosMeetingBO.OrganiserIUR = [[resOperatorDict objectForKey:@"IUR"] intValue];
        anArcosMeetingBO.Comments = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.commentsKey];
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

@end
