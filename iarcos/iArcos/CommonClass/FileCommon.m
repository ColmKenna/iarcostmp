//
//  FileCommon.m
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FileCommon.h"
#import "HumanReadableDataSizeHelper.h"
#import "ActivateAppStatusManager.h"
#import "ArcosUtils.h"

@implementation FileCommon
@synthesize data;
@synthesize delegate;
@synthesize fileName;
@synthesize fileHandle;
@synthesize filePath;
@synthesize folderName;
@synthesize error;
@synthesize fileIndex;
//@synthesize expectedFileSize = _expectedFileSize;
//@synthesize totalBytesReceived = _totalBytesReceived;
@synthesize myExpectedFileSize = _myExpectedFileSize;
@synthesize myTotalBytesReceived = _myTotalBytesReceived;

-(void)downloadFileWithURL:(NSURL*)url WithName:(NSString*)name toFolder:(NSString*)folder{
    self.error=NO;
    
    if (url==nil || name==nil||[name isEqualToString:@""] || folder==nil || [folder isEqualToString:@""]) {
        return;
    }
    
    NSLog(@"start getting data!");
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:true];
    self.fileName=name;
    self.folderName=folder;
    [connection release];
    [request release];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSLog(@"getting the data now!");
//    NSLog(@"expectedContentLength: %lld",response.expectedContentLength);
//    self.expectedFileSize = [NSNumber numberWithLongLong:response.expectedContentLength];
//    self.totalBytesReceived = 0.0f;
//    [self.delegate updateProgressBar:0.0f];
//    NSLog(@"expectedFileSize: %@", [HumanReadableDataSizeHelper humanReadableSizeFromBytes:self.expectedFileSize useSiPrefixes:YES useSiMultiplier:NO]);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    self.filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",self.folderName, self.fileName]];
    
    NSHTTPURLResponse* httpResponse=(NSHTTPURLResponse*) response;
//    NSLog(@"status code back from response is %d",[httpResponse statusCode]);
    if ([httpResponse statusCode]==404) {
        NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:@"404 - File or directory not found." forKey:NSLocalizedDescriptionKey];
        NSError* notFoundError = [NSError errorWithDomain:@"" code:404 userInfo:errorDetail];
        [self.delegate didFailWithError:notFoundError];
        self.error=YES;
        return;
    }
    if ([httpResponse statusCode] >= 400) {
        NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setObject:[NSString stringWithFormat:@"Http status code is %d", [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]]] forKey:NSLocalizedDescriptionKey];
        NSError* tmpError = [NSError errorWithDomain:@"" code:[httpResponse statusCode] userInfo:errorDetail];
        [self.delegate didFailWithError:tmpError];
        self.error=YES;
        return;
    }
    self.myExpectedFileSize = httpResponse.expectedContentLength;
    self.myTotalBytesReceived = 0;
    [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:nil attributes:nil];
    self.fileHandle =[NSFileHandle fileHandleForUpdatingAtPath:self.filePath];// 
    
    if (self.fileHandle)   {
        
        [self.fileHandle seekToEndOfFile];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataBack {
//    NSLog(@"saving data to the file!---%d",[dataBack length]);
//    self.totalBytesReceived = self.totalBytesReceived + [dataBack length];
//    [self.delegate updateProgressBar:self.totalBytesReceived / [self.expectedFileSize floatValue]];
    self.myTotalBytesReceived = self.myTotalBytesReceived + [dataBack length];
    if (self.fileHandle)  { 
        
        [self.fileHandle seekToEndOfFile];
        
    } 
    [self.fileHandle writeData:dataBack]; 

}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection { 
    NSLog(@"finished getting data");
    if (self.fileHandle) {
        [self.fileHandle closeFile]; 
    }
    ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
    if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
        if (self.myExpectedFileSize != NSURLResponseUnknownLength) {
            if (self.myExpectedFileSize != self.myTotalBytesReceived && self.myExpectedFileSize != 0) {
                NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setObject:[NSString stringWithFormat:@"The size of %@ is %lld bytes while the one on the server is %lld bytes, please try again.", self.fileName, self.myTotalBytesReceived, self.myExpectedFileSize] forKey:NSLocalizedDescriptionKey];
                NSError* anError = [NSError errorWithDomain:@"" code:9000 userInfo:errorDetail];
                [self.delegate didFailWithError:anError];
                
                [FileCommon removeFileAtPath:self.filePath];
            }
            //        NSLog(@"finish two value: %lld %lld",self.totalBytesReceived, self.expectedFileSize);
        }
    }
    
    @try {
        [self.delegate fileDownloaded:self withError:self.error];

    }
    @catch (NSException *exception) {
        NSLog(@"oop! exception on filecommon with discription %@",[exception description]);
    }
    @finally {
        
    }

    if (self.error) {
        [FileCommon removeFileAtPath:self.filePath];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError{
    self.error=YES;
    [FileCommon removeFileAtPath:self.filePath];
    [self.delegate fileDownloaded:self withError:YES];
    [self.delegate didFailWithError:anError];
}
#pragma mark static methods
+(BOOL)createFolder:(NSString*)folderName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", folderName]];
    
    NSError* error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}
