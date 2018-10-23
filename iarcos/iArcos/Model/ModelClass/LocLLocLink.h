//
//  LocLLocLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocLLocLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * CustomerCode;
@property (nonatomic, retain) NSNumber * FromLocationIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * rowguid;

@end
