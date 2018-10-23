//
//  SaveRecordBaseUpdateCenter.h
//  iArcos
//
//  Created by David Kilmartin on 22/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveRecordUpdateCenterDelegate.h"
#import "ArcosCoreData.h"

@interface SaveRecordBaseUpdateCenter : NSObject {
    NSArray* _recordList;
    NSTimer* _saveRecordTimer;
    int _rowPointer;
    int _rearRowPointer;
    int _recordCount;
    int _realRecordCount;
    int _activeRecordCount;
    int _commitCount;
    int _prevCommitCount;
    id<SaveRecordUpdateCenterDelegate> _saveRecordDelegate;
    BOOL _isSaveRecordLoadingFinished;
    NSString* _delimiter;
    int _expectedFieldCount;
    NSMutableDictionary* _existingObjectDict;
    int _batchedNumber;
    int _batchedSize;
    NSString* _auxClassName;
    NSNumber* _levelIUR;
}

@property(nonatomic, retain) NSArray* recordList;
@property(nonatomic, retain) NSTimer* saveRecordTimer;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, assign) int rearRowPointer;
@property(nonatomic, assign) int recordCount;
@property(nonatomic, assign) int realRecordCount;
@property(nonatomic, assign) int activeRecordCount;
@property(nonatomic, assign) int commitCount;
@property(nonatomic, assign) int prevCommitCount;
@property(nonatomic, assign) id<SaveRecordUpdateCenterDelegate> saveRecordDelegate;
@property(nonatomic, assign) BOOL isSaveRecordLoadingFinished;
@property(nonatomic, retain) NSString* delimiter;
@property(nonatomic, assign) int expectedFieldCount;
@property(nonatomic, retain) NSMutableDictionary* existingObjectDict;
@property(nonatomic, assign) int batchedNumber;
@property(nonatomic, assign) int batchedSize;
@property(nonatomic, retain) NSString* auxClassName;
@property(nonatomic, retain) NSNumber* levelIUR;

- (id)initWithRecordList:(NSArray*)aRecordList;
- (id)initWithRecordList:(NSArray*)aRecordList batchedNumber:(int)aBatchNumber batchedSize:(int)aBatchedSize;
- (void)runTask;
- (void)loadObjectWithFieldList:(NSArray*)aFieldList;
- (void)commitObjectRecord;
- (void)retrieveExistingObjectDict:(NSArray*)aRecordList;

@end