+(BOOL)fileExistInFolder:(NSString*)folderName withFileName:(NSString*)fileName{
    if (folderName==nil || [folderName isEqualToString:@""]) {
        return NO;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", folderName,fileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return NO;
    }else{
        return YES;
    }
    return NO;
}
+(BOOL)fileExistAtPath:(NSString*)path{
    if (path==nil || [path isEqualToString:@""]) {
        return NO;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        return NO;
    }else{
        return YES;
    }

    return NO;
    
}
+(BOOL)saveFileToFolder:(NSString*)folderName withName:(NSString*)fileName withData:(NSData*)data{
    if (folderName==nil || [folderName isEqualToString:@""] || fileName==nil ||[fileName isEqualToString:@""]) {
        return NO;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", folderName,fileName]];
    
    NSError* error;
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (error) {
        return NO;
    }
    return YES;
}
+(CompositeErrorResult*)removeFileAtPath:(NSString*)path{
    BOOL auxDirectoryFlag = YES;
    NSError* auxError = nil;
    BOOL auxResultFlag = YES;
    CompositeErrorResult* auxCompositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&auxDirectoryFlag]) {
        if (!auxDirectoryFlag) {
            auxResultFlag = [[NSFileManager defaultManager] removeItemAtPath:path error:&auxError];
        }
    }
    auxCompositeErrorResult.successFlag = auxResultFlag;
    auxCompositeErrorResult.errorMsg = [auxError localizedDescription];
    return auxCompositeErrorResult;
}
+(BOOL)removeAllFileUnderPresenterPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:[FileCommon presenterPath] error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[FileCommon presenterPath], file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    return YES;
}
+(BOOL)removeAllFileUnderFolder:(NSString*)aFolderName {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString* folderPath = [self pathWithFolder:aFolderName];
    for (NSString *file in [fm contentsOfDirectoryAtPath:folderPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@",folderPath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    return YES;
}
+(CompositeErrorResult*)removeFolderAtPath:(NSString*)aFolderPath {
    BOOL tmpDirectoryFlag = NO;
    NSError* tmpError = nil;
    BOOL tmpResultFlag = NO;
    CompositeErrorResult* tmpCompositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    if ([[NSFileManager defaultManager] fileExistsAtPath:aFolderPath isDirectory:&tmpDirectoryFlag]) {
        if (tmpDirectoryFlag) {
            tmpResultFlag = [[NSFileManager defaultManager] removeItemAtPath:aFolderPath error:&tmpError];
        }
    }
    tmpCompositeErrorResult.successFlag = tmpResultFlag;
    tmpCompositeErrorResult.errorMsg = [tmpError localizedDescription];
    return tmpCompositeErrorResult;
    
}
+(NSUInteger)fileCountUnderFolder:(NSString*)aFolderName {
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* anError = nil;
    NSString* folderPath = [self pathWithFolder:aFolderName];
    NSArray* fileList = [fm contentsOfDirectoryAtPath:folderPath error:&anError];
    return [fileList count];
}
+(NSString*)pathWithFolder:(NSString*)aFolderName {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", aFolderName]];
    return filePath;
}
+(NSString*)presenterPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"presenter"]];
    //NSLog(@"presenter path is %@",filePath);
    return filePath;
}
+(NSString*)settingFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"setting/setting.plist"]];
    return filePath;
}
+(NSString*)photosPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"photos"]];
    //NSLog(@"photos path is %@",filePath);
    return filePath;
}
+(NSString*)reporterPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"reporter"]];
    //NSLog(@"photos path is %@",filePath);
    return filePath;
}
+(NSString*)surveyPath {
    return [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"survey"]];
}
+(NSString*)overviewPath {
    return [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"overview"]];
}
+(NSString*)meetingPath {
    return [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"meeting"]];
}

