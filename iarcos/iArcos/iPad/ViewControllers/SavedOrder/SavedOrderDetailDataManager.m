//
//  SavedOrderDetailDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 21/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "SavedOrderDetailDataManager.h"

@implementation SavedOrderDetailDataManager
@synthesize sendingSuccessFlag = _sendingSuccessFlag;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.sendingSuccessFlag = NO;
    }
    return self;
}

- (void)normaliseData {
    self.sendingSuccessFlag = NO;
}

@end
