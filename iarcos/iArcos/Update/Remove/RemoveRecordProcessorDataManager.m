//
//  RemoveRecordProcessorDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 10/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "RemoveRecordProcessorDataManager.h"

@implementation RemoveRecordProcessorDataManager
@synthesize isRemovingRecordFinished = _isRemovingRecordFinished;
@synthesize rowPointer = _rowPointer;

- (NSMutableArray*)retrieveAllLocationIUR {
    NSMutableArray* locationIURList = [NSMutableArray array]; 
    NSArray* properties = [NSArray arrayWithObjects:@"LocationIUR", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:properties  withPredicate:nil withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    for (int i = 0; i < [objectArray count]; i++) {
        NSDictionary* tmpLocationDict = [objectArray objectAtIndex:i];
        [locationIURList addObject:[tmpLocationDict objectForKey:@"LocationIUR"]];
    }    
    return locationIURList;
}

@end
