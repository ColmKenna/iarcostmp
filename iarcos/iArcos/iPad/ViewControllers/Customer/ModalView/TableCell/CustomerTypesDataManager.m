//
//  CustomerTypesDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 11/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerTypesDataManager.h"
@interface CustomerTypesDataManager (Private)

@end


@implementation CustomerTypesDataManager
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize fieldNameList = _fieldNameList;
@synthesize constantFieldTypeDict = _constantFieldTypeDict;
@synthesize displayList = _displayList;
@synthesize auxFieldTypeDict = _auxFieldTypeDict;
@synthesize auxFieldTypeList = _auxFieldTypeList;
@synthesize changedDataList = _changedDataList;
@synthesize seqFieldTypeList = _seqFieldTypeList;
@synthesize constantFieldTypeTranslateDict = _constantFieldTypeTranslateDict;
@synthesize createdFieldNameList = _createdFieldNameList;
@synthesize createdFieldValueList = _createdFieldValueList;
@synthesize orderedFieldTypeList = _orderedFieldTypeList;
@synthesize customerDetailsActionBaseDataManager = _customerDetailsActionBaseDataManager;
@synthesize linksAlias = _linksAlias;
@synthesize linksLocationList = _linksLocationList;
@synthesize locationIUR = _locationIUR;
@synthesize fromLocationIUR = _fromLocationIUR;
@synthesize isTableViewEditable = _isTableViewEditable;
@synthesize currentLinkIndexPathRow = _currentLinkIndexPathRow;
@synthesize accessTimesSectionTitle = _accessTimesSectionTitle;
@synthesize myCustDict = _myCustDict;
@synthesize employeeIUR = _employeeIUR;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.linksAlias = @"Buying Group";
        self.accessTimesSectionTitle = @"Access Times";
        self.linksLocationList = [NSMutableArray array];
        self.fieldNameList = [[[NSMutableArray alloc] init] autorelease];        
        self.groupedDataDict = [NSMutableDictionary dictionary];
        self.originalGroupedDataDict = [NSMutableDictionary dictionary];
        self.constantFieldTypeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"IUR",[NSNumber numberWithInt:1],@"System.String",[NSNumber numberWithInt:2],@"System.Boolean", nil];
        self.displayList = [[[NSMutableArray alloc] init] autorelease];
        self.auxFieldTypeDict = [NSMutableDictionary dictionary];
        self.auxFieldTypeList = [NSArray array];
        self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
        self.seqFieldTypeList = [[[NSMutableArray alloc] init] autorelease];
        self.constantFieldTypeTranslateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Profiles",@"IUR",@"Details",@"System.String",@"Settings",@"System.Boolean",self.linksAlias,self.linksAlias,self.accessTimesSectionTitle,self.accessTimesSectionTitle, nil];
        self.isTableViewEditable = NO;
        self.employeeIUR = [SettingManager employeeIUR];
    }
    return self;
}

-(void)dealloc{    
    if (self.fieldNameList != nil) { self.fieldNameList = nil;}
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil;}    
    if (self.originalGroupedDataDict != nil) { self.originalGroupedDataDict = nil;}    
    if (self.constantFieldTypeDict != nil) { self.constantFieldTypeDict = nil;}
    if (self.displayList != nil) { self.displayList = nil;}
    if (self.auxFieldTypeDict != nil) { self.auxFieldTypeDict = nil;}
    if (self.auxFieldTypeList != nil) { self.auxFieldTypeList = nil;}    
    if (self.changedDataList != nil) { self.changedDataList = nil;}
    if (self.seqFieldTypeList != nil) { self.seqFieldTypeList = nil;}    
    if (self.constantFieldTypeTranslateDict != nil) { self.constantFieldTypeTranslateDict = nil;}    
    if (self.createdFieldNameList != nil) { self.createdFieldNameList = nil;}
    if (self.createdFieldValueList != nil) { self.createdFieldValueList = nil;}
    self.orderedFieldTypeList = nil;
    self.customerDetailsActionBaseDataManager = nil;
    self.linksAlias = nil;
    self.linksLocationList = nil;
    self.locationIUR = nil;
    self.fromLocationIUR = nil;
    self.accessTimesSectionTitle = nil;
    self.myCustDict = nil;
    self.employeeIUR = nil;
    
    [super dealloc];
}

