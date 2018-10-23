//
//  CustomerGroupContactTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 10/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerGroupContactTableViewCellDelegate <NSObject>

- (void)selectCustomerGroupContactRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath;
- (void)selectCustomerGroupAccessTimesRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath;
- (void)selectCustomerGroupNotSeenRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath;
- (void)selectCustomerGroupBuyingGroupRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath;


@end
