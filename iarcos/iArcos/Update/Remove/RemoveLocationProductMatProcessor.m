//
//  RemoveLocationProductMatProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "RemoveLocationProductMatProcessor.h"

@implementation RemoveLocationProductMatProcessor
@synthesize removeDelegate = _removeDelegate;
@synthesize removeRecordProcessorDataManager = _removeRecordProcessorDataManager;
@synthesize locationProductMatList = _locationProductMatList;
@synthesize overallMatCount = _overallMatCount;
@synthesize isBusy = _isBusy;
@synthesize removeRecordTimer = _removeRecordTimer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.removeRecordProcessorDataManager = [[[RemoveRecordProcessorDataManager alloc] init] autorelease];
        NSMutableArray* locationIURList = [self.removeRecordProcessorDataManager retrieveAllLocationIUR];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT (locationIUR IN %@)", locationIURList];
        self.locationProductMatList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        self.overallMatCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.locationProductMatList count]];
        self.isBusy = NO;
    }
    return self;
}

- (void)dealloc {
    self.removeRecordProcessorDataManager = nil;
    self.locationProductMatList = nil;
    self.removeRecordTimer = nil;
    
    [super dealloc];
}

- (void)runTask {
    if (self.overallMatCount <= 0 || self.isBusy) return;
    self.isBusy = YES;
    self.removeRecordProcessorDataManager.rowPointer = 0;
    self.removeRecordProcessorDataManager.isRemovingRecordFinished = YES;
    [self.removeDelegate updateRemoveStatusTextWithValue:@"Removing redundant MAT records"];
    [self.removeDelegate updateRemoveRecordProgressBarWithoutAnimation:0.0];
    self.removeRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(checkObjectList) userInfo:nil repeats:YES];
}

- (void)checkObjectList {
    if (!self.removeRecordProcessorDataManager.isRemovingRecordFinished) return;
    if (self.removeRecordProcessorDataManager.rowPointer >= self.overallMatCount) {
        [self.removeRecordTimer invalidate];
        self.removeRecordTimer = nil;
        [self.removeDelegate removeRecordProcessCompleted];
        self.isBusy = NO;
    } else {
        self.removeRecordProcessorDataManager.isRemovingRecordFinished = NO;
        LocationProductMAT* auxLocationProductMAT = [self.locationProductMatList objectAtIndex:self.removeRecordProcessorDataManager.rowPointer];
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:auxLocationProductMAT];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext refreshObject:auxLocationProductMAT mergeChanges:NO];        
        self.removeRecordProcessorDataManager.rowPointer++;
        [self.removeDelegate updateRemoveRecordProgressBar: self.removeRecordProcessorDataManager.rowPointer * 1.0f / self.overallMatCount];
        self.removeRecordProcessorDataManager.isRemovingRecordFinished = YES;
    }    
}

@end
