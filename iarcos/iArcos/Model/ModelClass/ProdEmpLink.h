//
//  ProdEmpLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProdEmpLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ProductIUR;
@property (nonatomic, retain) NSNumber * ForDetailing;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * ForSampling;
@property (nonatomic, retain) NSNumber * rowguid;

@end
