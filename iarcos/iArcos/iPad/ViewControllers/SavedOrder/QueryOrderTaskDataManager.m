//
//  QueryOrderTaskDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 27/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskDataManager.h"

@implementation QueryOrderTaskDataManager
@synthesize fieldNameList = _fieldNameList;
@synthesize displayList = _displayList;
@synthesize constantFieldTypeDict = _constantFieldTypeDict;
@synthesize seqFieldTypeList = _seqFieldTypeList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize constantFieldTypeTranslateDict = _constantFieldTypeTranslateDict;
@synthesize ruleoutFieldNameDict = _ruleoutFieldNameDict;
@synthesize activeSeqFieldTypeList = _activeSeqFieldTypeList;
@synthesize changedDataList = _changedDataList;
@synthesize createdFieldNameList = _createdFieldNameList;
@synthesize createdFieldValueList = _createdFieldValueList;
@synthesize arcosCreateRecordObject = _arcosCreateRecordObject;
@synthesize changedFieldName = _changedFieldName;
@synthesize changedActualContent = _changedActualContent;
@synthesize rowPointer = _rowPointer;
@synthesize issueClosedField = _issueClosedField;
@synthesize issueClosedActualValue = _issueClosedActualValue;
@synthesize isIssueClosedChanged = _isIssueClosedChanged;
@synthesize completionDateString = _completionDateString;
@synthesize defaultCompletionDateString = _defaultCompletionDateString;
@synthesize createMemoDetails = _createMemoDetails;
@synthesize contactIUR = _contactIUR;
@synthesize memoDisplayList = _memoDisplayList;
@synthesize isMemoDetailShowed = _isMemoDetailShowed;
@synthesize heightList = _heightList;
@synthesize specialIURFieldNameList = _specialIURFieldNameList;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.constantFieldTypeDict = [NSMutableDictionary dictionaryWithCapacity:6];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:1] forKey:@"System.String"];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:2] forKey:@"System.Boolean"];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:3] forKey:@"System.DateTime"];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:4] forKey:@"System.Byte"];
        [self.constantFieldTypeDict setObject:[NSNumber numberWithInt:5] forKey:@"System.Int16"];
        self.fieldNameList = [[[NSMutableArray alloc] init] autorelease];
        self.displayList = [[[NSMutableArray alloc] init] autorelease];
        self.seqFieldTypeList = [[[NSMutableArray alloc] init] autorelease];
        self.activeSeqFieldTypeList = [[[NSMutableArray alloc] init] autorelease];
        self.groupedDataDict = [NSMutableDictionary dictionary];
        self.originalGroupedDataDict = [NSMutableDictionary dictionary];
        self.constantFieldTypeTranslateDict = [NSMutableDictionary dictionaryWithCapacity:6];
        [self.constantFieldTypeTranslateDict setObject:@"Profiles" forKey:@"IUR"];
        [self.constantFieldTypeTranslateDict setObject:@"Details" forKey:@"System.String"];
        [self.constantFieldTypeTranslateDict setObject:@"Settings" forKey:@"System.Boolean"];
        [self.constantFieldTypeTranslateDict setObject:@"System.DateTime" forKey:@"System.DateTime"];
        [self.constantFieldTypeTranslateDict setObject:@"System.Byte" forKey:@"System.Byte"];
        [self.constantFieldTypeTranslateDict setObject:@"System.Int16" forKey:@"System.Int16"];
        [self.constantFieldTypeTranslateDict setObject:@"Memos" forKey:@"Memos"];
        self.ruleoutFieldNameDict = [NSMutableDictionary dictionary];
        [self.ruleoutFieldNameDict setObject:@"LocationIUR" forKey:@"LocationIUR"];
        [self.ruleoutFieldNameDict setObject:@"EmployeeIUR" forKey:@"EmployeeIUR"];
        [self.ruleoutFieldNameDict setObject:@"StartDate" forKey:@"StartDate"];
        [self.ruleoutFieldNameDict setObject:@"EndDate" forKey:@"EndDate"];
        [self.ruleoutFieldNameDict setObject:@"CompletionDate" forKey:@"CompletionDate"];
        [self.ruleoutFieldNameDict setObject:@"MemoIUR" forKey:@"MemoIUR"];
        [self.ruleoutFieldNameDict setObject:@"Priority" forKey:@"Priority"];
        [self.ruleoutFieldNameDict setObject:@"CallIUR" forKey:@"CallIUR"];
        [self.ruleoutFieldNameDict setObject:@"EmailAlert" forKey:@"EmailAlert"];
        [self.ruleoutFieldNameDict setObject:@"TextAlert" forKey:@"TextAlert"];
        [self.ruleoutFieldNameDict setObject:@"PassedToEmployeeIUR" forKey:@"PassedToEmployeeIUR"];
        self.rowPointer = 0;
        self.issueClosedField = @"Issue Closed";
        self.defaultCompletionDateString = @"01/01/1990";
        self.specialIURFieldNameList = [NSMutableArray arrayWithObjects:@"TYiur", @"TSiur", @"QSiur", @"QTiur", nil];
    }
    return self;
}

