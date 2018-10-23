//
//  SaveRecordBaseUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 22/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordBaseUpdateCenter.h"

@implementation SaveRecordBaseUpdateCenter
@synthesize recordList = _recordList;
@synthesize saveRecordTimer = _saveRecordTimer;
@synthesize rowPointer = _rowPointer;
@synthesize rearRowPointer = _rearRowPointer;
@synthesize recordCount = _recordCount;
@synthesize realRecordCount = _realRecordCount;
@synthesize activeRecordCount = _activeRecordCount;
@synthesize commitCount = _commitCount;
@synthesize prevCommitCount = _prevCommitCount;
@synthesize saveRecordDelegate = _saveRecordDelegate;
@synthesize isSaveRecordLoadingFinished = _isSaveRecordLoadingFinished;
@synthesize delimiter = _delimiter;
@synthesize expectedFieldCount = _expectedFieldCount;
@synthesize existingObjectDict = _existingObjectDict;
@synthesize batchedNumber = _batchedNumber;
@synthesize batchedSize = _batchedSize;
@synthesize auxClassName = _auxClassName;
@synthesize levelIUR = _levelIUR;

- (id)initWithRecordList:(NSArray*)aRecordList {
    self = [super init];
    if (self != nil) {
        self.isSaveRecordLoadingFinished = YES;
        self.delimiter = @"|";
    }
    return self;
}

- (id)initWithRecordList:(NSArray*)aRecordList batchedNumber:(int)aBatchedNumber batchedSize:(int)aBatchedSize {
    self.batchedNumber = aBatchedNumber;
    self.batchedSize = aBatchedSize;
    return [self initWithRecordList:aRecordList];
}

- (void)dealloc {
    self.recordList = nil;
    self.saveRecordTimer = nil;
    self.delimiter = nil;
    self.existingObjectDict = nil;
    self.auxClassName = nil;
    self.levelIUR = nil;
    
    [super dealloc];
}

- (void)runTask {
    self.activeRecordCount = 0;
    self.rowPointer = 1;
    self.recordCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.recordList count]];
    self.realRecordCount = self.recordCount - 1;
    self.commitCount = self.realRecordCount - 1;
    self.saveRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(checkObjectList) userInfo:nil repeats:YES];
}

- (void)checkObjectList {
    if (self.isSaveRecordLoadingFinished) {
        if (self.rowPointer >= self.recordCount) {
            [self.saveRecordTimer invalidate];
            self.saveRecordTimer = nil;
            [self.saveRecordDelegate saveRecordUpdateCompleted:self.activeRecordCount];
        } else {
            self.isSaveRecordLoadingFinished = NO;
            NSString* rowStr = [self.recordList objectAtIndex:self.rowPointer];
            NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
            if ([fieldList count] == self.expectedFieldCount) {
                [self loadObjectWithFieldList:fieldList];
                self.activeRecordCount++;
            }
            if (self.rowPointer == self.commitCount) {
                [self.saveRecordDelegate CommitData];
            }
            if (self.rowPointer == self.realRecordCount) {
                [self commitObjectRecord];
            }
            self.rowPointer++;
            [self.saveRecordDelegate updateSaveRecordProgressBar:(self.rowPointer - 1) * 1.0f / self.realRecordCount];
        }
    }
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList {

}

- (void)commitObjectRecord {

}

- (void)retrieveExistingObjectDict:(NSArray*)aRecordList {

}


@end
