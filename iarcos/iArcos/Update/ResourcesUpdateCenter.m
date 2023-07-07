//
//  ResourcesUpdateCenter.m
//  Arcos
//
//  Created by David Kilmartin on 13/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ResourcesUpdateCenter.h"

@implementation ResourcesUpdateCenter
@synthesize presenterFileList = _presenterFileList;
@synthesize presenterFileHashMap = _presenterFileHashMap;
@synthesize errorMsgList = _errorMsgList;
@synthesize needDownloadFileList = _needDownloadFileList;
@synthesize isResourceLoadingFinished = _isResourceLoadingFinished;
@synthesize isBusy = _isBusy;
@synthesize resourcesTimer = _resourcesTimer;
@synthesize currentFileName = _currentFileName;
@synthesize resourcesUpdateDelegate = _resourcesUpdateDelegate;
@synthesize overallFileCount = _overallFileCount;
@synthesize resourcesFileDownloader = _resourcesFileDownloader;
@synthesize downloadServer = _downloadServer;
@synthesize presenterPath = _presenterPath;
@synthesize sucessfulFileCount = _sucessfulFileCount;
@synthesize target = _target;
@synthesize action = _action;
@synthesize loadingAction = _loadingAction;
@synthesize existingFileList = _existingFileList;
@synthesize arcosService = _arcosService;
@synthesize rowPointer = _rowPointer;
@synthesize fileMD5Calculator = _fileMD5Calculator;
@synthesize selectedFileMD5Name = _selectedFileMD5Name;
@synthesize selectedFileMD5Value = _selectedFileMD5Value;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.downloadServer = [SettingManager downloadServer];
        self.presenterPath = [FileCommon presenterPath];
        self.isResourceLoadingFinished = YES;
        self.isBusy = NO;
        NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] presenterProductsActiveOnly:YES];
        self.presenterFileList = [NSMutableArray arrayWithCapacity:[objectList count]];
        self.presenterFileHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectList count]];
        self.errorMsgList = [NSMutableArray array];
        for (int i = 0; i < [objectList count]; i++) {
            NSString* fileName = [[objectList objectAtIndex:i] objectForKey:@"Name"];
            if (fileName != nil && ![@"" isEqualToString:fileName]) {
                NSString* existingFileName = [self.presenterFileHashMap objectForKey:fileName];
                if (existingFileName == nil) {
                    [self.presenterFileList addObject:[NSString stringWithFormat:@"%@", fileName]];
                    [self.presenterFileHashMap setObject:[NSString stringWithFormat:@"%@", fileName] forKey:[NSString stringWithFormat:@"%@", fileName]];
                }
            }
        }
        self.needDownloadFileList = [NSMutableArray arrayWithCapacity:[self.presenterFileList count]];
        self.existingFileList = [NSMutableArray arrayWithCapacity:[self.presenterFileList count]];
        for (int i = 0; i < [self.presenterFileList count]; i++) {
            NSString* fileName = [self.presenterFileList objectAtIndex:i];
            if (![FileCommon fileExistInFolder:@"presenter" withFileName:fileName]) {
                [self.needDownloadFileList addObject:fileName];
            } else {
                [self.existingFileList addObject:fileName]; 
            }
        }
//        NSLog(@"self.needDownloadFileList: %@", self.needDownloadFileList);
        self.overallFileCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.needDownloadFileList count]];
        self.sucessfulFileCount = 0;
        self.fileMD5Calculator = [[[FileMD5Calculator alloc] init] autorelease];
    }
    return self;
}

- (id)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction {
    self.target = aTarget;
    self.action = anAction;
    self.loadingAction = aLoadingAction;
    return [self init];
}

- (void)dealloc {
    if (self.needDownloadFileList != nil) { self.needDownloadFileList = nil; }
    if (self.presenterFileList != nil) { self.presenterFileList = nil; }
    self.presenterFileHashMap = nil;
    self.errorMsgList = nil;
    if (self.resourcesTimer != nil) { self.resourcesTimer = nil; }
    if (self.currentFileName != nil) { self.currentFileName = nil; }
    if (self.resourcesUpdateDelegate != nil) { self.resourcesUpdateDelegate = nil; }
    if (self.resourcesFileDownloader != nil) { self.resourcesFileDownloader = nil; }    
    if (self.downloadServer != nil) { self.downloadServer = nil; }
    if (self.presenterPath != nil) { self.presenterPath = nil; }
    self.existingFileList = nil;
    self.arcosService = nil;
    self.fileMD5Calculator = nil;
    self.selectedFileMD5Name = nil;
    self.selectedFileMD5Value = nil;
        
    [super dealloc];
}

- (void)runTask {
    if ([self.needDownloadFileList count] <= 0 || self.isBusy) {
        return;
    }
    if (self.isResourceLoadingFinished) {
        [FileCommon createFolder:@"presenter"];
        self.isBusy = YES;
        self.resourcesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkResourceList) userInfo:nil repeats:YES];
    }
}

- (void)stopTask {
    [self.resourcesTimer invalidate];
    self.resourcesTimer = nil;
    self.isBusy = NO;
    [self.needDownloadFileList removeAllObjects];
}

