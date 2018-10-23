//
//  OrderHeader.h
//  Arcos
//
//  Created by David Kilmartin on 26/10/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Call, CallTran, Memo, OrderLine;

@interface OrderHeader : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * enteredIUR;
@property (nonatomic, retain) NSString * wholesalerCode;
@property (nonatomic, retain) NSNumber * CallDuration;
@property (nonatomic, retain) NSString * DeliveryInstructions2;
@property (nonatomic, retain) NSNumber * Points;
@property (nonatomic, retain) NSNumber * FormIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * PromotionIUR;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSNumber * OSiur;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSNumber * OrderNumber;
@property (nonatomic, retain) NSDate * EnteredDate;
@property (nonatomic, retain) NSDate * OrderDate;
@property (nonatomic, retain) NSDecimalNumber * TotalVat;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSDecimalNumber * ExchangeRate;
@property (nonatomic, retain) NSString * InvoiseRef;
@property (nonatomic, retain) NSNumber * DocketIUR;
@property (nonatomic, retain) NSNumber * WholesaleIUR;
@property (nonatomic, retain) NSDecimalNumber * TotalGoods;
@property (nonatomic, retain) NSDecimalNumber * TotalNetRevenue;
@property (nonatomic, retain) NSNumber * PointsIUR;
@property (nonatomic, retain) NSNumber * DSiur;
@property (nonatomic, retain) NSNumber * TotalQty;
@property (nonatomic, retain) NSDecimalNumber * TotalBonusValue;
@property (nonatomic, retain) NSNumber * TotalBonus;
@property (nonatomic, retain) NSString * LocationCode;
@property (nonatomic, retain) NSString * DeliveryInstructions1;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * TotalFOC;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSNumber * PosteedIUR;
@property (nonatomic, retain) NSDate * DeliveryDate;
@property (nonatomic, retain) NSNumber * OTiur;
@property (nonatomic, retain) NSString * CustomerRef;
@property (nonatomic, retain) NSNumber * NumberOflines;
@property (nonatomic, retain) NSNumber * TotalTesters;
@property (nonatomic, retain) NSDecimalNumber * CallCost;
@property (nonatomic, retain) NSNumber * OrderHeaderIUR;
@property (nonatomic, retain) NSSet* orderlines;
@property (nonatomic, retain) Call * call;
@property (nonatomic, retain) Memo * memo;
@property (nonatomic, retain) NSSet* calltrans;

- (void)addOrderlines:(NSSet *)value;
- (void)addCalltrans:(NSSet *)value;
@end
