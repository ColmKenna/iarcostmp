//
//  OrderDetailOrderDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailOrderDataManager.h"
#import "ArcosConfigDataManager.h"

@implementation OrderDetailOrderDataManager

- (void)createAllSectionData {
    [self createLocationSectionData];    
    [self createContactSectionData];
    [self createOrderDetailsSectionData];
    [self createOrderMemoSectionData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enablePrinterFlag]) {
        [self createPrintSectionData];
    }
    [self createDrillDownSectionDataWithSectionTitle:@"Orderline Details" orderHeaderType:[NSNumber numberWithInt:1]];
}

@end