- (void)dealloc {
    self.fieldNameList = nil;
    self.displayList = nil;
    self.constantFieldTypeDict = nil;
    self.seqFieldTypeList = nil;
    self.groupedDataDict = nil;
    self.originalGroupedDataDict = nil;
    self.constantFieldTypeTranslateDict = nil;
    self.ruleoutFieldNameDict = nil;
    self.activeSeqFieldTypeList = nil;
    self.changedDataList = nil;
    self.createdFieldNameList = nil;
    self.createdFieldValueList = nil;
    self.arcosCreateRecordObject = nil;
    self.changedFieldName = nil;
    self.changedActualContent = nil;
    self.issueClosedField = nil;
    self.completionDateString = nil;
    self.defaultCompletionDateString = nil;
    self.createMemoDetails = nil;
    self.contactIUR = nil;
    self.memoDisplayList = nil;
    self.heightList = nil;
    self.specialIURFieldNameList = nil;
    
    [super dealloc];
}

-(void)processRawData:(ArcosGenericReturnObject*)result actionType:(NSString*)anActionType {
    ArcosGenericClass* arcosGenericClass = [result.ArrayOfData objectAtIndex:0];
    ArcosGenericClass* fieldNames = result.FieldNames;
    NSDictionary* fieldNamesElementDict = [PropertyUtils classPropsFor:[fieldNames class]];
//    NSLog(@"fieldNamesElementDict: %@", fieldNamesElementDict);
    NSArray* allKeys = [fieldNamesElementDict allKeys];
    int numRecords = 0;
    for (int i = 0; i < [allKeys count]; i++) {
        SEL selector = NSSelectorFromString([allKeys objectAtIndex:i]);
        id keyValue = [fieldNames performSelector:selector];
        if ([keyValue isKindOfClass:[NSString class]] && keyValue != nil) {
            numRecords++;
        }
    }
    for (int i = 1; i <= numRecords; i++) {
        NSString* methodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(methodName);
        
        //for FieldNames
        NSString* fieldName = [fieldNames performSelector:selector];
        [self.fieldNameList addObject:fieldName];
        
        NSString* dataStr = [arcosGenericClass performSelector:selector];
        NSArray* dataArray = [dataStr componentsSeparatedByString:@"|"];
        NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:8];
        [dataDict setObject:[dataArray objectAtIndex:0] forKey:@"fieldDesc"];
        [dataDict setObject:[[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:1]]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"contentString"];
        [dataDict setObject:[dataArray objectAtIndex:2] forKey:@"fieldType"];
        [dataDict setObject:[ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:3]]]] forKey:@"actualContent"];
        [dataDict setObject:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:4]]] forKey:@"securityLevel"];
        [dataDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"originalIndex"];
        [dataDict setObject:[self.constantFieldTypeDict objectForKey:[dataArray objectAtIndex:2]] forKey:@"fieldTypeCode"];
        
        NSString* descrTypeCode = [fieldName substringToIndex:2];
        [dataDict setObject:descrTypeCode forKey:@"descrTypeCode"];
        [dataDict setObject:fieldName forKey:@"fieldName"];
        if ([fieldName isEqualToString:@"CompletionDate"]) {
            self.completionDateString = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:3]]];
        }
        
        [self.displayList addObject:dataDict];
        if (![self.seqFieldTypeList containsObject:[dataArray objectAtIndex:2]]) {
            [self.seqFieldTypeList addObject:[dataArray objectAtIndex:2]];
        }
        [dataDict release];
    }
    
    for (int i = 0; i < [self.seqFieldTypeList count]; i++) {
        NSMutableArray* tmpDataArray = [[NSMutableArray alloc] init];
        NSMutableArray* originalTmpDataArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.displayList count]; j++) {
            NSString* fieldName = [self.fieldNameList objectAtIndex:j];
            if ([self.ruleoutFieldNameDict objectForKey:fieldName] != nil) continue;
            NSMutableDictionary* dataDict = [self.displayList objectAtIndex:j];
            if ([[dataDict objectForKey:@"fieldType"] isEqualToString:[self.seqFieldTypeList objectAtIndex:i]]) {
                [tmpDataArray addObject:dataDict];
                NSMutableDictionary* originalDataDict =
                [[NSMutableDictionary alloc] initWithDictionary:dataDict];
                [originalTmpDataArray addObject:originalDataDict];
                [originalDataDict release];
            }
        }
        [self.groupedDataDict setObject:tmpDataArray forKey:[self.seqFieldTypeList objectAtIndex:i]];
        [self.originalGroupedDataDict setObject:originalTmpDataArray forKey:[self.seqFieldTypeList objectAtIndex:i]];
        [tmpDataArray release];
        [originalTmpDataArray release];
    }
    
    if (![anActionType isEqualToString:@"create"]) {
        NSString* fieldType = @"System.Boolean";
        [self.fieldNameList addObject:self.issueClosedField];
        NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:8];
        [dataDict setObject:self.issueClosedField forKey:@"fieldDesc"];
        
        [dataDict setObject:fieldType forKey:@"fieldType"];
        if ([self.completionDateString isEqualToString:self.defaultCompletionDateString]) {
            [dataDict setObject:@"0" forKey:@"contentString"];
            [dataDict setObject:@"0" forKey:@"actualContent"];
        } else {
            [dataDict setObject:@"1" forKey:@"contentString"];
            [dataDict setObject:@"1" forKey:@"actualContent"];
        }
        [dataDict setObject:@"0" forKey:@"securityLevel"];
        [dataDict setObject:[NSString stringWithFormat:@"%u",[ArcosUtils convertNSUIntegerToUnsignedInt:self.fieldNameList.count]] forKey:@"originalIndex"];
        [dataDict setObject:[self.constantFieldTypeDict objectForKey:fieldType]
                     forKey:@"fieldTypeCode"];
        
        NSString* descrTypeCode = [self.issueClosedField substringToIndex:2];
        [dataDict setObject:descrTypeCode forKey:@"descrTypeCode"];
        NSMutableDictionary* originalDataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
        NSMutableArray* tmpDataList = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray* tmpOriginalDataList = [NSMutableArray arrayWithCapacity:1];
        [tmpDataList addObject:dataDict];
        [tmpOriginalDataList addObject:originalDataDict];
        [self.groupedDataDict setObject:tmpDataList forKey:fieldType];
        [self.originalGroupedDataDict setObject:tmpOriginalDataList forKey:fieldType];
        [dataDict release];
    }
    
    for (int i = 0; i < [self.seqFieldTypeList count]; i++) {
        NSString* fieldType = [self.seqFieldTypeList objectAtIndex:i];
        NSMutableArray* dataList = [self.groupedDataDict objectForKey:fieldType];
        if ([dataList count] > 0) {
            [self.activeSeqFieldTypeList addObject:fieldType];
        }
    }
    
    //memos
    if (![anActionType isEqualToString:@"create"]) {
        [self.activeSeqFieldTypeList addObject:@"Memos"];
    }
    
    if ([anActionType isEqualToString:@"create"]) {
        [self processContactIURFromHomePage];
    }
}

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.activeSeqFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.activeSeqFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContentString forKey:@"contentString"];
    [cellData setObject:anActualContent forKey:@"actualContent"];
