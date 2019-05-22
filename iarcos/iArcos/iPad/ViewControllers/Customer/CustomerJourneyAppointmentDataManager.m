//
//  CustomerJourneyAppointmentDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 21/05/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyAppointmentDataManager.h"

@implementation CustomerJourneyAppointmentDataManager
@synthesize callDate = _callDate;



- (void)dealloc {
    self.callDate = nil;
    
    [super dealloc];
}

@end
