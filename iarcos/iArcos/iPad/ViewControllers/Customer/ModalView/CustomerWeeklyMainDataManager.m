//
//  CustomerWeeklyMainDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerWeeklyMainDataManager.h"

@implementation CustomerWeeklyMainDataManager
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize fieldNameList = _fieldNameList;
@synthesize fieldValueList = _fieldValueList;
@synthesize isNewRecord = _isNewRecord;
@synthesize updatedFieldNameList = _updatedFieldNameList;
@synthesize updatedFieldValueList = _updatedFieldValueList;
@synthesize iur = _iur;
@synthesize dbFieldNameList = _dbFieldNameList;
@synthesize attachmentFileNameList = _attachmentFileNameList;
@synthesize attachmentFileContentList = _attachmentFileContentList;

-(id)initWithSectionTitleDictList:(NSMutableArray*)aSectionTitleDictList {
    self = [super init];
    if (self != nil) {        
        self.sectionTitleList = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < [aSectionTitleDictList count]; i++) {
            NSDictionary* sectionTitleDict = [aSectionTitleDictList objectAtIndex:i];
            [self.sectionTitleList addObject:[sectionTitleDict objectForKey:@"Title"]];
        }
        [self createBasicData];
        self.dbFieldNameList = [NSMutableArray arrayWithObjects:@"Narrative1", @"Narrative2", @"Narrative3", @"Narrative4", nil];
//        NSLog(@"dbFieldNameList %d", [self.dbFieldNameList count]);
        [self reinitiateAttachmentAuxiObject];
    }
    return self;
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
    self.isNewRecord = YES;
}

-(void)dealloc {
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    if (self.originalGroupedDataDict != nil) { self.originalGroupedDataDict = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }    
    if (self.fieldNameList != nil) { self.fieldNameList = nil; }
    if (self.fieldValueList != nil) { self.fieldValueList = nil; }
    if (self.updatedFieldNameList != nil) { self.updatedFieldNameList = nil; }
    if (self.updatedFieldValueList != nil) { self.updatedFieldValueList = nil; }
    if (self.iur != nil) { self.iur = nil; }
    if (self.dbFieldNameList != nil) { self.dbFieldNameList = nil; }
    self.attachmentFileNameList = nil;
    self.attachmentFileContentList = nil;
    
    [super dealloc];
}

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    return [self.groupedDataDict objectForKey:sectionTitle];
}

-(void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
    [cellData setObject:data forKey:@"Narrative"];
    [self.groupedDataDict setObject:cellData forKey:sectionTitle];
}

-(void)prepareForCreateWeeklyRecord {
    self.fieldNameList = [NSMutableArray array];
    self.fieldValueList = [NSMutableArray array];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        int fieldNameIndex = i;
        NSString* sectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:sectionTitle];
        [self.fieldNameList addObject:[NSString stringWithFormat:@"Narrative%d",++fieldNameIndex]];
        [self.fieldValueList addObject:[cellData objectForKey:@"Narrative"]];
    }
}

-(void)processRawData:(NSMutableArray*)aDataList {
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
}

-(void)getChangedDataList {
    self.updatedFieldNameList = [NSMutableArray array];
    self.updatedFieldValueList = [NSMutableArray array];
//    NSLog(@"groupedDataDict %@", self.groupedDataDict);
//    NSLog(@"originalGroupedDataDict %@", self.originalGroupedDataDict);
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* sectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:sectionTitle];
        NSMutableDictionary* originalCellData = [self.originalGroupedDataDict objectForKey:sectionTitle];
        if (![[cellData objectForKey:@"Narrative"] isEqualToString:[originalCellData objectForKey:@"Narrative"]]) {
            [self.updatedFieldNameList addObject:[self.dbFieldNameList objectAtIndex:i]];
            [self.updatedFieldValueList addObject:[cellData objectForKey:@"Narrative"]];
        }
    }
}

-(BOOL)checkValidation {
    int blankFieldNum = 0;
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSMutableDictionary* cellData = [self.groupedDataDict objectForKey:[self.sectionTitleList objectAtIndex:i]];
        if ([[cellData objectForKey:@"Narrative"] isEqualToString:@""]) {
            blankFieldNum++;
        }        
    }
    return (blankFieldNum == [self.sectionTitleList count]) ? NO :YES;
}

-(void)reinitiateAttachmentAuxiObject {
    self.attachmentFileNameList = [NSMutableArray array];
    self.attachmentFileContentList = [NSMutableArray array];
}

@end
