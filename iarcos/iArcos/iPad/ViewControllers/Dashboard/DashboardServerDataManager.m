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

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.resourceLoadingFinishedFlag = YES;
        self.dashboardFolderName = @"dashboard";
        self.currentPage = 0;
    }
    return self;
}

- (void)dealloc {
    self.dashboardFileList = nil;
    self.dashboardFolderName = nil;
    self.currentFileName = nil;
    self.displayFileList = nil;
        
    [super dealloc];
}

- (void)createDashboardFileList {
    self.dashboardFileList = [NSMutableArray array];
    if (![ArcosSystemCodesUtils allDashOptionExistence]) {
        NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", [SettingManager employeeIUR]];
        [self.dashboardFileList addObject:empFileName];
    } else {
        NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
        for (int i = 0; i < [employeeList count]; i++) {
            NSMutableDictionary* employeeDict = [employeeList objectAtIndex:i];
            NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", [employeeDict objectForKey:@"IUR"]];
            [self.dashboardFileList addObject:empFileName];
        }
    }
    
}

@end
