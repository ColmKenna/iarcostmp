//
//  News.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * ETiurS;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSString * EmailAddress;
@property (nonatomic, retain) NSDate * ExpiryDate;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSString * LinkAddress;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSDate * DDay;
@property (nonatomic, retain) NSNumber * NTIUR;
@property (nonatomic, retain) NSNumber * rowguid;

@end
