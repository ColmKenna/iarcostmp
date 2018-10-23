//
//  LocLocLink.h
//  iArcos
//
//  Created by David Kilmartin on 16/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocLocLink : NSManagedObject

@property (nonatomic, retain) NSString * CustomerCode;
@property (nonatomic, retain) NSNumber * FromLocationIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LinkType;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * preference;
@property (nonatomic, retain) NSNumber * rowguid;

@end
