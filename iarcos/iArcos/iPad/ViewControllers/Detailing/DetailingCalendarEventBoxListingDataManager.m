//
//  DetailingCalendarEventBoxListingDataManager.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingDataManager.h"

@implementation DetailingCalendarEventBoxListingDataManager
@synthesize actionDelegate = _actionDelegate;
@synthesize displayList = _displayList;
@synthesize dateList = _dateList;
@synthesize hourHashMap = _hourHashMap;
@synthesize cellFactory = _cellFactory;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellFactory = [[[DetailingCalendarEventBoxListingTableCellFactory alloc] init] autorelease];
        /*
        self.hourHashMap = [NSMutableDictionary dictionary];
        NSDate* startDate = [ArcosUtils beginOfDayWithZeroTime:[NSDate date]];
        
        NSDate* hourNineDate = [ArcosUtils addHours:9 date:startDate];
        NSDate* hourElevenDate = [ArcosUtils addHours:11 date:startDate];
        NSDate* hourFifteenDate = [ArcosUtils addHours:15 date:startDate];
        NSNumber* hourNineKey = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:hourNineDate]]];
        NSNumber* hourElevenKey = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:hourElevenDate]]];
        NSNumber* hourFifteenKey = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:hourFifteenDate]]];
        NSMutableArray* hourNineEventList = [NSMutableArray arrayWithCapacity:3];
        [hourNineEventList addObject:[self createBodyCellDataWithDate:hourNineDate data:@"contact name 1"]];
        [hourNineEventList addObject:[self createBodyCellDataWithDate:hourNineDate data:@"contact name 2"]];
        [hourNineEventList addObject:[self createBodyCellDataWithDate:hourNineDate data:@"contact name 3"]];
        [self.hourHashMap setObject:hourNineEventList forKey:hourNineKey];
        
        NSMutableArray* hourElevenEventList = [NSMutableArray arrayWithCapacity:1];
        [hourElevenEventList addObject:[self createBodyCellDataWithDate:hourElevenDate data:@"contact name a"]];
        [self.hourHashMap setObject:hourElevenEventList forKey:hourElevenKey];
        
        NSMutableArray* hourFifteenEventList = [NSMutableArray array];
        [hourFifteenEventList addObject:[self createBodyCellDataWithDate:hourFifteenDate data:@"contact name b"]];
        [hourFifteenEventList addObject:[self createBodyCellDataWithDate:hourFifteenDate data:@"contact name c"]];
        [self.hourHashMap setObject:hourFifteenEventList forKey:hourFifteenKey];
         */
    }
    return self;
}

- (void)dealloc {
    self.cellFactory = nil;
    self.displayList = nil;
    self.dateList = nil;
    self.hourHashMap = nil;
    
    [super dealloc];
}

- (void)createBasicDataWithDataList:(NSMutableArray*)aDataList {
    [self buildHourHashMapWithDataList:aDataList];
    self.displayList = [NSMutableArray array];
    NSDate* startDate = [ArcosUtils beginOfDayWithZeroTime:[NSDate date]];
    self.dateList = [NSMutableArray arrayWithCapacity:24];
    [self.dateList addObject:startDate];
//    NSLog(@"startDate %@", startDate);
    for (int i = 1; i < 24; i++) {
        NSDate* tmpDate = [ArcosUtils addHours:i date:startDate];
        [self.dateList addObject:tmpDate];
    }
    for (int i = 0; i < [self.dateList count]; i++) {
        NSDate* tmpDate = [self.dateList objectAtIndex:i];
//        NSLog(@"hour %d \n", [ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:tmpDate]]);
        NSNumber* tmpHourKey = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:tmpDate]]];
        NSMutableArray* hourEventList = [self.hourHashMap objectForKey:tmpHourKey];
        [self.displayList addObject:[self createHeaderCellDataWithDate:tmpDate]];
        if (hourEventList == nil) {
            [self.displayList addObject:[self createPlaceHolderCellData]];
        } else {
            [self.displayList addObjectsFromArray:hourEventList];
        }
    }
    
    
}

- (void)buildHourHashMapWithDataList:(NSMutableArray*)aDataList {
    self.hourHashMap = [NSMutableDictionary dictionary];
    for (int i = 0; i < [aDataList count]; i++) {
        NSDictionary* cellData = [aDataList objectAtIndex:i];
        NSDictionary* cellStartDict = [cellData objectForKey:@"start"];
        NSString* tmpCellStartDateStr = [cellStartDict objectForKey:@"dateTime"];
        NSDate* tmpCellStartDate = [ArcosUtils dateFromString:tmpCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
        int tmpHour = [ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:tmpCellStartDate]];
        NSNumber* tmpHourKey = [NSNumber numberWithInt:tmpHour];
        NSMutableArray* tmpHourDataList = [self.hourHashMap objectForKey:tmpHourKey];
        if (tmpHourDataList == nil) {
            tmpHourDataList = [NSMutableArray array];
        }
        [tmpHourDataList addObject:[self createBodyCellDataWithDate:tmpCellStartDate data:cellData]];
        [self.hourHashMap setObject:tmpHourDataList forKey:tmpHourKey];
    }
}

