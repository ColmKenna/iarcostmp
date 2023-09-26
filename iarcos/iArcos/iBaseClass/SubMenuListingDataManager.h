//
//  SubMenuListingDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 24/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@protocol SubMenuListingDataManagerDelegate
- (UIViewController*)retrieveSubMenuListingDataManagerParentViewController;
@end

@interface SubMenuListingDataManager : NSObject {
    id<SubMenuListingDataManagerDelegate> _delegate;
    NSMutableDictionary* _locationCellData;
    NSNumber* _lsCodeType;
    NSString* _errorMessage;
}

@property(nonatomic, assign) id<SubMenuListingDataManagerDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary* locationCellData;
@property(nonatomic, retain) NSNumber* lsCodeType;
@property(nonatomic, retain) NSString* errorMessage;

- (void)locationStatusProcessor:(NSNumber*)aLsiur;
- (BOOL)checkLocationCode;
- (BOOL)checkCreditStatus;
- (void)dialUpNumberProcessor:(NSMutableDictionary*)aCellData;
- (BOOL)checkDialUpNumber;

@end
