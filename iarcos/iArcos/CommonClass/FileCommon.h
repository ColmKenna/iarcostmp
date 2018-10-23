//
//  FileCommon.h
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FileCommonDelegate;
#import "CompositeErrorResult.h"

@interface FileCommon : NSObject {
    id data;
    id<FileCommonDelegate> delegate;
    NSString* fileName;
    NSString* folderName;
    NSString* filePath;
    NSFileHandle* fileHandle;
    NSNumber* fileIndex;
    BOOL error;
//    NSNumber* _expectedFileSize;
//    float _totalBytesReceived;
    long long _myExpectedFileSize;
    long long _myTotalBytesReceived;
}
@property(nonatomic,retain)    id data;
@property(nonatomic,assign)    id<FileCommonDelegate> delegate;
@property(nonatomic,retain)    NSString* fileName;
@property(nonatomic,retain)     NSString* folderName;
@property(nonatomic,retain)   NSString* filePath;
@property(nonatomic,retain)   NSFileHandle* fileHandle;
@property(nonatomic,assign)       BOOL error;
@property(nonatomic,assign)   NSNumber* fileIndex;
//@property(nonatomic,retain) NSNumber* expectedFileSize;
//@property(nonatomic,assign) float totalBytesReceived;
@property(nonatomic, assign) long long myExpectedFileSize;
@property(nonatomic, assign) long long myTotalBytesReceived;

-(void)downloadFileWithURL:(NSURL*)url WithName:(NSString*)name toFolder:(NSString*)folder;
//static method
+(BOOL)createFolder:(NSString*)folderName;
+(BOOL)fileExistInFolder:(NSString*)folderName withFileName:(NSString*)fileName;
+(BOOL)fileExistAtPath:(NSString*)path;
+(BOOL)saveFileToFolder:(NSString*)folderName withName:(NSString*)fileName withData:(NSData*)data;
+(CompositeErrorResult*)removeFileAtPath:(NSString*)path;
+(BOOL)removeAllFileUnderPresenterPath;
+(BOOL)removeAllFileUnderFolder:(NSString*)aFolderName;
+(CompositeErrorResult*)removeFolderAtPath:(NSString*)aFolderPath;
+(NSUInteger)fileCountUnderFolder:(NSString*)aFolderName;
+(NSString*)pathWithFolder:(NSString*)aFolderName;
+(NSString*)presenterPath;
+(NSString*)settingFilePath;
+(NSString*)photosPath;
+(NSString*)reporterPath;
+(NSString*)surveyPath;
+(NSString*)overviewPath;
+(BOOL)settingFileExist;
+(NSString*)documentsPath;
+(BOOL)updateCenterPlistExist;
+(NSString*)updateCenterPlistPath;
+ (CompositeErrorResult*)testCopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
+(void)copyfileTest;
+(NSString*)appStatusPlistPath;
+(NSString*)storeNewsDatePlistPath;
+(NSString*)orderRestorePlistPath;
+(NSString*)configurationPlistPath;
+(NSString*)storeExcInfoPlistPath;

@end

@protocol FileCommonDelegate
-(void)fileDownloaded:(FileCommon*)fileCommon withError:(BOOL)anyError;
@optional
-(void)didFailWithError:(NSError*)anError;
-(void)updateProgressBar:(float)aValue;
@end
