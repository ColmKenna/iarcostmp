//
//  Call.h
//  iArcos
//
//  Created by David Kilmartin on 16/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Memo, OrderHeader;

@interface Call : NSManagedObject

@property (nonatomic, retain) NSNumber * CallCost;
@property (nonatomic, retain) NSDate * CallDate;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * CTiur;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * enteredIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSNumber * MeetingIUR;
@property (nonatomic, retain) NSNumber * NextCallMemoIUR;
@property (nonatomic, retain) NSNumber * ReceptionLevelIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * ThisCallMemoIUR;
@property (nonatomic, retain) Memo *memo;
@property (nonatomic, retain) OrderHeader *orderheader;

@end
