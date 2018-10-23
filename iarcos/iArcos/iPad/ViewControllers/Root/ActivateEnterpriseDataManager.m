//
//  ActivateEnterpriseDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 24/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateEnterpriseDataManager.h"

@implementation ActivateEnterpriseDataManager
@synthesize connectivityCheck = _connectivityCheck;
@synthesize asyncDelegate = _asyncDelegate;
@synthesize serviceAddress = _serviceAddress;
@synthesize sqlName = _sqlName;
@synthesize employeeIURNumber = _employeeIURNumber;

- (id)init{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.connectivityCheck = nil;
    self.serviceAddress = nil;
    self.sqlName = nil;
    self.employeeIURNumber = nil;
    
    [super dealloc];
}

- (BOOL)validateRegCode:(NSString*)aServiceAddress {
    SettingManager* settingManager = [SettingManager setting];
    NSString* keyPath = @"CompanySetting.Connection";
    [settingManager updateSettingForKeypath:keyPath atIndex:1 withData:aServiceAddress];
    [settingManager saveSetting];
    self.connectivityCheck = [[[ConnectivityCheck alloc] init] autorelease];
    self.connectivityCheck.isRegisterValidation = YES;
    self.connectivityCheck.asyncDelegate = self;
    [self.connectivityCheck asyncWebStart];
    return NO;
}

- (void)validateAccessCode:(NSString*)anAccessCode {
    
}

- (void)asyncConnectionResult:(BOOL)result {
    [self.asyncDelegate asyncConnectionResult:result];
}
- (void)asyncFailWithError:(NSError *)anError {
    [self.asyncDelegate asyncFailWithError:anError];
}

- (void)updateServiceAddress {
    SettingManager* settingManager = [SettingManager setting];
    NSString* keyPath = @"CompanySetting.Connection";
    [settingManager updateSettingForKeypath:keyPath atIndex:1 withData:self.serviceAddress];
    [settingManager saveSetting];
}

- (void)updateSqlName {
    SettingManager* settingManager = [SettingManager setting];
    NSString* keyPath = @"CompanySetting.Connection";
    [settingManager updateSettingForKeypath:keyPath atIndex:3 withData:self.sqlName];
    [settingManager saveSetting];
}

- (void)updateEmployeeIURNumber {
    SettingManager* settingManager = [SettingManager setting];
    NSString* keyPath = @"PersonalSetting.Personal";
    [settingManager updateSettingForKeypath:keyPath atIndex:0 withData:self.employeeIURNumber];
    [settingManager saveSetting];
}
@end
