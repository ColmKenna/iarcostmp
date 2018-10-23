//
//  PhotoTransferProcessMachine.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "PhotoTransferProcessMachine.h"
#import "ArcosCoreData.h"

@implementation PhotoTransferProcessMachine
@synthesize transferDelegate = _transferDelegate;
@synthesize isBusy = _isBusy;
@synthesize fileTimer = _fileTimer;
@synthesize target = _target;
@synthesize action = _action;
@synthesize loadingAction = _loadingAction;
@synthesize collectedDictList = _collectedDictList;
@synthesize currentCollectedDict = _currentCollectedDict;
@synthesize overallFileCount = _overallFileCount;
@synthesize successfulFileCount = _successfulFileCount;

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction dataDictList:(NSMutableArray*)aDataDictList {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.action = anAction;
        self.loadingAction = aLoadingAction;
        self.collectedDictList = aDataDictList;
        self.overallFileCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.collectedDictList count]];
        self.successfulFileCount = 0;
    }
    return self;
}

- (void)dealloc {
    [self.fileTimer invalidate];
    self.fileTimer = nil;
    self.collectedDictList = nil;
    self.currentCollectedDict = nil;
    
    [super dealloc];
}

- (NSString*)retrieveEmployeeName {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    return [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
}

- (void)runTask {
    if ([self.collectedDictList count] <= 0 || self.isBusy) return;
    self.isBusy = YES;
    self.fileTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkFileStack) userInfo:nil repeats:YES];
}

- (void)checkFileStack {
    if (![self.target performSelector:self.loadingAction]) return;
    if ([self.collectedDictList count] <= 0) {
        [self.fileTimer invalidate];
        self.fileTimer = nil;
        [self.transferDelegate photoTransferCompleted:self.successfulFileCount];
        self.isBusy = NO;
    } else {
        NSDictionary* topCollectedDict = [[[self.collectedDictList lastObject] retain] autorelease];
        self.currentCollectedDict = [NSDictionary dictionaryWithDictionary:topCollectedDict];
        [self.transferDelegate photoTransferStartedWithText:[NSString stringWithFormat:@"Uploading %@", [self.currentCollectedDict objectForKey:@"Comments"]]];
        [self.target performSelector:self.action withObject:self.currentCollectedDict];
        [self.collectedDictList removeLastObject];
    }
}

- (void)stopTask {
    [self.fileTimer invalidate];
    self.fileTimer = nil;
    self.isBusy = NO;
    [self.collectedDictList removeAllObjects];
}

- (float)progressValue {
    int currentFileCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.collectedDictList count]];
    return (self.overallFileCount - currentFileCount) * 1.0 / self.overallFileCount;
}

- (void)saveResultToCollectedTable:(int)aResultValue {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ and Comments = %@", [self.currentCollectedDict objectForKey:@"LocationIUR"], [self.currentCollectedDict objectForKey:@"Comments"]];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Collected" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] == 1) {
        Collected* myCollected = [objectList objectAtIndex:0];
        myCollected.CallIUR = [NSNumber numberWithInt:aResultValue];
    }
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
}

@end
