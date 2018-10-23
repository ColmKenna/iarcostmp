//
//  DateRange.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DateRange : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * Number;
@property (nonatomic, retain) NSNumber * RangeType;
@property (nonatomic, retain) NSNumber * WorkingDays;
@property (nonatomic, retain) NSString * Nextyearend;
@property (nonatomic, retain) NSDate * StartDate;
@property (nonatomic, retain) NSDate * EndDate;
@property (nonatomic, retain) NSString * ShortDescription;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSString * Description;

@end
