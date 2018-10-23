//
//  CustomerSurveyDetailsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 21/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsDataManager.h"

@implementation CustomerSurveyDetailsDataManager
@synthesize displayList = _displayList;
@synthesize sectionNoList = _sectionNoList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize editFieldName = _editFieldName;
@synthesize currentIndexPath = _currentIndexPath;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.editFieldName = @"Answer";
    }
    
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.sectionNoList = nil;
    self.groupedDataDict = nil;
    self.sectionTitleList = nil;
    self.editFieldName = nil;
    self.currentIndexPath = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aDataList {
    NSSortDescriptor* sectionNoDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Field1" ascending:YES comparator:^(id obj1, id obj2) {        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSSortDescriptor* sequenceDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Field2" ascending:YES comparator:^(id obj1, id obj2) {        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    [aDataList sortUsingDescriptors:[NSArray arrayWithObjects:sectionNoDescriptor, sequenceDescriptor, nil]];
    self.sectionNoList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    self.sectionTitleList = [NSMutableArray array];
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        NSNumber* sectionNo = [ArcosUtils convertStringToNumber:arcosGenericClass.Field1];
        NSNumber* questionType = [ArcosUtils convertStringToNumber:arcosGenericClass.Field3];
        if (![self.sectionNoList containsObject:sectionNo]) {
            [self.sectionNoList addObject:sectionNo];            
            if ([questionType intValue] == 7) {
                [self.sectionTitleList addObject:arcosGenericClass.Field4];
            } else {
                [self.sectionTitleList addObject:@""];
            } 
            NSMutableArray* auxDataList = [NSMutableArray array];
            [self.groupedDataDict setObject:auxDataList forKey:sectionNo];
        }
        if ([questionType intValue] != 7) {
            NSMutableArray* myDataList = [self.groupedDataDict objectForKey:sectionNo];
            [myDataList addObject:arcosGenericClass];
        }
    }    
}

- (ArcosGenericClass*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSNumber* auxSectionNo = [self.sectionNoList objectAtIndex:anIndexPath.section];
    NSMutableArray* auxDataList = [self.groupedDataDict objectForKey:auxSectionNo];
    return [auxDataList objectAtIndex:anIndexPath.row];
}

- (NSString*)buildEmailMessage {
    NSMutableString* body = [NSMutableString string];
    [body appendString:@"<html><body><table width='100%' height='100%' cellspacing='0' cellpadding='0'>"];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* auxSectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSNumber* auxSectionNo = [self.sectionNoList objectAtIndex:i];
        [body appendString:[self createSectionHeader:auxSectionTitle]];
        NSMutableArray* auxDisplayList = [self.groupedDataDict objectForKey:auxSectionNo];
        for (int j = 0; j < [auxDisplayList count]; j++) {
            ArcosGenericClass* auxArcosGenericClass = [auxDisplayList objectAtIndex:j];
            NSNumber* tmpQuestionType = [ArcosUtils convertStringToNumber:auxArcosGenericClass.Field3];
            int tmpQuestionTypeNumber = [tmpQuestionType intValue];
            if (tmpQuestionTypeNumber == 13 || tmpQuestionTypeNumber == 14) {
                [body appendString:[self createScoreRecord:auxArcosGenericClass]];
            } else if (tmpQuestionTypeNumber == 16) {
                [body appendString:[self createSectionSubHeader:auxArcosGenericClass]];
            } else {
                [body appendString:[self createStandardRecord:auxArcosGenericClass]];
            }            
        }
    }
    [body appendString:@"</table></body></html>"];
    return body;
}

- (NSString*)createSectionHeader:(NSString*)aSectionHeader {
    NSMutableString* auxSectionHeader = [NSMutableString string];
    [auxSectionHeader appendString:@"<tr width='100%'><td width='100%' height='44' style='background-color:#00008B;color:#FFFFFF;text-align:center;font-weight:bold;font-size:18px'><table width='100%' height='100%' cellspacing='0' cellpadding='0' style='table-layout:fixed'><tr width='100%' height='100%'><td width='100%' height='100%' style='word-wrap:break-word'>"];
    [auxSectionHeader appendString:aSectionHeader];
    [auxSectionHeader appendString:@"</td></tr></table></td></tr>"];
    return auxSectionHeader;
}

