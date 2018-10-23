//
//  SubMenuListingDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 24/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface SubMenuListingDataManager : NSObject {
    NSMutableDictionary* _locationCellData;
    NSNumber* _lsCodeType;
}

@property(nonatomic, retain) NSMutableDictionary* locationCellData;
@property(nonatomic, retain) NSNumber* lsCodeType;

- (void)locationStatusProcessor:(NSNumber*)aLsiur;
- (BOOL)checkLocationCode;
- (BOOL)checkCreditStatus;

@end
