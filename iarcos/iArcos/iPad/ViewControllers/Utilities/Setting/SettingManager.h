//
//  SettingManager.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface SettingManager : NSObject {
    NSMutableDictionary* settingDict;
}
@property(nonatomic,retain)    NSMutableDictionary* settingDict;

+(id)setting;
-(BOOL)loadSetting;
-(BOOL)saveSetting;
-(BOOL)updateSettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index withData:(id)data;
-(id)getSettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index;
-(NSUInteger)numberOfItemsOnKeypath:(NSString*)keypath;
-(NSArray*)keysForSettingCat:(NSString*)settingCat;
-(BOOL)loadDefaultFromBoundle;
-(BOOL)loadDefaultSetting;
-(BOOL)reloadSetting;

+(NSNumber*)DisplayInactiveRecord;
+(NSNumber*)NextOrderNumber;
+(void)SetNextOrderNumber:(NSNumber*)number;
+(NSNumber*)SettingForKeypath:(NSString*)keypath atIndex:(NSUInteger)index;

+(NSNumber*)companyIUR;
+(NSNumber*)employeeIUR;
+(NSString*)downloadServer;
+(NSString*)serviceAddress;
+(NSString*)hostAddress;
+(NSNumber*)defaultOrderSentStatus;
+(BOOL)restrictOrderForm;
+(NSString*)arcosAdminEmail;
@end
