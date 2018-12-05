//
//  SavedIarcosOrderDetailRemoteCallDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 11/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailRemoteCallDataManager.h"

@implementation SavedIarcosOrderDetailRemoteCallDataManager
- (void)createAllSectionData {
    [self createRemoteContactSectionData];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] disableMemoFlag]) {
        [self createRemoteCallMemoSectionData];
    }
    [self createDrillDownSectionDataWithSectionTitle:@"Call Details" orderHeaderType:[NSNumber numberWithInt:4]];
}
@end
