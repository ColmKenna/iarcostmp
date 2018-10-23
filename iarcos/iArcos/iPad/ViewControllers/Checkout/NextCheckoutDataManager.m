//
//  NextCheckoutDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutDataManager.h"

@implementation NextCheckoutDataManager
@synthesize sortedOrderKeys = _sortedOrderKeys;
//@synthesize orderLines = _orderLines;
//@synthesize orderHeader = _orderHeader;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.sortedOrderKeys = nil;
//    self.orderLines = nil;
//    self.orderHeader = nil;
    
    [super dealloc];
}

@end
