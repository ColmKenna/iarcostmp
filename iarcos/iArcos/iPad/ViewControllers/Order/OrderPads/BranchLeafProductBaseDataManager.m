//
//  BranchLeafProductBaseDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 22/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductBaseDataManager.h"

@implementation BranchLeafProductBaseDataManager
@synthesize branchLeafMiscUtils = _branchLeafMiscUtils;
@synthesize leafSmallTemplateViewController = _leafSmallTemplateViewController;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.branchLeafMiscUtils = [[[BranchLeafMiscUtils alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.branchLeafMiscUtils != nil) { self.branchLeafMiscUtils = nil; }
    if (self.leafSmallTemplateViewController != nil) {
        self.leafSmallTemplateViewController = nil;
    }
    
    [super dealloc];
}

- (id)showProductTableViewController:(NSString*)aBranchLxCodeContent branchLxCode:(NSString*)aBranchLxCode leafLxCodeContent:(NSString*)anLeafLxCodeContent leafLxCode:(NSString*)anLeafLxCode {
    return nil;
}

@end
