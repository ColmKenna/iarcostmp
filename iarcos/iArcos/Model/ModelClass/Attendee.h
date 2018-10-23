//
//  Attendee.h
//  iArcos
//
//  Created by David Kilmartin on 16/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Attendee : NSManagedObject

@property (nonatomic, retain) NSString * Address1;
@property (nonatomic, retain) NSString * Address2;
@property (nonatomic, retain) NSString * Address3;
@property (nonatomic, retain) NSString * Address4;
@property (nonatomic, retain) NSString * Address5;
@property (nonatomic, retain) NSNumber * Attended;
@property (nonatomic, retain) NSNumber * cOiur;
@property (nonatomic, retain) NSNumber * Confirmed;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * Informed;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * MeetingIUR;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Organisation;
@property (nonatomic, retain) NSNumber * rowguid;

@end
