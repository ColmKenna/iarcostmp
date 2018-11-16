//
//  SubMenuTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 22/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubMenuTableViewControllerDelegate <NSObject>
- (void)didSelectSubMenuListingRow:(NSIndexPath*)anIndexPath
                    viewController:(UIViewController*)aViewController;
@optional
- (NSMutableDictionary*)retrieveSelectedCustomerBaseCellData;
- (UITableView*)retrieveMasterBottomTableView;
- (UIViewController*)retrieveMasterViewController;
@end
