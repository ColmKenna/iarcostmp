//
//  Package.h
//  iArcos
//
//  Created by Richard on 15/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Package : NSManagedObject

@property (nonatomic, retain) NSString *accountCode;
@property (nonatomic, retain) NSNumber *active;
@property (nonatomic, retain) NSNumber *allowBonus;
@property (nonatomic, retain) NSDate *dateLastModified;
@property (nonatomic, retain) NSNumber *defaultPackage;
@property (nonatomic, retain) NSNumber *formIUR;
@property (nonatomic, retain) NSNumber *iUR;
@property (nonatomic, retain) NSNumber *locationIUR;
@property (nonatomic, retain) NSNumber *pGiur;
@property (nonatomic, retain) NSNumber *wholesalerIUR;
@property (nonatomic, retain) NSNumber *xxIUR;
@property (nonatomic, retain) NSString *xxString;
@property (nonatomic, retain) NSNumber *yyIUR;

@end
