//
//  RemoveRecordUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "RemoveRecordUpdateCenter.h"

@implementation RemoveRecordUpdateCenter
@synthesize removeDelegate = _removeDelegate;
@synthesize removeRecordProcessMachine = _removeRecordProcessMachine;
@synthesize selectorList = _selectorList;
@synthesize currentSelectorDict = _currentSelectorDict;
@synthesize performTimer = _performTimer;
@synthesize isBusy = _isBusy;
@synthesize matTitle = _matTitle;
@synthesize orderCallTitle = _orderCallTitle;
@synthesize completedSelector = _completedSelector;
@synthesize completedOverallNumber = _completedOverallNumber;

- (instancetype)initWithCompletedSelector:(SEL)aSelector {
    self = [super init];
    if (self != nil) {
        self.completedSelector = aSelector;
        self.matTitle = @"MAT";
        self.orderCallTitle = @"Order/Call";
        self.removeRecordProcessMachine = [[[RemoveRecordProcessMachine alloc] init] autorelease];
        self.removeRecordProcessMachine.removeDelegate = self;
        self.selectorList = [NSMutableArray array];
        self.isBusy = NO;
    }
    return self;
}

- (void)dealloc {
    self.removeRecordProcessMachine = nil;
    self.selectorList = nil;
    self.currentSelectorDict = nil;
    self.performTimer = nil;
    self.matTitle = nil;
    self.orderCallTitle = nil;
    
    [super dealloc];
}

- (void)pushSelector:(SEL)aSelector name:(NSString*)aName {
    NSDictionary* tmpSelDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithPointer:aSelector], aName, nil] forKeys:[NSArray arrayWithObjects:@"selector", @"name", nil]];
    [self.selectorList addObject:tmpSelDict];
}

- (NSDictionary*)popSelector {
    if ([self.selectorList count] > 0) {
        NSDictionary* tmpDict = [[[self.selectorList lastObject] retain] autorelease];
        if (tmpDict) {
            [self.selectorList removeLastObject];
        } else {
            return nil;
        }
        
        self.currentSelectorDict = tmpDict;
        return tmpDict;
    }
    return nil;
}

- (void)stopTask {
    [self.performTimer invalidate];
    self.performTimer = nil;
    [self.selectorList removeAllObjects];
    self.isBusy = NO;
//    self.itemsWebServiceProcessor.isProcessingFinished = YES;
}

- (void)startPerformSelectorList {
    if ([self.selectorList count] <= 0 || self.isBusy) return;
        
    self.isBusy = YES;
    self.performTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkSelectorStack) userInfo:nil repeats:YES];
}

- (void)checkSelectorStack {
    if (!self.removeRecordProcessMachine.isProcessingFinished) return;
    if ([self.selectorList count] <= 0) {
        [self.performTimer invalidate];
        self.performTimer = nil;
        [self.removeDelegate didFinishRemoveRecordUpdateCenter];
        self.isBusy = NO;
    } else {
        NSDictionary* topSelectorDict = [self popSelector];
        if (topSelectorDict == nil) return;
        SEL topSelector = [[topSelectorDict objectForKey:@"selector"] pointerValue];
        [self.removeRecordProcessMachine performSelector:topSelector];
    }
}

- (void)buildProcessSelectorList {
    [self.selectorList removeAllObjects];
    [self pushSelector:@selector(removeLocationProductMatRecord) name:self.matTitle];
    [self pushSelector:@selector(removeOrderHeaderRecord) name:self.orderCallTitle];
}

#pragma mark RemoveRecordProcessorDelegate
- (void)updateRemoveRecordProgressBar:(float)aValue {
    [self.removeDelegate updateRemoveRecordProgressBar:aValue];
}

- (void)updateRemoveRecordProgressBarWithoutAnimation:(float)aValue {
    [self.removeDelegate updateRemoveRecordProgressBarWithoutAnimation:aValue];
}

- (void)updateRemoveStatusTextWithValue:(NSString*)aValue {
    [self.removeDelegate updateRemoveStatusTextWithValue:aValue];
}

- (void)removeRecordProcessCompleted {
    [self.removeDelegate removeRecordProcessCompleted];
}

- (void)didFinishRemoveRecordUpdateCenter {
    [self.removeDelegate didFinishRemoveRecordUpdateCenter];
}

@end
