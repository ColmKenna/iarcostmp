//
//  CustomerMasterViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 09/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerMasterViewControllerDelegate <NSObject>

- (void)didSelectTableRow:(NSIndexPath*)anIndexPath myCustomController:(UIViewController*)aViewController;
@optional
- (BOOL)isCustomerBaseCellSelected;
- (NSMutableDictionary*)selectedCustomerBaseCellData;

@end
