//
//  CustomerJourneyAppointmentDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 21/05/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerJourneyAppointmentDataManager : NSObject {
    NSDate* _callDate;
    
}

@property(nonatomic, retain) NSDate* callDate;

@end


