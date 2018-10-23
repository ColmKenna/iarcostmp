//
//  Presenter.h
//  iArcos
//
//  Created by David Kilmartin on 21/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Presenter : NSManagedObject

@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * displaySequence;
@property (nonatomic, retain) NSNumber * employeeIUR;
@property (nonatomic, retain) NSNumber * FileTypeIUR;
@property (nonatomic, retain) NSNumber * FormIUR;
@property (nonatomic, retain) NSString * fullTitle;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * L1code;
@property (nonatomic, retain) NSString * L2code;
@property (nonatomic, retain) NSString * L3code;
@property (nonatomic, retain) NSString * L4code;
@property (nonatomic, retain) NSString * L5code;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSString * memoDetails;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * OnPromotion;
@property (nonatomic, retain) NSNumber * OrderLevel;
@property (nonatomic, retain) NSNumber * parentIUR;
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSNumber * minimumSeconds;

@end
