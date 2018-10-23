//
//  CustomerMasterBottomTabBarItemTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterTabBarItemTableCell.h"
#import "SubMenuTableViewControllerDelegate.h"

@interface CustomerMasterBottomTabBarItemTableCell : CustomerMasterTabBarItemTableCell {
    id<SubMenuTableViewControllerDelegate> _subMenuDelegate;
}

@property(nonatomic, assign) id<SubMenuTableViewControllerDelegate> subMenuDelegate;

@end
