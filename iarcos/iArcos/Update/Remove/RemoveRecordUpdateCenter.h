//
//  RemoveRecordUpdateCenter.h
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoveRecordProcessMachine.h"

@interface RemoveRecordUpdateCenter : NSObject <RemoveRecordProcessorDelegate> {
    id<RemoveRecordProcessorDelegate> _removeDelegate;
    RemoveRecordProcessMachine* _removeRecordProcessMachine;
    NSMutableArray* _selectorList;
    NSDictionary* _currentSelectorDict;
    NSTimer* _performTimer;
    BOOL _isBusy;
    NSString* _matTitle;
    NSString* _orderCallTitle;
    SEL _completedSelector;
    int _completedOverallNumber;
}

@property(nonatomic, assign) id<RemoveRecordProcessorDelegate> removeDelegate;
@property(nonatomic, retain) RemoveRecordProcessMachine* removeRecordProcessMachine;
@property(nonatomic, retain) NSMutableArray* selectorList;
@property(nonatomic, retain) NSDictionary* currentSelectorDict;
@property(nonatomic, retain) NSTimer* performTimer;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSString* matTitle;
@property(nonatomic, retain) NSString* orderCallTitle;
@property(nonatomic, assign) SEL completedSelector;
@property(nonatomic, assign) int completedOverallNumber;

- (instancetype)initWithCompletedSelector:(SEL)aSelector;
- (void)pushSelector:(SEL)aSelector name:(NSString*)aName;
- (NSDictionary*)popSelector;
- (void)stopTask;
- (void)startPerformSelectorList;
- (void)buildProcessSelectorList;

@end
