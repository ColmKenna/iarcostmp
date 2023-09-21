//
//  ReporterFileManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterFileManager.h"

@implementation ReporterFileManager
@synthesize fileDelegate = _fileDelegate;
@synthesize destFolderName = _destFolderName;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize localExcelFilePath = _localExcelFilePath;
@synthesize urlConnection = _urlConnection;
@synthesize fileHandle = _fileHandle;
@synthesize reporterFolderName = _reporterFolderName;
@synthesize previewDocumentList = _previewDocumentList;
@synthesize pdfFileName = _pdfFileName;
@synthesize pdfServerFilePath = _pdfServerFilePath;
@synthesize reportTitle = _reportTitle;
@synthesize previewPdfDocumentList = _previewPdfDocumentList;
@synthesize isFileNotSuccessfullyDownloaded = _isFileNotSuccessfullyDownloaded;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.reporterFolderName = @"reporter";
    }
    return self;
}

- (void)dealloc {
//    if (self.fileDelegate != nil) { self.fileDelegate = nil; }
    if (self.destFolderName != nil) { self.destFolderName = nil; }
    if (self.fileName != nil) { self.fileName = nil; }
    if (self.filePath != nil) { self.filePath = nil; }
    if (self.localExcelFilePath != nil) { self.localExcelFilePath = nil; }
    if (self.urlConnection != nil) { self.urlConnection = nil; }
    if (self.fileHandle != nil) { self.fileHandle = nil; }
    if (self.reporterFolderName != nil) { self.reporterFolderName = nil; }
    if (self.previewDocumentList != nil) { self.previewDocumentList = nil; }
    if (self.pdfFileName != nil) { self.pdfFileName = nil; }
    if (self.pdfServerFilePath != nil) { self.pdfServerFilePath = nil; }
    if (self.reportTitle != nil) { self.reportTitle = nil; }
    if (self.previewPdfDocumentList != nil) { self.previewPdfDocumentList = nil; }
    
    [super dealloc];
}

- (void)downloadFileWithURL:(NSURL*)anURL destFolderName:(NSString*)aFolderName fileName:(NSString*)aFileName {
    NSURLRequest* request = [NSURLRequest requestWithURL:anURL];
    
    self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    self.destFolderName = aFolderName;
    self.fileName = aFileName;
    self.filePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", aFolderName, aFileName]];
//    NSLog(@"downloadFileWithURL:%@ %@ %@", self.filePath , anURL.absoluteString, self.destFolderName);    
}

- (BOOL)synchronousDownloadFileWithURL:(NSURL*)anURL destFolderName:(NSString*)aFolderName fileName:(NSString*)aFileName {
    NSError* anError = nil;
    NSHTTPURLResponse* response = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:anURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];    
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&anError];
//    NSLog(@"synchronousDownloadFileWithURL statusCode: %d", [response statusCode]);
    if (404 == [response statusCode]) {
//        [ArcosUtils showMsg:@"404 - File or directory not found." delegate:nil];
        [ArcosUtils showDialogBox:@"404 - File or directory not found." title:@"" target:[ArcosUtils getRootView] handler:nil];
        return NO;
    }
    if (nil != result && 200 == [response statusCode]) {
        NSString* tmpFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", aFolderName, aFileName]];
        [result writeToFile:tmpFilePath atomically:YES];
        return YES;
    }
//    [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
    [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" target:[ArcosUtils getRootView] handler:nil];
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
//    NSLog(@"NSHTTPURLResponse status code: %d", httpResponse.statusCode);
    self.isFileNotSuccessfullyDownloaded = NO;
    if ([httpResponse statusCode] == 404) {
        self.isFileNotSuccessfullyDownloaded = YES;
        NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"404 - File or directory not found." forKey:NSLocalizedDescriptionKey];
        NSError* notFoundError = [NSError errorWithDomain:@"" code:404 userInfo:errorDetail];
        [self.fileDelegate didFailWithErrorReporterFileDelegate:notFoundError];
        return;
    }
    [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];    
    if (self.fileHandle) {        
        [self.fileHandle seekToEndOfFile];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.fileHandle)  {        
        [self.fileHandle seekToEndOfFile];
    } 
    [self.fileHandle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.fileHandle) {
        [self.fileHandle closeFile]; 
    }
    [self.fileDelegate didFinishLoadingReporterFileDelegate];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError{
    self.isFileNotSuccessfullyDownloaded = YES;
    [FileCommon removeFileAtPath:self.filePath];
    [self.fileDelegate didFailWithErrorReporterFileDelegate:anError];
}

@end
