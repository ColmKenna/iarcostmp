//
//  FileSharedClass.m
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FileSharedClass.h"


@implementation FileSharedClass
SYNTHESIZE_SINGLETON_FOR_CLASS(FileSharedClass);
-(id)init{
    self=[super init];
    if (self!=nil) {
        
    }
    return self;
}

-(BOOL)createFolder:(NSString*)folderName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", folderName]];
    
    NSError* error;
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
-(BOOL)fileExistInFolder:(NSString*)folderName withFileName:(NSString*)fileName{
    if (folderName==nil || [folderName isEqualToString:@""]) {
        return NO;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", folderName,fileName]];
    
    NSError* error;
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
-(BOOL)saveFileToFolder:(NSString*)folderName withName:(NSString*)fileName withData:(NSData*)data{
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
@end
