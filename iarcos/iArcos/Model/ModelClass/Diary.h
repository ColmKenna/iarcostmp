//
//  Diary.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Diary : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * FullFilled;
@property (nonatomic, retain) NSNumber * EntryMadebyIUR;
@property (nonatomic, retain) NSNumber * APiur;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * JourneyIUR;
@property (nonatomic, retain) NSString * MeetWhere;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSDate * DateTime;
@property (nonatomic, retain) NSString * MeetWho;
@property (nonatomic, retain) NSNumber * Duration;
@property (nonatomic, retain) NSNumber * HighPriority;
@property (nonatomic, retain) NSNumber * MeetingIUR;

@end
