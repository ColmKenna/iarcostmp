//
//  RemoveOrderHeaderProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 11/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoveRecordProcessorDelegate.h"
#import "RemoveRecordProcessorDataManager.h"

@interface RemoveOrderHeaderProcessor : NSObject {
    id<RemoveRecordProcessorDelegate> _removeDelegate;
    RemoveRecordProcessorDataManager* _removeRecordProcessorDataManager;
    NSMutableArray* _orderHeaderList;
    int _overallOrderHeaderCount;
    BOOL _isBusy;
    NSTimer* _removeRecordTimer;
}

@property(nonatomic, assign) id<RemoveRecordProcessorDelegate> removeDelegate;
@property(nonatomic, retain) RemoveRecordProcessorDataManager* removeRecordProcessorDataManager;
@property(nonatomic, retain) NSMutableArray* orderHeaderList;
@property(nonatomic, assign) int overallOrderHeaderCount;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* removeRecordTimer;

- (void)runTask;

@end
