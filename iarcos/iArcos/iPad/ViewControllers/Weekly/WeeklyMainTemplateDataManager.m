//
//  WeeklyMainTemplateDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 22/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "WeeklyMainTemplateDataManager.h"

@implementation WeeklyMainTemplateDataManager
@synthesize employeeIUR = _employeeIUR;
@synthesize employeeName = _employeeName;
@synthesize dayOfWeekend = _dayOfWeekend;
@synthesize rowPointer = _rowPointer;
@synthesize employeeDetailList = _employeeDetailList;
@synthesize employeeDict = _employeeDict;
@synthesize currentWeekendDate = _currentWeekendDate;
@synthesize highestAllowedWeekendDate = _highestAllowedWeekendDate;
@synthesize sectionTitleDictList = _sectionTitleDictList;
@synthesize arcosCreateRecordObject = _arcosCreateRecordObject;

@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize dbFieldNameList = _dbFieldNameList;
@synthesize attachmentFileNameList = _attachmentFileNameList;
@synthesize attachmentFileContentList = _attachmentFileContentList;
@synthesize isNewRecord = _isNewRecord;
@synthesize iur = _iur;

@synthesize mondayAmKey = _mondayAmKey;
@synthesize mondayPmKey = _mondayPmKey;
@synthesize tuesdayAmKey = _tuesdayAmKey;
@synthesize tuesdayPmKey = _tuesdayPmKey;
@synthesize wednesdayAmKey = _wednesdayAmKey;
@synthesize wednesdayPmKey = _wednesdayPmKey;
@synthesize thursdayAmKey = _thursdayAmKey;
@synthesize thursdayPmKey = _thursdayPmKey;
@synthesize fridayAmKey = _fridayAmKey;
@synthesize fridayPmKey = _fridayPmKey;
@synthesize saturdayAmKey = _saturdayAmKey;
@synthesize saturdayPmKey = _saturdayPmKey;
@synthesize sundayAmKey = _sundayAmKey;
@synthesize sundayPmKey = _sundayPmKey;
@synthesize daysOfWeekKeyList = _daysOfWeekKeyList;
@synthesize arcosDescriptionTrManager = _arcosDescriptionTrManager;
@synthesize dayPartsDbFieldNameList = _dayPartsDbFieldNameList;
@synthesize dayPartsGroupedDataDict = _dayPartsGroupedDataDict;
@synthesize dayPartsOriginalGroupedDataDict = _dayPartsOriginalGroupedDataDict;
@synthesize fieldNameList = _fieldNameList;
@synthesize fieldValueList = _fieldValueList;
@synthesize dayPartsDictList = _dayPartsDictList;
@synthesize dayPartsCode = _dayPartsCode;
@synthesize weekdayCode = _weekdayCode;
@synthesize weekendCode = _weekendCode;
@synthesize dayPartsTitle = _dayPartsTitle;
@synthesize updatedFieldNameList = _updatedFieldNameList;
@synthesize updatedFieldValueList = _updatedFieldValueList;
@synthesize weekDayDescList = _weekDayDescList;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dayPartsCode = @"DP";
        self.weekdayCode = @"OT";
        self.weekendCode = @"WE";
        self.arcosCreateRecordObject = [[[ArcosCreateRecordObject alloc] init] autorelease];
        self.sectionTitleDictList = [self retrieveSectionTitleDictList];
        self.sectionTitleList = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < [self.sectionTitleDictList count]; i++) {
            NSDictionary* sectionTitleDict = [self.sectionTitleDictList objectAtIndex:i];
            [self.sectionTitleList addObject:[sectionTitleDict objectForKey:@"Title"]];
        }
        
        self.dbFieldNameList = [NSMutableArray arrayWithObjects:@"Narrative1", @"Narrative2", @"Narrative3", @"Narrative4", nil];
        [self reinitiateAttachmentAuxiObject];
        self.arcosDescriptionTrManager = [[[ArcosDescriptionTrManager alloc] init] autorelease];
        self.mondayAmKey = [NSNumber numberWithInt:10];
        self.mondayPmKey = [NSNumber numberWithInt:11];
        self.tuesdayAmKey = [NSNumber numberWithInt:20];
        self.tuesdayPmKey = [NSNumber numberWithInt:21];
        self.wednesdayAmKey = [NSNumber numberWithInt:30];
        self.wednesdayPmKey = [NSNumber numberWithInt:31];
        self.thursdayAmKey = [NSNumber numberWithInt:40];
        self.thursdayPmKey = [NSNumber numberWithInt:41];
        self.fridayAmKey = [NSNumber numberWithInt:50];
        self.fridayPmKey = [NSNumber numberWithInt:51];
        self.saturdayAmKey = [NSNumber numberWithInt:60];
        self.saturdayPmKey = [NSNumber numberWithInt:61];
        self.sundayAmKey = [NSNumber numberWithInt:70];
        self.sundayPmKey = [NSNumber numberWithInt:71];
        self.daysOfWeekKeyList = [NSMutableArray arrayWithObjects:self.mondayAmKey, self.mondayPmKey, self.tuesdayAmKey, self.tuesdayPmKey, self.wednesdayAmKey, self.wednesdayPmKey, self.thursdayAmKey, self.thursdayPmKey, self.fridayAmKey, self.fridayPmKey, self.saturdayAmKey, self.saturdayPmKey, self.sundayAmKey, self.sundayPmKey, nil];
        self.dayPartsDbFieldNameList = [NSMutableArray arrayWithObjects:@"Day1AM",@"Day1PM",@"Day2AM",@"Day2PM",@"Day3AM",@"Day3PM",@"Day4AM",@"Day4PM",@"Day5AM",@"Day5PM",@"Day6AM",@"Day6PM",@"Day7AM",@"Day7PM", nil];
        self.weekDayDescList = [NSMutableArray arrayWithObjects:@"MONDAY", @"TUESDAY", @"WEDNEDDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY", @"SUNDAY", nil];
        [self createBasicData];
    }
    return self;
}

