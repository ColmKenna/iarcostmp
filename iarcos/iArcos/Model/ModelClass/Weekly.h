//
//  Weekly.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weekly : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Narrative1;
@property (nonatomic, retain) NSNumber * SunIUR;
@property (nonatomic, retain) NSNumber * TueIUR;
@property (nonatomic, retain) NSString * Narrative3;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSDate * WeekendDate;
@property (nonatomic, retain) NSNumber * PersonalMileage;
@property (nonatomic, retain) NSNumber * WedIUR;
@property (nonatomic, retain) NSNumber * FriIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * EndMillage;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSString * Narrative2;
@property (nonatomic, retain) NSNumber * MonIUR;
@property (nonatomic, retain) NSNumber * StartMileage;
@property (nonatomic, retain) NSString * Narrative4;
@property (nonatomic, retain) NSNumber * ThursIUR;
@property (nonatomic, retain) NSNumber * SatIUR;

@end
