//
//  ArcosMiniToolkit.m
//  iArcos
//
//  Created by David Kilmartin on 01/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosMiniToolkit.h"

@implementation ArcosMiniToolkit

- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList numberOfObjInRow:(int)aNumberOfObjInRow {
    NSMutableArray* resultDisplayList  = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % aNumberOfObjInRow == 0) {
            [resultDisplayList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [resultDisplayList addObject:subsetDisplayList];
    }
    return resultDisplayList;
}

@end
