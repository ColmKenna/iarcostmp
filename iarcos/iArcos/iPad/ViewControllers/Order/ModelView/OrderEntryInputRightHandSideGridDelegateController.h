//
//  OrderEntryInputRightHandSideGridDelegateController.h
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntryInputRightHandSideGridDelegateControllerDelegate.h"
#import "OrderEntryInputRightHandSideTableViewCell.h"
#import "OrderEntryInputRightHandSideFooterView.h"

@interface OrderEntryInputRightHandSideGridDelegateController : UITableViewController {
    id<OrderEntryInputRightHandSideGridDelegateControllerDelegate> _myDelegate;
    NSMutableArray* _orderLineDictList;
    int _cumulativeBal;
    int _totalInStock;
    int _totalFoc;
}

@property(nonatomic, assign) id<OrderEntryInputRightHandSideGridDelegateControllerDelegate> myDelegate;
@property(nonatomic, retain) NSMutableArray* orderLineDictList;
@property(nonatomic, assign) int cumulativeBal;
@property(nonatomic, assign) int totalInStock;
@property(nonatomic, assign) int totalFoc;

- (void)retrieveRightHandSideGridData;

@end

