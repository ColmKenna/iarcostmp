//
//  LocProdLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocProdLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * StockAvailable;
@property (nonatomic, retain) NSNumber * StockLowQty;
@property (nonatomic, retain) NSNumber * StockOnOrder;
@property (nonatomic, retain) NSString * ProductCode;
@property (nonatomic, retain) NSNumber * BlockBonus;
@property (nonatomic, retain) NSString * WholesalerCode;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSDate * StockDueDate;

@end
