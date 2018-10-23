//
//  CustomerContactDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDataManager.h"

@implementation CustomerContactDataManager
@synthesize displayList = _displayList;
//@synthesize tableCellData = _tableCellData;
@synthesize isNewRecord = _isNewRecord;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize updatedFieldNameList = _updatedFieldNameList;
@synthesize updatedFieldValueList = _updatedFieldValueList;
@synthesize dbFieldNameList = _dbFieldNameList;
@synthesize iur = _iur;
@synthesize seqFieldTypeList = _seqFieldTypeList;
@synthesize flagDisplayList = _flagDisplayList;
@synthesize originalFlagDisplayList = _originalFlagDisplayList;
@synthesize flagChangedDataList = _flagChangedDataList;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray arrayWithCapacity:7];
        self.originalDisplayList = [NSMutableArray arrayWithCapacity:7];
        for (int i = 0; i < 7; i++) {
            NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
            [cellData setObject:@"" forKey:@"contentString"];
            [cellData setObject:@"" forKey:@"actualContent"];
            NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
            [self.displayList addObject:cellData];
            [self.originalDisplayList addObject:originalCellData];
//            [cellData release];
        }        
        self.isNewRecord = YES;
        self.dbFieldNameList = [NSMutableArray arrayWithObjects:@"CLiur", @"Forename", @"Surname", @"PhoneNumber", @"MobileNumber", @"Email", @"COiur", nil];
        self.seqFieldTypeList = [NSMutableArray arrayWithObjects:@"Details", @"Flags", nil];
        self.flagDisplayList = [NSMutableArray array];
        self.originalFlagDisplayList = [NSMutableArray array];
        [self createFlagBasicData];
    }
    return self;
}

-(void)processRawData:(ArcosGenericClass*)aContactGenericClass flagData:(NSMutableArray*)anArrayOfData {
    [self processFlagRawData:anArrayOfData];
    if (aContactGenericClass == nil) {//from add sign button
        return;
    }
    NSLog(@"contact aContactGenericClass %@", aContactGenericClass);
    self.isNewRecord = NO;
    self.iur = [ArcosUtils convertStringToNumber:[aContactGenericClass Field1]];
    [self createDescrCellData:@"CLiur" descrType:@"CL" cellValue:[aContactGenericClass Field2] withIndex:0];
    [self createCellData:@"Forename" cellValue:[aContactGenericClass Field3] withIndex:1];
    [self createCellData:@"Surname" cellValue:[aContactGenericClass Field4] withIndex:2];
    [self createCellData:@"PhoneNumber" cellValue:[aContactGenericClass Field5] withIndex:3];
    [self createCellData:@"MobileNumber" cellValue:[aContactGenericClass Field6] withIndex:4];
    [self createCellData:@"Email" cellValue:[aContactGenericClass Field7] withIndex:5];
    [self createDescrCellData:@"COiur" descrType:@"CO" cellValue:[aContactGenericClass Field8] withIndex:6];        
}

-(void)createCellData:(NSString*)aKeyName cellValue:(NSString*)aCellValue withIndex:(int)anIndex {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndex];
    NSString* cellContentData = [ArcosUtils convertNilToEmpty:aCellValue];    
    [cellData setObject:cellContentData forKey:@"contentString"];
    [cellData setObject:cellContentData forKey:@"actualContent"];
    NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [self.originalDisplayList replaceObjectAtIndex:anIndex withObject:originalCellData];
    [self.displayList replaceObjectAtIndex:anIndex withObject:cellData];
    
}

-(void)createDescrCellData:(NSString*)aKeyName descrType:(NSString*)aDescrType cellValue:(NSString*)aCellValue withIndex:(int)anIndex { 
    NSNumber* cellNumberValue = [ArcosUtils convertStringToNumber:aCellValue];
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndex];
    NSMutableArray* dataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:aDescrType]; 
    NSLog(@"[aCellData objectForKey:aKeyName] %@", cellNumberValue);
    NSString* contentString = [self translateIUR:cellNumberValue dataList:dataList];
    [cellData setObject:contentString forKey:@"contentString"];
    [cellData setObject:cellNumberValue forKey:@"actualContent"];
    NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [self.originalDisplayList replaceObjectAtIndex:anIndex withObject:originalCellData];
    [self.displayList replaceObjectAtIndex:anIndex withObject:cellData];   
}

-(NSString*)translateIUR:(NSNumber*)anIUR dataList:(NSMutableArray*)aDataList {
    NSString* detail = @"";
    for (int i = 0; i < [aDataList count]; i++) {
        NSMutableDictionary* cellData = [aDataList objectAtIndex:i];                
        NSNumber* descrDetailIUR = [cellData objectForKey:@"DescrDetailIUR"];        
        if ([anIUR isEqualToNumber:descrDetailIUR]) {
            detail = [cellData objectForKey:@"Detail"];
            break;
        }
    }
    return detail;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.originalDisplayList != nil) { self.originalDisplayList = nil; }    
