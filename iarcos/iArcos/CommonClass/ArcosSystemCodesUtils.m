//
//  ArcosSystemCodesUtils.m
//  Arcos
//
//  Created by David Kilmartin on 17/10/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosSystemCodesUtils.h"

@implementation ArcosSystemCodesUtils


+ (BOOL)webServiceResourceExistence {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    //    NSLog(@"presenterPwd:%@", presenterPwd);
    NSRange aWSRRange = [presenterPwd rangeOfString:@"[WSR]"];
    if (aWSRRange.location != NSNotFound) return YES;
    return NO;
}

+ (id)handleResultErrorProcess:(id)result {
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)result;
        [ArcosUtils showMsg:[aSoapFault faultString] delegate:nil];
        return nil;
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
        return nil;
    }
    return result;
}

+ (BOOL)convertBase64ToPhysicalFile:(NSString*)result filePath:(NSString*)aFilePath {
    @try {
        NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
        BOOL saveFileFlag = [myNSData writeToFile:aFilePath atomically:YES];
        if (saveFileFlag) {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
        return NO;
    }
}

+ (BOOL)taskOptionExistence {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    //    NSLog(@"presenterPwd:%@", presenterPwd);
    NSRange aWSRRange = [presenterPwd rangeOfString:@"[TASK]"];
    if (aWSRRange.location != NSNotFound) return YES;
    return NO;
}

+ (BOOL)logoOptionExistence {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    //    NSLog(@"presenterPwd:%@", presenterPwd);
    NSRange aWSRRange = [presenterPwd rangeOfString:@"[LOGO]"];
    if (aWSRRange.location != NSNotFound) return YES;
    return NO;
}

+ (BOOL)myNewsOptionExistence {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSRange aWSRRange = [presenterPwd rangeOfString:@"[NEWS-"];
    if (aWSRRange.location != NSNotFound) return YES;
    return NO;
}

+ (NSNumber*)retrieveHourNumberInNewsOption {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSScanner* scanner = [NSScanner scannerWithString:presenterPwd];
    NSString* subString = nil;
    [scanner scanUpToString:@"[NEWS-" intoString:nil];
    [scanner scanString:@"[NEWS-" intoString:nil];
    [scanner scanUpToString:@"]" intoString:&subString];    
    return [ArcosUtils convertStringToFloatNumber:subString];
}

+ (BOOL)optionExistenceWithCode:(NSString*)aCode {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSRange aWSRRange = [presenterPwd rangeOfString:aCode];
    if (aWSRRange.location != NSNotFound) return YES;
    return NO;
}


+ (NSNumber*)retrieveNumberInOptionWithCode:(NSString*)aCode {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSScanner* scanner = [NSScanner scannerWithString:presenterPwd];
    NSString* subString = nil;
    [scanner scanUpToString:aCode intoString:nil];
    [scanner scanString:aCode intoString:nil];
    [scanner scanUpToString:@"]" intoString:&subString];
    
    return [ArcosUtils convertStringToNumber:subString];
}

+ (NSString*)retrieveDescrTypeCodeWithCode:(NSString*)aCode {
    NSScanner* scanner = [NSScanner scannerWithString:aCode];
    NSString* subString = @"";
    [scanner scanUpToString:@"[" intoString:nil];
    [scanner scanString:@"[" intoString:nil];
    [scanner scanUpToString:@"-" intoString:&subString];
    return subString;
}

+ (BOOL)allDashOptionExistence {
    return [self optionExistenceWithCode:@"[ALLDASH]"];
}

@end
