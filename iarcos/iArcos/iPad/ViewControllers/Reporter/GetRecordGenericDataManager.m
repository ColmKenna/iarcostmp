//
//  GetRecordGenericDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericDataManager.h"
@interface GetRecordGenericDataManager()

- (GetRecordTypeGenericBaseObject*)deserialise:(NSString*)anActualContent fieldType:(NSString*)aFieldType;

@end

@implementation GetRecordGenericDataManager
@synthesize constantFieldTypeDict = _constantFieldTypeDict;
@synthesize iURFieldTypeText = _iURFieldTypeText;
@synthesize stringFieldTypeText = _stringFieldTypeText;
@synthesize booleanFieldTypeText = _booleanFieldTypeText;
@synthesize dateTimeFieldTypeText = _dateTimeFieldTypeText;
@synthesize intFieldTypeText = _intFieldTypeText;
@synthesize decimalFieldTypeText = _decimalFieldTypeText;
@synthesize rowPointer = _rowPointer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.iURFieldTypeText = @"IUR";
        self.stringFieldTypeText = @"System.String";
        self.booleanFieldTypeText = @"System.Boolean";
        self.dateTimeFieldTypeText = @"System.DateTime";
        self.intFieldTypeText = @"System.Int32";
        self.decimalFieldTypeText = @"System.Decimal";
        self.constantFieldTypeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], self.iURFieldTypeText, [NSNumber numberWithInt:1], self.stringFieldTypeText, [NSNumber numberWithInt:2], self.booleanFieldTypeText, [NSNumber numberWithInt:3], self.dateTimeFieldTypeText, [NSNumber numberWithInt:4], self.intFieldTypeText, [NSNumber numberWithInt:5], self.decimalFieldTypeText, nil];
        self.rowPointer = 0;
    }
    return self;
}

- (void)dealloc {
    self.iURFieldTypeText = nil;
    self.stringFieldTypeText = nil;
    self.booleanFieldTypeText = nil;
    self.dateTimeFieldTypeText = nil;
    self.intFieldTypeText = nil;
    self.decimalFieldTypeText = nil;
    
    [super dealloc];
}

