//
//  ArcosConfigDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 21/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ArcosConfigDataManager.h"
@interface ArcosConfigDataManager ()
- (BOOL)retrieveConfigFlagByIndex:(int)anIndex;
@end

@implementation ArcosConfigDataManager
SYNTHESIZE_SINGLETON_FOR_CLASS(ArcosConfigDataManager);

@synthesize systemCodes = _systemCodes;


-(id)init {
    self = [super init];
    if (self != nil) {
        NSMutableDictionary* configurationDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon configurationPlistPath]];
        self.systemCodes = [configurationDict objectForKey:@"SystemCodes"];
    }
    
    return self;
}

- (void)dealloc {
    self.systemCodes = nil;
    
    [super dealloc];
}

- (BOOL)recordPresenterTransactionFlag {
    return [self retrieveConfigFlagByIndex:6];
}

- (BOOL)downloadDataByCSVFlag {
    return [self retrieveConfigFlagByIndex:12];
}

- (BOOL)retrieveLocationProductMATDataLocallyFlag {
    return [self retrieveConfigFlagByIndex:2];
}

- (BOOL)recordTasksFlag {
    return [self retrieveConfigFlagByIndex:5];
}

- (BOOL)hideCustomerDetailsAfterUpdateFlag {
    return [self retrieveConfigFlagByIndex:1];
}

- (BOOL)enableAutosaveFlag {
    return [self retrieveConfigFlagByIndex:9];
}

- (BOOL)showAccountBalancesFlag {
    return [self retrieveConfigFlagByIndex:3];
}

- (BOOL)showCompanyOverviewFlag {
    return [self retrieveConfigFlagByIndex:4];
}

- (BOOL)recordPIRequestFlag {
    return [self retrieveConfigFlagByIndex:7];
}

- (BOOL)recordPIGivenFlag {
    return [self retrieveConfigFlagByIndex:8];
}

- (BOOL)checkMultiplesOfUnitsPerPackFlag {
    return [self retrieveConfigFlagByIndex:13];
}

- (BOOL)checkDrilldownOfOrderCall {
    return [self retrieveConfigFlagByIndex:15];
}

- (BOOL)showInStockFlag {
    return [self retrieveConfigFlagByIndex:10];
}

- (BOOL)excludeValueFromOrderEmailFlag {
    return [self retrieveConfigFlagByIndex:17];
}

- (BOOL)showMATWithQtyPopoverFlag {
    return [self retrieveConfigFlagByIndex:11];
}

- (BOOL)allowScannerToBeUsedFlag {
    return [self retrieveConfigFlagByIndex:18];
}

- (BOOL)allowTopxCustomerFlag {
    return [self retrieveConfigFlagByIndex:19];
}

- (BOOL)allowTopxCompanyFlag {
    return [self retrieveConfigFlagByIndex:20];
}

- (BOOL)includeCallTimeFlag {
    return [self retrieveConfigFlagByIndex:21];
}

- (BOOL)enableCreateLocationByEmailFlag {
    return [self retrieveConfigFlagByIndex:22];
}

- (BOOL)enableEditLocationByEmailFlag {
    return [self retrieveConfigFlagByIndex:23];
}

- (BOOL)recordInStockRBFlag {
    return [self retrieveConfigFlagByIndex:24];
}

- (BOOL)allowDownloadByEmployeeFlag {
    return [self retrieveConfigFlagByIndex:26];
}

- (BOOL)enableCreateContactByEmailFlag {
    return [self retrieveConfigFlagByIndex:27];
}

- (BOOL)enableEditContactByEmailFlag {
    return [self retrieveConfigFlagByIndex:28];
}

- (BOOL)showProductCodeFlag {
    return [self retrieveConfigFlagByIndex:30];
}

- (BOOL)uploadPhotoAfterSendingOrderFlag {
    return [self retrieveConfigFlagByIndex:31];
}

- (BOOL)showWholesalerLogoFlag {
    return [self retrieveConfigFlagByIndex:33];
}

