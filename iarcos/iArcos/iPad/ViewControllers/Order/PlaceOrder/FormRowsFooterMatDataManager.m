//
//  FormRowsFooterMatDataManager.m
//  iArcos
//
//  Created by Richard on 14/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsFooterMatDataManager.h"

@implementation FormRowsFooterMatDataManager
@synthesize displayList = _displayList;
@synthesize matDataFoundFlag = _matDataFoundFlag;
@synthesize headerMonthList = _headerMonthList;

- (void)dealloc {
    self.displayList = nil;
    self.headerMonthList = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    NSMutableDictionary* rowData0 = [NSMutableDictionary dictionary];
    [rowData0 setObject:@"LY" forKey:@"Details"];
    NSMutableDictionary* rowData1 = [NSMutableDictionary dictionary];
    [rowData1 setObject:@"TY" forKey:@"Details"];
    self.displayList = [NSMutableArray arrayWithCapacity:2];
    [self.displayList addObject:rowData0];
    [self.displayList addObject:rowData1];
}

- (void)retrieveFooterMatDataWithProductIUR:(NSNumber*)aProductIUR locationIUR:(NSNumber*)aLocationIUR {
    self.matDataFoundFlag = NO;
    NSArray* properties = [NSArray arrayWithObjects:@"productIUR", @"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",@"dateLastModified",@"qty01",@"qty02",@"qty03",@"qty04",@"qty05",@"qty06",@"qty07",@"qty08",@"qty09",@"qty10",@"qty11",@"qty12",@"bonus13",@"bonus14",@"bonus15",@"bonus16",@"bonus17",@"bonus18",@"bonus19",@"bonus20",@"bonus21",@"bonus22",@"bonus23",@"bonus24",@"bonus25",@"bonus01",@"bonus02",@"bonus03",@"bonus04",@"bonus05",@"bonus06",@"bonus07",@"bonus08",@"bonus09",@"bonus10",@"bonus11",@"bonus12",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and productIUR = %@", aLocationIUR, aProductIUR];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectArray count] > 0) {
        self.matDataFoundFlag = YES;
        self.headerMonthList = [NSMutableArray arrayWithCapacity:12];
        NSDictionary* cellData = [objectArray objectAtIndex:0];
        NSDate* dateLastModified = [cellData objectForKey:@"dateLastModified"];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM"];
        NSString* myMonthStr = [df stringFromDate:dateLastModified];
        [self.headerMonthList addObject:[ArcosUtils convertNilToEmpty:myMonthStr]];
        int monthStep = 0;
        for (int i = 0; i < 11; i++) {
            monthStep--;
            NSDate* tmpDateLastModified = [ArcosUtils addMonths:monthStep date:dateLastModified];
            NSString* tmpMonthStr = [df stringFromDate:tmpDateLastModified];
            [self.headerMonthList insertObject:[ArcosUtils convertNilToEmpty:tmpMonthStr] atIndex:0];
        }
        [df release];
        self.displayList = [NSMutableArray arrayWithCapacity:2];
        NSMutableDictionary* rowData0 = [NSMutableDictionary dictionary];
        [rowData0 setObject:@"LY" forKey:@"Details"];
        [rowData0 setObject:[NSDictionary dictionaryWithDictionary:cellData] forKey:@"Data"];
        NSMutableDictionary* rowData1 = [NSMutableDictionary dictionary];
        [rowData1 setObject:@"TY" forKey:@"Details"];
        [rowData1 setObject:[NSDictionary dictionaryWithDictionary:cellData] forKey:@"Data"];
        [self.displayList addObject:rowData0];
        [self.displayList addObject:rowData1];
    } else {
        [self createBasicData];
    }
}

@end
