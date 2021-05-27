//
//  ArcosSystemCodesUtils.h
//  Arcos
//
//  Created by David Kilmartin on 17/10/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "ArcosUtils.h"
#import "SoapFault.h"

@interface ArcosSystemCodesUtils : NSObject

+ (BOOL)webServiceResourceExistence;
+ (id)handleResultErrorProcess:(id)result;
+ (BOOL)convertBase64ToPhysicalFile:(NSString*)result filePath:(NSString*)aFilePath;
+ (BOOL)taskOptionExistence;
+ (BOOL)logoOptionExistence;
+ (BOOL)myNewsOptionExistence;
+ (NSNumber*)retrieveHourNumberInNewsOption;
+ (BOOL)optionExistenceWithCode:(NSString*)aCode;
+ (NSNumber*)retrieveNumberInOptionWithCode:(NSString*)aCode;
+ (NSString*)retrieveDescrTypeCodeWithCode:(NSString*)aCode;
+ (BOOL)allDashOptionExistence;

@end
