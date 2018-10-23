//
//  Contact.h
//  iArcos
//
//  Created by David Kilmartin on 09/10/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * accessTimes;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * CLiur;
@property (nonatomic, retain) NSNumber * COiur;
@property (nonatomic, retain) NSNumber * cP01;
@property (nonatomic, retain) NSNumber * cP02;
@property (nonatomic, retain) NSNumber * cP03;
@property (nonatomic, retain) NSNumber * cP04;
@property (nonatomic, retain) NSNumber * cP05;
@property (nonatomic, retain) NSNumber * cP06;
@property (nonatomic, retain) NSNumber * cP07;
@property (nonatomic, retain) NSNumber * cP08;
@property (nonatomic, retain) NSNumber * cP09;
@property (nonatomic, retain) NSNumber * cP10;
@property (nonatomic, retain) NSNumber * cP11;
@property (nonatomic, retain) NSNumber * cP12;
@property (nonatomic, retain) NSNumber * cP13;
@property (nonatomic, retain) NSNumber * cP14;
@property (nonatomic, retain) NSNumber * cP15;
@property (nonatomic, retain) NSNumber * cP16;
@property (nonatomic, retain) NSNumber * cP17;
@property (nonatomic, retain) NSNumber * cP18;
@property (nonatomic, retain) NSNumber * cP19;
@property (nonatomic, retain) NSNumber * cP20;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * Forename;
@property (nonatomic, retain) NSString * Initial;
@property (nonatomic, retain) NSNumber * InitialIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSDate * Lastcall;
@property (nonatomic, retain) NSNumber * linkedContactIUR;
@property (nonatomic, retain) NSNumber * MemoIUR;
@property (nonatomic, retain) NSString * MobileNumber;
@property (nonatomic, retain) NSDate * NextCall;
@property (nonatomic, retain) NSString * PhoneNumber;
@property (nonatomic, retain) NSString * registeredNumber;
@property (nonatomic, retain) NSNumber * SecondIUR;
@property (nonatomic, retain) NSString * Surname;

@end
