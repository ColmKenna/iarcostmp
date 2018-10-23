//
//  PhotoTransferProcessMachine.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "PhotoTransferProcessMachineDelegate.h"

@interface PhotoTransferProcessMachine : NSObject {
    id<PhotoTransferProcessMachineDelegate> _transferDelegate;
    BOOL _isBusy;
    NSTimer* _fileTimer;
    id _target;
    SEL _action;
    SEL _loadingAction;
    NSMutableArray* _collectedDictList;
    NSDictionary* _currentCollectedDict;
    int _overallFileCount;
    int _successfulFileCount;
}

@property(nonatomic, assign) id<PhotoTransferProcessMachineDelegate> transferDelegate;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* fileTimer;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL action;
@property(nonatomic, assign) SEL loadingAction;
@property(nonatomic, retain) NSMutableArray* collectedDictList;
@property(nonatomic, retain) NSDictionary* currentCollectedDict;
@property(nonatomic, assign) int overallFileCount;
@property(nonatomic, assign) int successfulFileCount;

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction dataDictList:(NSMutableArray*)aDataDictList;
- (NSString*)retrieveEmployeeName;
- (void)runTask;
- (void)stopTask;
- (float)progressValue;
- (void)saveResultToCollectedTable:(int)aResultValue;

@end
