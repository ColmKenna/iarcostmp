//
//  PTran.h
//  iArcos
//
//  Created by David Kilmartin on 21/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PTran : NSManagedObject

@property (nonatomic, retain) NSNumber * contactIUR;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * locationIUR;
@property (nonatomic, retain) NSNumber * presenterIUR;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
