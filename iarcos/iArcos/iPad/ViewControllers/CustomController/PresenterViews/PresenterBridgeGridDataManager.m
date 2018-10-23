//
//  PresenterBridgeGridDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 31/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PresenterBridgeGridDataManager.h"

@implementation PresenterBridgeGridDataManager
@synthesize numberOfBtn = _numberOfBtn;
@synthesize arcosMiniToolkit = _arcosMiniToolkit;
@synthesize displayList = _displayList;
@synthesize branchLeafMiscUtils = _branchLeafMiscUtils;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfBtn = 5;
        self.arcosMiniToolkit = [[[ArcosMiniToolkit alloc] init] autorelease];
        self.branchLeafMiscUtils = [[[BranchLeafMiscUtils alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.arcosMiniToolkit = nil;
    self.displayList = nil;
    self.branchLeafMiscUtils = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aDataList {
    self.displayList = [self.arcosMiniToolkit processSubsetArrayData:aDataList numberOfObjInRow:self.numberOfBtn];
}

@end
