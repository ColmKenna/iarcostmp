//
//  ArcosConfigDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 21/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "FileCommon.h"
#import "ArcosUtils.h"

@interface ArcosConfigDataManager : NSObject {
    NSString* _systemCodes;
    
}

@property(nonatomic, retain) NSString* systemCodes;

+ (ArcosConfigDataManager *)sharedArcosConfigDataManager;
- (BOOL)recordPresenterTransactionFlag;
- (BOOL)downloadDataByCSVFlag;
- (BOOL)retrieveLocationProductMATDataLocallyFlag;
- (BOOL)recordTasksFlag;
- (BOOL)hideCustomerDetailsAfterUpdateFlag;
- (BOOL)enableAutosaveFlag;
- (BOOL)showAccountBalancesFlag;
- (BOOL)showCompanyOverviewFlag;
- (BOOL)recordPIRequestFlag;
- (BOOL)recordPIGivenFlag;
- (BOOL)checkMultiplesOfUnitsPerPackFlag;
- (BOOL)checkDrilldownOfOrderCall;
- (BOOL)showInStockFlag;
- (BOOL)excludeValueFromOrderEmailFlag;
- (BOOL)showMATWithQtyPopoverFlag;
- (BOOL)allowScannerToBeUsedFlag;
- (BOOL)allowTopxCustomerFlag;
- (BOOL)allowTopxCompanyFlag;
- (BOOL)includeCallTimeFlag;
- (BOOL)enableCreateLocationByEmailFlag;
- (BOOL)enableEditLocationByEmailFlag;
- (BOOL)recordInStockRBFlag;
- (BOOL)checkTotalOrderValueFlag;
- (BOOL)allowDownloadByEmployeeFlag;
- (BOOL)enableCreateContactByEmailFlag;
- (BOOL)enableEditContactByEmailFlag;
- (BOOL)showProductCodeFlag;
- (BOOL)uploadPhotoAfterSendingOrderFlag;
- (BOOL)showWholesalerLogoFlag;
- (BOOL)unloadSurveyResponseFlag;
- (BOOL)showCallTypeFlag;
- (BOOL)enablePrinterFlag;
- (BOOL)enableVanSaleFlag;
- (BOOL)checkAccountNumberFlag;
- (BOOL)enableSendOriginalPhotoFlag;
- (BOOL)enableSelectionBoxInCallEntryFlag;
- (BOOL)enableAlternativeLogoFlag;
- (BOOL)enableUsePriceListFlag;
- (BOOL)enableUsePriceProductGroupFlag;
- (BOOL)showDeliveryInstructionsFlag;
- (BOOL)showTotalVATInvoiceFlag;
- (BOOL)hideInStockRBFlag;
- (BOOL)useMailLibFlag;
- (BOOL)useWeightToCalculatePriceFlag;
- (BOOL)showGDPRFlag;
- (BOOL)enableProductCheckFlag;
- (BOOL)enablePriceChangeFlag;
- (BOOL)showRRPInOrderPadFlag;
- (BOOL)clearWholeSalerFlag;
- (BOOL)clearOrderTypeFlag;
- (BOOL)disableMemoFlag;
- (BOOL)forceEnterCusRefOnCheckoutFlag;
- (BOOL)showMeetingFlag;
- (BOOL)showTargetFlag;
- (BOOL)showTaskInCallEmailFlag;
- (BOOL)showSingleTaskFlag;
- (BOOL)useDiscountFromPriceFlag;
- (BOOL)useDiscountByPriceGroupFlag;
- (BOOL)showRunningTotalFlag;
- (BOOL)enableCallOnlyFlag;
- (BOOL)showMATImageFlag;
- (BOOL)useOutlookFlag;
- (BOOL)disableBonusBoxWithPriceRecordFlag;
- (BOOL)enableAlternateOrderEntryPopoverFlag;
- (BOOL)showPreviousMemoInCallEntryFlag;
- (BOOL)showStartTimeAtHomePageFlag;
- (BOOL)showPackageFlag;
- (void)resetSystemCodes:(NSString*)aSystemCodes;
- (void)persistentSystemCodes;

@end
