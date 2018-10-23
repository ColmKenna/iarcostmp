//
//  StoreNewsDateDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 26/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface StoreNewsDateDataManager : NSObject {
    NSMutableDictionary* _storeNewsDateDict;
}

@property(nonatomic, retain) NSMutableDictionary* storeNewsDateDict;

+ (id)storeNewsDateInstance;
- (void)loadStoreNewsDatePlist;
- (void)loadDefaultStoreNewsDatePlist;
- (BOOL)storeNewsDatePlistExistent;
- (BOOL)saveStoreNewsDate;

@end
