//
//  CustomerMasterBottomTabBarItemTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterBottomTabBarItemTableCell.h"

@implementation CustomerMasterBottomTabBarItemTableCell
@synthesize subMenuDelegate = _subMenuDelegate;

- (void)handleSingleTapGesture {
    [self.subMenuDelegate didSelectSubMenuListingRow:self.indexPath viewController:self.myCustomController];
}

@end