- (void)checkResourceList {
    if (self.isResourceLoadingFinished) {
        //stop the timer
        if ([self.needDownloadFileList count] <= 0) {
            [self.resourcesTimer invalidate];
            self.resourcesTimer = nil;
            [self.resourcesUpdateDelegate resourcesUpdateCompleted:self.sucessfulFileCount];
            self.isBusy = NO;
        } else {
            self.isResourceLoadingFinished = NO;
            NSString* tmpFileName = [[[self.needDownloadFileList lastObject] retain] autorelease];
            self.currentFileName = [NSString stringWithFormat:@"%@", tmpFileName];            
            if (self.resourcesFileDownloader != nil) {
                self.resourcesFileDownloader = nil;
            }
            self.resourcesFileDownloader = [[[UtilitiesUpdateResourcesFileDownloader alloc] init] autorelease];
            [self.resourcesFileDownloader downloadFileWithServerAddress:self.downloadServer destFolderName:self.resourcesFileDownloader.presenterFolderName destFileName:self.currentFileName];
            self.resourcesFileDownloader.resourcesFileDelegate = self;
            [self.resourcesUpdateDelegate ResourceStatusTextWithValue:[NSString stringWithFormat:@"Start getting data for %@", self.currentFileName]];
            [self.needDownloadFileList removeLastObject];
        }
    }
}

- (void)runWSRTask {
    if ([self.needDownloadFileList count] <= 0 || self.isBusy) {
        return;
    }
    if ([self.target performSelector:self.loadingAction]) {
        [FileCommon createFolder:@"presenter"];
        self.isBusy = YES;
        self.resourcesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkWSResourceList) userInfo:nil repeats:YES];
    }
}

- (void)checkWSResourceList {
    if ([self.target performSelector:self.loadingAction]) {
        //stop the timer
        if ([self.needDownloadFileList count] <= 0) {
            [self.resourcesTimer invalidate];
            self.resourcesTimer = nil;
            [self.resourcesUpdateDelegate resourcesUpdateCompleted:self.sucessfulFileCount];
            self.isBusy = NO;
        } else {
            NSString* tmpFileName = [[[self.needDownloadFileList lastObject] retain] autorelease];
            self.currentFileName = [NSString stringWithFormat:@"%@", tmpFileName];
            [self.target performSelector:self.action withObject:self.currentFileName];
            
            [self.resourcesUpdateDelegate ResourceStatusTextWithValue:[NSString stringWithFormat:@"Start getting data for %@", self.currentFileName]];
            [self.needDownloadFileList removeLastObject];
        }
    }
}

#pragma mark UtilitiesUpdateResourcesFileDelegate
- (void)didFinishLoadingResourcesFileDelegate:(NSError *)anError {
    self.isResourceLoadingFinished = YES;
    if (anError != nil) {
        [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
    } else {
        self.sucessfulFileCount++; 
    }
}

- (void)didFailWithErrorResourcesFileDelegate:(NSError *)anError {
    self.isResourceLoadingFinished = YES;
    [self stopTask];
    [self.resourcesUpdateDelegate didFailWithErrorResourcesFileDelegate:anError];
}

- (void)updateResourcesProgressBar:(float)aValue {
    [self.resourcesUpdateDelegate updateResourcesProgressBar:aValue];
}

- (void)errorWithResourcesFile:(NSError *)anError {
    self.sucessfulFileCount--;
    [self.resourcesUpdateDelegate errorWithResourcesFile:(NSError *)anError];
}

- (void)checkFileIntegrity {
    self.arcosService = [[[ArcosService alloc] init] autorelease];
    self.rowPointer = 0;
    [self checkFileMD5];
}

- (void)checkFileMD5 {
    if (self.rowPointer == [self.existingFileList count]) {
        [self.resourcesUpdateDelegate checkFileMD5Completed];
        return;
    }
    self.selectedFileMD5Name = [self.existingFileList objectAtIndex:self.rowPointer];
    NSString* auxFileMD5Path = [self.presenterPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", self.selectedFileMD5Name]];
    self.selectedFileMD5Value = [self.fileMD5Calculator retrieveFileMD5WithFilePath:auxFileMD5Path];
    
    [self.arcosService GetFromResourcesDifferentMd5:self action:@selector(backFromGetFromResourcesDifferentMd5:) FileNAme:self.selectedFileMD5Name  MD5:self.selectedFileMD5Value];
}

- (void)backFromGetFromResourcesDifferentMd5:(NSString*)result {
    self.rowPointer++;
    result = [ArcosSystemCodesUtils handleResultErrorProcess:result]; 
    if (result == nil || [result isEqualToString:@""]) {
        [self checkFileMD5];
        return;
    }
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"test two %@ %@", result, self.selectedFileMD5Value);
    if (![[result lowercaseString] isEqualToString:[self.selectedFileMD5Value lowercaseString]]) {
        [self.needDownloadFileList addObject:self.selectedFileMD5Name];
    }    
    if (self.rowPointer == [self.existingFileList count]) {
        [self.resourcesUpdateDelegate checkFileMD5Completed];
        return;
    }
    [self checkFileMD5];
}

@end
