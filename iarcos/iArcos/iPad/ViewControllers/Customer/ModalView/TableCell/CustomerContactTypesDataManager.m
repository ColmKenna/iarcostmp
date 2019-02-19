//
//  CustomerContactTypesDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactTypesDataManager.h"

@implementation CustomerContactTypesDataManager
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize fieldNameList = _fieldNameList;
@synthesize constantFieldTypeDict = _constantFieldTypeDict;
@synthesize displayList = _displayList;
@synthesize changedDataList = _changedDataList;
@synthesize seqFieldTypeList = _seqFieldTypeList;
@synthesize constantFieldTypeTranslateDict = _constantFieldTypeTranslateDict;
@synthesize orderedFieldTypeList = _orderedFieldTypeList;
@synthesize createdFieldNameList = _createdFieldNameList;
@synthesize createdFieldValueList = _createdFieldValueList;
@synthesize flagDisplayList = _flagDisplayList;
@synthesize originalFlagDisplayList = _originalFlagDisplayList;
@synthesize flagChangedDataList = _flagChangedDataList;
@synthesize checkFieldTypeConstantList = _checkFieldTypeConstantList;
@synthesize iur = _iur;
@synthesize isNewRecord = _isNewRecord;
@synthesize actionType = _actionType;
@synthesize specialIURFieldNameList = _specialIURFieldNameList;
@synthesize isTableViewEditable = _isTableViewEditable;
@synthesize customerContactActionBaseDataManager = _customerContactActionBaseDataManager;
@synthesize linksLocationList = _linksLocationList;
@synthesize flagsAlias = _flagsAlias;
@synthesize linksAlias = _linksAlias;
@synthesize linkLocationIUR = _linkLocationIUR;
@synthesize currentLinkIndexPathRow = _currentLinkIndexPathRow;
@synthesize accessTimesSectionTitle = _accessTimesSectionTitle;
@synthesize myCustDict = _myCustDict;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.flagsAlias = @"Flags";
        self.linksAlias = @"Links";
        self.accessTimesSectionTitle = @"Access Times";
        self.fieldNameList = [[[NSMutableArray alloc] init] autorelease];        
        self.groupedDataDict = [NSMutableDictionary dictionary];
        self.originalGroupedDataDict = [NSMutableDictionary dictionary];
        self.constantFieldTypeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"IUR",[NSNumber numberWithInt:1],@"System.String",[NSNumber numberWithInt:2],@"System.Boolean", nil];
        self.displayList = [[[NSMutableArray alloc] init] autorelease];
        self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
        self.seqFieldTypeList = [[[NSMutableArray alloc] init] autorelease];
        self.constantFieldTypeTranslateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Profiles",@"IUR",@"Details",@"System.String",@"Settings",@"System.Boolean",@"Flags",@"Flags",@"Links",@"Links",self.accessTimesSectionTitle,self.accessTimesSectionTitle, nil];
//        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String", @"IUR", @"System.Boolean", @"Flags", nil];
        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String", @"IUR", @"Flags", @"System.Boolean", nil];
        self.flagDisplayList = [NSMutableArray array];
        self.originalFlagDisplayList = [NSMutableArray array];
        self.checkFieldTypeConstantList = [NSMutableArray arrayWithObjects:@"System.String", @"IUR", nil];
        self.specialIURFieldNameList = [NSMutableArray arrayWithObjects:@"COiur", @"CLiur", nil];
        self.isTableViewEditable = NO;
        self.linksLocationList = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil;}    
    if (self.originalGroupedDataDict != nil) { self.originalGroupedDataDict = nil;}
    if (self.fieldNameList != nil) { self.fieldNameList = nil;}    
    if (self.constantFieldTypeDict != nil) { self.constantFieldTypeDict = nil;}
    if (self.displayList != nil) { self.displayList = nil;}
    if (self.changedDataList != nil) { self.changedDataList = nil;}
    if (self.seqFieldTypeList != nil) { self.seqFieldTypeList = nil;}    
    if (self.constantFieldTypeTranslateDict != nil) { self.constantFieldTypeTranslateDict = nil;}   
    if (self.orderedFieldTypeList != nil) { self.orderedFieldTypeList = nil;}    
    if (self.createdFieldNameList != nil) { self.createdFieldNameList = nil;}
    if (self.createdFieldValueList != nil) { self.createdFieldValueList = nil;}
    if (self.flagDisplayList != nil) { self.flagDisplayList = nil; }
    if (self.originalFlagDisplayList != nil) { self.originalFlagDisplayList = nil; }
    if (self.flagChangedDataList != nil) { self.flagChangedDataList = nil; }
    if (self.checkFieldTypeConstantList != nil) { self.checkFieldTypeConstantList = nil;}
    if (self.iur != nil) { self.iur = nil; }
    if (self.actionType != nil) { self.actionType = nil; }
    if (self.specialIURFieldNameList != nil) { self.specialIURFieldNameList = nil; }
    if (self.customerContactActionBaseDataManager != nil) { self.customerContactActionBaseDataManager = nil; }
    if (self.linksLocationList != nil ) { self.linksLocationList = nil; }    
    if (self.flagsAlias != nil ) { self.flagsAlias = nil; }    
    if (self.linksAlias != nil ) { self.linksAlias = nil; }    
    if (self.linkLocationIUR != nil ) { self.linkLocationIUR = nil; }
    self.accessTimesSectionTitle = nil;
    self.myCustDict = nil;
                
    [super dealloc];
}