//    NSLog(@"groupedDataDict:%@",self.groupedDataDict);
//    NSLog(@"originalGroupedDataDict:%@",self.originalGroupedDataDict);
}

-(NSMutableArray*)getChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.activeSeqFieldTypeList count]; i++) {
        NSString* groupName = [self.activeSeqFieldTypeList objectAtIndex:i];
        NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:groupName];
        NSMutableArray* originalTmpDisplayList = [self.originalGroupedDataDict objectForKey:groupName];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            NSMutableDictionary* dataCell = [tmpDisplayList objectAtIndex:j];
            NSMutableDictionary* originalDataCell = [originalTmpDisplayList objectAtIndex:j];
            if (![[ArcosUtils convertToString:[dataCell objectForKey:@"actualContent"]] isEqualToString:[ArcosUtils convertToString:[originalDataCell objectForKey:@"actualContent"]]]) {
                [self.changedDataList addObject:dataCell];
            }
        }
    }
//    NSLog(@"%@",self.changedDataList);
    return self.changedDataList;
}

-(void)prepareToCreateRecord {
    BOOL isFirstTimeToFixTrue = NO;
    self.arcosCreateRecordObject = [[[ArcosCreateRecordObject alloc] init] autorelease];
    self.createdFieldNameList = [NSMutableArray array];
    self.createdFieldValueList = [NSMutableArray array];
    NSMutableArray* specialIURDataDictList = [self processSpecialIURFieldNameList:self.changedDataList];
    if ([specialIURDataDictList count] > 0) {
        [self.changedDataList addObjectsFromArray:specialIURDataDictList];
    }
    
    for (int i = 0; i < [self.changedDataList count]; i++) {
        NSMutableDictionary* cellData = [self.changedDataList objectAtIndex:i];
        NSString* fieldName = [self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1];
        [self.createdFieldNameList addObject:fieldName];
        id fieldValue = [cellData objectForKey:@"actualContent"];
        NSString* classType = NSStringFromClass([fieldValue class]);
        if ([fieldValue isKindOfClass:[NSNumber class]] || [classType isEqualToString:@"_PFCachedNumber"] || [classType isEqualToString:@"__NSCFNumber"]) {
            [self.createdFieldValueList addObject:[fieldValue stringValue]];
        } else {
            [self.createdFieldValueList addObject:fieldValue];
        }
        if ([fieldName isEqualToString:@"FirstTimeToFix"]) {
            isFirstTimeToFixTrue = YES;
        }
    }
    if (isFirstTimeToFixTrue) {
        [self.createdFieldNameList addObject:@"CompletionDate"];
        [self.createdFieldValueList addObject:[ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy:HH:mm"]];
    } else {
        [self.createdFieldNameList addObject:@"CompletionDate"];
        [self.createdFieldValueList addObject:@"01/01/1990"];
    }
//    NSLog(@"createdFieldNameList %@", self.createdFieldNameList);
//    NSLog(@"createdFieldValueList %@", self.createdFieldValueList);
    self.arcosCreateRecordObject.FieldNames = self.createdFieldNameList;
    self.arcosCreateRecordObject.FieldValues = self.createdFieldValueList;
}

-(NSString*)fieldNameWithIndex:(int)anIndex {
    return [self.fieldNameList objectAtIndex:anIndex];
}

-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:theIndexpath];
    return [self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1];
}

