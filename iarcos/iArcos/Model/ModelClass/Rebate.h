//
//  Rebate.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rebate : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * masterLocation;
@property (nonatomic, retain) NSNumber * Rebate;
@property (nonatomic, retain) NSNumber * PricetoWholesaler;
@property (nonatomic, retain) NSNumber * Bonus;
@property (nonatomic, retain) NSNumber * Qty;
@property (nonatomic, retain) NSDate * DateofRebate;
@property (nonatomic, retain) NSNumber * TradePrice;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * RevenueRebate;
@property (nonatomic, retain) NSNumber * RebatePercent;

@end
