//
//  OrderlinesIarcosTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosTableViewCell.h"
#import "OrderlinesIarcosTableCellFactory.h"
#import "UIViewController+ArcosStackedController.h"
#import "ArcosUtils.h"
#import "ProductFormRowConverter.h"
#import "OrderInputPadViewController.h"
#import "WidgetFactory.h"
#import "ProductDetailViewController.h"
#import "OrderLineDetailProductTableViewController.h"

@interface OrderlinesIarcosTableViewController : UITableViewController<WidgetFactoryDelegate,PresentViewControllerDelegate,OrderLineDetailProductDelegate,UIActionSheetDelegate,UIPopoverPresentationControllerDelegate> {
    BOOL _isCellEditable;
    NSNumber* _formIUR;
    NSNumber* _orderNumber;
    NSMutableArray* _displayList;
    NSMutableDictionary* _currentSelectedOrderLine;
    NSMutableDictionary* _backupSelectedOrderLine;
    OrderlinesIarcosTableCellFactory* _tableCellFactory;
//    UIPopoverController* _inputPopover;
    WidgetViewController* _globalWidgetViewController;
    WidgetFactory* _factory;
    UIViewController* _myRootViewController;
    UINavigationController* _globalNavigationController;
    NSNumber* _locationIUR;
    NSMutableDictionary* _vansOrderHeader;
    UIBarButtonItem* _discountButton;
    BOOL _viewPresentingFlag;
}

@property(nonatomic, assign) BOOL isCellEditable;
@property(nonatomic, retain) NSNumber* formIUR;
@property(nonatomic, retain) NSNumber* orderNumber;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* currentSelectedOrderLine;
@property(nonatomic, retain) NSMutableDictionary* backupSelectedOrderLine;
@property(nonatomic, retain) OrderlinesIarcosTableCellFactory* tableCellFactory;
//@property(nonatomic, retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSMutableDictionary* vansOrderHeader;
@property(nonatomic,retain) UIBarButtonItem* discountButton;
@property(nonatomic,assign) BOOL viewPresentingFlag;

- (void)resetTableDataWithData:(NSMutableArray*)theData;

@end
