//
//  FlagsSelectedContactDataManager.m
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsSelectedContactDataManager.h"

@implementation FlagsSelectedContactDataManager
@synthesize displayList = _displayList;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
        
    [super dealloc];
}

@end
