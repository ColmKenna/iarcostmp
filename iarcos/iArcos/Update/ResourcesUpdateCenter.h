//
//  ResourcesUpdateCenter.h
//  Arcos
//
//  Created by David Kilmartin on 13/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "FileCommon.h"
#import "ResourcesUpdateCenterDelegate.h"
#import "UtilitiesUpdateResourcesFileDownloader.h"
#import "SettingManager.h"
#import "FileMD5Calculator.h"
#import "ArcosSystemCodesUtils.h"

@interface ResourcesUpdateCenter : NSObject <UtilitiesUpdateResourcesFileDelegate> {
    NSMutableArray* _presenterFileList;
    NSMutableDictionary* _presenterFileHashMap;
    NSMutableArray* _errorMsgList;
    NSMutableArray* _needDownloadFileList;
    NSMutableArray* _resultDownloadFileList;
    NSString* _currentResultFileName;
    int _resultRowPointer;
    BOOL _isResourceLoadingFinished;
    BOOL _isBusy;
    NSTimer* _resourcesTimer;
    NSString* _currentFileName;
    id<ResourcesUpdateCenterDelegate> _resourcesUpdateDelegate;
    int _overallFileCount;
    UtilitiesUpdateResourcesFileDownloader* _resourcesFileDownloader;
    NSString* _downloadServer;
    NSString* _presenterPath;
    int _sucessfulFileCount;
    
    id _target;
    SEL _action;
    SEL _loadingAction;
    NSMutableArray* _existingFileList;
    ArcosService* _arcosService;
    int _rowPointer;
    FileMD5Calculator* _fileMD5Calculator;
    NSString* _selectedFileMD5Name;
    NSString* _selectedFileMD5Value;
}

@property(nonatomic, retain) NSMutableArray* presenterFileList;
@property(nonatomic, retain) NSMutableDictionary* presenterFileHashMap;
@property(nonatomic, retain) NSMutableArray* errorMsgList;
@property(nonatomic, retain) NSMutableArray* needDownloadFileList;
@property(nonatomic, retain) NSMutableArray* resultDownloadFileList;
@property(nonatomic, retain) NSString* currentResultFileName;
@property(nonatomic, assign) int resultRowPointer;
@property(nonatomic, assign) BOOL isResourceLoadingFinished;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* resourcesTimer;
@property(nonatomic, retain) NSString* currentFileName;
@property(nonatomic, assign) id<ResourcesUpdateCenterDelegate> resourcesUpdateDelegate;
@property(nonatomic, assign) int overallFileCount;
@property(nonatomic, retain) UtilitiesUpdateResourcesFileDownloader* resourcesFileDownloader;
@property(nonatomic, retain) NSString* downloadServer;
@property(nonatomic, retain) NSString* presenterPath;
@property(nonatomic, assign) int sucessfulFileCount;
@property(nonatomic,assign) id target;
@property(nonatomic) SEL action;
@property(nonatomic) SEL loadingAction;
@property(nonatomic, retain) NSMutableArray* existingFileList;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) FileMD5Calculator* fileMD5Calculator;
@property(nonatomic, retain) NSString* selectedFileMD5Name;
@property(nonatomic, retain) NSString* selectedFileMD5Value;

- (void)runTask;
- (void)stopTask;
- (void)runWSRTask;
//- (void)stopWSRTask;
- (id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction;
- (void)checkFileIntegrity;
- (void)checkFileExistence;
- (void)compositeStopTask:(NSError*)anError;

@end
