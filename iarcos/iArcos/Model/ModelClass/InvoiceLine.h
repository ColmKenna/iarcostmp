//
//  InvoiceLine.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InvoiceLine : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * CurrencyValue;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * BonusValue;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSDate * LineDate;
@property (nonatomic, retain) NSString * comments2;
@property (nonatomic, retain) NSNumber * OrderLineNumber;
@property (nonatomic, retain) NSNumber * Points;
@property (nonatomic, retain) NSNumber * Qty;
@property (nonatomic, retain) NSNumber * InvoiceLineNumber;
@property (nonatomic, retain) NSNumber * LineValue;
@property (nonatomic, retain) NSNumber * CostPrice;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * BonusQty;
@property (nonatomic, retain) NSString * ProductCode;
@property (nonatomic, retain) NSNumber * Reference;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * OrderNumber;
@property (nonatomic, retain) NSString * comments1;

@end
