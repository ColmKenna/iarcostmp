//
//  BatchedUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 11/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "BatchedUpdateCenter.h"
#import "ArcosUtils.h"

@implementation BatchedUpdateCenter
@synthesize target = _target;
@synthesize isBusy = _isBusy;
@synthesize overallNumber = _overallNumber;
@synthesize pageNumberList = _pageNumberList;
@synthesize action = _action;
@synthesize loadingAction = _loadingAction;
@synthesize batchedTimer = _batchedTimer;
@synthesize batchedDelegate = _batchedDelegate;
@synthesize currentPageNumber = _currentPageNumber;
@synthesize pageSize = _pageSize;
@synthesize activeRecordBatchedCount = _activeRecordBatchedCount;
@synthesize recordList = _recordList;
@synthesize levelIUR = _levelIUR;

-(id)initBatchedWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction recordList:(NSArray*)aRecordList pageSize:(int)aPageSize {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.action = anAction;
        self.loadingAction = aLoadingAction;
        self.recordList = aRecordList;
        self.overallNumber = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.recordList count]];
        self.pageSize = aPageSize;
        self.isBusy = NO;
        [self createBatchedPageNumberList];
        self.currentPageNumber = 0;
        self.activeRecordBatchedCount = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.pageNumberList != nil) { self.pageNumberList = nil; }
    if (self.batchedTimer != nil) { self.batchedTimer = nil; }
    self.recordList = nil;
    self.levelIUR = nil;
    
    [super dealloc];
}

-(void)createBatchedPageNumberList {
    int totalPages = [self totalPage];
//    int listLength = totalPages - 1;
    self.pageNumberList = [NSMutableArray arrayWithCapacity:totalPages];
    for (int i = totalPages; i >= 1; i--) {
        [self.pageNumberList addObject:[NSNumber numberWithInt:i]];
    }
//    NSLog(@"pageNumberList: %@", self.pageNumberList);
}

-(void)runTask {
    if ([self.pageNumberList count] <= 0 || self.isBusy) {
        return;
    }
//    [GlobalSharedClass shared].serviceTimeoutInterval = 600.0;
    if ([self.target performSelector:self.loadingAction]) {
        self.isBusy = YES;
        self.batchedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPageNumberList) userInfo:nil repeats:YES];
    }
}

-(void)checkPageNumberList {
    if ([self.target performSelector:self.loadingAction]) {
        
        //stop the timer
        if ([self.pageNumberList count]<=0) {
            [self.batchedTimer invalidate];
            //[self.performTimer release];
            self.batchedTimer=nil;
            [self.batchedDelegate batchedUpdateCompleted:self.activeRecordBatchedCount];
            self.isBusy = NO;
            
            //set the service time out interval back to default
//            [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
        }else{
            NSNumber* pageNumberObj = [[[self.pageNumberList lastObject] retain] autorelease];
            self.currentPageNumber = [pageNumberObj intValue];
            [self.target performSelector:self.action withObject:pageNumberObj];
            [self.pageNumberList removeLastObject];
        }
    }
}

-(void)stopTask {
    [self.batchedTimer invalidate];
    //[self.performTimer release];
    self.batchedTimer=nil;
    self.isBusy = NO;
    [self.pageNumberList removeAllObjects];
    //set the service time out interval back to default
//    [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
}

-(int)totalPage {
    //    float tmpTotalPage = self.overallNumber * 1.0f / [GlobalSharedClass shared].pageSize;
    float tmpTotalPage = self.overallNumber * 1.0f / self.pageSize;
    int totalPages = (int)ceilf(tmpTotalPage);
//    NSLog(@"totalPages is: %d", totalPages);
    return totalPages;
}

-(void)accumulateActiveRecordCount:(int)anActiveRecordCount {
    self.activeRecordBatchedCount = self.activeRecordBatchedCount + anActiveRecordCount;
}

@end