-(void)processRawData:(ArcosGenericReturnObject*)aContactResult flagData:(NSMutableArray*)anArrayOfFlagData {    
    [self createFlagBasicData];
    [self processFlagRawData:anArrayOfFlagData];
    ArcosGenericClass* arcosGenericClass = [aContactResult.ArrayOfData objectAtIndex:0];
    ArcosGenericClass* fieldNames = aContactResult.FieldNames;
    NSDictionary* fieldNamesElementDict = [PropertyUtils classPropsFor:[fieldNames class]];
    NSArray* allKeys = [fieldNamesElementDict allKeys];
    int numRecords = 0;
    for (int i = 0; i < [allKeys count]; i++) {
        SEL selector = NSSelectorFromString([allKeys objectAtIndex:i]);
        id keyValue = [fieldNames performSelector:selector];
        if ([keyValue isKindOfClass:[NSString class]] && [fieldNames performSelector:selector] != nil) {
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
        NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:7];
        [dataDict setObject:[dataArray objectAtIndex:0] forKey:@"fieldDesc"];
        [dataDict setObject:[ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:1]]]] forKey:@"contentString"];
        [dataDict setObject:[dataArray objectAtIndex:2] forKey:@"fieldType"];
        [dataDict setObject:[ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:3]]]] forKey:@"actualContent"];
        [dataDict setObject:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:4]]] forKey:@"securityLevel"];
        [dataDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"originalIndex"];
        [dataDict setObject:[self.constantFieldTypeDict objectForKey:[dataArray objectAtIndex:2]] forKey:@"fieldTypeCode"];
        
        NSString* descrTypeCode = [fieldName substringToIndex:2];
        if ([descrTypeCode isEqualToString:@"CP"]) {
            descrTypeCode = [fieldName substringFromIndex:2];
        }

        [dataDict setObject:descrTypeCode forKey:@"descrTypeCode"];
        [dataDict setObject:fieldName forKey:@"fieldName"];
        
        [self.displayList addObject:dataDict];
        if (![self.seqFieldTypeList containsObject:[dataArray objectAtIndex:2]]) {
            [self.seqFieldTypeList addObject:[dataArray objectAtIndex:2]];
        }
        [dataDict release];
    }
//    NSLog(@"self.seqFieldTypeList: %@", self.seqFieldTypeList);
    //process the data to be used in table view    
    for (int i = 0; i < [self.seqFieldTypeList count]; i++) {
        NSMutableArray* tmpDataArray = [[NSMutableArray alloc] init];
        NSMutableArray* originalTmpDataArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.displayList count]; j++) {
            NSMutableDictionary* dataDict = [self.displayList objectAtIndex:j];
            NSMutableDictionary* originalDataDict =
            [[NSMutableDictionary alloc] initWithDictionary:dataDict];
            if ([[dataDict objectForKey:@"fieldType"] isEqualToString:[self.seqFieldTypeList objectAtIndex:i]]) {
                [tmpDataArray addObject:dataDict];
                [originalTmpDataArray addObject:originalDataDict];                    
            }
            [originalDataDict release];
        }
        [self.groupedDataDict setObject:tmpDataArray forKey:[self.seqFieldTypeList objectAtIndex:i]];
        [self.originalGroupedDataDict setObject:originalTmpDataArray forKey:[self.seqFieldTypeList objectAtIndex:i]];        
        [tmpDataArray release];
        [originalTmpDataArray release];
    }
    //process links data