- (BOOL)unloadSurveyResponseFlag {
    return [self retrieveConfigFlagByIndex:35];
}

- (BOOL)showCallTypeFlag {
    return [self retrieveConfigFlagByIndex:36];
}

- (BOOL)enablePrinterFlag {
    return [self retrieveConfigFlagByIndex:38];
}

- (BOOL)enableVanSaleFlag {
    return [self retrieveConfigFlagByIndex:37];
}

- (BOOL)checkAccountNumberFlag {
    return [self retrieveConfigFlagByIndex:39];
}

- (BOOL)enableSendOriginalPhotoFlag {
    return [self retrieveConfigFlagByIndex:40];
}

- (BOOL)enableSelectionBoxInCallEntryFlag {
    return [self retrieveConfigFlagByIndex:41];
}

- (BOOL)enableAlternativeLogoFlag {
    return [self retrieveConfigFlagByIndex:42];
}

- (BOOL)enableUsePriceListFlag {
    return [self retrieveConfigFlagByIndex:29];
}

- (BOOL)enableUsePriceProductGroupFlag {
    return [self retrieveConfigFlagByIndex:43];    
}

- (BOOL)showDeliveryInstructionsFlag {
    return [self retrieveConfigFlagByIndex:44];
}

- (BOOL)showTotalVATInvoiceFlag {
    return [self retrieveConfigFlagByIndex:46];
}

- (BOOL)hideInStockRBFlag {
    return [self retrieveConfigFlagByIndex:47];
}

- (BOOL)useMailLibFlag {
    return [self retrieveConfigFlagByIndex:48];
}

- (BOOL)useWeightToCalculatePriceFlag {
    return [self retrieveConfigFlagByIndex:49];
}

- (BOOL)showGDPRFlag {
    return [self retrieveConfigFlagByIndex:50];
}

- (BOOL)enableProductCheckFlag {
    return [self retrieveConfigFlagByIndex:53];
}

- (BOOL)enablePriceChangeFlag {
    return [self retrieveConfigFlagByIndex:52];
}

- (BOOL)showRRPInOrderPadFlag {
    return [self retrieveConfigFlagByIndex:54];
}

- (BOOL)clearWholeSalerFlag {
    return [self retrieveConfigFlagByIndex:55];
}

- (BOOL)clearOrderTypeFlag {
    return [self retrieveConfigFlagByIndex:56];
}

- (BOOL)disableMemoFlag {
    return [self retrieveConfigFlagByIndex:57];
}

- (BOOL)forceEnterCusRefOnCheckoutFlag {
    return [self retrieveConfigFlagByIndex:58];
}

- (BOOL)showMeetingFlag {
    return [self retrieveConfigFlagByIndex:59];
}

- (BOOL)showTargetFlag {
    return [self retrieveConfigFlagByIndex:60];
}

- (BOOL)showTaskInCallEmailFlag {
    return [self retrieveConfigFlagByIndex:61];
}

- (BOOL)showSingleTaskFlag {
    return [self retrieveConfigFlagByIndex:62];
}

- (BOOL)useDiscountFromPriceFlag {
    return [self retrieveConfigFlagByIndex:63];
}

- (BOOL)useDiscountByPriceGroupFlag {
    return [self retrieveConfigFlagByIndex:64];
}

- (void)resetSystemCodes:(NSString*)aSystemCodes {
    self.systemCodes = aSystemCodes;
}

- (void)persistentSystemCodes {
    NSMutableDictionary* configurationDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon configurationPlistPath]];
    [configurationDict setObject:self.systemCodes forKey:@"SystemCodes"];
    [configurationDict writeToFile:[FileCommon configurationPlistPath] atomically:YES];
}

- (BOOL)retrieveConfigFlagByIndex:(int)anIndex {
    NSString* resultFlag = [self.systemCodes substringWithRange:NSMakeRange(anIndex - 1, 1)];
    NSNumber* resultFlagNumber = [ArcosUtils convertStringToNumber:resultFlag];
    return [resultFlagNumber boolValue];
}

@end
