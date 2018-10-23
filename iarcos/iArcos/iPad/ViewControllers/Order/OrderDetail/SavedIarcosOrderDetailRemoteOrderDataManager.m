//
//  SavedIarcosOrderDetailRemoteOrderDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 11/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailRemoteOrderDataManager.h"

@implementation SavedIarcosOrderDetailRemoteOrderDataManager

- (void)createAllSectionData {
    [self createRemoteContactSectionData];
    [self createRemoteOrderDetailsSectionData];
    [self createRemoteOrderMemoSectionData];
    [self createDrillDownSectionDataWithSectionTitle:@"Order lines" orderHeaderType:[NSNumber numberWithInt:3]];
}

@end
