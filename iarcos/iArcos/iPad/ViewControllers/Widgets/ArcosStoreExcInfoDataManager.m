//
//  ArcosStoreExcInfoDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 14/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ArcosStoreExcInfoDataManager.h"

@implementation ArcosStoreExcInfoDataManager
@synthesize storeExcInfoDict = _storeExcInfoDict;
@synthesize storeExcInfoKey = _storeExcInfoKey;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storeExcInfoKey = @"StoreExcInfo";
        if (![self storeExcInfoPlistExistent]) {
            [self loadDefaultStoreExcInfoPlist];
        } else {
            [self loadStoreExcInfoPlist];
        }
    }
    return self;
}

+ (instancetype)storeExcInfoInstance {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.storeExcInfoDict = nil;
    self.storeExcInfoKey = nil;
    
    [super dealloc];
}

- (BOOL)storeExcInfoPlistExistent {
    if ([FileCommon fileExistAtPath:[FileCommon storeExcInfoPlistPath]]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)loadStoreExcInfoPlist {
    self.storeExcInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon storeExcInfoPlistPath]];
}

- (void)loadDefaultStoreExcInfoPlist {
    NSString* defaultStoreExcInfoPlistPath = [[NSBundle mainBundle] pathForResource:@"StoreExcInfo" ofType:@"plist"];
    self.storeExcInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile: defaultStoreExcInfoPlistPath];
    [self.storeExcInfoDict writeToFile:[FileCommon storeExcInfoPlistPath] atomically:YES];
}

- (NSString*)retrieveStoreExcInfo {
    return [self.storeExcInfoDict objectForKey:self.storeExcInfoKey];
}

- (void)updateStoreExcInfo:(NSString*)aStoreExcInfo {
    [self.storeExcInfoDict setObject:aStoreExcInfo forKey:self.storeExcInfoKey];
}

- (BOOL)persistentStoreExcInfo {
    return [self.storeExcInfoDict writeToFile:[FileCommon storeExcInfoPlistPath] atomically:YES];
}

@end
