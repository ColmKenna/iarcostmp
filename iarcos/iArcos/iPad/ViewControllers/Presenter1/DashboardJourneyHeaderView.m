//
//  DashboardJourneyHeaderView.m
//  iArcos
//
//  Created by David Kilmartin on 08/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardJourneyHeaderView.h"

@implementation DashboardJourneyHeaderView
@synthesize customerName = _customerName;
@synthesize status = _status;
@synthesize horizontalSeparator = _horizontalSeparator;

- (void)dealloc {
    self.customerName = nil;
    self.status = nil;
    self.horizontalSeparator = nil;
    
    [super dealloc];
}


@end
