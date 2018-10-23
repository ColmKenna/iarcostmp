//
//  Location.h
//  iArcos
//
//  Created by David Kilmartin on 21/09/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * accessTimes;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSString * Address1;
@property (nonatomic, retain) NSString * Address2;
@property (nonatomic, retain) NSString * Address3;
@property (nonatomic, retain) NSString * Address4;
@property (nonatomic, retain) NSString * Address5;
@property (nonatomic, retain) NSNumber * AgedAmount1;
@property (nonatomic, retain) NSNumber * AgedAmount2;
@property (nonatomic, retain) NSNumber * AgedAmount3;
@property (nonatomic, retain) NSNumber * AgedAmount4;
@property (nonatomic, retain) NSNumber * BonusBlocker;
@property (nonatomic, retain) NSNumber * CCiur;
@property (nonatomic, retain) NSString * CompanyNumber;
@property (nonatomic, retain) NSNumber * Competitor1;
@property (nonatomic, retain) NSNumber * Competitor2;
@property (nonatomic, retain) NSNumber * Competitor3;
@property (nonatomic, retain) NSNumber * CreditLimit;
@property (nonatomic, retain) NSNumber * CSiur;
@property (nonatomic, retain) NSNumber * CUiur;
@property (nonatomic, retain) NSString * DialupNumber;
@property (nonatomic, retain) NSString * EAN;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * FaxNumber;
@property (nonatomic, retain) NSString * FormList;
@property (nonatomic, retain) NSNumber * GMSCode;
@property (nonatomic, retain) NSNumber * Headoffice;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LastPaymentAmount;
@property (nonatomic, retain) NSDate * LastPaymentDate;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSString * LocationCode;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSNumber * lP0;
@property (nonatomic, retain) NSNumber * lP01;
@property (nonatomic, retain) NSNumber * lP02;
@property (nonatomic, retain) NSNumber * lP03;
@property (nonatomic, retain) NSNumber * lP04;
@property (nonatomic, retain) NSNumber * lP05;
@property (nonatomic, retain) NSNumber * lP06;
@property (nonatomic, retain) NSNumber * lP07;
@property (nonatomic, retain) NSNumber * lP08;
@property (nonatomic, retain) NSNumber * lP09;
@property (nonatomic, retain) NSNumber * lP10;
@property (nonatomic, retain) NSNumber * lP11;
@property (nonatomic, retain) NSNumber * lP12;
@property (nonatomic, retain) NSNumber * lP13;
@property (nonatomic, retain) NSNumber * lP14;
@property (nonatomic, retain) NSNumber * lP15;
@property (nonatomic, retain) NSNumber * lP16;
@property (nonatomic, retain) NSNumber * lP17;
@property (nonatomic, retain) NSNumber * lP18;
@property (nonatomic, retain) NSNumber * lP19;
@property (nonatomic, retain) NSNumber * lP20;
@property (nonatomic, retain) NSNumber * lsiur;
@property (nonatomic, retain) NSNumber * LTiur;
@property (nonatomic, retain) NSNumber * MasterLocationIUR;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * OustandingBalance;
@property (nonatomic, retain) NSNumber * OverrideBonusBlocker;
@property (nonatomic, retain) NSString * Password;
@property (nonatomic, retain) NSNumber * PGiur;
@property (nonatomic, retain) NSString * PhoneNumber;
@property (nonatomic, retain) NSString * Postcode;
@property (nonatomic, retain) NSNumber * PriceOverride;
@property (nonatomic, retain) NSString * PSINumber;
@property (nonatomic, retain) NSNumber * RCiur;
@property (nonatomic, retain) NSString * RegisteredAddress1;
@property (nonatomic, retain) NSString * RegisteredAddress2;
@property (nonatomic, retain) NSString * RegisteredAddress3;
@property (nonatomic, retain) NSString * RegisteredAddress4;
@property (nonatomic, retain) NSString * RegisteredName;
@property (nonatomic, retain) NSString * RouteNumber;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSString * ShortName;
@property (nonatomic, retain) NSString * SortKey;
@property (nonatomic, retain) NSNumber * TCiur;
@property (nonatomic, retain) NSString * Tradingas;
@property (nonatomic, retain) NSString * VATNumber;
@property (nonatomic, retain) NSString * Website;

@end
