//
//  ArcosCalendarEventEntryDetailDataManager.m
//  iArcos
//
//  Created by Richard on 12/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailDataManager.h"

@implementation ArcosCalendarEventEntryDetailDataManager
@synthesize actionType = _actionType;
@synthesize createText = _createText;
@synthesize headlineText = _headlineText;
@synthesize dateText = _dateText;
@synthesize detailText = _detailText;
@synthesize deleteText = _deleteText;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize subjectKey = _subjectKey;
@synthesize locationKey = _locationKey;
@synthesize bodyKey = _bodyKey;
@synthesize startKey = _startKey;
@synthesize endKey = _endKey;
@synthesize allDayKey = _allDayKey;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.createText = @"create";
        self.headlineText = @"Headline";
        self.dateText = @"Date";
        self.detailText = @"Detail";
        self.deleteText = @"Delete";
        self.subjectKey = @"subject";
        self.locationKey = @"location";
        self.bodyKey = @"body";
        self.startKey = @"start";
        self.endKey = @"end";
        self.allDayKey = @"isAllDay";
    }
    return self;
}

- (void)dealloc {
    self.actionType = nil;
    self.createText = nil;
    self.headlineText = nil;
    self.dateText = nil;
    self.detailText = nil;
    self.deleteText = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.originalGroupedDataDict = nil;
    self.subjectKey = nil;
    self.locationKey = nil;
    self.bodyKey = nil;
    self.startKey = nil;
    self.endKey = nil;
    self.allDayKey = nil;
    
    [super dealloc];
}

- (void)retrieveCreateDataWithDate:(NSDate*)aDate {
    self.sectionTitleList = [NSMutableArray arrayWithObjects:self.headlineText, self.dateText, self.detailText, nil];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    NSMutableArray* headlineDataList = [NSMutableArray arrayWithCapacity:2];
    [headlineDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldDesc:@"Title" fieldName:self.subjectKey fieldData:@""]];
    [headlineDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldDesc:@"Location" fieldName:self.locationKey fieldData:@""]];
    [self.groupedDataDict setObject:headlineDataList forKey:self.headlineText];
    NSMutableArray* dateDataList = [NSMutableArray arrayWithCapacity:3];
    [dateDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] fieldDesc:@"All-day" fieldName:self.allDayKey fieldData:@"1"]];
    NSMutableDictionary* startFieldData = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString* compositeDateString = [NSString stringWithFormat:@"%@ %@", [ArcosUtils stringFromDate:aDate format:[GlobalSharedClass shared].dateFormat], [ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].hourMinuteFormat]];
    NSDate* compositeDate = [ArcosUtils dateFromString:compositeDateString format:[GlobalSharedClass shared].datetimehmFormat];
    NSDate* firstDate = [ArcosUtils configDateWithMinute:0 date:compositeDate];
    NSDate* startFinalDate = [ArcosUtils addHours:1 date:firstDate];
    [startFieldData setObject:startFinalDate forKey:@"Date"];
    [startFieldData setObject:startFinalDate forKey:@"Time"];
    [dateDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:4] fieldDesc:@"Starts" fieldName:self.startKey fieldData:startFieldData]];
    NSMutableDictionary* endFieldData = [NSMutableDictionary dictionaryWithCapacity:2];
    NSDate* endFinalDate = [ArcosUtils addHours:2 date:firstDate];
    [endFieldData setObject:endFinalDate forKey:@"Date"];
    [endFieldData setObject:endFinalDate forKey:@"Time"];
    [dateDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:4] fieldDesc:@"Ends" fieldName:self.endKey fieldData:endFieldData]];
    [self.groupedDataDict setObject:dateDataList forKey:self.dateText];
    NSMutableArray* detailDataList = [NSMutableArray arrayWithCapacity:1];
    [detailDataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:2] fieldDesc:@"Notes" fieldName:self.bodyKey fieldData:@""]];
    [self.groupedDataDict setObject:detailDataList forKey:self.detailText];
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldDesc:(NSString*)aFieldDesc fieldName:(NSString*)aFieldName fieldData:(id)aFieldData {
    NSMutableDictionary* auxDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [auxDataDict setObject:aCellType forKey:@"CellType"];
    [auxDataDict setObject:aFieldDesc forKey:@"FieldDesc"];
    [auxDataDict setObject:aFieldName forKey:@"FieldName"];
    [auxDataDict setObject:aFieldData forKey:@"FieldData"];
    
    return auxDataDict;
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (void)dataDetailBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:anIndexPath];
    [cellData setObject:aData forKey:@"FieldData"];
}

- (NSIndexPath*)indexPathWithFieldName:(NSString*)aFieldName {
    NSIndexPath* resIndexPath = nil;
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            NSMutableDictionary* tmpDataDict = [tmpDisplayList objectAtIndex:j];
            NSString* tmpFieldName = [tmpDataDict objectForKey:@"FieldName"];
            if ([aFieldName isEqualToString:tmpFieldName]) {
                resIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                break;
            }
        }
    }
    return resIndexPath;
}

