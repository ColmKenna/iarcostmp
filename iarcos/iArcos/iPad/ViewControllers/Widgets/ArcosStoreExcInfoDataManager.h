//
//  ArcosStoreExcInfoDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 14/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface ArcosStoreExcInfoDataManager : NSObject {
    NSMutableDictionary* _storeExcInfoDict;
    NSString* _storeExcInfoKey;
}

@property(nonatomic, retain) NSMutableDictionary* storeExcInfoDict;
@property(nonatomic, retain) NSString* storeExcInfoKey;

+ (instancetype)storeExcInfoInstance;
- (BOOL)storeExcInfoPlistExistent;
- (NSString*)retrieveStoreExcInfo;
- (void)updateStoreExcInfo:(NSString*)aStoreExcInfo;
- (BOOL)persistentStoreExcInfo;

@end
