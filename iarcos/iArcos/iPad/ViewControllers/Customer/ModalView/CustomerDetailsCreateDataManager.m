//
//  CustomerDetailsCreateDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsCreateDataManager.h"

@implementation CustomerDetailsCreateDataManager

- (id)init {
    self = [super init];
    if (self != nil) {
        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String", @"IUR", @"System.Boolean", nil];
    }
    return self;
}

@end