-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList {
    for (int i = 0; i < [aCellDictList count]; i++) {
        NSMutableDictionary* cellDict = [aCellDictList objectAtIndex:i];
        if ([[self fieldNameWithIndex:[[cellDict objectForKey:@"originalIndex"] intValue] - 1] isEqualToString:aFieldName]) {
            NSString* contentString = [ArcosUtils trim:[cellDict objectForKey:@"contentString"]];
            return [ArcosValidator checkAllowedFieldValue:contentString];
        }
    }
    return YES;
}

-(NSString*)getActualValueWithFieldName:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList {
    NSString* actualContent = @"";
    for (int i = 0; i < [aCellDictList count]; i++) {
        NSMutableDictionary* cellDict = [aCellDictList objectAtIndex:i];
        if ([[self fieldNameWithIndex:[[cellDict objectForKey:@"originalIndex"] intValue] - 1] isEqualToString:aFieldName]) {
//            NSLog(@"found: %@ ", cellDict);
            return [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[cellDict objectForKey:@"actualContent"]]]];
        }
    }
    return actualContent;
}

-(void)processContactIURFromHomePage {
    if (self.contactIUR.intValue == 0) return;
    NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:self.contactIUR];
    if (tmpContactDict == nil) return;
    NSString* fullName = [tmpContactDict objectForKey:@"Title"];