- (void)dealloc {
    self.employeeIUR = nil;
    self.employeeName = nil;
    self.dayOfWeekend = nil;
    self.employeeDetailList = nil;
    self.employeeDict = nil;
    self.currentWeekendDate = nil;
    self.highestAllowedWeekendDate = nil;
    self.sectionTitleDictList = nil;
    self.arcosCreateRecordObject = nil;
    
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.originalGroupedDataDict = nil;
    self.dbFieldNameList = nil;
    self.attachmentFileNameList = nil;
    self.attachmentFileContentList = nil;
    self.iur = nil;
    
    self.mondayAmKey = nil;
    self.mondayAmKey = nil;
    self.mondayPmKey = nil;
    self.tuesdayAmKey = nil;
    self.tuesdayPmKey = nil;
    self.wednesdayAmKey = nil;
    self.wednesdayPmKey = nil;
    self.thursdayAmKey = nil;
    self.thursdayPmKey = nil;
    self.fridayAmKey = nil;
    self.fridayPmKey = nil; 
    self.saturdayAmKey = nil;
    self.saturdayPmKey = nil;
    self.sundayAmKey = nil;
    self.sundayPmKey = nil;
    self.daysOfWeekKeyList = nil;
    self.arcosDescriptionTrManager = nil;
    self.dayPartsDbFieldNameList = nil;
    
    self.fieldNameList = nil;
    self.fieldValueList = nil;
    self.dayPartsDictList = nil;
    self.dayPartsCode = nil;
    self.weekdayCode = nil;
    self.weekendCode = nil;
    self.dayPartsTitle = nil;
    self.updatedFieldNameList = nil;
    self.updatedFieldValueList = nil;
    self.weekDayDescList = nil;
    
    [super dealloc];
}

