//
//  DashboardGenericDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardGenericDataManager.h"

@implementation DashboardGenericDataManager
@synthesize displayList = _displayList;


- (void)createBasicData {
    self.displayList = [NSMutableArray array];
    NSMutableArray* rowList = [NSMutableArray array];
    [rowList addObject:[self createLabelWithDesc:@"abc" percent:0.5 alignment:0]];
    [rowList addObject:[self createLabelWithDesc:@"def" percent:0.3 alignment:1]];
    [rowList addObject:[self createLabelWithDesc:@"ghi" percent:0.1 alignment:2]];
    [self.displayList addObject:rowList];
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createLabelWithDesc:(NSString*)aDesc percent:(float)aPercent alignment:(int)anAlignment{
    NSMutableDictionary* labelDataDict = [NSMutableDictionary dictionary];
    [labelDataDict setObject:aDesc forKey:@"fieldDesc"];
    [labelDataDict setObject:[NSNumber numberWithFloat:aPercent] forKey:@"fieldPercent"];
    [labelDataDict setObject:[NSNumber numberWithInt:anAlignment] forKey:@"fieldAlignment"];
    return labelDataDict;
}

@end
