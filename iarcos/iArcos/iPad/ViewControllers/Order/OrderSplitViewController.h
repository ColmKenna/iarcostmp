//
//  OrderSplitViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMasterViewController.h"
#import "PreviousOrderDetailViewController.h"
#import "FormRowsTableViewController.h"

@interface OrderSplitViewController : UISplitViewController {
    OrderFormTableViewController* theFormView;
}
@property(nonatomic,retain)     OrderFormTableViewController* theFormView;

@end
