//
//  ReporterGroupMainDataManager.m
//  iArcos
//
//  Created by Richard on 18/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterGroupMainDataManager.h"

@implementation ReporterGroupMainDataManager
@synthesize originalDisplayList = _originalDisplayList;
@synthesize numberOfBtn = _numberOfBtn;
@synthesize displayList = _displayList;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.originalDisplayList = [NSMutableArray array];
        self.numberOfBtn = 5;
        self.displayList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    self.originalDisplayList = nil;
    self.displayList = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aDisplayList {
    self.originalDisplayList = aDisplayList;
    NSMutableDictionary* groupDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[aDisplayList count]];
    for (int i = 0; i < [aDisplayList count]; i++) {
        ArcosGenericClass* aReporter = [aDisplayList objectAtIndex:i];
        NSString* groupDetail = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:aReporter.Field14]];
        [groupDetailHashMap setObject:groupDetail forKey:groupDetail];
    }
    NSArray* tmpDisplayList = [[groupDetailHashMap allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.displayList = [self processSubsetArrayData:tmpDisplayList];
}

- (NSMutableArray*)processSubsetArrayData:(NSArray*)aDisplayList {
    NSMutableArray* groupDetailArrayList  = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % self.numberOfBtn == 0) {
            [groupDetailArrayList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [groupDetailArrayList addObject:subsetDisplayList];
    }
    return groupDetailArrayList;
}

- (NSMutableArray*)retrieveReporterListWithGroupDetail:(NSString*)aGroupDetail {
    NSMutableArray* reporterList = [NSMutableArray array];
    for (int i = 0; i < [self.originalDisplayList count]; i++) {
        ArcosGenericClass* auxReporter = [self.originalDisplayList objectAtIndex:i];
        NSString* auxGroupDetail = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:auxReporter.Field14]];
        if ([auxGroupDetail isEqualToString:aGroupDetail]) {
            [reporterList addObject:auxReporter];
        }
    }
    return reporterList;
}

@end
