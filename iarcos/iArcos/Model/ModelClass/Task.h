//
//  Task.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * StartDate;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * Priority;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * TYiur;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSDate * CompletionDate;
@property (nonatomic, retain) NSDate * EndDate;
@property (nonatomic, retain) NSNumber * TSiur;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * textAlert;
@property (nonatomic, retain) NSNumber * rowgrid;
@property (nonatomic, retain) NSNumber * EmailAlert;

@end
