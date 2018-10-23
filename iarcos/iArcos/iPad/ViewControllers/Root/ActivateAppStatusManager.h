//
//  ActivateAppStatusManager.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface ActivateAppStatusManager : NSObject {
    NSMutableDictionary* _appStatusDict;
    NSString* _appStatusKey;
    NSNumber* _demoAppStatusNum;
    NSNumber* _activateAppStatusNum;
    NSNumber* _defaultAppStatusNum;
}

@property(nonatomic, retain) NSMutableDictionary* appStatusDict;
@property(nonatomic, retain) NSString* appStatusKey;
@property(nonatomic, retain) NSNumber* demoAppStatusNum;
@property(nonatomic, retain) NSNumber* activateAppStatusNum;
@property(nonatomic, retain) NSNumber* defaultAppStatusNum;

+ (id)appStatusInstance;
- (void)loadAppStatusPlist;
- (void)loadDefaultAppStatusPlist;
- (BOOL)appStatusPlistExistent;
- (NSNumber*)getAppStatus;
- (void)updateAppStatus:(NSNumber*)anAppStatus;
- (BOOL)saveAppStatus;
- (BOOL)saveDemoAppStatus;
- (BOOL)saveActivateAppStatus;
- (BOOL)saveDefaultAppStatus;
- (CompositeErrorResult*)loadDemoSettingFromBundle;


@end
