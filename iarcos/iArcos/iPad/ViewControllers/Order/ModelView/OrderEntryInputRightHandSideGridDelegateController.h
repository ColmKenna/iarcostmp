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

@interface OrderEntryInputRightHandSideGridDelegateController : UITableViewController {
    id<OrderEntryInputRightHandSideGridDelegateControllerDelegate> _myDelegate;
    NSMutableArray* _orderLineDictList;
    int _cumulativeBal;
}

@property(nonatomic, assign) id<OrderEntryInputRightHandSideGridDelegateControllerDelegate> myDelegate;
@property(nonatomic, retain) NSMutableArray* orderLineDictList;
@property(nonatomic, assign) int cumulativeBal;

- (void)retrieveRightHandSideGridData;

@end

