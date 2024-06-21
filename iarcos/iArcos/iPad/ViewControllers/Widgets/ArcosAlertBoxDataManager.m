//
//  ArcosAlertBoxDataManager.m
//  iArcos
//
//  Created by Richard on 21/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ArcosAlertBoxDataManager.h"

@implementation ArcosAlertBoxDataManager
@synthesize qtyKey = _qtyKey;
@synthesize bonKey = _bonKey;
@synthesize focKey = _focKey;
@synthesize instKey = _instKey;
@synthesize testKey = _testKey;
@synthesize columnDescDataDict = _columnDescDataDict;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.qtyKey = @"QTY";
        self.bonKey = @"BON";
        self.focKey = @"FOC";
        self.instKey = @"INST";
        self.testKey = @"TEST";
    }
    return self;
}

- (void)dealloc {
    self.qtyKey = nil;
    self.bonKey = nil;
    self.focKey = nil;
    self.instKey = nil;
    self.testKey = nil;
    self.columnDescDataDict = nil;
    
    [super dealloc];
}

- (void)retrieveColumnDescriptionInfo {
    NSMutableArray* descrDetailCodeList = [NSMutableArray arrayWithObjects:self.qtyKey, self.bonKey, self.focKey, self.instKey, self.testKey, nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'CD' and DescrDetailCode in %@ and Active = 1", descrDetailCodeList];
    NSMutableArray* resultList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    self.columnDescDataDict = [NSMutableDictionary dictionaryWithCapacity:5];
    for (NSDictionary* dict in resultList) {
        NSString* descrDetailCode = [ArcosUtils convertNilToEmpty:[dict objectForKey:@"DescrDetailCode"]];
        NSString* detail = [ArcosUtils convertNilToEmpty:[dict objectForKey:@"Detail"]];
        [self.columnDescDataDict setObject:detail forKey:descrDetailCode];
    }
}

@end
