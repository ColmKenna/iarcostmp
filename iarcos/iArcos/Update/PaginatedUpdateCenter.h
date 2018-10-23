//
//  PaginatedUpdateCenter.h
//  Arcos
//
//  Created by David Kilmartin on 14/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSharedClass.h"
@protocol PaginatedUpdateCenterDelegate
-(void)paginatedUpdateCompleted:(int)anOverallNumber;
@end

@interface PaginatedUpdateCenter : NSObject {
    id _target;
    BOOL _isBusy;
    int _overallNumber;
    NSMutableArray* _pageNumberList;
    SEL _action;
    SEL _loadingAction;
    NSTimer* _paginatedTimer;
    id<PaginatedUpdateCenterDelegate> _paginatedDelegate;
    int _currentPageNumber;
    int _pageSize;
}

@property(nonatomic,assign) id target;
@property(nonatomic,assign) BOOL isBusy;
@property(nonatomic,assign) int overallNumber;
@property(nonatomic,retain) NSMutableArray* pageNumberList;
@property(nonatomic) SEL action;
@property(nonatomic) SEL loadingAction;
@property(nonatomic,retain) NSTimer* paginatedTimer;
@property(nonatomic,assign) id<PaginatedUpdateCenterDelegate> paginatedDelegate;
@property(nonatomic,assign) int currentPageNumber;
@property(nonatomic,assign) int pageSize; 

//-(id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction overallNumber:(int)anOverallNubmer;
-(id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction overallNumber:(int)anOverallNubmer pageSize:(int)aPageSize;
-(void)createPageNumberList;
-(void)runTask;
-(void)stopTask;
-(int)totalPage;
-(float)progressValue;

@end
