//
//  StockTransaction.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StockTransaction : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * BatchCode;
@property (nonatomic, retain) NSNumber * StockValue;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * Qty;
@property (nonatomic, retain) NSNumber * OrderlineIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSDate * StockDate;
@property (nonatomic, retain) NSNumber * DocketIUR;
@property (nonatomic, retain) NSNumber * STiur;
@property (nonatomic, retain) NSDate * ExpiryDate;

@end
