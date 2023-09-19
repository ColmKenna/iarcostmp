//
//  SubMenuListingDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 24/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SubMenuListingDataManager.h"

@implementation SubMenuListingDataManager
@synthesize locationCellData = _locationCellData;
@synthesize lsCodeType = _lsCodeType;


- (void)dealloc {
    self.locationCellData = nil;
    self.lsCodeType = nil;
    
    [super dealloc];
}

- (void)locationStatusProcessor:(NSNumber*)aLsiur {
    NSDictionary* locationStatusDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:aLsiur needActive:NO];
    if (locationStatusDict != nil) {
        self.lsCodeType = [locationStatusDict objectForKey:@"CodeType"];
        if ([self.lsCodeType intValue] != 0) {
//            [ArcosUtils showMsg:[ArcosUtils convertNilToEmpty:[locationStatusDict objectForKey:@"Tooltip"]] delegate:nil];
            [ArcosUtils showDialogBox:[ArcosUtils convertNilToEmpty:[locationStatusDict objectForKey:@"Tooltip"]] title:@"" target:[ArcosUtils getRootView] handler:nil];
        }
    }
}

- (BOOL)checkLocationCode {
    NSString* tmpLocationCode = [self.locationCellData objectForKey:@"LocationCode"];
    NSString* locationCode = [tmpLocationCode uppercaseString];
    if (locationCode != nil && [locationCode hasPrefix:@"HQ:"]) {
//        [ArcosUtils showMsg:@"Order Entry disabled for Head Office accounts" delegate:nil];
        [ArcosUtils showDialogBox:@"Order Entry disabled for Head Office accounts" title:@"" target:[ArcosUtils getRootView] handler:nil];
        return NO;
    }
    return YES;
}

- (BOOL)checkCreditStatus {
    NSDictionary* descDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:[self.locationCellData objectForKey:@"CSiur"]];
    if (descDict != nil) {
        NSNumber* codeType = [descDict objectForKey:@"CodeType"];
        if ([codeType intValue] != 0) {
//            [ArcosUtils showMsg:[ArcosUtils convertNilToEmpty:[descDict objectForKey:@"Tooltip"] ]delegate:nil];
            [ArcosUtils showDialogBox:[ArcosUtils convertNilToEmpty:[descDict objectForKey:@"Tooltip"]] title:@"" target:[ArcosUtils getRootView] handler:nil];
        }
        if ([codeType intValue] == 2) {
            return NO;
        }
    }
    return YES;
}

- (void)dialUpNumberProcessor:(NSMutableDictionary*)aCellData {
    NSString* dialupNumberContent = [aCellData objectForKey:@"DialupNumber"];
    if (dialupNumberContent != nil && ![dialupNumberContent isEqualToString:@""]) {
//        [ArcosUtils showMsg:dialupNumberContent delegate:nil];
        [ArcosUtils showDialogBox:dialupNumberContent title:@"" target:[ArcosUtils getRootView] handler:nil];
    }
}

- (BOOL)checkDialUpNumber {
    NSString* dialupNumberContent = [self.locationCellData objectForKey:@"DialupNumber"];
    if (dialupNumberContent != nil && ![dialupNumberContent isEqualToString:@""]) {
        NSRange myRange = [dialupNumberContent rangeOfString:@"["];
        if (myRange.location != NSNotFound) {
//            [ArcosUtils showMsg:@"ORDER ENTRY RESTRICTED" delegate:nil];
            [ArcosUtils showDialogBox:@"ORDER ENTRY RESTRICTED" title:@"" target:[ArcosUtils getRootView] handler:nil];
            return NO;
        }
    }
    return YES;
}

@end
