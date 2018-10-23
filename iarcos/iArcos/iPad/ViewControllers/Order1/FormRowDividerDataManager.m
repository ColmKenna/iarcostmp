//
//  FormRowDividerDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FormRowDividerDataManager.h"

@implementation FormRowDividerDataManager
@synthesize displayList = _displayList;

- (id)init{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }    
    
    [super dealloc];
}

- (void)createBasicData:(NSNumber*)aFormIUR {
    if (aFormIUR == nil) return;
    self.displayList = [[ArcosCoreData sharedArcosCoreData] selectionWithFormIUR:aFormIUR];
    [self.displayList insertObject:[self createAllNodeDict] atIndex:0];
}

- (NSMutableDictionary*)createAllNodeDict {
    NSMutableDictionary* allNodeDict = [NSMutableDictionary dictionary];
    [allNodeDict setObject:@"All" forKey:@"Details"];
    [allNodeDict setObject:[NSNumber numberWithInt:-1] forKey:@"SequenceDivider"];
    return allNodeDict;
}

@end