- (void)processRawData:(ArcosGenericReturnObject*) result withNumOfFields:(int)numFields {
    ArcosGenericClass* arcosGenericClass = [result.ArrayOfData objectAtIndex:0];
    ArcosGenericClass* fieldNames = result.FieldNames;
    NSDictionary* fieldNamesElementDict = [PropertyUtils classPropsFor:[fieldNames class]];
//    NSLog(@"fieldNamesElementDict: %@", fieldNamesElementDict);
//    NSLog(@"fieldNamesElementDict keys: %d", [[fieldNamesElementDict allKeys] count] - 1);
    NSArray* allKeys = [fieldNamesElementDict allKeys];
    int numRecords = 0;
    for (int i = 0; i < [allKeys count]; i++) {
        SEL selector = NSSelectorFromString([allKeys objectAtIndex:i]);
//        NSLog(@"value of element %@ is: %@", [allKeys objectAtIndex:i], [arcosGenericClass performSelector:selector]);
        id keyValue = [fieldNames performSelector:selector];
        if ([keyValue isKindOfClass:[NSString class]] && [fieldNames performSelector:selector] != nil) {
            numRecords++;
        }
    }
//    NSLog(@"numRecords are %d", numRecords);
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
        [dataDict setObject:[[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:1]]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"contentString"];     
        [dataDict setObject:[dataArray objectAtIndex:2] forKey:@"fieldType"];
        [dataDict setObject:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:3]]] forKey:@"actualContent"];
        [dataDict setObject:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:4]]] forKey:@"securityLevel"];
        [dataDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"originalIndex"];
        [dataDict setObject:[self.constantFieldTypeDict objectForKey:[dataArray objectAtIndex:2]] forKey:@"fieldTypeCode"];
        
        //
        NSString* descrTypeCode = [fieldName substringToIndex:2];
        if ([descrTypeCode isEqualToString:@"LP"]) {
            descrTypeCode = [NSString stringWithFormat:@"%d", [[fieldName substringFromIndex:2] intValue] + 20];
        }
//        NSLog(@"in cell descrTypeCode is %@", descrTypeCode);
        [dataDict setObject:descrTypeCode forKey:@"descrTypeCode"];
        
        [self.displayList addObject:dataDict];
        [self.auxFieldTypeDict setObject:[dataArray objectAtIndex:2] forKey:[dataArray objectAtIndex:2]];
        if (![self.seqFieldTypeList containsObject:[dataArray objectAtIndex:2]]) {
            [self.seqFieldTypeList addObject:[dataArray objectAtIndex:2]];
        }
        [dataDict release];
    }
//    NSLog(@"self.seqFieldTypeList: %@", self.seqFieldTypeList);
    //process the data to be used in table view
    self.auxFieldTypeList = [self.auxFieldTypeDict allKeys];
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
    [self getLinkData];
}

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:fieldType];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
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
//    NSLog(@"%@",self.changedDataList);
    return self.changedDataList;
}

