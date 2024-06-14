//
//  OrderEntryInputDataManager.m
//  iArcos
//
//  Created by Apple on 10/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputDataManager.h"

@implementation OrderEntryInputDataManager
@synthesize bonKey = _bonKey;
@synthesize focKey = _focKey;
@synthesize instKey = _instKey;
@synthesize testKey = _testKey;
@synthesize columnDescDataDict = _columnDescDataDict;
@synthesize qtyList = _qtyList;
@synthesize bonList = _bonList;
@synthesize relatedFormDetailDict = _relatedFormDetailDict;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.bonKey = @"BON";
        self.focKey = @"FOC";
        self.instKey = @"INST";
        self.testKey = @"TEST";
    }
    return self;
}

- (void)dealloc {
    self.bonKey = nil;
    self.focKey = nil;
    self.instKey = nil;
    self.testKey = nil;
    self.columnDescDataDict = nil;
    self.qtyList = nil;
    self.bonList = nil;   
    self.relatedFormDetailDict = nil;
    
    [super dealloc];
}

- (void)retrieveColumnDescriptionInfo {
    NSMutableArray* descrDetailCodeList = [NSMutableArray arrayWithObjects:self.bonKey, self.focKey, self.instKey, self.testKey, nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'CD' and DescrDetailCode in %@ and Active = 1", descrDetailCodeList];
    NSMutableArray* resultList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    self.columnDescDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    for (NSDictionary* dict in resultList) {
        NSString* descrDetailCode = [ArcosUtils convertNilToEmpty:[dict objectForKey:@"DescrDetailCode"]];
        NSString* detail = [ArcosUtils convertNilToEmpty:[dict objectForKey:@"Detail"]];
        [self.columnDescDataDict setObject:detail forKey:descrDetailCode];
    }
}

@end
