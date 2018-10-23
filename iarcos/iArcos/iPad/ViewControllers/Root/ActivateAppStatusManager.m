//
//  ActivateAppStatusManager.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateAppStatusManager.h"

@implementation ActivateAppStatusManager
@synthesize appStatusDict = _appStatusDict;
@synthesize appStatusKey = _appStatusKey;
@synthesize demoAppStatusNum = _demoAppStatusNum;
@synthesize activateAppStatusNum = _activateAppStatusNum;
@synthesize defaultAppStatusNum = _defaultAppStatusNum;

/*
 *0:default 10:demo 100:activate
 */
- (id)init{
    self = [super init];
    if (self != nil) {
        if (![self appStatusPlistExistent]) {
            [self loadDefaultAppStatusPlist];
        } else {
            [self loadAppStatusPlist];
        }
        self.appStatusKey = @"AppStatus";
        self.demoAppStatusNum = [NSNumber numberWithInt:10];
        self.activateAppStatusNum = [NSNumber numberWithInt:100];
        self.defaultAppStatusNum = [NSNumber numberWithInt:0];
//        NSLog(@"appStatusDict: %@", self.appStatusDict);
    }
    return self;
}

+ (id)appStatusInstance {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    self.appStatusDict = nil;
    self.appStatusKey = nil;
    self.demoAppStatusNum = nil;
    self.activateAppStatusNum = nil;
    self.defaultAppStatusNum = nil;
    
    [super dealloc];
}

- (void)loadAppStatusPlist {
    self.appStatusDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon appStatusPlistPath]];
}

- (void)loadDefaultAppStatusPlist {
    NSString* defaultAppStatusPlistPath = [[NSBundle mainBundle] pathForResource:@"AppStatus" ofType:@"plist"];
    self.appStatusDict = [NSMutableDictionary dictionaryWithContentsOfFile: defaultAppStatusPlistPath];
    [self.appStatusDict writeToFile:[FileCommon appStatusPlistPath] atomically:YES];
}

- (BOOL)appStatusPlistExistent {
    if ([FileCommon fileExistAtPath:[FileCommon appStatusPlistPath]]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSNumber*)getAppStatus {
    return [self.appStatusDict objectForKey:self.appStatusKey];
}

- (void)updateAppStatus:(NSNumber*)anAppStatus {
    [self.appStatusDict setObject:anAppStatus forKey:self.appStatusKey];
}

- (BOOL)saveAppStatus {
    return [self.appStatusDict writeToFile:[FileCommon appStatusPlistPath] atomically:YES];
}

- (BOOL)saveDemoAppStatus {
    [self updateAppStatus:self.demoAppStatusNum];
    return [self saveAppStatus];
}

- (BOOL)saveActivateAppStatus {
    [self updateAppStatus:self.activateAppStatusNum];
    return [self saveAppStatus];
}

- (BOOL)saveDefaultAppStatus {
    [self updateAppStatus:self.defaultAppStatusNum];
    return [self saveAppStatus];
}

- (CompositeErrorResult*)loadDemoSettingFromBundle {
    NSString* settingSrcPath = [[NSBundle mainBundle] pathForResource:@"demoSetting" ofType:@"plist"];
    NSString* settingDescPath = [FileCommon settingFilePath];
//    NSError* settingError = nil;
    return [FileCommon testCopyItemAtPath:settingSrcPath toPath:settingDescPath];
//    return settingResultFlag;
}

@end
