//
//  Memo.h
//  Arcos
//
//  Created by David Kilmartin on 22/08/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Call, OrderHeader;

@interface Memo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * FullFilled;
@property (nonatomic, retain) NSString * Subject;
@property (nonatomic, retain) NSString * TableName;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * TableIUR;
@property (nonatomic, retain) NSNumber * MTIUR;
@property (nonatomic, retain) NSDate * DateEntered;
@property (nonatomic, retain) OrderHeader * orderheader;
@property (nonatomic, retain) Call * call;

@end
