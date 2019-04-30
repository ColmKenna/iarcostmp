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

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
//    [self createDataObjectDict];
    self.displayList = [NSMutableArray arrayWithCapacity:9];
    NSDate* currentDate = [NSDate date];
    NSDate* currentTime = [NSDate date];
    NSString* duration = @"";
    NSString* code = @"";
    NSString* venue = @"";
    NSMutableDictionary* statusDict = [self createDefaultIURDict];
    NSMutableDictionary* typeDict = [self createDefaultIURDict];
    NSMutableDictionary* styleDict = [self createDefaultIURDict];
    NSString* title = @"";
    NSMutableDictionary* operatorDict = [self createDefaultEmployeeDict];
    NSString* comments = @"";
    if (anArcosMeetingWithDetailsDownload != nil) {
        currentDate = anArcosMeetingWithDetailsDownload.DateTime;
        currentTime = anArcosMeetingWithDetailsDownload.DateTime;
        if (currentDate == nil) {
            currentDate = [NSDate date];
        }
        if (currentTime == nil) {
            currentTime = [NSDate date];
        }
        duration = [NSString stringWithFormat:@"%d", anArcosMeetingWithDetailsDownload.Duration];
        code = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.Code];
        venue = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.Venue];
        statusDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.MSiur] title:anArcosMeetingWithDetailsDownload.MSDetails];
        typeDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.MPiur] title:anArcosMeetingWithDetailsDownload.MPDetails];
        styleDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.MYiur] title:anArcosMeetingWithDetailsDownload.MYDetails];
        title = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.Reason];
        operatorDict = [self createDefaultEmployeeDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.OrganiserIUR] title:anArcosMeetingWithDetailsDownload.OrganiserName];
        comments = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.Comments];
    }
    [self.displayList addObject:[self createDateTimeCellWithDate:currentDate time:currentTime duration:duration]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Code" cellKey:self.meetingCellKeyDefinition.codeKey fieldData:code]];
    [self.displayList addObject:[self createLocationCellWithFieldName:@"Venue" cellKey:self.meetingCellKeyDefinition.venueKey fieldData:venue]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Status" cellKey:self.meetingCellKeyDefinition.statusKey fieldData:statusDict descrTypeCode:@"MS"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Type" cellKey:self.meetingCellKeyDefinition.typeKey fieldData:typeDict descrTypeCode:@"MP"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Style" cellKey:self.meetingCellKeyDefinition.styleKey fieldData:styleDict descrTypeCode:@"MY"]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Title" cellKey:self.meetingCellKeyDefinition.titleKey fieldData:title]];
    [self.displayList addObject:[self createEmployeeCellWithFieldName:@"Operator" cellKey:self.meetingCellKeyDefinition.operatorKey fieldData:operatorDict]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Comments" cellKey:self.meetingCellKeyDefinition.commentsKey fieldData:comments]];
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

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    @try {
        NSDate* resDate = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.dateKey];
        NSDate* resTime = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.timeKey];
        NSString* resDateTimeStr = [NSString stringWithFormat:@"%@ %@", [ArcosUtils stringFromDate:resDate format:[GlobalSharedClass shared].dateFormat], [ArcosUtils stringFromDate:resTime format:[GlobalSharedClass shared].hourMinuteFormat]];
        NSDate* resDateTime = [ArcosUtils dateFromString:resDateTimeStr format:[GlobalSharedClass shared].datetimehmFormat];
        anArcosMeetingWithDetailsDownload.DateTime = resDateTime;
        NSString* resDuration = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.durationKey];
        anArcosMeetingWithDetailsDownload.Duration = [[ArcosUtils convertStringToNumber:resDuration] intValue];
        anArcosMeetingWithDetailsDownload.Code = [ArcosUtils wrapStringByCDATA:[self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.codeKey]];
        anArcosMeetingWithDetailsDownload.Venue = [ArcosUtils wrapStringByCDATA:[self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.venueKey]];
        NSMutableDictionary* resStatusDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.statusKey];
        anArcosMeetingWithDetailsDownload.MSiur = [[resStatusDict objectForKey:@"DescrDetailIUR"] intValue];
        NSMutableDictionary* resTypeDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.typeKey];
        anArcosMeetingWithDetailsDownload.MPiur = [[resTypeDict objectForKey:@"DescrDetailIUR"] intValue];
        NSMutableDictionary* resStyleDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.styleKey];
        anArcosMeetingWithDetailsDownload.MYiur = [[resStyleDict objectForKey:@"DescrDetailIUR"] intValue];
        anArcosMeetingWithDetailsDownload.Reason = [ArcosUtils wrapStringByCDATA:[self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.titleKey]];//come back
        NSMutableDictionary* resOperatorDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.operatorKey];
        anArcosMeetingWithDetailsDownload.OrganiserIUR = [[resOperatorDict objectForKey:@"IUR"] intValue];
        anArcosMeetingWithDetailsDownload.Comments = [ArcosUtils wrapStringByCDATA:[self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.commentsKey]];
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

@end
