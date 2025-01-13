//
//  CustomerListingMapDataManager.m
//  iArcos
//
//  Created by Richard on 09/01/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerListingMapDataManager.h"

@implementation CustomerListingMapDataManager
@synthesize displayList = _displayList;


- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

@end
