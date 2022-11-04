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
@synthesize overviewsFolder = _overviewsFolder;
@synthesize rowPointer = _rowPointer;
@synthesize currentDashFileDict = _currentDashFileDict;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.resourceLoadingFinishedFlag = YES;
        self.dashboardFolderName = @"dashboard";
        self.currentPage = 0;
        self.dashboardTitle = @"Dashboard";
        self.overviewsFolder = @"Overviews";
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
    self.overviewsFolder = nil;
    self.currentDashFileDict = nil;
        
    [super dealloc];
}

- (void)createDashboardFileList {
    self.dashboardFileList = [NSMutableArray arrayWithCapacity:1];
    NSNumber* employeeIUR = [SettingManager employeeIUR];
    NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", employeeIUR];
    NSMutableDictionary* tmpDashFileDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDashFileDict setObject:[ArcosUtils convertNilToEmpty:empFileName] forKey:@"FileName"];
    [tmpDashFileDict setObject:@"" forKey:@"Directory"];
    [self.dashboardFileList addObject:tmpDashFileDict];
//    if (![ArcosSystemCodesUtils allDashOptionExistence]) {
        
//        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
//        self.employeeDictList = [NSMutableArray arrayWithCapacity:1];
//        if (employeeDict != nil) {
//            NSMutableDictionary* resEmployeeDict = [NSMutableDictionary dictionaryWithDictionary:employeeDict];
//            [resEmployeeDict setObject:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]],[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]] ] forKey:@"Title"];
//            [self.employeeDictList addObject:resEmployeeDict];
//        }
//    }
//    else {
//        self.employeeDictList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
//        for (int i = 0; i < [self.employeeDictList count]; i++) {
//            NSMutableDictionary* employeeDict = [self.employeeDictList objectAtIndex:i];
//            NSString* empFileName = [NSString stringWithFormat:@"Emp_Dashboard_%@.pdf", [employeeDict objectForKey:@"IUR"]];
//            [self.dashboardFileList addObject:empFileName];
//        }
//    }
    
}

- (void)processGet_Download_Filenames:(id)aResult {
    ArcosArrayOfDownloadFileInfo* tmpDataList = (ArcosArrayOfDownloadFileInfo*)aResult;
    self.dashboardFileList = [NSMutableArray arrayWithCapacity:[tmpDataList count]];
    for (int i = 0; i < [tmpDataList count]; i++) {
        ArcosDownloadFileInfo* tmpArcosDownloadFileInfo = [tmpDataList objectAtIndex:i];
        NSMutableDictionary* tmpDashFileDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [tmpDashFileDict setObject:[ArcosUtils convertNilToEmpty:tmpArcosDownloadFileInfo.FileName] forKey:@"FileName"];
        [tmpDashFileDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:tmpArcosDownloadFileInfo.Directory] characters:@"\\"] forKey:@"Directory"];
        [self.dashboardFileList addObject:tmpDashFileDict];
    }
}

- (NSString*)retrieveFilePathWithFileDict:(NSMutableDictionary*)aDashFileDict {
    NSString* tmpFileDirectory = [aDashFileDict objectForKey:@"Directory"];
    NSString* resFileDirectory = [tmpFileDirectory stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString* filePath = @"";
    if ([resFileDirectory isEqualToString:@""]) {
        filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon dashboardPath], [aDashFileDict objectForKey:@"FileName"]];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@/%@", [FileCommon dashboardPath], resFileDirectory, [aDashFileDict objectForKey:@"FileName"]];
    }
    return filePath;
}

@end