//    self.linksLocationList = [self.customerContactActionBaseDataManager locationListWithContactIUR:self.iur];
    [self getLinkData];
//    NSLog(@"self.groupedDataDict: %@", self.groupedDataDict);
//    NSLog(@"self.flagDisplayList: %@", self.flagDisplayList);
}

-(void)createFlagBasicData {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='CF' and Active = 1"];
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

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContentString forKey:@"contentString"];
    [cellData setObject:anActualContent forKey:@"actualContent"];
    [tmpDisplayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
    [self.groupedDataDict setObject:tmpDisplayList forKey:fieldType];
}

- (void)updateChangedData:(NSNumber*)aContactFlag indexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContactFlag forKey:@"ContactFlag"];
    [self.flagDisplayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
//    NSLog(@"self.flagDisplayList %@", self.flagDisplayList);
}

/**
-(BOOL)checkAllowedBeforeSubmit {
    BOOL isAllowed = YES;
    NSMutableArray* stringDisplayList = [self.groupedDataDict objectForKey:@"System.String"];
    NSMutableArray* iurDisplayList = [self.groupedDataDict objectForKey:@"IUR"];
    return isAllowed;
}
*/

-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList {
    for (int i = 0; i < [aCellDictList count]; i++) {
        NSMutableDictionary* cellDict = [aCellDictList objectAtIndex:i];
        if ([[cellDict objectForKey:@"fieldName"] isEqualToString:aFieldName]) {
            NSString* contentString = [ArcosUtils trim:[cellDict objectForKey:@"contentString"]];
            return [ArcosValidator checkAllowedFieldValue:contentString];
        }
    }    
    return YES;
}

-(BOOL)checkAllowedIURField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList {
    for (int i = 0; i < [aCellDictList count]; i++) {
        NSMutableDictionary* cellDict = [aCellDictList objectAtIndex:i];
        if ([[cellDict objectForKey:@"fieldName"] isEqualToString:aFieldName]) {
            NSString* contentString = [ArcosUtils trim:[cellDict objectForKey:@"contentString"]];
            return [ArcosValidator checkAllowedFieldValueAndAssigned:contentString];
        }
    }    
    return YES;
}

-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList maxDigitNum:(int)aMaxDigitNum {
    for (int i = 0; i < [aCellDictList count]; i++) {
        NSMutableDictionary* cellDict = [aCellDictList objectAtIndex:i];
        if ([[cellDict objectForKey:@"fieldName"] isEqualToString:aFieldName]) {
            NSString* contentString = [ArcosUtils trim:[cellDict objectForKey:@"contentString"]];
            if (contentString.length > aMaxDigitNum) {                
                return NO;
            }
        }
    }    
    return YES;
}

-(void)getFlagChangedDataList {
    self.flagChangedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.flagDisplayList count]; i++) {
        NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:i];
        NSMutableDictionary* originalCellData = [self.originalFlagDisplayList objectAtIndex:i];
        if ([[cellData objectForKey:@"ContactFlag"] intValue] != [[originalCellData objectForKey:@"ContactFlag"] intValue]) {
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

-(NSMutableArray*)getChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.seqFieldTypeList count]; i++) {
        NSString* groupName = [self.seqFieldTypeList objectAtIndex:i];
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
//    NSLog(@"self.changedDataList %@",self.changedDataList);
    return self.changedDataList;
}

- (NSString*)fieldNameWithIndex:(int)anIndex {
    return [self.fieldNameList objectAtIndex:anIndex];
}

