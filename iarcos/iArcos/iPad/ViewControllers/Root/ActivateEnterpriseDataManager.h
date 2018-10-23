//
//  ActivateEnterpriseDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 24/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "ConnectivityCheck.h"
#import "ArcosUtils.h"

@interface ActivateEnterpriseDataManager : NSObject <AsyncWebConnectionDelegate> {
    ConnectivityCheck* _connectivityCheck;
    id<AsyncWebConnectionDelegate> _asyncDelegate;
    NSString* _serviceAddress;
    NSString* _sqlName;
    NSNumber* _employeeIURNumber;
}

@property(nonatomic, retain) ConnectivityCheck* connectivityCheck;
@property(nonatomic, assign) id<AsyncWebConnectionDelegate> asyncDelegate;
@property(nonatomic, retain) NSString* serviceAddress;
@property(nonatomic, retain) NSString* sqlName;
@property(nonatomic, retain) NSNumber* employeeIURNumber;

- (BOOL)validateRegCode:(NSString*)aServiceAddress;
- (void)validateAccessCode:(NSString*)anAccessCode;
- (void)updateServiceAddress;
- (void)updateSqlName;
- (void)updateEmployeeIURNumber;

@end