- (NSString*)createSectionSubHeader:(ArcosGenericClass*)anArcosGenericClass {
    NSMutableString* auxSectionSubHeader = [NSMutableString string];
    [auxSectionSubHeader appendString:@"<tr width='100%'><td width='100%' height='44' style='background-color:#87CEFA;text-align:center'><table width='100%' height='100%' style='table-layout:fixed'><tr width='100%' height='100%'><td width='100%' height='100%' style='word-wrap:break-word'>"];
    [auxSectionSubHeader appendString:[ArcosUtils convertNilToEmpty:anArcosGenericClass.Field4]];
    [auxSectionSubHeader appendString:@"</td></tr></table></td></tr>"];
    return auxSectionSubHeader;
}

- (NSString*)createStandardRecord:(ArcosGenericClass*)anArcosGenericClass {
    NSMutableString* auxStandardRecord = [NSMutableString string];
    [auxStandardRecord appendString:@"<tr width='100%'><td width='100%' height='44'><table width='100%' height='100%' style='table-layout:fixed'><tr width='100%' height='100%'><td width='50%' height='44' style='text-align:left;word-wrap:break-word'>"];
    [auxStandardRecord appendString:[ArcosUtils convertNilToEmpty:anArcosGenericClass.Field4]];
    [auxStandardRecord appendString:@"</td><td width='50%' height='44' style='text-align:right;word-wrap:break-word'>"];
    [auxStandardRecord appendString:[ArcosUtils convertNilToEmpty:anArcosGenericClass.Field6]];
    [auxStandardRecord appendString:@"</td></table></td></tr>"];
    return auxStandardRecord;
}

- (NSString*)createScoreRecord:(ArcosGenericClass*)anArcosGenericClass {
    NSArray* responseArray = [[ArcosUtils convertNilToEmpty:anArcosGenericClass.Field6] componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
    NSString* scoreString = @"";
    NSString* responseString = @"";    
    if ([responseArray count] == 2) {
        scoreString = [responseArray objectAtIndex:0];
        responseString = [responseArray objectAtIndex:1];
    }
    if ([responseArray count] == 1) {
        scoreString = [responseArray objectAtIndex:0];
    }
    if ([scoreString isEqualToString:[GlobalSharedClass shared].unknownText]) {
        scoreString = @"";
    }
    NSMutableString* auxScoreRecord = [NSMutableString string];
    [auxScoreRecord appendString:@"<tr width='100%'><td width='100%' height='70'><table width='100%' height='100%' cellspacing='0' cellpadding='0' style='table-layout:fixed'><tr width='100%' height='100%'><td width='50%' height='100%' style='word-wrap:break-word;text-align:left'>"];
    [auxScoreRecord appendString:[ArcosUtils convertNilToEmpty:anArcosGenericClass.Field4]];
    [auxScoreRecord appendString:@"</td><td width='50%' height='100%'><table width='100%' height='100%' cellspacing='0' cellpadding='0' style='table-layout:fixed'><tr width='100%' height='100%'><td height='100%' style='text-align:right;vertical-align:bottom;word-wrap:break-word;'>"];
    [auxScoreRecord appendString:responseString];
    [auxScoreRecord appendString:@"</td><td width='70' height='100%' style='color:#87CEFA;text-align:center;font-weight:bold;font-size:30px'>"];
    [auxScoreRecord appendString:scoreString];
    [auxScoreRecord appendString:@"</td></tr></table></td></tr></table></td></tr>"];
    return auxScoreRecord;
}

- (void)updateResponseRecord {
    ArcosGenericClass* auxCellData = [self cellDataWithIndexPath:self.currentIndexPath];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %@", [ArcosUtils convertStringToNumber:auxCellData.Field7]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectArray count] > 0) {
        Response* auxResponse = [objectArray objectAtIndex:0];
        auxResponse.Answer = auxCellData.Field6;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (void)updateBooleanResponseRecord {
    ArcosGenericClass* auxCellData = [self cellDataWithIndexPath:self.currentIndexPath];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %@", [ArcosUtils convertStringToNumber:auxCellData.Field7]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectArray count] > 0) {
        Response* auxResponse = [objectArray objectAtIndex:0];
        NSString* auxAnswer = [auxCellData.Field6 isEqualToString:@"Yes"] ? @"1" : @"0";
        auxResponse.Answer = auxAnswer;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}


@end
