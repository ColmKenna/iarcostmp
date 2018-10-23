//
//  SavedIarcosOrderDetailOrderDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailOrderDataManager.h"

@implementation SavedIarcosOrderDetailOrderDataManager

- (void)createAllSectionData {
//    [self createLocationSectionData];
    [self createContactSectionData];
    [self createOrderDetailsSectionData];
    [self createOrderMemoSectionData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enablePrinterFlag]) {
        [self createPrintSectionData];
    }
    [self createDrillDownSectionDataWithSectionTitle:@"Order lines" orderHeaderType:[NSNumber numberWithInt:1]];
}

@end
