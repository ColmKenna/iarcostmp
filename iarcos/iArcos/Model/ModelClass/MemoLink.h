//
//  MemoLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MemoLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * Seen;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * MemoIUR;

@end
