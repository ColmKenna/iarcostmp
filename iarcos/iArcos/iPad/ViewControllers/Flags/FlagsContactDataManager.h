//
//  FlagsContactDataManager.h
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface FlagsContactDataManager : NSObject {
    
}

- (NSMutableArray*)retrieveContactListWithLocationDict:(NSMutableDictionary*)aLocationDict;

@end

