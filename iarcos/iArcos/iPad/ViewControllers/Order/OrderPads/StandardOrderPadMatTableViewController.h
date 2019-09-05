//
//  StandardOrderPadMatTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StandardOrderPadMatDataManager.h"
#import "FormRowsTableViewController.h"
#import "MATFormRowsTableViewController.h"
#import "MATFormRowsTableCell.h"
#import "StandardOrderPadMatHeaderView.h"
#import "MATFormRowsTableCellRrpGenerator.h"
#import "MATFormRowsTableCellNormalGenerator.h"
#import "MATFormRowsTableHeaderView.h"
#import "OrderPadFooterViewDataManager.h"

@interface StandardOrderPadMatTableViewController : UITableViewController<WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    StandardOrderPadMatDataManager* _standardOrderPadMatDataManager;
    FormRowsTableViewController* _formRowsTableViewController;
    MATFormRowsTableViewController* _mATFormRowsTableViewController;
    BOOL _isShowingInStockFlag;
    BOOL _isVanSalesEnabledFlag;
    UIPopoverController* _inputPopover;
    WidgetFactory* _factory;
    StandardOrderPadMatHeaderView* _standardOrderPadMatHeaderView;
    UISearchBar* _mySearchBar;
    BOOL _isPageMultipleLoaded;
    id<MATFormRowsTableCellGeneratorDelegate> _mATFormRowsTableCellGeneratorDelegate;
    OrderPadFooterViewDataManager* _orderPadFooterViewDataManager;
}

@property(nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, retain) StandardOrderPadMatDataManager* standardOrderPadMatDataManager;
@property(nonatomic, retain) FormRowsTableViewController* formRowsTableViewController;
@property(nonatomic, retain) MATFormRowsTableViewController* mATFormRowsTableViewController;
@property(nonatomic, assign) BOOL isShowingInStockFlag;
@property(nonatomic, assign) BOOL isVanSalesEnabledFlag;
@property(nonatomic, retain) UIPopoverController* inputPopover;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) IBOutlet StandardOrderPadMatHeaderView* standardOrderPadMatHeaderView;
@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic, assign) BOOL isPageMultipleLoaded;
@property(nonatomic, retain) id<MATFormRowsTableCellGeneratorDelegate> mATFormRowsTableCellGeneratorDelegate;
@property(nonatomic, retain) OrderPadFooterViewDataManager* orderPadFooterViewDataManager;

@end
