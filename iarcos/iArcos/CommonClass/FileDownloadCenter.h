//
//  FileDownloadCenter.h
//  Arcos
//
//  Created by David Kilmartin on 18/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"
#import "SettingManager.h"

@protocol FileDownloadCenterDelegate 
-(void)fileDownload:(FileCommon*)FC withError:(BOOL)error;
-(void)allFilesDownload;
@optional
-(void)didFailWithError:(NSError*)anError;
-(void)updateProgressBar:(float)aValue;
@end

@interface FileDownloadCenter : NSObject<FileCommonDelegate>{
    NSMutableArray* fileQueue;
    NSString* downloadServer;
    NSString* downloadFoler;
    FileCommon* _currentFileDownloader;
    
    id<FileDownloadCenterDelegate> delegate;
}
@property(nonatomic,retain)    NSMutableArray* fileQueue;
@property(nonatomic,retain)    NSString* downloadServer;
@property(nonatomic,retain)    NSString* downloadFoler;
@property(nonatomic,retain) FileCommon* currentFileDownloader;

@property(nonatomic,assign)  id<FileDownloadCenterDelegate> delegate;

-(void)addFileWithName:(NSString*)name;
-(void)removeAllFiles;
-(void)startDownload;
@end