-(void)createBasicData {
    self.groupedDataDict = [NSMutableDictionary dictionary];
    self.originalGroupedDataDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
        [cellData setObject:@"" forKey:@"Narrative"];
        [cellData setObject:[NSNumber numberWithBool:NO] forKey:@"HasRecord"];
        [self.groupedDataDict setObject:cellData forKey:[self.sectionTitleList objectAtIndex:i]];
        NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
        [self.originalGroupedDataDict setObject:originalCellData forKey:[self.sectionTitleList objectAtIndex:i]];
    }
    self.dayPartsGroupedDataDict = [NSMutableDictionary dictionaryWithCapacity:[self.daysOfWeekKeyList count]];
    self.dayPartsOriginalGroupedDataDict = [NSMutableDictionary dictionaryWithCapacity:[self.daysOfWeekKeyList count]];
    for (int j = 0; j < [self.daysOfWeekKeyList count]; j++) {
        NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:j];
        NSMutableDictionary* daysOfWeekDataDict = [NSMutableDictionary dictionary];
        [daysOfWeekDataDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasRecord"];
        [daysOfWeekDataDict setObject:[self createCompositeUnAssignedDescrDetailDict] forKey:@"Data"];
        NSMutableDictionary* originalDaysOfWeekDataDict = [NSMutableDictionary dictionaryWithDictionary:daysOfWeekDataDict]; 
        [self.dayPartsGroupedDataDict setObject:daysOfWeekDataDict forKey:auxDaysOfWeekKey];
        [self.dayPartsOriginalGroupedDataDict setObject:originalDaysOfWeekDataDict forKey:auxDaysOfWeekKey];
    }
    self.isNewRecord = YES;
}

- (NSNumber*)getDayOfWeekend {
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    return [configDict objectForKey:@"DayofWeekend"];
}

- (NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend {
    //in sql server
    //0 or 7 stands for Sunday.
    //1 to 6 stand for Monday to Saturday
    //in objective c 1 to 7 stand for Sunday to Saturday
    if (aDayOfWeekend == 7) {
        aDayOfWeekend = 0;
    }
//    NSLog(@"aDayOfWeekend is %d", [ArcosUtils convertNSIntegerToInt:aDayOfWeekend]);
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:aDate];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    //in order to sync with the number in the sql server
    NSInteger weekday = [weekdayComponents weekday] - 1;
    NSInteger numOfdays = 0;
    if (weekday == aDayOfWeekend) {
        
    } else {
        numOfdays = (aDayOfWeekend == 0) ? (aDayOfWeekend - weekday + 7) : (aDayOfWeekend - weekday);
    }    
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

- (NSMutableArray*)retrieveSectionTitleDictList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='WF'"];
    NSArray* sortArray = [NSArray arrayWithObjects:@"DescrDetailCode",nil];
    return [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicate sortByArray:sortArray];
}

- (void)reinitiateAttachmentAuxiObject {
    self.attachmentFileNameList = [NSMutableArray array];
    self.attachmentFileContentList = [NSMutableArray array];
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    return [self.groupedDataDict objectForKey:sectionTitle];
}

- (BOOL)checkValidation {
    int blankFieldNum = 0;
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:[self.sectionTitleList objectAtIndex:i]];
        if ([[cellData objectForKey:@"Narrative"] isEqualToString:@""]) {
            blankFieldNum++;
        }        
    }
    return (blankFieldNum == [self.sectionTitleList count]) ? NO :YES;
}

