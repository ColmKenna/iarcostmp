//
//  StandardOrderPadMatDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 05/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "StandardOrderPadMatDataManager.h"

@implementation StandardOrderPadMatDataManager
@synthesize matDictHashtable = _matDictHashtable;



- (void)dealloc {
    self.matDictHashtable = nil;
    
    [super dealloc];
}

- (void)processMatDataList:(NSMutableArray*)aMatDictList {
    self.matDictHashtable = [NSMutableDictionary dictionaryWithCapacity:[aMatDictList count]];
    for (int i = 0; i < [aMatDictList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aMatDictList objectAtIndex:i];
        NSNumber* productIUR = [ArcosUtils convertStringToNumber:arcosGenericClass.Field1];
        [self.matDictHashtable setObject:arcosGenericClass forKey:productIUR];
    }
}

@end