//    if (self.tableCellData != nil) { self.tableCellData = nil; }    
    if (self.updatedFieldNameList != nil) { self.updatedFieldNameList = nil; }
    if (self.updatedFieldValueList != nil) { self.updatedFieldValueList = nil; }
    if (self.dbFieldNameList != nil) { self.dbFieldNameList = nil; }
    if (self.iur != nil) { self.iur = nil; }
    if (self.seqFieldTypeList != nil) { self.seqFieldTypeList = nil; }
    if (self.flagDisplayList != nil) { self.flagDisplayList = nil; }
    if (self.originalFlagDisplayList != nil) { self.originalFlagDisplayList = nil; }
    if (self.flagChangedDataList != nil) { self.flagChangedDataList = nil; }
            
    [super dealloc];
}

-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContentString forKey:@"contentString"];
    [cellData setObject:anActualContent forKey:@"actualContent"];
    [self.displayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
}

-(void)getChangedDataList {
    self.updatedFieldNameList = [NSMutableArray array];
    self.updatedFieldValueList = [NSMutableArray array];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellData = [self.displayList objectAtIndex:i];
        NSMutableDictionary* originalCellData = [self.originalDisplayList objectAtIndex:i];
        if (![[cellData objectForKey:@"contentString"] isEqualToString:[originalCellData objectForKey:@"contentString"]]) {
            [self.updatedFieldNameList addObject:[self.dbFieldNameList objectAtIndex:i]];
            [self.updatedFieldValueList addObject:[cellData objectForKey:@"actualContent"]];
        }
    }
}

- (void)createFlagBasicData {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='CF'"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"Active",nil];
    
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    for(NSDictionary* aDict in objectsArray){
        NSMutableDictionary* newFlagDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [newFlagDict setObject:[NSNumber numberWithInt:0] forKey:@"ContactFlag"];
        [newFlagDict setObject:[NSNumber numberWithInt:0] forKey:@"LocationIUR"];
        [self.flagDisplayList addObject:newFlagDict];
        NSMutableDictionary* originalNewFlagDict = [NSMutableDictionary dictionaryWithDictionary:newFlagDict];
        [self.originalFlagDisplayList addObject:originalNewFlagDict];
    }
}

- (void)updateChangedData:(NSNumber*)aContactFlag indexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContactFlag forKey:@"ContactFlag"];
    [self.flagDisplayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
}

-(void)processFlagRawData:(NSMutableArray*)anArrayOfData {
//    NSLog(@"processFlagRawData anArrayOfData %d", [anArrayOfData count]);
    for (int i = 0; i < [anArrayOfData count]; i++) {
        ArcosGenericClass* arcosGenericClass = [anArrayOfData objectAtIndex:i];
        for (int j = 0; j < [self.flagDisplayList count]; j++) {
            NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:j];
            if ([[arcosGenericClass Field2] isEqualToString:[[cellData objectForKey:@"DescrDetailIUR"] stringValue]] ) {
                [cellData setObject:[NSNumber numberWithInt:1] forKey:@"ContactFlag"];
                [cellData setObject:[ArcosUtils convertStringToNumber:[arcosGenericClass Field4]] forKey:@"LocationIUR"];
                [self.flagDisplayList replaceObjectAtIndex:j withObject:cellData];
                break;
            }
        }
    }
    self.originalFlagDisplayList = [NSMutableArray array];
    for(NSMutableDictionary* aDict in self.flagDisplayList){
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [self.originalFlagDisplayList addObject:newDict];
    }
}

-(void)getFlagChangedDataList {
    self.flagChangedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.flagDisplayList count]; i++) {
        NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:i];
        NSMutableDictionary* originalCellData = [self.originalFlagDisplayList objectAtIndex:i];
        if ([[cellData objectForKey:@"ContactFlag"] intValue] != [[originalCellData objectForKey:@"ContactFlag"] intValue]) {
            //            [self.changedDataList addObject:cellData];
            ArcosCreateRecordObject* arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
            NSMutableArray* fieldNames = [NSMutableArray arrayWithObjects:@"LocationIUR", @"ContactIUR", @"DescrDetailIUR", @"CreateDelete", nil];
            NSMutableArray* fieldValues = [NSMutableArray arrayWithCapacity:4];
            [fieldValues addObject:[[NSNumber numberWithInt:0] stringValue]];
            [fieldValues addObject:[ArcosUtils convertNilToEmpty:[self.iur stringValue]]];
            [fieldValues addObject:[[cellData objectForKey:@"DescrDetailIUR"] stringValue]];            
            NSString* actionType = [[cellData objectForKey:@"ContactFlag"] intValue] == 0 ? @"D" : @"S";
            [fieldValues addObject: actionType];
            
            arcosCreateRecordObject.FieldNames = fieldNames;
            arcosCreateRecordObject.FieldValues = fieldValues;
            [self.flagChangedDataList addObject:arcosCreateRecordObject];
            [arcosCreateRecordObject release];            
        }
    }
}


@end
