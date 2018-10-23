//
//  Collected.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Collected : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * ChequeReference;
@property (nonatomic, retain) NSNumber * AmountCollected;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSDate * DateCollected;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * CallIUR;

@end
