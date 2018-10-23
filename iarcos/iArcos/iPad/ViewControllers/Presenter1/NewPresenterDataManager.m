//
//  NewPresenterDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 11/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "NewPresenterDataManager.h"

@implementation NewPresenterDataManager
@synthesize rowPointer = _rowPointer;
@synthesize candidateRemovedFileList = _candidateRemovedFileList;
@synthesize removedFileList = _removedFileList;
@synthesize auxEmailCellData = _auxEmailCellData;
@synthesize resultFileList = _resultFileList;
@synthesize groupName = _groupName;

- (void)dealloc {
    self.candidateRemovedFileList = nil;
    self.removedFileList = nil;
    self.auxEmailCellData = nil;
    self.resultFileList = nil;
    self.groupName = nil;
    
    [super dealloc];
}

- (NSMutableArray*)getGroupPresenterItems:(NSMutableArray*)aPresenterProducts {
    NSMutableArray* resultList = [NSMutableArray array];
    for (int i = 0; i < [aPresenterProducts count]; i++) {
        NSMutableDictionary* aPresentProduct = [aPresenterProducts objectAtIndex:i];
        [resultList addObject:aPresentProduct];
        NSNumber* presenterIUR = [aPresentProduct objectForKey:@"IUR"];
        NSMutableArray* presenterChildren = [[ArcosCoreData sharedArcosCoreData]presenterChildrenWithParentIUR:presenterIUR];
        for (int j = 0; j < [presenterChildren count]; j++) {
            [resultList addObject:[presenterChildren objectAtIndex:j]];
        }
    }
    return resultList;
}

- (NSString*)getMimeTypeWithFileName:(NSString*)aFileName {
    NSString* mimeTypeString = @"application/octet-stream";
    @try {
        NSArray* fileComponents = [aFileName componentsSeparatedByString:@"."];
        // Use the filename (index 0) and the extension (index 1) to get path
        NSString* fileExtension = [fileComponents objectAtIndex:1];
        if ([@"png" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/png";
        } else if ([@"jpg" isEqualToString:fileExtension] || [@"jpeg" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/jpeg";
        } else if ([@"pdf" isEqualToString:fileExtension]) {
            mimeTypeString = @"application/pdf";
        } else if ([@"mov" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/quicktime";
        } else if ([@"mp4" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/mp4";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    return mimeTypeString;
}

- (void)getOverSizeFileListFromDataList:(NSMutableArray*)aDataList {
    self.candidateRemovedFileList = [NSMutableArray array];
    int sizeLimit = 1024*1024*10;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    for (int i = 0; i < [aDataList count]; i++) {
        NSDictionary* tmpPresenterProduct = [aDataList objectAtIndex:i];
        NSString* fileName = [tmpPresenterProduct objectForKey:@"Name"];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        if ([FileCommon fileExistAtPath:filePath]) {
            NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
            NSNumber* fileSize = [fileAttributes objectForKey:@"NSFileSize"];
            if ([fileSize unsignedLongLongValue] > sizeLimit) {
                NSMutableDictionary* newTmpPresenterProduct = [NSMutableDictionary dictionaryWithDictionary:tmpPresenterProduct];
                [newTmpPresenterProduct setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:fileSize useSiPrefixes:YES useSiMultiplier:NO] forKey:@"fileSize"];
                [self.candidateRemovedFileList addObject:newTmpPresenterProduct];
            }
        }
    }
}

- (BOOL)isFileInRemovedList:(NSString*)fileName {
    BOOL resultFlag = NO;
    for (int i = 0; i < [self.removedFileList count]; i++) {
        NSMutableDictionary* tmpPresenterProduct = [self.removedFileList objectAtIndex:i];
        NSString* tmpFileName = [tmpPresenterProduct objectForKey:@"Name"];
        if ([tmpFileName isEqualToString:fileName]) {
            resultFlag = YES;
            break;
        }
    }
    return resultFlag;
}

@end
