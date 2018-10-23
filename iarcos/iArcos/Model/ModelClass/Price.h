//
//  Price.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Price : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * PGIUR;
@property (nonatomic, retain) NSNumber * MinimumUnitPrice;
@property (nonatomic, retain) NSDecimalNumber * DiscountPercent;
@property (nonatomic, retain) NSNumber * CurrencyIUR;
@property (nonatomic, retain) NSNumber * UnitTradePrice;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * AllowFree;
@property (nonatomic, retain) NSDecimalNumber * RebatePercent;
@property (nonatomic, retain) NSNumber * rowgrid;

@end
