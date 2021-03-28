//
//  NextCheckoutDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutDataManager.h"
#import "ArcosCoreData.h"

@implementation NextCheckoutDataManager
@synthesize sortedOrderKeys = _sortedOrderKeys;
//@synthesize orderLines = _orderLines;
//@synthesize orderHeader = _orderHeader;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.sortedOrderKeys = nil;
//    self.orderLines = nil;
//    self.orderHeader = nil;
    
    [super dealloc];
}

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString*)aDescrTypeCode hasDescrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode ENDSWITH[cd] %@", aDescrTypeCode, aDescrDetailCode];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"DescrDetailCode",nil];
    return  [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

@end
