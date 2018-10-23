//
//  UploadWebServiceDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 15/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UploadWebServiceDataManager.h"

@implementation UploadWebServiceDataManager
@synthesize collectedDataDictList = _collectedDataDictList;
@synthesize filteredCollectedDataDictList = _filteredCollectedDataDictList;
@synthesize collectedRowPointer = _collectedRowPointer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.collectedDataDictList = [NSMutableArray array];
        self.filteredCollectedDataDictList = [NSMutableArray array];
        self.collectedRowPointer = 0;
    }
    return self;
}

- (void)dealloc {
    self.collectedDataDictList = nil;
    self.filteredCollectedDataDictList = nil;
    
    [super dealloc];
}

@end
