//
//  CallTran.h
//  Arcos
//
//  Created by David Kilmartin on 26/10/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderHeader;

@interface CallTran : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Fullfilled;
@property (nonatomic, retain) NSString * Reference;
@property (nonatomic, retain) NSNumber * Score;
@property (nonatomic, retain) NSString * DetailLevelIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * DetailIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * DTiur;
@property (nonatomic, retain) NSNumber * CAllIUR;
@property (nonatomic, retain) NSDate * Calldate;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * CallTranIUR;
@property (nonatomic, retain) OrderHeader * orderheader;

@end
