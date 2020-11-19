//
//  NewOrderDataManager.m
//  iArcos
//
//  Created by Richard on 16/11/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "NewOrderDataManager.h"
#import "ArcosCoreData.h"

@implementation NewOrderDataManager

- (NSMutableArray*)retrieveLocationProductMATWithLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %d", [aLocationIUR intValue]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    return objectArray;
}

@end
