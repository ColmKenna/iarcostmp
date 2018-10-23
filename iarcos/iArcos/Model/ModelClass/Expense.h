//
//  Expense.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expense : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * MeetingIUR;
@property (nonatomic, retain) NSNumber * VatAmount;
@property (nonatomic, retain) NSNumber * ChequeNumber;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * TotalAmount;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSDate * ExpDate;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * ApprovedbyIUR;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * Reimbursed;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * EXiur;
@property (nonatomic, retain) NSNumber * Receipted;

@end
