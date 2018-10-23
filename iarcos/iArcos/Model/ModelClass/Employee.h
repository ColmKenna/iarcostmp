//
//  Employee.h
//  Arcos
//
//  Created by David Kilmartin on 14/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSNumber * lastiur;
@property (nonatomic, retain) NSNumber * LastFormIURUsed;
@property (nonatomic, retain) NSString * EmployeeCode;
@property (nonatomic, retain) NSNumber * AllowAdd;
@property (nonatomic, retain) NSNumber * WeeklyReport;
@property (nonatomic, retain) NSNumber * AllowDelete;
@property (nonatomic, retain) NSString * Password;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * UseLastForm;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSNumber * LocationLookup;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * AllowWrite;
@property (nonatomic, retain) NSNumber * ForceProfiling;
@property (nonatomic, retain) NSNumber * NumberofweeksinCycle;
@property (nonatomic, retain) NSDate * LastDialup;
@property (nonatomic, retain) NSNumber * CTiur;
@property (nonatomic, retain) NSString * Surname;
@property (nonatomic, retain) NSNumber * OUiur;
@property (nonatomic, retain) NSNumber * LTiur;
@property (nonatomic, retain) NSString * DefaultCustomerView;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * UTiur;
@property (nonatomic, retain) NSNumber * Callcost;
@property (nonatomic, retain) NSString * Loginname;
@property (nonatomic, retain) NSDate * JourneyStartDate;
@property (nonatomic, retain) NSNumber * MergeID;
@property (nonatomic, retain) NSNumber * GetLocationSalesAnalysis;
@property (nonatomic, retain) NSNumber * FTiur;
@property (nonatomic, retain) NSNumber * EmployeeIUR;
@property (nonatomic, retain) NSNumber * OwnDataOnly;
@property (nonatomic, retain) NSNumber * DefaultDateType;
@property (nonatomic, retain) NSString * EncPassword;
@property (nonatomic, retain) NSNumber * SYiur;
@property (nonatomic, retain) NSString * FullName;
@property (nonatomic, retain) NSString * PhoneNumber;
@property (nonatomic, retain) NSNumber * OTiur;
@property (nonatomic, retain) NSString * MobileNumber;
@property (nonatomic, retain) NSString * HomeNumber;
@property (nonatomic, retain) NSNumber * SecurityLevel;
@property (nonatomic, retain) NSNumber * LastOrderNumber;
@property (nonatomic, retain) NSDate * PasswordLastChanged;
@property (nonatomic, retain) NSNumber * ImageIUR;
@property (nonatomic, retain) NSNumber * ETiur;
@property (nonatomic, retain) NSString * ForeName;

@end
