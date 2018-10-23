//
//  Request.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Request : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Amount;
@property (nonatomic, retain) NSNumber * ChequeNumber;
@property (nonatomic, retain) NSDate * DateRequested;
@property (nonatomic, retain) NSDate * DateFullFilled;
@property (nonatomic, retain) NSNumber * CallIUR;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * Memoiur;
@property (nonatomic, retain) NSNumber * RTIUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * ChequetoRep;
@property (nonatomic, retain) NSString * ChequePayee;
@property (nonatomic, retain) NSNumber * RSiur;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * STiur;

@end