- (GetRecordGenericReturnObject*)processRawData:(ArcosGenericReturnObject*)aGenericReturnObject {
    GetRecordGenericReturnObject* getRecordGenericReturnObject = [[[GetRecordGenericReturnObject alloc] init] autorelease];
    ArcosGenericClass* arcosGenericClass = [aGenericReturnObject.ArrayOfData objectAtIndex:0];
    ArcosGenericClass* fieldNames = aGenericReturnObject.FieldNames;
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
    NSMutableArray* fieldNameList = [NSMutableArray arrayWithCapacity:numRecords];
    NSMutableArray* displayList = [NSMutableArray arrayWithCapacity:numRecords];
    NSMutableArray* seqFieldTypeList = [NSMutableArray array];
    NSMutableDictionary* groupedDataDict = [NSMutableDictionary dictionary];
    NSMutableDictionary* originalGroupedDataDict = [NSMutableDictionary dictionary];
    
    for (int i = 1; i <= numRecords; i++) {
        NSString* methodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(methodName);
        
        //for FieldNames
        NSString* fieldName = [fieldNames performSelector:selector];
        [fieldNameList addObject:fieldName];
        
        NSString* dataStr = [arcosGenericClass performSelector:selector];
        NSArray* dataArray = [dataStr componentsSeparatedByString:@"|"];
        NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:7];
        [dataDict setObject:[ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:0]]]] forKey:@"fieldDesc"];
        [dataDict setObject:[ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:1]]]] forKey:@"contentString"];
        NSString* tmpFieldType = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:2]]]];
        [dataDict setObject:tmpFieldType forKey:@"fieldType"];
        NSString* tmpActualContent = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:3]]]];
        
        [dataDict setObject:[self deserialise:tmpActualContent fieldType:tmpFieldType] forKey:@"actualContent"];
        [dataDict setObject:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[dataArray objectAtIndex:4]]] forKey:@"securityLevel"];
        [dataDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"originalIndex"];
        [dataDict setObject:[ArcosUtils convertNilToZero:[self.constantFieldTypeDict objectForKey:tmpFieldType]] forKey:@"fieldTypeCode"];
        
        
        NSString* descrTypeCode = [fieldName substringToIndex:2];
        [dataDict setObject:descrTypeCode forKey:@"descrTypeCode"];
        [dataDict setObject:fieldName forKey:@"fieldName"];
        
        [displayList addObject:dataDict];
        if (![seqFieldTypeList containsObject:tmpFieldType]) {
            [seqFieldTypeList addObject:tmpFieldType];
        }
        [dataDict release];
    }
    //process the data to be used in table view
    for (int i = 0; i < [seqFieldTypeList count]; i++) {
        NSMutableArray* tmpDataArray = [[NSMutableArray alloc] init];
        NSMutableArray* originalTmpDataArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [displayList count]; j++) {
            NSMutableDictionary* dataDict = [displayList objectAtIndex:j];
            NSMutableDictionary* originalDataDict =
            [[NSMutableDictionary alloc] initWithDictionary:dataDict];
            GetRecordTypeGenericBaseObject* tmpGetRecordTypeGenericBaseObject = [dataDict objectForKey:@"actualContent"];
            GetRecordTypeGenericBaseObject* originalGetRecordTypeGenericBaseObject = [[[NSClassFromString(NSStringFromClass([tmpGetRecordTypeGenericBaseObject class])) alloc] initWithTypeObjectValue:tmpGetRecordTypeGenericBaseObject.resultContent] autorelease];
            [originalDataDict setObject:originalGetRecordTypeGenericBaseObject forKey:@"actualContent"];
            
            if ([[dataDict objectForKey:@"fieldType"] isEqualToString:[seqFieldTypeList objectAtIndex:i]]) {
                [tmpDataArray addObject:dataDict];
                [originalTmpDataArray addObject:originalDataDict];
            }
            [originalDataDict release];
        }
        [groupedDataDict setObject:tmpDataArray forKey:[seqFieldTypeList objectAtIndex:i]];
        [originalGroupedDataDict setObject:originalTmpDataArray forKey:[seqFieldTypeList objectAtIndex:i]];
        [tmpDataArray release];
        [originalTmpDataArray release];
    }
    [getRecordGenericReturnObject configDataWithFieldNameList:fieldNameList displayList:displayList seqFieldTypeList:seqFieldTypeList groupedDataDict:groupedDataDict originalGroupedDataDict:originalGroupedDataDict];
    
    return getRecordGenericReturnObject;
}

- (GetRecordTypeGenericBaseObject*)deserialise:(NSString*)anActualContent fieldType:(NSString*)aFieldType {
    if ([aFieldType isEqualToString:self.iURFieldTypeText]) {
        return [[[GetRecordTypeGenericIURObject alloc] initWithTypeObjectValue:[ArcosUtils convertStringToNumber:anActualContent]] autorelease];
    }
    if ([aFieldType isEqualToString:self.stringFieldTypeText]) {
        return [[[GetRecordTypeGenericStringObject alloc] initWithTypeObjectValue:anActualContent] autorelease];
    }
    if ([aFieldType isEqualToString:self.booleanFieldTypeText]) {
        return [[[GetRecordTypeGenericIURObject alloc] initWithTypeObjectValue:[ArcosUtils convertStringToNumber:anActualContent]] autorelease];
    }
    if ([aFieldType isEqualToString:self.dateTimeFieldTypeText]) {
        if (anActualContent.length >= 10) {
            NSDate* auxDate = [ArcosUtils dateFromString:[anActualContent substringToIndex:10] format:[GlobalSharedClass shared].dateFormat];
            return [[[GetRecordTypeGenericDateObject alloc] initWithTypeObjectValue:auxDate] autorelease];
        }
    }
    if ([aFieldType isEqualToString:self.intFieldTypeText]) {
        return [[[GetRecordTypeGenericIntObject alloc] initWithTypeObjectValue:[ArcosUtils convertStringToNumber:anActualContent]] autorelease];
    }
    if ([aFieldType isEqualToString:self.decimalFieldTypeText]) {
        return [[[GetRecordTypeGenericDecimalObject alloc] initWithTypeObjectValue:[ArcosUtils convertStringToFloatNumber:anActualContent]] autorelease];
    }
    
    return [[[GetRecordTypeGenericStringObject alloc] initWithTypeObjectValue:@""] autorelease];
}

- (int)retrieveEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    return [securityLevel intValue];
}


@end
