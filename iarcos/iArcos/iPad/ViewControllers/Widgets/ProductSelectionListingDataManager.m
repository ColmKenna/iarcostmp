//
//  ProductSelectionListingDataManager.m
//  iArcos
//
//  Created by Richard on 13/04/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ProductSelectionListingDataManager.h"
#import "ArcosCoreData.h"

@implementation ProductSelectionListingDataManager

- (NSMutableArray*)retrieveActiveProductList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1'"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Description", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectArray count] > 0) {
        NSMutableArray* resultObjectList = [NSMutableArray arrayWithCapacity:[objectArray count]];
        for (int i = 0; i < [objectArray count]; i++) {
            NSMutableDictionary* auxProductDict = [NSMutableDictionary dictionaryWithDictionary:[objectArray objectAtIndex:i]];
            NSString* auxDesc = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[auxProductDict objectForKey:@"Description"]]];
            if (auxDesc.length == 0) {
                [auxProductDict setObject:@" " forKey:@"Description"];
            }
            [auxProductDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
            [resultObjectList addObject:auxProductDict];
        }
        return resultObjectList;
    } else {
        return nil;
    }
}

@end
