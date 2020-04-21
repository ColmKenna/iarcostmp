//
//  OrderEntryInputRightHandSideGridViewController.h
//  iArcos
//
//  Created by Apple on 09/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntryInputViewController.h"
#import "OrderEntryInputRightHandSideGridDelegateController.h"
#import "OrderEntryInputRightHandSideHeaderView.h"


@interface OrderEntryInputRightHandSideGridViewController : OrderEntryInputViewController <OrderEntryInputRightHandSideGridDelegateControllerDelegate> {
    OrderEntryInputRightHandSideHeaderView* _orderEntryInputRightHandSideHeaderView;
    UITableView* _rightHandSideGridView;
    OrderEntryInputRightHandSideGridDelegateController* _orderEntryInputRightHandSideGridDelegateController;
}

@property(nonatomic, retain) IBOutlet OrderEntryInputRightHandSideHeaderView* orderEntryInputRightHandSideHeaderView;
@property(nonatomic, retain) IBOutlet UITableView* rightHandSideGridView;
@property(nonatomic, retain) OrderEntryInputRightHandSideGridDelegateController* orderEntryInputRightHandSideGridDelegateController;

@end

