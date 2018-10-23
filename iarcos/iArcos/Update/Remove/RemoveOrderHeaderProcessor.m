//
//  RemoveOrderHeaderProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 11/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "RemoveOrderHeaderProcessor.h"

@implementation RemoveOrderHeaderProcessor
@synthesize removeDelegate = _removeDelegate;
@synthesize removeRecordProcessorDataManager = _removeRecordProcessorDataManager;
@synthesize orderHeaderList = _orderHeaderList;
@synthesize overallOrderHeaderCount = _overallOrderHeaderCount;
@synthesize isBusy = _isBusy;
@synthesize removeRecordTimer = _removeRecordTimer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.removeRecordProcessorDataManager = [[[RemoveRecordProcessorDataManager alloc] init] autorelease];
        NSMutableArray* locationIURList = [self.removeRecordProcessorDataManager retrieveAllLocationIUR];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT (LocationIUR IN %@) AND OrderHeaderIUR != 0", locationIURList];
        self.orderHeaderList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        self.overallOrderHeaderCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.orderHeaderList count]];
        self.isBusy = NO;
    }
    return self;
}

- (void)dealloc {
    self.removeRecordProcessorDataManager = nil;
    self.orderHeaderList = nil;
    self.removeRecordTimer = nil;
    
    [super dealloc];
}

- (void)runTask {
    if (self.overallOrderHeaderCount <= 0 || self.isBusy) return;
    self.isBusy = YES;
    self.removeRecordProcessorDataManager.rowPointer = 0;
    self.removeRecordProcessorDataManager.isRemovingRecordFinished = YES;
    [self.removeDelegate updateRemoveStatusTextWithValue:@"Removing redundant Order/Call records"];
    [self.removeDelegate updateRemoveRecordProgressBarWithoutAnimation:0.0];
    self.removeRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(checkObjectList) userInfo:nil repeats:YES];
}

- (void)checkObjectList {
    if (!self.removeRecordProcessorDataManager.isRemovingRecordFinished) return;
    if (self.removeRecordProcessorDataManager.rowPointer >= self.overallOrderHeaderCount) {
        [self.removeRecordTimer invalidate];
        self.removeRecordTimer = nil;
        [self.removeDelegate removeRecordProcessCompleted];
        self.isBusy = NO;
    } else {
        self.removeRecordProcessorDataManager.isRemovingRecordFinished = NO;
        OrderHeader* auxOrderHeader = [self.orderHeaderList objectAtIndex:self.removeRecordProcessorDataManager.rowPointer];
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:auxOrderHeader];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext refreshObject:auxOrderHeader mergeChanges:NO];        
        self.removeRecordProcessorDataManager.rowPointer++;
        [self.removeDelegate updateRemoveRecordProgressBar: self.removeRecordProcessorDataManager.rowPointer * 1.0f / self.overallOrderHeaderCount];
        self.removeRecordProcessorDataManager.isRemovingRecordFinished = YES;
    }    
}

@end
