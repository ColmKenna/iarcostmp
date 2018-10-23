//
//  RequestItem.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequestItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSDate * DateRequired;
@property (nonatomic, retain) NSNumber * RequestIUR;
@property (nonatomic, retain) NSDate * DateFullFilled;
@property (nonatomic, retain) NSNumber * RSiur;
@property (nonatomic, retain) NSNumber * Quantity;
@property (nonatomic, retain) NSNumber * PIiur;
@property (nonatomic, retain) NSNumber * Rowguid;

@end
