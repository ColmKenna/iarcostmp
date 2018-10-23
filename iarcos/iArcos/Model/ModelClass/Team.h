//
//  Team.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Team : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSNumber * locationIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * TTiur;
@property (nonatomic, retain) NSNumber * rowgrid;
@property (nonatomic, retain) NSNumber * Active;

@end