- (void)dataRefreshListWithSwitchReturnValue:(NSString*)aReturnValue {
    NSNumber* auxCellType = [NSNumber numberWithInt:4];
    if (![aReturnValue isEqualToString:@"1"]) {
        auxCellType = [NSNumber numberWithInt:5];
    }
    NSIndexPath* startIndexPath = [self indexPathWithFieldName:self.startKey];
    NSMutableDictionary* startCellDataDict = [self cellDataWithIndexPath:startIndexPath];
    [startCellDataDict setObject:auxCellType forKey:@"CellType"];
    NSIndexPath* endIndexPath = [self indexPathWithFieldName:self.endKey];
    NSMutableDictionary* endCellDataDict = [self cellDataWithIndexPath:endIndexPath];
    [endCellDataDict setObject:auxCellType forKey:@"CellType"];
}

- (NSMutableDictionary*)retrieveEventDict {
    NSMutableDictionary* eventDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSIndexPath* subjectIndexPath = [self indexPathWithFieldName:self.subjectKey];
    NSMutableDictionary* subjectCellDataDict = [self cellDataWithIndexPath:subjectIndexPath];
    [eventDict setObject:[subjectCellDataDict objectForKey:@"FieldData"] forKey:self.subjectKey];
    
    NSIndexPath* locationIndexPath = [self indexPathWithFieldName:self.locationKey];
    NSMutableDictionary* locationCellDataDict = [self cellDataWithIndexPath:locationIndexPath];
    
    NSMutableDictionary* locationResultDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [locationResultDict setObject:[locationCellDataDict objectForKey:@"FieldData"] forKey:@"displayName"];
    [eventDict setObject:locationResultDict forKey:self.locationKey];
    
    NSIndexPath* bodyIndexPath = [self indexPathWithFieldName:self.bodyKey];
    NSMutableDictionary* bodyCellDataDict = [self cellDataWithIndexPath:bodyIndexPath];
    
    NSMutableDictionary* bodyResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [bodyResultDict setObject:@"text" forKey:@"contentType"];
    [bodyResultDict setObject:[bodyCellDataDict objectForKey:@"FieldData"] forKey:@"content"];
    [eventDict setObject:bodyResultDict forKey:self.bodyKey];
    
    NSIndexPath* allDayIndexPath = [self indexPathWithFieldName:self.allDayKey];
    NSMutableDictionary* allDayCellDataDict = [self cellDataWithIndexPath:allDayIndexPath];
    
    NSString* allDayFieldData = [allDayCellDataDict objectForKey:@"FieldData"];
    NSString* allDayResultData = @"true";
    if (![allDayFieldData isEqualToString:@"1"]) {
        allDayResultData = @"false";
    }
    [eventDict setObject:allDayResultData forKey:self.allDayKey];
    
    NSIndexPath* startIndexPath = [self indexPathWithFieldName:self.startKey];
    NSMutableDictionary* startCellDataDict = [self cellDataWithIndexPath:startIndexPath];
    NSMutableDictionary* startFieldData = [startCellDataDict objectForKey:@"FieldData"];
    
    NSString* startResultData = [NSString stringWithFormat:@"%@T00:00:00", [ArcosUtils stringFromDate:[startFieldData objectForKey:@"Date"] format:[GlobalSharedClass shared].utcDateFormat]];
    if (![allDayFieldData isEqualToString:@"1"]) {
        startResultData = [NSString stringWithFormat:@"%@T%@:00", [ArcosUtils stringFromDate:[startFieldData objectForKey:@"Date"] format:[GlobalSharedClass shared].utcDateFormat], [ArcosUtils stringFromDate:[startFieldData objectForKey:@"Time"] format:[GlobalSharedClass shared].hourMinuteFormat]];
    }
    
    NSMutableDictionary* startResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [startResultDict setObject:startResultData forKey:@"dateTime"];
    [startResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];
    [eventDict setObject:startResultDict forKey:@"start"];
    
    NSIndexPath* endIndexPath = [self indexPathWithFieldName:self.endKey];
    NSMutableDictionary* endCellDataDict = [self cellDataWithIndexPath:endIndexPath];
    NSMutableDictionary* endFieldData = [endCellDataDict objectForKey:@"FieldData"];
    
    NSString* endResultData = [NSString stringWithFormat:@"%@T00:00:00", [ArcosUtils stringFromDate:[ArcosUtils addDays:1 date:[endFieldData objectForKey:@"Date"]] format:[GlobalSharedClass shared].utcDateFormat]];
    if (![allDayFieldData isEqualToString:@"1"]) {
        endResultData = [NSString stringWithFormat:@"%@T%@:00", [ArcosUtils stringFromDate:[endFieldData objectForKey:@"Date"] format:[GlobalSharedClass shared].utcDateFormat], [ArcosUtils stringFromDate:[endFieldData objectForKey:@"Time"] format:[GlobalSharedClass shared].hourMinuteFormat]];
    }
        
    NSMutableDictionary* endResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [endResultDict setObject:endResultData forKey:@"dateTime"];
    [endResultDict setObject:[GlobalSharedClass shared].ieTimeZone forKey:@"timeZone"];    
    [eventDict setObject:endResultDict forKey:@"end"];
    
    NSLog(@"eventDict %@", eventDict);
    return eventDict;
}



@end
