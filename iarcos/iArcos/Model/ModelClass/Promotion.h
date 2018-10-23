//
//  Promotion.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Promotion : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * LevelCode;
@property (nonatomic, retain) NSString * Advertfiles;
@property (nonatomic, retain) NSNumber * DiscountRate;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * PackFiles;
@property (nonatomic, retain) NSNumber * BonusGiven;
@property (nonatomic, retain) NSNumber * DiscountQTY;
@property (nonatomic, retain) NSString * POSFiles;
@property (nonatomic, retain) NSString * PIcode;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * MemoIUr;
@property (nonatomic, retain) NSString * BackgroundFiles;
@property (nonatomic, retain) NSDate * StartDate;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * MinmumQty;
@property (nonatomic, retain) NSNumber * PromotionLevel;
@property (nonatomic, retain) NSString * RadioFiles;
@property (nonatomic, retain) NSNumber * QtyRequired;
@property (nonatomic, retain) NSDate * EndDate;
@property (nonatomic, retain) NSNumber * ProductIUR;

@end
