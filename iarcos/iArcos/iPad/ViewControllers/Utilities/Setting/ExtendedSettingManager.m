//
//  ExtendedSettingManager.m
//  Arcos
//
//  Created by David Kilmartin on 20/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ExtendedSettingManager.h"

@implementation ExtendedSettingManager
@synthesize extendedSettingDict = _extendedSettingDict;

- (id)init {
    self = [super init];
    if (self != nil) {
        if (![self isExtendedSettingPlistExistent]) {
            [self loadDefaultExtendedSettingPlist];
        } else {
            if ([self isVersionDiffNotExistent]) {
                [self loadExtendedSettingPlist];
            } else {
                [self loadDefaultExtendedSettingPlist];
            }
        }
    }
    return self;
}

- (void)dealloc {
    if (self.extendedSettingDict != nil) { self.extendedSettingDict = nil; }        
        
    [super dealloc];
}

- (void)loadExtendedSettingPlist {
    self.extendedSettingDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self extendedSettingPlistPath]];
}

- (void)loadDefaultExtendedSettingPlist {
    NSString* defaultExtendedSettingPath = [self defaultExtendedSettingPlistPath];
    self.extendedSettingDict = [NSMutableDictionary dictionaryWithContentsOfFile:defaultExtendedSettingPath];
    [self.extendedSettingDict writeToFile:[self extendedSettingPlistPath] atomically:YES];
}

- (BOOL)isVersionDiffNotExistent {
    NSMutableDictionary* tmpDefaultExtendedSettingDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self defaultExtendedSettingPlistPath]];
    NSMutableDictionary* tmpExtendedSettingDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self extendedSettingPlistPath]];
    NSString* defaultVersion = [tmpDefaultExtendedSettingDict objectForKey:@"Version"];
    NSString* version = [tmpExtendedSettingDict objectForKey:@"Version"];
    if ([version isEqualToString:defaultVersion]) {
        return YES;
    }
    return NO;
}

- (NSString*)extendedSettingPlistPath {
    NSString* filePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"setting/ExtendedDefaultSetting.plist"]];
    return filePath;
}

- (NSString*)defaultExtendedSettingPlistPath {
    NSString* defaultFilePath = [[NSBundle mainBundle] pathForResource:@"ExtendedDefaultSetting" ofType:@"plist"];
    return defaultFilePath;
}

- (BOOL)isExtendedSettingPlistExistent {
    if ([FileCommon fileExistAtPath:[self extendedSettingPlistPath]]) {
        return YES;
    } else {
        [FileCommon createFolder:@"setting"];
        return NO;
    }
}

- (NSUInteger)numberOfItemsOnKeypath:(NSString*)aKeypath {
    NSMutableArray* items = [self.extendedSettingDict valueForKeyPath:aKeypath];
    if (items == nil) {
        return 0;
    }else{
        return [items count];
    }
}

- (NSMutableDictionary*)getSettingForKeypath:(NSString*)aKeypath atIndex:(NSUInteger)anIndex {
    NSMutableArray* items = [self.extendedSettingDict valueForKeyPath:aKeypath];
    NSMutableDictionary* item = [items objectAtIndex:anIndex];
    return item;
}

- (void)updateSettingForKeypath:(NSString*)aKeypath atIndex:(NSUInteger)anIndex withData:(id)aData {
    NSMutableArray* items = [self.extendedSettingDict valueForKeyPath:aKeypath];
    NSMutableDictionary* item = [items objectAtIndex:anIndex];
    [item setObject:aData forKey:@"Value"];
    [items replaceObjectAtIndex:anIndex withObject:item];
    [self.extendedSettingDict setValue:items forKeyPath:aKeypath];
}

- (BOOL)saveSetting {
    BOOL isSuccess = [self.extendedSettingDict writeToFile:[self extendedSettingPlistPath] atomically:YES];    
    return isSuccess;
}


@end
