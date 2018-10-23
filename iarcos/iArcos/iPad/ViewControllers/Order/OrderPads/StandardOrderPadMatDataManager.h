//
//  StandardOrderPadMatDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 05/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"

@interface StandardOrderPadMatDataManager : NSObject {
    NSMutableDictionary* _matDictHashtable;
    
}

@property(nonatomic, retain) NSMutableDictionary* matDictHashtable;

- (void)processMatDataList:(NSMutableArray*)aMatDictList;

@end
