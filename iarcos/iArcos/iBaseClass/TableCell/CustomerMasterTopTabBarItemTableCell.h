//
//  CustomerMasterTopTabBarItemTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterTabBarItemTableCell.h"
#import "CustomerMasterViewControllerDelegate.h"

@interface CustomerMasterTopTabBarItemTableCell : CustomerMasterTabBarItemTableCell {
    id<CustomerMasterViewControllerDelegate> _actionDelegate;
}

@property(nonatomic, assign) id<CustomerMasterViewControllerDelegate> actionDelegate;

@end
