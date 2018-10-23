//
//  FormRow.h
//  Arcos
//
//  Created by David Kilmartin on 16/08/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FormRow : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSNumber * FormRowIUR;
@property (nonatomic, retain) NSDecimalNumber * TradePrice;
@property (nonatomic, retain) NSNumber * SequenceNumber;
@property (nonatomic, retain) NSNumber * SequenceDivider;
@property (nonatomic, retain) NSNumber * FOCavailable;
@property (nonatomic, retain) NSNumber * TestersAvailable;
@property (nonatomic, retain) NSNumber * DefaultQty;
@property (nonatomic, retain) NSNumber * FOCRO;
@property (nonatomic, retain) NSNumber * Level5IUR;
@property (nonatomic, retain) NSNumber * rowgid;
@property (nonatomic, retain) NSNumber * Bonus;
@property (nonatomic, retain) NSDecimalNumber * UnitPrice;
@property (nonatomic, retain) NSNumber * Qty;
@property (nonatomic, retain) NSString * DividerDescription;
@property (nonatomic, retain) NSNumber * Bon1Available;
@property (nonatomic, retain) NSDecimalNumber * LineValue;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * FormIUR;
@property (nonatomic, retain) NSDecimalNumber * DiscountPercent;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSString * SortKey;
@property (nonatomic, retain) NSNumber * Bon1RO;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * TesterRO;

@end
