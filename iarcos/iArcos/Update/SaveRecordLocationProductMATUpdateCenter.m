//
//  SaveRecordLocationProductMATUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 05/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordLocationProductMATUpdateCenter.h"
//@interface SaveRecordLocationProductMATUpdateCenter ()
//- (void)retrieveExistingObjectDict:(NSArray*)aRecordList;
//
//@end

@implementation SaveRecordLocationProductMATUpdateCenter

- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 80;
//        [self retrieveExistingLocationProductMATDict:aRecordList];
    }
    return self;
}
- (id)initWithRecordList:(NSArray*)aRecordList batchedNumber:(int)aBatchedNumber batchedSize:(int)aBatchedSize {
    self = [super initWithRecordList:aRecordList batchedNumber:aBatchedNumber batchedSize:aBatchedSize];
    if (self != nil) {
        self.recordList = aRecordList;
        self.expectedFieldCount = 80;
//        [self retrieveExistingLocationProductMATDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)runTask {
    self.activeRecordCount = 0;
    self.rowPointer = self.batchedSize * (self.batchedNumber - 1);
    if (self.batchedNumber == 1) {
        self.rowPointer = 1;
    }
    
    self.recordCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.recordList count]];
    self.rearRowPointer = self.batchedSize * self.batchedNumber;
    if (self.rearRowPointer > self.recordCount) {
        self.rearRowPointer = self.recordCount;
    }
    self.commitCount = self.rearRowPointer - 1;
    self.prevCommitCount = self.commitCount - 1;
    [self retrieveExistingObjectDict:self.recordList];
    self.saveRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(checkObjectList) userInfo:nil repeats:YES];
}

- (void)checkObjectList {
    if (self.isSaveRecordLoadingFinished) {
        if (self.rowPointer >= self.rearRowPointer) {
            [self.saveRecordTimer invalidate];
            self.saveRecordTimer = nil;
            [self.saveRecordDelegate batchedSaveRecordUpdateCompleted:self.activeRecordCount];
        } else {
            self.isSaveRecordLoadingFinished = NO;
            NSString* rowStr = [self.recordList objectAtIndex:self.rowPointer];
            NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
//            NSLog(@"cc %d", [ArcosUtils convertNSUIntegerToUnsignedInt:[fieldList count]]);
            if ([fieldList count] == self.expectedFieldCount) {
                [self loadObjectWithFieldList:fieldList];
                self.activeRecordCount++;
            }
            if (self.rowPointer == self.prevCommitCount) {
                [self.saveRecordDelegate CommitData];
            }
            if (self.rowPointer == self.commitCount) {
                [self commitObjectRecord];
            }
            self.rowPointer++;
            [self.saveRecordDelegate updateSaveRecordProgressBar:self.rowPointer * 1.0f / self.recordCount];
        }
    }
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData]loadLocationProductMATWithFieldList:aFieldList existingLocationProductMATDict:self.existingObjectDict levelIUR:self.levelIUR];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingObjectDict:(NSArray*)aRecordList {
    NSMutableDictionary* locationIURDict = [NSMutableDictionary dictionaryWithCapacity:self.batchedSize];
    NSMutableDictionary* productIURDict = [NSMutableDictionary dictionaryWithCapacity:self.batchedSize];
    NSMutableArray* recordCombinationKeyList = [NSMutableArray arrayWithCapacity:self.batchedSize];
    for (int i = self.rowPointer; i < self.rearRowPointer; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* locationIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            NSNumber* productIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:1]];
            [locationIURDict setObject:locationIUR forKey:locationIUR];
            [productIURDict setObject:productIUR forKey:productIUR];
            [recordCombinationKeyList addObject:[NSString stringWithFormat:@"%@->%@", locationIUR, productIUR]];
        }
    }
    NSArray* locationIURList = [locationIURDict allKeys];
    NSArray* productIURList = [productIURDict allKeys];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR in %@ and productIUR in %@", locationIURList, productIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* auxExistingLocationProductMATDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (LocationProductMAT* locationProductMAT in objectArray) {
        NSString* tmpKey = [NSString stringWithFormat:@"%@->%@", locationProductMAT.locationIUR, locationProductMAT.productIUR];
        [auxExistingLocationProductMATDict setObject:locationProductMAT forKey:tmpKey];
    }
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (NSString* combinationKey in recordCombinationKeyList) {
        LocationProductMAT* tmpLocationProductMAT = [auxExistingLocationProductMATDict objectForKey:combinationKey];
        if (tmpLocationProductMAT != nil) {
            [self.existingObjectDict setObject:tmpLocationProductMAT forKey:combinationKey];
        }
    }
}

@end
