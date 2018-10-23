//
//  RemoveRecordProcessMachine.m
//  iArcos
//
//  Created by David Kilmartin on 09/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "RemoveRecordProcessMachine.h"

@implementation RemoveRecordProcessMachine
@synthesize removeDelegate = _removeDelegate;
@synthesize isProcessingFinished = _isProcessingFinished;
@synthesize removeLocationProductMatProcessor = _removeLocationProductMatProcessor;
@synthesize removeOrderHeaderProcessor = _removeOrderHeaderProcessor;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.isProcessingFinished = YES;
    }
    return self;
}

- (void)dealloc {
    self.removeLocationProductMatProcessor = nil;
    self.removeOrderHeaderProcessor = nil;
    
    [super dealloc];
}

- (void)removeLocationProductMatRecord {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        self.removeLocationProductMatProcessor = [[[RemoveLocationProductMatProcessor alloc] init] autorelease];        
        self.removeLocationProductMatProcessor.removeDelegate = self;
        if (self.removeLocationProductMatProcessor.overallMatCount <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.removeLocationProductMatProcessor runTask];
    }    
}

- (void)removeOrderHeaderRecord {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        self.removeOrderHeaderProcessor = [[[RemoveOrderHeaderProcessor alloc] init] autorelease];
        self.removeOrderHeaderProcessor.removeDelegate = self;
        if (self.removeOrderHeaderProcessor.overallOrderHeaderCount <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.removeOrderHeaderProcessor runTask];
    }
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
    self.isProcessingFinished = YES;
}

- (void)didFinishRemoveRecordUpdateCenter {
    
}


@end
