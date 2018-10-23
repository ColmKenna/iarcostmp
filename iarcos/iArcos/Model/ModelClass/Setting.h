//
//  Setting.h
//  Arcos
//
//  Created by David Kilmartin on 22/08/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Setting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * WholesalerTypeIUR;
@property (nonatomic, retain) NSNumber * PendingOrderIUR;
@property (nonatomic, retain) NSNumber * OrderTypeIUR;
@property (nonatomic, retain) NSNumber * CallTypeIUR;
@property (nonatomic, retain) NSNumber * MemoTypeIUR;
@property (nonatomic, retain) NSNumber * NeedInactiveRecord;
@property (nonatomic, retain) NSNumber * DefaultFormIUR;
@property (nonatomic, retain) NSString * DownloadServer;
@property (nonatomic, retain) NSString * WebServiceServer;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * NextOrderNumber;

@end
