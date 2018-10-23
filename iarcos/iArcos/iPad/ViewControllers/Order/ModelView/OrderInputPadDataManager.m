//
//  OrderInputPadDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 10/06/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "OrderInputPadDataManager.h"

@implementation OrderInputPadDataManager
@synthesize monthList = _monthList;

- (void)dealloc {
    self.monthList = nil;
    
    [super dealloc];
}

- (NSMutableArray*)retrieveLocationProductMATWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %d and productIUR = %d", [aLocationIUR intValue], [aProductIUR intValue]];
    NSArray* properties = [NSArray arrayWithObjects:@"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",@"bonus13",@"bonus14",@"bonus15",@"bonus16",@"bonus17",@"bonus18",@"bonus19",@"bonus20",@"bonus21",@"bonus22",@"bonus23",@"bonus24",@"bonus25",@"dateLastModified",nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (void)processMonthListWithDate:(NSDate*)aDateLastModified {
    self.monthList = [NSMutableArray arrayWithCapacity:13];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM"];
    NSString* myMonthStr = [df stringFromDate:aDateLastModified];
    [self.monthList addObject:myMonthStr];
    int monthStep = 0;
    for (int i = 12; i > 0; i--) {
        monthStep--;
        NSDate* tmpDateLastModified = [ArcosUtils addMonths:monthStep date:aDateLastModified];
        NSString* tmpMonthStr = [df stringFromDate:tmpDateLastModified];
        [self.monthList addObject:tmpMonthStr];
    }
    [df release];
}

@end
