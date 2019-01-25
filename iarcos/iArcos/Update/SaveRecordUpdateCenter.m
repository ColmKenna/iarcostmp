//
//  SaveRecordUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 02/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordUpdateCenter.h"
//@interface SaveRecordUpdateCenter ()
//- (void)retrieveExistingProductDict:(NSArray*)aRecordList;
//
//@end

@implementation SaveRecordUpdateCenter

- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        self.expectedFieldCount = 27;
//        [self retrieveExistingProductDict:aRecordList];
    }
    return self;
}

- (id)initWithRecordList:(NSArray*)aRecordList batchedNumber:(int)aBatchedNumber batchedSize:(int)aBatchedSize {
    self = [super initWithRecordList:aRecordList batchedNumber:aBatchedNumber batchedSize:aBatchedSize];
    if (self != nil) {
        self.recordList = aRecordList;
        self.expectedFieldCount = 38;
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
    [[ArcosCoreData sharedArcosCoreData]LoadProductWithFieldList:aFieldList existentProductDict:self.existingObjectDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingObjectDict:(NSArray*)aRecordList {
    int myCapacity = self.batchedSize < self.recordCount ? self.batchedSize : self.recordCount;
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:myCapacity];
    for (int i = self.rowPointer; i < self.rearRowPointer; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* productIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [productIURList addObject:productIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR in %@", productIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (Product* aProduct in objectArray) {
        [self.existingObjectDict setObject:aProduct forKey:aProduct.ProductIUR];
    }
}

@end
