//
//  UtilitiesUpdateResourcesFileDownloader.h
//  Arcos
//
//  Created by David Kilmartin on 14/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilitiesUpdateResourcesFileDelegate.h"
#import "FileCommon.h"
#import "ArcosUtils.h"

@interface UtilitiesUpdateResourcesFileDownloader : NSObject {
    id<UtilitiesUpdateResourcesFileDelegate> _resourcesFileDelegate;
    NSString* _destFileName;
    NSString* _destFilePath;
    NSString* _presenterFolderName;
    NSURLConnection* _urlConnection;
    NSFileHandle* _fileHandle;
    long long _expectedFileSize;
    long long _totalBytesReceived;
    NSString* _currentServerAddress;
}

@property(nonatomic, retain) id<UtilitiesUpdateResourcesFileDelegate> resourcesFileDelegate;
@property(nonatomic, retain) NSString* destFileName;
@property(nonatomic, retain) NSString* destFilePath;
@property(nonatomic, retain) NSString* presenterFolderName;
@property(nonatomic, retain) NSURLConnection* urlConnection;
@property(nonatomic, retain) NSFileHandle* fileHandle;
@property(nonatomic, assign) long long expectedFileSize;
@property(nonatomic, assign) long long totalBytesReceived;
@property(nonatomic, retain) NSString* currentServerAddress;

- (void)downloadFileWithServerAddress:(NSString*)aServerAddress destFolderName:(NSString*)aFolderName destFileName:(NSString*)aFileName;

@end