-(void)prepareToCreateNewContact:(NSMutableArray*)aChangedDataArray {
    self.createdFieldNameList = [NSMutableArray array];
    self.createdFieldValueList = [NSMutableArray array];
    
    NSMutableArray* specialIURDataDictList = [self processSpecialIURFieldNameList:aChangedDataArray];
    if ([specialIURDataDictList count] > 0) {
        [aChangedDataArray addObjectsFromArray:specialIURDataDictList];
    }
    NSMutableArray* specialBooleanDataDictList = [self processSpecialBooleanFieldNameList:aChangedDataArray];
    if ([specialBooleanDataDictList count] > 0) {
        [aChangedDataArray addObjectsFromArray:specialBooleanDataDictList];
    }
    
    
    for (int i = 0; i < [aChangedDataArray count]; i++) {
        NSMutableDictionary* cellData = [aChangedDataArray objectAtIndex:i];
        NSString* fieldName = [self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1];
        [self.createdFieldNameList addObject:fieldName];
        //New contact must be active.
        if ([fieldName isEqualToString:@"Active"]) {
            NSLog(@"Active is set to be 1.");
            [self.createdFieldValueList addObject:@"1"];
        } else {
            id fieldValue = [cellData objectForKey:@"actualContent"];
            NSLog(@"fieldname is %@", fieldName);
            NSString* classType = NSStringFromClass([fieldValue class]);
            NSLog(@"NSStringFromClass %@", classType);
            if ([fieldValue isKindOfClass:[NSNumber class]] || [classType isEqualToString:@"_PFCachedNumber"] || [classType isEqualToString:@"__NSCFNumber"]) {
                [self.createdFieldValueList addObject:[fieldValue stringValue]];
            } else {
                [self.createdFieldValueList addObject:fieldValue];
            }
        }                
    }
//    NSLog(@"self.createdFieldNameList: %@; self.createdFieldValueList: %@",self.createdFieldNameList, self.createdFieldValueList);
}

