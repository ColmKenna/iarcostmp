//
//  Cheque.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cheque : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Amount;
@property (nonatomic, retain) NSNumber * ChequeNumber;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * AuthorizedbyIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSString * Payee;
@property (nonatomic, retain) NSDate * chqdate;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * PTIUR;
@property (nonatomic, retain) NSString * Comments;

@end
