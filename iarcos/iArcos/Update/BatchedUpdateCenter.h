//
//  BatchedUpdateCenter.h
//  iArcos
//
//  Created by David Kilmartin on 11/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BatchedUpdateCenterDelegate
-(void)batchedUpdateCompleted:(int)anOverallNumber;
@end

@interface BatchedUpdateCenter : NSObject {
    id _target;
    BOOL _isBusy;
    int _overallNumber;
    NSMutableArray* _pageNumberList;
    SEL _action;
    SEL _loadingAction;
    NSTimer* _batchedTimer;
    id<BatchedUpdateCenterDelegate> _batchedDelegate;
    int _currentPageNumber;
    int _pageSize;
    int _activeRecordBatchedCount;
    NSArray* _recordList;
    NSNumber* _levelIUR;
}

@property(nonatomic,assign) id target;
@property(nonatomic,assign) BOOL isBusy;
@property(nonatomic,assign) int overallNumber;
@property(nonatomic,retain) NSMutableArray* pageNumberList;
@property(nonatomic) SEL action;
@property(nonatomic) SEL loadingAction;
@property(nonatomic,retain) NSTimer* batchedTimer;
@property(nonatomic,assign) id<BatchedUpdateCenterDelegate> batchedDelegate;
@property(nonatomic,assign) int currentPageNumber;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) int activeRecordBatchedCount;
@property(nonatomic,retain) NSArray* recordList;
@property(nonatomic,retain) NSNumber* levelIUR;

-(id)initBatchedWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction recordList:(NSArray*)aRecordList pageSize:(int)aPageSize;
-(void)createBatchedPageNumberList;
-(void)runTask;
-(void)stopTask;
-(int)totalPage;
//-(float)progressValue;
-(void)accumulateActiveRecordCount:(int)anActiveRecordCount;

@end