+(BOOL)settingFileExist{
    if ([self fileExistAtPath:[self settingFilePath]]) {
        return YES;
    }else{
        [self createFolder:@"setting"];
        return NO;
    }
}
+(NSString*)documentsPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    return [paths objectAtIndex:0];
}
+(BOOL)updateCenterPlistExist {
    if ([self fileExistAtPath:[self updateCenterPlistPath]]) {
        return YES;
    }else{
        [self createFolder:@"setting"];
        return NO;
    }
}
+(NSString*)updateCenterPlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"setting/UpdateCenter.plist"]];
    return filePath;
}

+ (CompositeErrorResult*)testCopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
//    BOOL myDirectoryFlag = YES;
    NSError* myError = nil;
    BOOL myResultFlag = NO;
    CompositeErrorResult* myCompositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    CompositeErrorResult* tmpCompositeErrorResult = [self removeFileAtPath:dstPath];
    if (!tmpCompositeErrorResult.successFlag) {
        return tmpCompositeErrorResult;
    }
//    if ([[NSFileManager defaultManager] fileExistsAtPath:dstPath isDirectory:&myDirectoryFlag]) {
//        if (!myDirectoryFlag) {
//            BOOL removeFlag = [[NSFileManager defaultManager] removeItemAtPath:dstPath error:&myError];
//            if (!removeFlag) {
//                myCompositeErrorResult.successFlag = removeFlag;
//                myCompositeErrorResult.errorMsg = [myError localizedDescription];
//                return myCompositeErrorResult;
//            }
//        }
//    }    
    myResultFlag = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&myError];
    myCompositeErrorResult.successFlag = myResultFlag;
    myCompositeErrorResult.errorMsg = [myError localizedDescription];
    return myCompositeErrorResult;
}

+(void)copyfileTest {
    NSError* anError = nil;
    NSString* aSrcPath = [[NSBundle mainBundle] pathForResource:@"Workbook1" ofType:@"xlsx"];
    NSString* aDstPath = [NSString stringWithFormat:@"%@/Workbook1.xlsx", [self presenterPath]];
    BOOL resultFlag = [[NSFileManager defaultManager] copyItemAtPath:aSrcPath toPath:aDstPath error:&anError];
    NSLog(@"copyItemAtPath: %@ %d", anError, resultFlag);
}

+(NSString*)appStatusPlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"AppStatus.plist"]];
    return filePath;
}

+(NSString*)storeNewsDatePlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"StoreNewsDate.plist"]];
    return filePath;
}

+(NSString*)orderRestorePlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"OrderRestore.plist"]];
    return filePath;
}

+(NSString*)configurationPlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"Configuration.plist"]];
    return filePath;
}

+(NSString*)storeExcInfoPlistPath {
    NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"StoreExcInfo.plist"]];
    return filePath;
}

- (void)dealloc
{
    if (self.data != nil) { self.data = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.fileName != nil) { self.fileName = nil; }
    if (self.folderName != nil) { self.folderName = nil; }    
    if (self.filePath != nil) { self.filePath = nil; }
    if (self.fileHandle != nil) { self.fileHandle = nil; }
//    if (self.expectedFileSize != nil) { self.expectedFileSize = nil; }
    
    [super dealloc];
}
@end
