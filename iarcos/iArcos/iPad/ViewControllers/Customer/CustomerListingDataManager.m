//
//  CustomerListingDataManager.m
//  iArcos
//
//  Created by Richard on 09/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerListingDataManager.h"

@implementation CustomerListingDataManager
@synthesize popoverOpenFlag = _popoverOpenFlag;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.popoverOpenFlag = NO;
    }
    return self;
}

@end
