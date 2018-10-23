//
//  CustomerMasterTopTabBarItemTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 22/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterTopTabBarItemTableCell.h"

@implementation CustomerMasterTopTabBarItemTableCell
@synthesize actionDelegate = _actionDelegate;

- (void)handleSingleTapGesture {
    [self.actionDelegate didSelectTableRow:self.indexPath myCustomController:self.myCustomController];
}


@end
