//
//  RemoveLocationProductMatProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoveRecordProcessorDataManager.h"
#import "RemoveRecordProcessorDelegate.h"

@interface RemoveLocationProductMatProcessor : NSObject {
    id<RemoveRecordProcessorDelegate> _removeDelegate;
    RemoveRecordProcessorDataManager* _removeRecordProcessorDataManager;
    NSMutableArray* _locationProductMatList;
    int _overallMatCount;
    BOOL _isBusy;
    NSTimer* _removeRecordTimer;
}

@property(nonatomic, assign) id<RemoveRecordProcessorDelegate> removeDelegate;
@property(nonatomic, retain) RemoveRecordProcessorDataManager* removeRecordProcessorDataManager;
@property(nonatomic, retain) NSMutableArray* locationProductMatList;
@property(nonatomic, assign) int overallMatCount;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* removeRecordTimer;

- (void)runTask;
//- (void)stopTask;

@end
