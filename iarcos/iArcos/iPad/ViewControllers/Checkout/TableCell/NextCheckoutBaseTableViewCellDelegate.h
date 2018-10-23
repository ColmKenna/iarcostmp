//
//  NextCheckoutBaseTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 29/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NextCheckoutBaseTableViewCellDelegate <NSObject>

- (void)inputFinishedWithData:(id)data forIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithTitleKey:(NSString*)aTitleKey data:(id)aData;
- (void)inputFinishedWithData:(id)data forIndexPath:(NSIndexPath*)anIndexPath index:(NSNumber*)anIndex;
- (BOOL)checkWholesalerAppliedStatus;
- (NSMutableDictionary*)retrieveOrderHeaderData;
- (UIViewController*)retrieveMainViewController;

@end
