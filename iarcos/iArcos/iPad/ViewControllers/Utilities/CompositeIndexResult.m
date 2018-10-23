//
//  CompositeIndexResult.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "CompositeIndexResult.h"

@implementation CompositeIndexResult
@synthesize sectionTitle = _sectionTitle;
@synthesize indexPath = _indexPath;

- (void)dealloc {
    self.sectionTitle = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

@end