- (NSMutableDictionary*)createHeaderCellDataWithDate:(NSDate*)aDate {
    NSMutableDictionary* resDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [resDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    [resDataDict setObject:aDate forKey:@"FieldDesc"];
    return resDataDict;
}

- (NSMutableDictionary*)createBodyCellDataWithDate:(NSDate*)aDate data:(NSDictionary*)aDataDict {
    NSMutableDictionary* resDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [resDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [resDataDict setObject:aDate forKey:@"FieldDesc"];
    [resDataDict setObject:aDataDict forKey:@"FieldValue"];
    return resDataDict;
}

- (NSMutableDictionary*)createPlaceHolderCellData {
    NSMutableDictionary* resDataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [resDataDict setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    return resDataDict;
}

- (NSMutableDictionary*)createBodyForTemplateCellDataWithDate:(NSDate*)aDate data:(NSMutableDictionary*)aDataDict {
    NSMutableDictionary* resDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [resDataDict setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    [resDataDict setObject:aDate forKey:@"FieldDesc"];
    [resDataDict setObject:aDataDict forKey:@"FieldValue"];
    return resDataDict;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    int cellTypeInt = [[cellData objectForKey:@"CellType"] intValue];
    if (cellTypeInt == 1 || cellTypeInt == 3) {
        return 30;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    DetailingCalendarEventBoxListingBaseTableCell* cell = (DetailingCalendarEventBoxListingBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (DetailingCalendarEventBoxListingBaseTableCell*)[self.cellFactory createDetailingCalendarEventBoxListingBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithData:cellData];
    
    
    return cell;
}

#pragma mark - DetailingCalendarEventBoxListingBaseTableCellDelegate

- (NSNumber*)retrieveDetailingCalendarEventBoxListingTableCellLocationIUR {
    return [self.actionDelegate retrieveDetailingCalendarEventBoxListingDataManagerLocationIUR];
}

- (NSNumber*)retrieveDetailingCalendarEventBoxListingTableCellLocationIURWithEventDict:(NSDictionary*)anEventDict {
    return [self.actionDelegate retrieveDetailingCalendarEventBoxListingLocationIURWithEventDict:anEventDict];
}

- (void)doubleTapBodyLabelWithIndexPath:(NSIndexPath*)anIndexPath {    
    [self.actionDelegate doubleTapListingBodyLabelWithIndexPath:anIndexPath];
}

- (void)createBasicDataForTemplateWithDataList:(NSMutableArray*)aDataList {
    [self buildHourHashMapForTemplateWithDataList:aDataList];
    self.displayList = [NSMutableArray array];
    NSDate* startDate = [ArcosUtils beginOfDayWithZeroTime:[NSDate date]];
    self.dateList = [NSMutableArray arrayWithCapacity:24];
    [self.dateList addObject:startDate];
    for (int i = 1; i < 24; i++) {
        NSDate* tmpDate = [ArcosUtils addHours:i date:startDate];
        [self.dateList addObject:tmpDate];
    }
    for (int i = 0; i < [self.dateList count]; i++) {
        NSDate* tmpDate = [self.dateList objectAtIndex:i];
        NSNumber* tmpHourKey = [NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:tmpDate]]];
        NSMutableArray* hourEventList = [self.hourHashMap objectForKey:tmpHourKey];
        [self.displayList addObject:[self createHeaderCellDataWithDate:tmpDate]];
        if (hourEventList == nil) {
            [self.displayList addObject:[self createPlaceHolderCellData]];
        } else {
            [self.displayList addObjectsFromArray:hourEventList];
        }
    }
}

- (void)buildHourHashMapForTemplateWithDataList:(NSMutableArray*)aDataList {
    self.hourHashMap = [NSMutableDictionary dictionary];
    for (int i = 0; i < [aDataList count]; i++) {
        NSMutableDictionary* cellData = [aDataList objectAtIndex:i];
        NSDate* tmpCellStartDate = [cellData objectForKey:@"Date"];
        int tmpHour = [ArcosUtils convertNSIntegerToInt:[ArcosUtils hourWithDate:tmpCellStartDate]];
        NSNumber* tmpHourKey = [NSNumber numberWithInt:tmpHour];
        NSMutableArray* tmpHourDataList = [self.hourHashMap objectForKey:tmpHourKey];
        if (tmpHourDataList == nil) {
            tmpHourDataList = [NSMutableArray array];
        }
        [tmpHourDataList addObject:[self createBodyForTemplateCellDataWithDate:tmpCellStartDate data:cellData]];
        [self.hourHashMap setObject:tmpHourDataList forKey:tmpHourKey];
    }
}

@end
