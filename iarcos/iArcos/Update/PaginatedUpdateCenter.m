//
//  PaginatedUpdateCenter.m
//  Arcos
//
//  Created by David Kilmartin on 14/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PaginatedUpdateCenter.h"

@implementation PaginatedUpdateCenter
@synthesize target = _target;
@synthesize isBusy = _isBusy;
@synthesize overallNumber = _overallNumber;
@synthesize pageNumberList = _pageNumberList;
@synthesize action = _action;
@synthesize loadingAction = _loadingAction;
@synthesize paginatedTimer = _paginatedTimer;
@synthesize paginatedDelegate = _paginatedDelegate;
@synthesize currentPageNumber = _currentPageNumber;
@synthesize pageSize = _pageSize;
/*
-(id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction overallNumber:(int)anOverallNubmer {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.action = anAction;
        self.loadingAction = aLoadingAction;
        self.overallNumber = anOverallNubmer;
        self.isBusy = NO;
        [self createPageNumberList];
        self.currentPageNumber = 0;
        
    }
    return self;    
}
*/
-(id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction overallNumber:(int)anOverallNubmer pageSize:(int)aPageSize {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.action = anAction;
        self.loadingAction = aLoadingAction;
        self.overallNumber = anOverallNubmer;
        self.pageSize = aPageSize;
        self.isBusy = NO;
        [self createPageNumberList];
        self.currentPageNumber = 0;        
    }
    return self;
}

- (void)dealloc {
    if (self.pageNumberList != nil) { self.pageNumberList = nil; }    
//    if (self.paginatedDelegate != nil) { self.paginatedDelegate = nil; }
    if (self.paginatedTimer != nil) { self.paginatedTimer = nil; }
    
    
    [super dealloc];
}

-(void)createPageNumberList {
//    float tmpTotalPage = self.overallNumber * 1.0f / [GlobalSharedClass shared].pageSize;
//    int totalPages = (int)ceilf(tmpTotalPage);
//    NSLog(@"totalPages is: %d", totalPages);
    int totalPages = [self totalPage];
    int listLength = totalPages - 1;
    self.pageNumberList = [NSMutableArray arrayWithCapacity:listLength];
    for (int i = totalPages; i > 1; i--) {
        [self.pageNumberList addObject:[NSNumber numberWithInt:i]];
    }
//    NSLog(@"self.pageNumberList: %@", self.pageNumberList);
}

-(void)runTask {
//    while ([self.pageNumberList count] > 0) {
//        NSNumber* pageNumberObj = [[[self.pageNumberList lastObject] retain] autorelease];
//        [self.target performSelector:self.action withObject:pageNumberObj];
//        [self.pageNumberList removeLastObject];
//    }
    if ([self.pageNumberList count] <= 0 || self.isBusy) {
        return;
    }
//    [GlobalSharedClass shared].serviceTimeoutInterval = 600.0;
    if ([self.target performSelector:self.loadingAction]) {
        self.isBusy = YES;
        self.paginatedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPageNumberList) userInfo:nil repeats:YES];
    }
}

-(void)checkPageNumberList {
    if ([self.target performSelector:self.loadingAction]) {      
        
        //stop the timer
        if ([self.pageNumberList count]<=0) {
            [self.paginatedTimer invalidate];
            //[self.performTimer release];
            self.paginatedTimer=nil;
            [self.paginatedDelegate paginatedUpdateCompleted:self.overallNumber];
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
    [self.paginatedTimer invalidate];
    //[self.performTimer release];
    self.paginatedTimer=nil;
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

-(float)progressValue {
    return self.currentPageNumber * 1.0f / [self totalPage];
}

@end
