//
//  PaginatedRequestObject.m
//  Arcos
//
//  Created by David Kilmartin on 19/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PaginatedRequestObject.h"

@implementation PaginatedRequestObject
@synthesize selectStateMent = _selectStateMent;
@synthesize fromStatement = _fromStatement;
@synthesize orderBy = _orderBy;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.selectStateMent = @"";
        self.fromStatement = @"";
        self.orderBy = @"";
    }
    
    return self;
}

- (void) dealloc {
    if (self.selectStateMent != nil) { self.selectStateMent = nil; }
    if (self.fromStatement != nil) { self.fromStatement = nil; }
    if (self.orderBy != nil) { self.orderBy = nil; }      
    
    [super dealloc];
}

@end
