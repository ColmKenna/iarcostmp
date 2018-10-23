//
//  GetRecordGenericReturnObject.m
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericReturnObject.h"

@implementation GetRecordGenericReturnObject
@synthesize fieldNameList = _fieldNameList;
@synthesize displayList = _displayList;
@synthesize seqFieldTypeList = _seqFieldTypeList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;

- (void)dealloc {
    self.fieldNameList = nil;
    self.displayList = nil;
    self.seqFieldTypeList = nil;
    self.groupedDataDict = nil;
    self.originalGroupedDataDict = nil;
    
    [super dealloc];
}

- (void)configDataWithFieldNameList:(NSMutableArray*)aFieldNameList displayList:(NSMutableArray*)aDisplayList seqFieldTypeList:(NSMutableArray*)aSeqFieldTypeList groupedDataDict:(NSMutableDictionary*)aGroupedDataDict originalGroupedDataDict:(NSMutableDictionary*)anOriginalGroupedDataDict {
    self.fieldNameList = aFieldNameList;
    self.displayList = aDisplayList;
    self.seqFieldTypeList = aSeqFieldTypeList;
    self.groupedDataDict = aGroupedDataDict;
    self.originalGroupedDataDict = anOriginalGroupedDataDict;
}

@end
