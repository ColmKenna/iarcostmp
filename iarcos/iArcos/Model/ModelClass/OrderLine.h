//
//  OrderLine.h
//  iArcos
//
//  Created by David Kilmartin on 26/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderHeader;

@interface OrderLine : NSManagedObject

@property (nonatomic, retain) NSNumber * Bonus;
@property (nonatomic, retain) NSNumber * CallCost;
@property (nonatomic, retain) NSDecimalNumber * CostPrice;
@property (nonatomic, retain) NSDecimalNumber * dealValue;
@property (nonatomic, retain) NSDate * DeliveryDate;
@property (nonatomic, retain) NSDecimalNumber * DiscountPercent;
@property (nonatomic, retain) NSNumber * FOC;
@property (nonatomic, retain) NSNumber * InStock;
@property (nonatomic, retain) NSNumber * InvoiceLineNumber;
@property (nonatomic, retain) NSString * InvoiceRef;
@property (nonatomic, retain) NSDecimalNumber * LineValue;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSDecimalNumber * NetRevenue;
@property (nonatomic, retain) NSDate * OrderDate;
@property (nonatomic, retain) NSNumber * OrderHeaderIUR;
@property (nonatomic, retain) NSNumber * OrderLine;
@property (nonatomic, retain) NSNumber * OrderLineIUR;
@property (nonatomic, retain) NSNumber * OrderNumber;
@property (nonatomic, retain) NSDecimalNumber * packFee;
@property (nonatomic, retain) NSNumber * Points;
@property (nonatomic, retain) NSNumber * PPIUR;
@property (nonatomic, retain) NSString * ProductCode;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * ProductIUR1;
@property (nonatomic, retain) NSNumber * Qty;
@property (nonatomic, retain) NSNumber * qtyDelivered;
@property (nonatomic, retain) NSNumber * QtyReturned;
@property (nonatomic, retain) NSDecimalNumber * RebatePercent;
@property (nonatomic, retain) NSDecimalNumber * rebateValue;
@property (nonatomic, retain) NSNumber * Testers;
@property (nonatomic, retain) NSDecimalNumber * TradeValue;
@property (nonatomic, retain) NSDecimalNumber * UnitPrice;
@property (nonatomic, retain) NSNumber * presenterIUR;
@property (nonatomic, retain) NSDecimalNumber* vatAmount;
@property (nonatomic, retain) NSNumber *units;
@property (nonatomic, retain) OrderHeader *orderheader;

@end
