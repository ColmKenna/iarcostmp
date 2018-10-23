//
//  InvoiceHeader.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InvoiceHeader : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * NumberOfLines;
@property (nonatomic, retain) NSNumber * ISiur;
@property (nonatomic, retain) NSString * CustomerRef;
@property (nonatomic, retain) NSDecimalNumber * ExtraCharge;
@property (nonatomic, retain) NSString * Comments2;
@property (nonatomic, retain) NSNumber * TotalCurrency;
@property (nonatomic, retain) NSNumber * WholesalerIUR;
@property (nonatomic, retain) NSNumber * ITiur;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * Points;
@property (nonatomic, retain) NSString * LocationCode;
@property (nonatomic, retain) NSDecimalNumber * ExchangeRates;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * Comments1;
@property (nonatomic, retain) NSNumber * TotalVAT;
@property (nonatomic, retain) NSNumber * TotalGoods;
@property (nonatomic, retain) NSDate * InvDate;
@property (nonatomic, retain) NSNumber * TotalBonus;
@property (nonatomic, retain) NSNumber * TotalQty;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * WholesaleIUR;
@property (nonatomic, retain) NSNumber * Reference;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * OrderNumber;

@end
