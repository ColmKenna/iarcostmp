//
//  MATFormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 25/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ArcosCustomiseAnimation.h"
#import "MATFormRowsDataManager.h"
#import "MATFormRowsTableCell.h"
#import "WidgetFactory.h"
#import "OrderSharedClass.h"
#import "CheckoutViewController.h"
#import "OrderBaseTableViewController.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosConfigDataManager.h"
#import "ProductDetailViewController.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "MATFormRowsTableCellRrpGenerator.h"
#import "MATFormRowsTableCellNormalGenerator.h"
#import "MATFormRowsTableHeaderView.h"
#import "OrderPadFooterViewDataManager.h"

@interface MATFormRowsTableViewController : OrderBaseTableViewController<WidgetFactoryDelegate, SlideAcrossViewAnimationDelegate, MATCheckoutViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate> {
    NSNumber* _locationIUR;
    id<ModelViewDelegate> _modelDelegate;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    CallGenericServices* _callGenericServices;
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    MATFormRowsTableHeaderView* _customiseTableHeaderView;
    MATFormRowsDataManager* _matFormRowsDataManager;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _inputPopover;
    WidgetViewController* _globalWidgetViewController;
    BOOL _isServiceCalled;
    NSDate* _startDate;
    NSDate* _endDate;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isShowingInStockFlag;
    BOOL _isVanSalesEnabledFlag;
    UISearchBar* _mySearchBar;
    BOOL _isPageMultipleLoaded;
    id<MATFormRowsTableCellGeneratorDelegate> _mATFormRowsTableCellGeneratorDelegate;
    OrderPadFooterViewDataManager* _orderPadFooterViewDataManager;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) id<ModelViewDelegate> modelDelegate;
@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) MATFormRowsTableHeaderView* customiseTableHeaderView;
@property(nonatomic, retain) MATFormRowsDataManager* matFormRowsDataManager;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, assign) BOOL isServiceCalled;
@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property(nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, assign) BOOL isShowingInStockFlag;
@property(nonatomic, assign) BOOL isVanSalesEnabledFlag;
@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic, assign) BOOL isPageMultipleLoaded;
@property(nonatomic, retain) id<MATFormRowsTableCellGeneratorDelegate> mATFormRowsTableCellGeneratorDelegate;
@property (nonatomic, retain) OrderPadFooterViewDataManager* orderPadFooterViewDataManager;

@end