- (void)processRawData:(NSMutableArray*)aDataList {
    [self createBasicData];
    if ([aDataList count] != 1) {
        return;
    }
    self.isNewRecord = NO;
    NSMutableArray* narrativeList = [NSMutableArray arrayWithCapacity:4];    
    ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:0];
    self.iur = [ArcosUtils convertStringToNumber:[arcosGenericClass Field1]];    
    for (int i = 4; i <= 7; i++) {
        NSString* methodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(methodName);
        [narrativeList addObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass performSelector:selector]]];
    }
    for (int i = 0; i < [self.sectionTitleList count]; i++) {    
        NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:1];
        [cellData setObject:[narrativeList objectAtIndex:i] forKey:@"Narrative"];
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"HasRecord"];
        [self.groupedDataDict setObject:cellData forKey:[self.sectionTitleList objectAtIndex:i]];
        NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
        [self.originalGroupedDataDict setObject:originalCellData forKey:[self.sectionTitleList objectAtIndex:i]];
    }
    NSMutableArray* dayPartsDescrDetailIURList = [NSMutableArray arrayWithCapacity:14];
    for (int i = 8; i <= 21; i++) {
        NSString* methodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(methodName);
        [dayPartsDescrDetailIURList addObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass performSelector:selector]]]]];
    }
    NSMutableArray* auxDayPartsDictList = [self retrieveDayPartsDictList];
    NSMutableDictionary* auxDayPartsDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[auxDayPartsDictList count]];
    for (int i = 0; i < [auxDayPartsDictList count]; i++) {
        NSMutableDictionary* auxDayPartsDict = [auxDayPartsDictList objectAtIndex:i];
        [auxDayPartsDictHashMap setObject:auxDayPartsDict forKey:[auxDayPartsDict objectForKey:@"DescrDetailIUR"]];
    }
    for (int j = 0; j < [self.daysOfWeekKeyList count]; j++) {
        NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:j];
        NSMutableDictionary* daysOfWeekDataDict = [NSMutableDictionary dictionary];
        [daysOfWeekDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"HasRecord"];
        NSNumber* auxDayPartsDescrDetailIUR = [dayPartsDescrDetailIURList objectAtIndex:j];
        NSMutableDictionary* auxDayPartsDict = [auxDayPartsDictHashMap objectForKey:auxDayPartsDescrDetailIUR];
        if (auxDayPartsDict == nil) {
            auxDayPartsDict = [self createCompositeUnAssignedDescrDetailDict];
        }
        [daysOfWeekDataDict setObject:auxDayPartsDict forKey:@"Data"];
        NSMutableDictionary* originalDaysOfWeekDataDict = [NSMutableDictionary dictionaryWithDictionary:daysOfWeekDataDict]; 
        [self.dayPartsGroupedDataDict setObject:daysOfWeekDataDict forKey:auxDaysOfWeekKey];
        [self.dayPartsOriginalGroupedDataDict setObject:originalDaysOfWeekDataDict forKey:auxDaysOfWeekKey];
    }
}

- (NSMutableDictionary*)createCompositeUnAssignedDescrDetailDict {
    NSMutableDictionary* descrDetailDict = [self.arcosDescriptionTrManager createUnAssignedDescrDetailDict];
    [descrDetailDict setObject:[ArcosUtils trim:[descrDetailDict objectForKey:@"Detail"]] forKey:@"Title"];
    return descrDetailDict;
}

- (void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
    [cellData setObject:data forKey:@"Narrative"];
    [self.groupedDataDict setObject:cellData forKey:sectionTitle];
}

- (void)updateChangedData:(id)data withTag:(NSNumber*)aTagNumber {
    NSMutableDictionary* auxDayCellData = [self.dayPartsGroupedDataDict objectForKey:aTagNumber];
    [auxDayCellData setObject:data forKey:@"Data"];
}

- (void)prepareForCreateWeeklyRecord {
    self.fieldNameList = [NSMutableArray array];
    self.fieldValueList = [NSMutableArray array];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        int fieldNameIndex = i;
        NSString* sectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:sectionTitle];
        [self.fieldNameList addObject:[NSString stringWithFormat:@"Narrative%d",++fieldNameIndex]];
        [self.fieldValueList addObject:[cellData objectForKey:@"Narrative"]];
    }
    for (int j = 0; j < [self.daysOfWeekKeyList count]; j++) {
        NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:j];
        NSMutableDictionary* auxDaysOfWeekDataDict = [self.dayPartsGroupedDataDict objectForKey:auxDaysOfWeekKey];
        NSMutableDictionary* auxDaysOfWeekCompositeContentDataDict = [auxDaysOfWeekDataDict objectForKey:@"Data"];
        [self.fieldNameList addObject:[self.dayPartsDbFieldNameList objectAtIndex:j]];
        NSString* auxDescrDetailIURStr = [ArcosUtils convertNumberToIntString:[auxDaysOfWeekCompositeContentDataDict objectForKey:@"DescrDetailIUR"]];
        [self.fieldValueList addObject:auxDescrDetailIURStr];
    }
}

- (NSString*)retrieveDayPartsTitle {
    NSString* auxDayPartsTitle = @"";
    NSDictionary* dayPartsDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:self.dayPartsCode];
    if (dayPartsDict != nil) {
        auxDayPartsTitle = [dayPartsDict objectForKey:@"Details"];
    }
    return auxDayPartsTitle;
}

