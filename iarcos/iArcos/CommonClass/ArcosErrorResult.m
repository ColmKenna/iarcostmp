//
//  ArcosErrorResult.m
//  Arcos
//
//  Created by David Kilmartin on 27/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosErrorResult.h"

@implementation ArcosErrorResult
@synthesize successFlag = _successFlag;
@synthesize errorDesc = _errorDesc;

- (id)init {
    self = [super init];
    if (self) {
        self.successFlag = YES;
        self.errorDesc = @"";
    }
    return self;
}

- (void)dealloc {
    if (self.errorDesc != nil) {
        self.errorDesc = nil;
    }
    
    [super dealloc];
}

@end
