//
//  CustomerContactInfoDataManager.m
//  iArcos
//
//  Created by Richard on 10/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerContactInfoDataManager.h"

@implementation CustomerContactInfoDataManager
@synthesize popoverOpenFlag = _popoverOpenFlag;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.popoverOpenFlag = NO;
    }
    return self;
}

@end
