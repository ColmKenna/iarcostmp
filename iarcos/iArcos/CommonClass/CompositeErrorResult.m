//
//  CompositeErrorResult.m
//  iArcos
//
//  Created by David Kilmartin on 15/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "CompositeErrorResult.h"

@implementation CompositeErrorResult
@synthesize successFlag = _successFlag;
@synthesize errorMsg = _errorMsg;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.successFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.errorMsg = nil;
    
    [super dealloc];
}

@end
