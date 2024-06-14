//
//  ReporterCsvDataManager.m
//  iArcos
//
//  Created by Richard on 10/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReporterCsvDataManager.h"

@implementation ReporterCsvDataManager
@synthesize attrNameList = _attrNameList;
@synthesize displayList = _displayList;
@synthesize cellWidth = _cellWidth;
@synthesize cellHeight = _cellHeight;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.cellWidth = 128;
        self.cellHeight = 44;
    }
    return self;
}

- (void)dealloc {
    self.attrNameList = nil;
    self.displayList = nil;
    
    [super dealloc];
}


- (void)processRawDataWithFilePath:(NSString*)aFilePath {
    self.attrNameList = [NSArray array];
    self.displayList = [NSMutableArray array];
    int expectedFieldCount = -1;
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile:aFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* rowList = [fileContents componentsSeparatedByString:[GlobalSharedClass shared].rowDelimiter];
    [fileContents release];
    if ([rowList count] >= 1) {
        NSString* headingRow = [rowList objectAtIndex:0];
        NSArray* fieldList = [headingRow componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
        self.attrNameList = [NSArray arrayWithArray:fieldList];
        expectedFieldCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[fieldList count]];
//        NSLog(@"\n%ld", [fieldList count]);
//        NSLog(@"\nfieldList %@", fieldList);
    }
    if ([rowList count] >= 2) {
        for (int i = 1; i < [rowList count]; i++) {
            NSString* bodyRow = [rowList objectAtIndex:i];
            NSArray* bodyFieldList = [bodyRow componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
            if ([bodyFieldList count] == expectedFieldCount) {
                [self.displayList addObject:bodyFieldList];
            }
        }
    }
//    NSLog(@"aa %@", self.displayList);
}

@end
