//
//  DashboardServerDataManager.h
//  iArcos
//
//  Created by Richard on 24/05/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosSystemCodesUtils.h"
#import "ArcosCoreData.h"


@interface DashboardServerDataManager : NSObject {
    BOOL _resourceLoadingFinishedFlag;
    NSMutableArray* _dashboardFileList;
    NSString* _dashboardFolderName;
    NSString* _currentFileName;
    NSMutableArray* _displayFileList;
    int _currentPage;
    NSMutableArray* _employeeDictList;
    NSMutableArray* _displayEmployeeNameList;
    NSMutableDictionary* _currentEmployeeDict;
    NSString* _dashboardTitle;
    NSString* _overviewsFolder;
    int _rowPointer;
    NSMutableDictionary* _currentDashFileDict;
}

@property(nonatomic, assign) BOOL resourceLoadingFinishedFlag;
@property(nonatomic, retain) NSMutableArray* dashboardFileList;
@property(nonatomic, retain) NSString* dashboardFolderName;
@property(nonatomic, retain) NSString* currentFileName;
@property(nonatomic, retain) NSMutableArray* displayFileList;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, retain) NSMutableArray* employeeDictList;
@property(nonatomic, retain) NSMutableArray* displayEmployeeNameList;
@property(nonatomic, retain) NSMutableDictionary* currentEmployeeDict;
@property(nonatomic, retain) NSString* dashboardTitle;
@property(nonatomic, retain) NSString* overviewsFolder;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSMutableDictionary* currentDashFileDict;


- (void)createDashboardFileList;
- (void)processGet_Download_Filenames:(id)aResult;
- (NSString*)retrieveFilePathWithFileDict:(NSMutableDictionary*)aDashFileDict;

@end

