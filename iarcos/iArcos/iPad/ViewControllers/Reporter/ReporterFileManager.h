//
//  ReporterFileManager.h
//  Arcos
//
//  Created by David Kilmartin on 15/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReporterFileDelegate.h"
#import "FileCommon.h"
#import "ArcosUtils.h"

@interface ReporterFileManager : NSObject <NSURLConnectionDataDelegate> {
    id<ReporterFileDelegate> _fileDelegate;
    NSString* _destFolderName;
    NSString* _fileName;
    NSString* _filePath;
    NSString* _localExcelFilePath;
    NSURLConnection* _urlConnection;
    NSFileHandle* _fileHandle;
    NSString* _reporterFolderName;
    NSMutableArray* _previewDocumentList;
    NSString* _pdfFileName;
    NSString* _pdfServerFilePath;
    NSString* _reportTitle;
    NSMutableArray* _previewPdfDocumentList;
    BOOL _isFileNotSuccessfullyDownloaded;
}

@property(nonatomic, assign) id<ReporterFileDelegate> fileDelegate;
@property(nonatomic, retain) NSString* destFolderName;
@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, retain) NSString* filePath;
@property(nonatomic, retain) NSString* localExcelFilePath;
@property(nonatomic, retain) NSURLConnection* urlConnection;
@property(nonatomic, retain) NSFileHandle* fileHandle;
@property(nonatomic, retain) NSString* reporterFolderName;
@property(nonatomic, retain) NSMutableArray* previewDocumentList;
@property(nonatomic, retain) NSString* pdfFileName;
@property(nonatomic, retain) NSString* pdfServerFilePath;
@property(nonatomic, retain) NSString* reportTitle;
@property(nonatomic, retain) NSMutableArray* previewPdfDocumentList;
@property(nonatomic, assign) BOOL isFileNotSuccessfullyDownloaded;

- (void)downloadFileWithURL:(NSURL*)anURL destFolderName:(NSString*)aFolderName fileName:(NSString*)aFileName;
- (BOOL)synchronousDownloadFileWithURL:(NSURL*)anURL destFolderName:(NSString*)aFolderName fileName:(NSString*)aFileName;
/*
- (NSString*)documentsPath;
- (BOOL)removeFileAtPath:(NSString*)path;
*/ 


@end