//    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:self.contactIUR];
//    if ([contactList count] == 0) return;
//    NSDictionary* contactDict = [contactList objectAtIndex:0];
//    NSString* fullname = [ArcosUtils contactFullName:contactDict];
    NSMutableArray* dataList = [self.groupedDataDict objectForKey:@"IUR"];
    for (int i = 0; i < [dataList count]; i++) {
        NSMutableDictionary* cellData = [dataList objectAtIndex:i];
        NSString* fieldName = [self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1];
        if ([fieldName hasPrefix:@"Contact"]) {
            [cellData setObject:fullName forKey:@"contentString"];
            [cellData setObject:self.contactIUR forKey:@"actualContent"];
            break;
        }
    }
}

-(NSMutableArray*)processSpecialIURFieldNameList:(NSMutableArray*)aChangedDataArray {
    /*
     special case for TYiur(Task Type) TSiur(Task status) QSiur(Query Status) QTiur(Query Type)
     if there is a default value and it is not included in the aChangedDataArray, then use the default value
     */
    //check whether is in the aChangedDataArray
    
    NSMutableArray* specialIURDataDictList = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < [self.specialIURFieldNameList count]; i++) {
        NSString* specialIURFieldName = [self.specialIURFieldNameList objectAtIndex:i];
        BOOL isFound = NO;
        
        for (NSMutableDictionary* aChangedDataDict in aChangedDataArray) {
            NSString* fieldName = [self fieldNameWithIndex:[[aChangedDataDict objectForKey:@"originalIndex"] intValue] - 1];
            if ([fieldName isEqualToString:specialIURFieldName]) {
                isFound = YES;
                break;
            }
        }
        if (!isFound) {
            NSMutableArray* iurDictList = [self.originalGroupedDataDict objectForKey:@"IUR"];
            for (NSMutableDictionary* anIURDict in iurDictList) {
                NSString* fieldName = [self fieldNameWithIndex:[[anIURDict objectForKey:@"originalIndex"] intValue] - 1];
                if ([fieldName isEqualToString:specialIURFieldName]) {
                    NSMutableDictionary* newIURDict = [NSMutableDictionary dictionaryWithDictionary:anIURDict];
                    if ([[ArcosUtils convertNilToEmpty:[anIURDict objectForKey:@"actualContent"]] isEqualToString:@""]) {
                        [newIURDict setObject:[NSNumber numberWithInt:0] forKey:@"actualContent"];
                    }
                    [specialIURDataDictList addObject:newIURDict];
                    break;
                }
            }
        }
    }
    //    NSLog(@"specialIURDataDictList: %@", specialIURDataDictList);
    return specialIURDataDictList;
}

@end