-(NSMutableArray*)processSpecialIURFieldNameList:(NSMutableArray*)aChangedDataArray {
    /*
     special case for COiur(Contact Type) CLiur(Contact Title)
     if there is a default value and it is not included in the aChangedDataArray, then use the default value
     */
    //check whether is in the aChangedDataArray
    
    NSMutableArray* specialIURDataDictList = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < [self.specialIURFieldNameList count]; i++) {
        NSString* specialIURFieldName = [self.specialIURFieldNameList objectAtIndex:i];
        BOOL isFound = NO;
        for (NSMutableDictionary* aChangedDataDict in aChangedDataArray) {
            if ([[aChangedDataDict objectForKey:@"fieldName"] isEqualToString:specialIURFieldName]) {
                isFound = YES;
                break;
            }
        }
        if (!isFound) {
            NSMutableArray* iurDictList = [self.originalGroupedDataDict objectForKey:@"IUR"];
            for (NSMutableDictionary* anIURDict in iurDictList) {
                if ([[anIURDict objectForKey:@"fieldName"] isEqualToString:specialIURFieldName]) {
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

-(NSMutableArray*)processSpecialBooleanFieldNameList:(NSMutableArray*)aChangedDataArray {
    NSMutableArray* specialBooleanDataDictList = [NSMutableArray arrayWithCapacity:1];
    NSString* specialBooleanFieldName = @"Active";
    BOOL isFound = NO;
    for (NSMutableDictionary* aChangedDataDict in aChangedDataArray) {
        if ([[aChangedDataDict objectForKey:@"fieldName"] isEqualToString:specialBooleanFieldName]) {            
            isFound = YES;
            break;
        }
    }
    if (!isFound) {
        NSMutableArray* booleanDictList = [self.originalGroupedDataDict objectForKey:@"System.Boolean"];
        for (NSMutableDictionary* aBooleanDict in booleanDictList) {
            if ([[aBooleanDict objectForKey:@"fieldName"] isEqualToString:specialBooleanFieldName]) {
                [specialBooleanDataDictList addObject:aBooleanDict];
                break;
            }
        }
    }
//    NSLog(@"specialBooleanDataDictList: %@",specialBooleanDataDictList);
    return specialBooleanDataDictList;
}

-(void)createCustomerContactActionDataManager:(NSString*)anActionType {
    if ([anActionType isEqualToString:@"edit"]) {
        self.customerContactActionBaseDataManager = [[[CustomerContactEditDataManager alloc] init] autorelease];
    } else {
        self.customerContactActionBaseDataManager = [[[CustomerContactCreateDataManager alloc] init] autorelease];
    }
}

-(void)getLinkData {
    self.linksLocationList = [self.customerContactActionBaseDataManager locLinkLocationListWithContactIUR:self.iur];
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [self.linksLocationList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];    
}

-(BOOL)isLocationExistent:(NSMutableDictionary*)aCustDict {
    NSNumber* locationIUR = [aCustDict objectForKey:@"LocationIUR"];
    BOOL existFlag = NO;
    for (int i = 0; i < [self.linksLocationList count]; i++) {
        NSNumber* tmpLocationIUR = [[self.linksLocationList objectAtIndex:i] objectForKey:@"LocationIUR"];
        if ([locationIUR isEqualToNumber:tmpLocationIUR]) {
            existFlag = YES;
            break;
        }
    }
    return existFlag;
}

- (NSString*)buildEmailMessageBody {
    NSMutableString* body = [NSMutableString string];
    if ([self.displayList count] == 0) return @"";
    [body appendString:@"<html><head><style>td {font-size: 15px;}</style></head><body leftmargin='0' rightmargin='0' topmargin='0' marginwidth='0' marginheight='0' width='100%' height='100%'><table width='100%'  border='1' cellpadding='2' cellspacing='0'>"];
    int flagSectionIndex = [self.customerContactActionBaseDataManager retrieveFlagSectionIndex];
    NSMutableArray* locationFieldNameList = [NSMutableArray arrayWithObjects:@"Name", @"Address1", @"Address2", @"Address3", @"Address4", nil];
    NSMutableArray* locationFieldValueList = [NSMutableArray arrayWithObjects:[ArcosUtils convertNilToEmpty:[self.myCustDict objectForKey:@"Name"]], [ArcosUtils convertNilToEmpty:[self.myCustDict objectForKey:@"Address1"]], [ArcosUtils convertNilToEmpty:[self.myCustDict objectForKey:@"Address2"]], [ArcosUtils convertNilToEmpty:[self.myCustDict objectForKey:@"Address3"]], [ArcosUtils convertNilToEmpty:[self.myCustDict objectForKey:@"Address4"]], nil];
    [body appendString:@"<tr><th width='100%' height='44' colspan='3' align='center' bgcolor='#d3d3d3'>"];
    [body appendString:@"Location Details"];
    [body appendString:@"</th></tr>"];
    for (int i = 0; i < [locationFieldNameList count]; i++) {
        [body appendString:@"<tr><td width='30%' height='44'><b>"];
        [body appendString:[locationFieldNameList objectAtIndex:i]];
        [body appendString:@"</b></td><td width='40%' height='44'>"];
        [body appendString:[locationFieldValueList objectAtIndex:i]];
        [body appendString:@"</td><td width='30%' height='44'>"];
        [body appendString:@""];
        [body appendString:@"</td></tr>"];
    }
    
    for (int i = 0; i <= flagSectionIndex; i++) {
        NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:i];
        if ([fieldType isEqualToString:self.accessTimesSectionTitle]) continue;
        NSString* sectionTitle = [self.constantFieldTypeTranslateDict objectForKey:fieldType];
        [body appendString:@"<tr><th width='100%' height='44' colspan='3' align='center' bgcolor='#d3d3d3'>"];
        [body appendString:sectionTitle];
        [body appendString:@"</th></tr>"];
        
        if ([fieldType isEqualToString:self.flagsAlias]) {
            for (int j = 0; j < [self.flagDisplayList count]; j++) {
                NSMutableDictionary* cellData = [self.flagDisplayList objectAtIndex:j];
                [body appendString:@"<tr><td width='30%' height='44'><b>"];
                [body appendString:[cellData objectForKey:@"Detail"]];
                [body appendString:@"</b></td><td width='40%' height='44'>"];
                if ([[cellData objectForKey:@"ContactFlag"] intValue] == 0) {
                    [body appendString:@""];
                } else {
                    [body appendString:@"YES"];
                }
                [body appendString:@"</td><td width='30%' height='44'>"];
                [body appendString:@""];
                [body appendString:@"</td></tr>"];
            }
        } else {
            NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
            for (int j = 0; j < [tmpDisplayList count]; j++) {
                NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:j];
                [body appendString:@"<tr><td width='30%' height='44'><b>"];
                [body appendString:[cellData objectForKey:@"fieldDesc"]];
                [body appendString:@"</b></td><td width='40%' height='44'>"];
                [body appendString:[cellData objectForKey:@"contentString"]];
                [body appendString:@"</td><td width='30%' height='44'>"];
                [body appendString:@""];
                [body appendString:@"</td></tr>"];
            }
        }
    }
    [body appendString:@"</table></body></html>"];
    return body;
}

@end
