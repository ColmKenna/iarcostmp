//
//  UtilitiesUpdateResourcesFileDownloader.m
//  Arcos
//
//  Created by David Kilmartin on 14/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "UtilitiesUpdateResourcesFileDownloader.h"

@implementation UtilitiesUpdateResourcesFileDownloader
@synthesize resourcesFileDelegate = _resourcesFileDelegate;
@synthesize destFileName = _destFileName;
@synthesize destFilePath = _destFilePath;
@synthesize presenterFolderName = _presenterFolderName;
@synthesize urlConnection = _urlConnection;
@synthesize fileHandle = _fileHandle;
@synthesize expectedFileSize = _expectedFileSize;
@synthesize totalBytesReceived = _totalBytesReceived;
@synthesize currentServerAddress = _currentServerAddress;

-(id)init{
    self = [super init];
    if (self != nil) {
        self.presenterFolderName = @"presenter";
    }
    return self;
}

- (void)dealloc {
    if (self.resourcesFileDelegate != nil) { self.resourcesFileDelegate = nil; }
    if (self.destFileName != nil) { self.destFileName = nil; }
    if (self.destFilePath != nil) { self.destFilePath = nil; }
    if (self.presenterFolderName != nil) { self.presenterFolderName = nil; }    
    if (self.urlConnection != nil) { self.urlConnection = nil; }
    if (self.fileHandle != nil) { self.fileHandle = nil; }
    if (self.currentServerAddress != nil) { self.currentServerAddress = nil; }       
    
    
    [super dealloc];
}

- (void)downloadFileWithServerAddress:(NSString*)aServerAddress destFolderName:(NSString*)aFolderName destFileName:(NSString*)aFileName {
    self.currentServerAddress = [NSString stringWithFormat:@"%@",aServerAddress];
    NSString* urlString = [NSString stringWithFormat:@"%@%@", aServerAddress, aFileName];
    NSURL* aURL = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:aURL];
    self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    self.destFileName = aFileName;
    self.destFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", aFolderName, aFileName]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
//    NSLog(@"NSHTTPURLResponse status code: %d", httpResponse.statusCode);
    if ([httpResponse statusCode] == 404) {
        NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:[NSString stringWithFormat:@"%@ not found on %@.",self.destFileName, self.currentServerAddress] forKey:NSLocalizedDescriptionKey];
        NSError* notFoundError = [NSError errorWithDomain:@"" code:404 userInfo:errorDetail];
        [self.resourcesFileDelegate errorWithResourcesFile:notFoundError];        
        return;
    }
    if ([httpResponse statusCode] >= 400) {
        NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:[NSString stringWithFormat:@"Http status code is %d while downloading %@ from %@.", [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]], self.destFileName, self.currentServerAddress] forKey:NSLocalizedDescriptionKey];
        NSError* tmpError = [NSError errorWithDomain:@"" code:[httpResponse statusCode] userInfo:errorDetail];
        [self.resourcesFileDelegate errorWithResourcesFile:tmpError];
        return;
    }
    self.expectedFileSize = httpResponse.expectedContentLength;
    self.totalBytesReceived = 0;
    [self.resourcesFileDelegate updateResourcesProgressBar:0.0f];
    [[NSFileManager defaultManager] createFileAtPath:self.destFilePath contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.destFilePath];    
    if (self.fileHandle) {
        [self.fileHandle seekToEndOfFile];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.totalBytesReceived = self.totalBytesReceived + [data length];
    if (self.expectedFileSize != NSURLResponseUnknownLength && self.expectedFileSize != 0) {
        [self.resourcesFileDelegate updateResourcesProgressBar:self.totalBytesReceived*1.0/self.expectedFileSize];
    }
    if (self.fileHandle)  {        
        [self.fileHandle seekToEndOfFile];
    } 
    [self.fileHandle writeData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* anError = nil;
    if (self.fileHandle) {
        [self.fileHandle closeFile];
    }
    if (self.expectedFileSize != NSURLResponseUnknownLength) {
        if (self.expectedFileSize != self.totalBytesReceived && self.expectedFileSize != 0) {
            NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setObject:[NSString stringWithFormat:@"The size of %@ is %lld bytes while the one on %@ is %lld bytes.", self.destFileName, self.totalBytesReceived, self.currentServerAddress, self.expectedFileSize] forKey:NSLocalizedDescriptionKey];
            anError = [NSError errorWithDomain:@"" code:9000 userInfo:errorDetail];
        }
//        NSLog(@"finish two value: %lld %lld",self.totalBytesReceived, self.expectedFileSize);
    }
    [self.resourcesFileDelegate didFinishLoadingResourcesFileDelegate: anError];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError{
    [FileCommon removeFileAtPath:self.destFilePath];
    [self.resourcesFileDelegate didFailWithErrorResourcesFileDelegate:anError];
}

@end
