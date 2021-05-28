//
//  DashboardServerDataManager.m
//  iArcos
//
//  Created by Richard on 24/05/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "DashboardServerDataManager.h"

@implementation DashboardServerDataManager
@synthesize resourceLoadingFinishedFlag = _resourceLoadingFinishedFlag;
@synthesize dashboardFileList = _dashboardFileList;
@synthesize dashboardFolderName = _dashboardFolderName;
@synthesize currentFileName = _currentFileName;
@synthesize displayFileList = _displayFileList;
@synthesize currentPage = _currentPage;
@synthesize employeeDictList = _employeeDictList;
@synthesize displayEmployeeNameList = _displayEmployeeNameList;
@synthesize currentEmployeeDict = _currentEmployeeDict;
@synthesize dashboardTitle = _dashboardTitle;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.resourceLoadingFinishedFlag = YES;
        self.dashboardFolderName = @"dashboard";
        self.currentPage = 0;
        self.dashboardTitle = @"Dashboard";
    }
    return self;
}

- (void)dealloc {
    self.dashboardFileList = nil;
    self.dashboardFolderName = nil;
    self.currentFileName = nil;
    self.displayFileList = nil;
    self.employeeDictList = nil;
    self.displayEmployeeNameList = nil;
    self.currentEmployeeDict = nil;
    self.dashboardTitle = nil;
        
    [super dealloc];
}

- (void)createDashboardFileList {
    self.dashboardFileList = [NSMutableArray array];
    if (![ArcosSystemCodesUtils allDashOptionExistence]) {
        NSNumber* employeeIUR = [SettingManager employeeIUR];
        NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", employeeIUR];
        [self.dashboardFileList addObject:empFileName];
        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
        self.employeeDictList = [NSMutableArray arrayWithCapacity:1];
        if (employeeDict != nil) {
            NSMutableDictionary* resEmployeeDict = [NSMutableDictionary dictionaryWithDictionary:employeeDict];
            [resEmployeeDict setObject:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]],[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]] ] forKey:@"Title"];
            [self.employeeDictList addObject:resEmployeeDict];
        }
    } else {
        self.employeeDictList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
        for (int i = 0; i < [self.employeeDictList count]; i++) {
            NSMutableDictionary* employeeDict = [self.employeeDictList objectAtIndex:i];
            NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", [employeeDict objectForKey:@"IUR"]];
            [self.dashboardFileList addObject:empFileName];
        }
    }
    
}

@end