-(NSString*)fieldNameWithIndex:(int)anIndex {
    return [self.fieldNameList objectAtIndex:anIndex];
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

-(void)prepareToCreateNewLocation:(NSMutableArray*)aChangedDataArray {
    self.createdFieldNameList = [NSMutableArray array];
    self.createdFieldValueList = [NSMutableArray array];
    for (int i = 0; i < [aChangedDataArray count]; i++) {
        NSMutableDictionary* cellData = [aChangedDataArray objectAtIndex:i];
        [self.createdFieldNameList addObject:[self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1]];
        id fieldValue = [cellData objectForKey:@"actualContent"];
        NSLog(@"fieldname is %@", [self fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1]);
        NSString* classType = NSStringFromClass([fieldValue class]);
        NSLog(@"NSStringFromClass %@", classType);
        if ([fieldValue isKindOfClass:[NSNumber class]] || [classType isEqualToString:@"_PFCachedNumber"] || [classType isEqualToString:@"__NSCFNumber"]) {
            [self.createdFieldValueList addObject:[fieldValue stringValue]];
        } else {
            [self.createdFieldValueList addObject:fieldValue];
        }        
    }
//    NSLog(@"createdFieldNameList %@", self.createdFieldNameList);
//    NSLog(@"createdFieldValueList %@", self.createdFieldValueList);
}

-(void)createCustomerDetailsActionDataManager:(NSString*)anActionType {
    if ([anActionType isEqualToString:@"create"]) {//create a new location
        self.customerDetailsActionBaseDataManager = [[[CustomerDetailsCreateDataManager alloc] init] autorelease];
    } else {// update an existed record
        self.customerDetailsActionBaseDataManager = [[[CustomerDetailsEditDataManager alloc] init] autorelease];
    }
}

-(void)getLinkData {
    self.linksLocationList = [self.customerDetailsActionBaseDataManager buyingGroupLocationListWithLocationIUR:self.locationIUR];
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [self.linksLocationList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
}

-(void)addLocLocLinkWithIUR:(NSNumber*)anIUR locationIUR:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR {
    NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
    LocLocLink* tmpLocLocLink = [NSEntityDescription insertNewObjectForEntityForName:@"LocLocLink" inManagedObjectContext:context];
    tmpLocLocLink.IUR = anIUR;
    tmpLocLocLink.LocationIUR = aLocationIUR;
    tmpLocLocLink.FromLocationIUR = aFromLocationIUR;
    tmpLocLocLink.LinkType = [NSNumber numberWithInt:9];
    [[ArcosCoreData sharedArcosCoreData] saveContext:context];
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

-(BOOL)deleteLocLocLinkWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d",[anIUR intValue]];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0 && objectsArray != nil) {
        LocLocLink* aLocLocLink = [objectsArray objectAtIndex:0];
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:aLocLocLink];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        return YES;
    }else{
        return NO;
    }
}

- (NSString*)buildEmailMessageBody {
    NSMutableString* body = [NSMutableString string];
    if ([self.displayList count] == 0) return @"";
    [body appendString:@"<html><head><style>td {font-size: 15px;}</style></head><body leftmargin='0' rightmargin='0' topmargin='0' marginwidth='0' marginheight='0' width='100%' height='100%'><table width='100%'  border='1' cellpadding='2' cellspacing='0'>"];
    int iurIndex = [self.customerDetailsActionBaseDataManager retrieveIURSectionIndex];
    for (int i = 0; i <= iurIndex; i++) {
        NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:i];
        if ([fieldType isEqualToString:self.accessTimesSectionTitle]) continue;
        NSString* sectionTitle = [self.constantFieldTypeTranslateDict objectForKey:fieldType];
        [body appendString:@"<tr><th width='100%' height='44' colspan='3' align='center' bgcolor='#d3d3d3'>"];
        [body appendString:sectionTitle];
        [body appendString:@"</th></tr>"];
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
    if (self.myCustDict != nil) {
        NSNumber* auxLocationIUR = [self.myCustDict objectForKey:@"LocationIUR"];
        NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] orderContactsWithLocationIUR:auxLocationIUR];
        [body appendString:@"<tr><th width='100%' height='44' colspan='3' align='center' bgcolor='#d3d3d3'>"];
        [body appendString:@"Contacts"];
        [body appendString:@"</th></tr>"];
        for (int i = 0; i < [contactList count]; i++) {
            NSMutableDictionary* contactDict = [contactList objectAtIndex:i];
            [body appendString:@"<tr><td width='30%' height='44'><b>"];
            [body appendString:[contactDict objectForKey:@"Title"]];
            [body appendString:@"</b></td><td width='40%' height='44'>"];
            [body appendString:@""];
            [body appendString:@"</td><td width='30%' height='44'>"];
            [body appendString:@""];
            [body appendString:@"</td></tr>"];
        }
    }
    [body appendString:@"</table></body></html>"];
    return body;
}

@end
