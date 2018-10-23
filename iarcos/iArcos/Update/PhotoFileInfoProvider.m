//
//  PhotoFileInfoProvider.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "PhotoFileInfoProvider.h"
#import "ArcosCoreData.h"
@interface PhotoFileInfoProvider ()

- (NSMutableArray*)retrieveCollectedInfoWithPartialFlag:(BOOL)partialFlag;

@end

@implementation PhotoFileInfoProvider


- (void)dealloc {
    
    [super dealloc];
}

- (NSMutableArray*)retrieveCollectedInfoWithPartialFlag:(BOOL)partialFlag {
    NSPredicate* predicate = nil;
    if (partialFlag) {
        predicate = [NSPredicate predicateWithFormat:@"CallIUR = 0"];
    }
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Collected" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
}

- (NSMutableArray*)retrievePartialPhotoInfo {
    return [self retrieveCollectedInfoWithPartialFlag:YES];
}

- (NSMutableArray*)retrieveFullPhotoInfo {
    return [self retrieveCollectedInfoWithPartialFlag:NO];
}

@end
