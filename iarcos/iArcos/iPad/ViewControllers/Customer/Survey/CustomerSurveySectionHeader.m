//
//  CustomerSurveySectionHeader.m
//  iArcos
//
//  Created by David Kilmartin on 02/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySectionHeader.h"

@implementation CustomerSurveySectionHeader
@synthesize narrative = _narrative;

- (void)dealloc {
    self.narrative = nil;
    
    [super dealloc];
}

@end
