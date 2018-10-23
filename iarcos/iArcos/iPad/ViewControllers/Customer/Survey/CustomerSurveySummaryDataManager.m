//
//  CustomerSurveySummaryDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySummaryDataManager.h"

@implementation CustomerSurveySummaryDataManager
@synthesize displayList = _displayList;

- (instancetype)init{
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
