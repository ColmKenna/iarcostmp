//
//  Product.h
//  iArcos
//
//  Created by David Kilmartin on 04/06/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSString * AdvertFiles;
@property (nonatomic, retain) NSString * BackgroundFile;
@property (nonatomic, retain) NSString * BlackBonus;
@property (nonatomic, retain) NSNumber * Bonusby;
@property (nonatomic, retain) NSNumber * BonusGiven;
@property (nonatomic, retain) NSNumber * BonusMinimum;
@property (nonatomic, retain) NSNumber * BonusRequired;
@property (nonatomic, retain) NSNumber * CasesPerPallet;
@property (nonatomic, retain) NSString * CatalogCode;
@property (nonatomic, retain) NSString * ColumnDescription;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * DetailingFiles;
@property (nonatomic, retain) NSString * EAN;
@property (nonatomic, retain) NSNumber * EmployeeTypeIUR;
@property (nonatomic, retain) NSNumber * FlagIUR;
@property (nonatomic, retain) NSNumber * FOrDetailing;
@property (nonatomic, retain) NSNumber * ForSampling;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * L1Code;
@property (nonatomic, retain) NSString * L2Code;
@property (nonatomic, retain) NSString * L3Code;
@property (nonatomic, retain) NSString * L4Code;
@property (nonatomic, retain) NSString * L5Code;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSNumber * MinimumOrderQuantity;
@property (nonatomic, retain) NSNumber * MinimumUnitPrice;
@property (nonatomic, retain) NSNumber * MiscToggle;
@property (nonatomic, retain) NSString * OrderPadDetails;
@property (nonatomic, retain) NSString * PackEAN;
@property (nonatomic, retain) NSString * PackFiles;
@property (nonatomic, retain) NSNumber * PacksPerCase;
@property (nonatomic, retain) NSNumber * PIcodes;
@property (nonatomic, retain) NSNumber * Points;
@property (nonatomic, retain) NSString * POSFiles;
@property (nonatomic, retain) NSString * ProductCode;
@property (nonatomic, retain) NSString * ProductColour;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSString * Productsize;
@property (nonatomic, retain) NSString * RadioFiles;
@property (nonatomic, retain) NSNumber * RecordDistribution;
@property (nonatomic, retain) NSString * Reference;
@property (nonatomic, retain) NSNumber * RepacementIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * SamplesAvailable;
@property (nonatomic, retain) NSString * Scoreprocedure;
@property (nonatomic, retain) NSNumber * SellBy;
@property (nonatomic, retain) NSNumber * StockAvailable;
@property (nonatomic, retain) NSDate * StockDueDate;
@property (nonatomic, retain) NSNumber * StockonHand;
@property (nonatomic, retain) NSNumber * StockonOrder;
@property (nonatomic, retain) NSNumber * UnitManufacturePrice;
@property (nonatomic, retain) NSNumber * UnitRevenueAmount;
@property (nonatomic, retain) NSNumber * UnitRRP;
@property (nonatomic, retain) NSNumber * UnitsPerPack;
@property (nonatomic, retain) NSDecimalNumber * UnitTradePrice;
@property (nonatomic, retain) NSNumber * VCIUR;
@property (nonatomic, retain) NSString * wwwLink;

@end