- (NSMutableArray*)retrieveDayPartsDictList {  
    return [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:self.dayPartsCode];
}

- (void)getChangedDataList {
    self.updatedFieldNameList = [NSMutableArray array];
    self.updatedFieldValueList = [NSMutableArray array];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* sectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:sectionTitle];
        NSMutableDictionary* originalCellData = [self.originalGroupedDataDict objectForKey:sectionTitle];
        if (![[cellData objectForKey:@"Narrative"] isEqualToString:[originalCellData objectForKey:@"Narrative"]]) {
            [self.updatedFieldNameList addObject:[self.dbFieldNameList objectAtIndex:i]];
            [self.updatedFieldValueList addObject:[cellData objectForKey:@"Narrative"]];
        }
    }
    
    for (int j = 0; j < [self.daysOfWeekKeyList count]; j++) {
        NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:j];
        NSMutableDictionary* auxDaysOfWeekDataDict = [self.dayPartsGroupedDataDict objectForKey:auxDaysOfWeekKey];
        NSMutableDictionary* auxDaysOfWeekCompositeContentDataDict = [auxDaysOfWeekDataDict objectForKey:@"Data"];
        NSMutableDictionary* auxDaysOfWeekOriginalDataDict = [self.dayPartsOriginalGroupedDataDict objectForKey:auxDaysOfWeekKey];
        NSMutableDictionary* auxDaysOfWeekCompositeContentOriginalDataDict = [auxDaysOfWeekOriginalDataDict objectForKey:@"Data"];
        NSNumber* auxDescrDetailIUR = [auxDaysOfWeekCompositeContentDataDict objectForKey:@"DescrDetailIUR"];
        NSNumber* auxOriginalDescrDetailIUR = [auxDaysOfWeekCompositeContentOriginalDataDict objectForKey:@"DescrDetailIUR"];
        if ([auxDescrDetailIUR compare:auxOriginalDescrDetailIUR] != NSOrderedSame) {
            [self.updatedFieldNameList addObject:[self.dayPartsDbFieldNameList objectAtIndex:j]];
            [self.updatedFieldValueList addObject:[ArcosUtils convertNumberToIntString:auxDescrDetailIUR]];
        }
    }
}

- (void)assignDefaultDayPartsAfterBasicData {
    NSMutableArray* auxDayPartsDictList = [self retrieveDayPartsDictList];
    NSMutableDictionary* auxDefaultWeekdayDict = nil;
    NSMutableDictionary* auxDefaultWeekendDict = nil;
    for (int i = 0; i < [auxDayPartsDictList count]; i++) {
        NSMutableDictionary* auxDayPartsDict = [auxDayPartsDictList objectAtIndex:i];
        NSString* auxDescrDetailCode = [ArcosUtils trim:[auxDayPartsDict objectForKey:@"DescrDetailCode"]];
        if ([auxDescrDetailCode isEqualToString:self.weekdayCode]) {
            auxDefaultWeekdayDict = auxDayPartsDict;
        } else if ([auxDescrDetailCode isEqualToString:self.weekendCode]) {
            auxDefaultWeekendDict = auxDayPartsDict;
        }
    }
    if (auxDefaultWeekdayDict != nil) {
        for (int i = 0; i <= 9; i++) {
            NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:i];
            NSMutableDictionary* auxDaysOfWeekDataDict = [self.dayPartsGroupedDataDict objectForKey:auxDaysOfWeekKey];
            [auxDaysOfWeekDataDict setObject:[NSMutableDictionary dictionaryWithDictionary:auxDefaultWeekdayDict] forKey:@"Data"];
        }
    }
    if (auxDefaultWeekendDict != nil) {
        for (int i = 10; i <= 13; i++) {
            NSNumber* auxDaysOfWeekKey = [self.daysOfWeekKeyList objectAtIndex:i];
            NSMutableDictionary* auxDaysOfWeekDataDict = [self.dayPartsGroupedDataDict objectForKey:auxDaysOfWeekKey];
            [auxDaysOfWeekDataDict setObject:[NSMutableDictionary dictionaryWithDictionary:auxDefaultWeekendDict] forKey:@"Data"];
        }
    }    
}

@end
