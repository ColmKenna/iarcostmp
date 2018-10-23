//
//  Docket.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Docket : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * OrderIUR;
@property (nonatomic, retain) NSString * DeliveryAddress2;
@property (nonatomic, retain) NSString * Reference;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * DeliveryAddress5;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSString * AcceptedBy;
@property (nonatomic, retain) NSString * DeliveryAddress3;
@property (nonatomic, retain) NSString * DeliveryAddress1;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSDate * DocketDate;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * STiur;
@property (nonatomic, retain) NSString * DeliveryAddress4;

@end
