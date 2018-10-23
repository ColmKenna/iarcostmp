//
//  ExtendedSettingManager.h
//  Arcos
//
//  Created by David Kilmartin on 20/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface ExtendedSettingManager : NSObject {
    NSMutableDictionary* _extendedSettingDict;
}

@property(nonatomic,retain) NSMutableDictionary* extendedSettingDict;

- (void)loadExtendedSettingPlist;
- (void)loadDefaultExtendedSettingPlist;
- (BOOL)isVersionDiffNotExistent;
- (NSString*)extendedSettingPlistPath;
- (NSString*)defaultExtendedSettingPlistPath;
- (BOOL)isExtendedSettingPlistExistent;
- (NSUInteger)numberOfItemsOnKeypath:(NSString*)aKeypath;
- (NSMutableDictionary*)getSettingForKeypath:(NSString*)aKeypath atIndex:(NSUInteger)anIndex;
- (void)updateSettingForKeypath:(NSString*)aKeypath atIndex:(NSUInteger)anIndex withData:(id)aData;
- (BOOL)saveSetting;


@end
