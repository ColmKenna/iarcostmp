//
//  StoreNewsDateDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "StoreNewsDateDataManager.h"

@implementation StoreNewsDateDataManager
@synthesize storeNewsDateDict = _storeNewsDateDict;

- (id)init{
    self = [super init];
    if (self != nil) {
        if (![self storeNewsDatePlistExistent]) {
            [self loadDefaultStoreNewsDatePlist];
        } else {
            [self loadStoreNewsDatePlist];
        }
    }
    return self;
}

+ (id)storeNewsDateInstance {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.storeNewsDateDict = nil;
    
    [super dealloc];
}

- (void)loadStoreNewsDatePlist {
    self.storeNewsDateDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon storeNewsDatePlistPath]];
}

- (void)loadDefaultStoreNewsDatePlist {
    NSString* defaultStoreNewsDatePlistPath = [[NSBundle mainBundle] pathForResource:@"StoreNewsDate" ofType:@"plist"];
    self.storeNewsDateDict = [NSMutableDictionary dictionaryWithContentsOfFile: defaultStoreNewsDatePlistPath];
    [self.storeNewsDateDict writeToFile:[FileCommon storeNewsDatePlistPath] atomically:YES];
}

- (BOOL)storeNewsDatePlistExistent {
    if ([FileCommon fileExistAtPath:[FileCommon storeNewsDatePlistPath]]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)saveStoreNewsDate {
    [self.storeNewsDateDict setObject:[NSNumber numberWithBool:YES] forKey:@"NotFirstTime"];
    [self.storeNewsDateDict setObject:[NSDate date] forKey:@"Date"];
    return [self.storeNewsDateDict writeToFile:[FileCommon storeNewsDatePlistPath] atomically:YES];
}

@end
