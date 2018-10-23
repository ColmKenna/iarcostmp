//
//  FileDownloadCenter.m
//  Arcos
//
//  Created by David Kilmartin on 18/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FileDownloadCenter.h"

@interface FileDownloadCenter (Private)
-(void)makeADownloader;

@end
@implementation FileDownloadCenter
@synthesize fileQueue;
@synthesize delegate;
@synthesize downloadFoler;
@synthesize downloadServer;
@synthesize currentFileDownloader = _currentFileDownloader;
-(id)init{
    self=[super init];
    if (self!=nil) {
        self.downloadServer=[SettingManager downloadServer];
        self.downloadFoler=@"presenter";
        self.fileQueue=[NSMutableArray array];
    }
    return self;
}
-(void)startDownload{
    if (self.fileQueue==nil) {
        return;
    }
    
    if ([self.fileQueue count]>0) {
        [self makeADownloader];
    }
}
-(void)addFileWithName:(NSString*)name{
    if (name==nil) {
        return;
    }
    [self.fileQueue addObject:name];
}
-(void)removeAllFiles{
    if (self.fileQueue==nil) {
        return;
    }
    [self.fileQueue removeAllObjects];
}

-(void)makeADownloader{
    if (self.fileQueue==nil) {
        return;
    }
    if ([self.fileQueue count]<=0) {
        [self.delegate allFilesDownload];
        return;
    }
    
    NSString* fileToDownload=[self.fileQueue lastObject];
    if (fileToDownload!=nil) {
        self.currentFileDownloader=[[[FileCommon alloc]init]autorelease];
        self.currentFileDownloader.delegate=self;
        
        NSString* urlStirng=[NSString stringWithFormat:@"%@%@",self.downloadServer,fileToDownload];
        NSLog(@"path to server file %@",urlStirng);
        NSURL* serverUrl=[NSURL URLWithString:urlStirng];
        [self.currentFileDownloader downloadFileWithURL:serverUrl WithName:fileToDownload toFolder:self.downloadFoler];
    }
    [self.fileQueue removeLastObject];
}

-(void)fileDownloaded:(FileCommon *)fileCommon withError:(BOOL)anyError{
    [self makeADownloader];
    [self.delegate fileDownload:fileCommon withError:anyError];
}
-(void)didFailWithError:(NSError *)anError {
    [self.delegate didFailWithError:anError];
}
-(void)updateProgressBar:(float)aValue {
    [self.delegate updateProgressBar:aValue];
}

-(void)dealloc{
    self.fileQueue = nil;
    self.downloadServer = nil;
    self.downloadFoler = nil;
    self.currentFileDownloader = nil;
    
    [super dealloc];
}
@end
