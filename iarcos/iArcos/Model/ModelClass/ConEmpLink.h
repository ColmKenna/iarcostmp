//
//  ConEmpLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConEmpLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * DefaultLink;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * rowguid;

@end
