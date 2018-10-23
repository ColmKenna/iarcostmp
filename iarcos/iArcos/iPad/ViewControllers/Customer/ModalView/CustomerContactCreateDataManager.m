//
//  CustomerContactCreateDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerContactCreateDataManager.h"

@implementation CustomerContactCreateDataManager

- (id)init {
    self = [super init];
    if (self != nil) {
        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String", @"IUR", @"Flags", @"System.Boolean", nil];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

@end
