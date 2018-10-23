//
//  ReportMeetingDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportMeetingDataManager.h"

@implementation ReportMeetingDataManager
@synthesize getRecordGenericDataManager = _getRecordGenericDataManager;
@synthesize getRecordGenericReturnObject = _getRecordGenericReturnObject;
@synthesize auxOrderedFieldTypeList = _auxOrderedFieldTypeList;
@synthesize orderedFieldTypeList = _orderedFieldTypeList;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize changedDataList = _changedDataList;
@synthesize excludeFieldTypeList = _excludeFieldTypeList;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.getRecordGenericDataManager = [[[GetRecordGenericDataManager alloc] init] autorelease];
        self.auxOrderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.DateTime", @"System.String", @"IUR", @"System.Int32", @"System.Decimal", @"System.Boolean", nil];
        self.excludeFieldTypeList = [NSMutableArray arrayWithObjects:@"System.Memo", @"System.Contact", nil];
    }
    return self;
}

- (void)dealloc {
    self.getRecordGenericDataManager = nil;
    self.getRecordGenericReturnObject = nil;
    self.auxOrderedFieldTypeList = nil;
    self.orderedFieldTypeList = nil;
    self.changedDataList = nil;
    self.excludeFieldTypeList = nil;
    
    [super dealloc];
}

- (void)retrieveOrderedFieldTypeList:(NSMutableArray*)aResultFieldTypeList {
    self.orderedFieldTypeList = [NSMutableArray arrayWithArray:self.auxOrderedFieldTypeList];
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.orderedFieldTypeList count]] - 1; i >= 0; i--) {
        NSString* tmpFieldType = [self.orderedFieldTypeList objectAtIndex:i];
        if (![aResultFieldTypeList containsObject:tmpFieldType]) {
            [self.orderedFieldTypeList removeObjectAtIndex:i];
        }
    }
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* fieldType = [self.orderedFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.getRecordGenericReturnObject.groupedDataDict objectForKey:fieldType];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (void)inputFinishedWithData:(id)aContentString actualData:(id)anActualData indexPath:(NSIndexPath*)anIndexPath {
    NSString* tmpFieldType = [self.orderedFieldTypeList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.getRecordGenericReturnObject.groupedDataDict objectForKey:tmpFieldType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContentString forKey:@"contentString"];
    GetRecordTypeGenericBaseObject* tmpActualContentObject = [cellData objectForKey:@"actualContent"];
    tmpActualContentObject.resultContent = anActualData;
}

- (void)retrieveChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.getRecordGenericReturnObject.seqFieldTypeList count]; i++) {
        NSString* groupName = [self.getRecordGenericReturnObject.seqFieldTypeList objectAtIndex:i];
        if ([self.excludeFieldTypeList containsObject:groupName]) {
            continue;
        }
        NSMutableArray* tmpDisplayList = [self.getRecordGenericReturnObject.groupedDataDict objectForKey:groupName];
        NSMutableArray* originalTmpDisplayList = [self.getRecordGenericReturnObject.originalGroupedDataDict objectForKey:groupName];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            NSMutableDictionary* dataCell = [tmpDisplayList objectAtIndex:j];
            NSMutableDictionary* originalDataCell = [originalTmpDisplayList objectAtIndex:j];
            GetRecordTypeGenericBaseObject* actualContentObject = [dataCell objectForKey:@"actualContent"];
            GetRecordTypeGenericBaseObject* originalActualContentObject = [originalDataCell objectForKey:@"actualContent"];
            if (![actualContentObject compareGenericBaseObject:originalActualContentObject]) {
                [self.changedDataList addObject:dataCell];
            }
        }
    }
}

@end
