//
//  OrderLineDetailProductTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSharedClass.h"
#import "PresentViewControllerDelegate.h"
#import "OrderLineDetailProductDataManager.h"
#import "ArcosUtils.h"
#import "OrderProductTableCell.h"
#import "OrderInputPadViewController.h"
#import "WidgetFactory.h"
#import "ProductDetailViewController.h"
#import "ProductSearchDataManager.h"
#import "FormRowCurrentListSearchDataManager.h"
#import "FormRowTableCellRrpGenerator.h"
#import "FormRowTableCellNormalGenerator.h"

@protocol OrderLineDetailProductDelegate <NSObject>
@optional
- (void)didSaveOrderlinesFinish;
- (void)didDeleteAllOrderlinesFinish;

@end

@interface OrderLineDetailProductTableViewController : UITableViewController<UISearchBarDelegate, WidgetFactoryDelegate, UIActionSheetDelegate, OrderProductTableCellDelegate, UIPopoverPresentationControllerDelegate> {
    UISearchBar* _mySearchBar;
    id<PresentViewControllerDelegate> _delegate;
    OrderLineDetailProductDataManager* _orderLineDetailProductDataManager;
    UIViewController* _rootView;
//    UIPopoverController* _inputPopover;
    WidgetViewController* _globalWidgetViewController;
    WidgetFactory* _widgetFactory;
    BOOL _showSeparator;
    BOOL _isNotFirstLoaded;
    id<OrderLineDetailProductDelegate> _saveDelegate;
    NSNumber* _locationIUR;
    id<FormRowSearchDelegate> _formRowSearchDelegate;
    NSMutableDictionary* _vansOrderHeader;
    id<FormRowTableCellGeneratorDelegate> _formRowTableCellGeneratorDelegate;
}

@property (nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property (nonatomic, retain) id<PresentViewControllerDelegate> delegate;
@property (nonatomic, retain) OrderLineDetailProductDataManager* orderLineDetailProductDataManager;
@property (nonatomic, retain) UIViewController* rootView;
//@property (nonatomic, retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property (nonatomic, retain) WidgetFactory* widgetFactory;
@property (nonatomic, assign) BOOL showSeparator;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) id<OrderLineDetailProductDelegate> saveDelegate;
@property (nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic,retain) id<FormRowSearchDelegate> formRowSearchDelegate;
@property(nonatomic,retain) NSMutableDictionary* vansOrderHeader;
@property (nonatomic, retain) id<FormRowTableCellGeneratorDelegate> formRowTableCellGeneratorDelegate;

- (void)reloadTableViewData;
- (void)showInputPopover;

@end
