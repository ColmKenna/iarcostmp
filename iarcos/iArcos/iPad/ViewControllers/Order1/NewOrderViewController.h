//
//  NewOrderViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderSharedClass.h"
#import "ArcosUtils.h"
#import "FormDetailTableViewController.h"
#import "OrderBaseTableViewController.h"
#import "MATFormRowsTableViewController.h"
#import "ImageFormRowsTableViewController.h"
#import "FormRowsTableViewController.h"
#import "ProductSearchDataManager.h"
#import "L3SearchFormRowsTableViewController.h"
#import "HumanReadableDataSizeHelper.h"
#import "ArcosMemoryUtils.h"
#import "LargeImageFormRowsSlideViewController.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "LargeSmallImageFormRowsSlideViewController.h"
#import "LargeSmallL3SearchFormRowSlideViewController.h"
#import "LargeSmallFormDetailSlideViewController.h"
#import "BranchLargeSmallSlideViewController.h"
#import "TwoBigImageLevelCodeTableViewController.h"
@class ArcosRootViewController;
#import "NextCheckoutViewController.h"
#import "CheckoutPrinterWrapperViewController.h"
#import "FormPlanogramViewController.h"
#import "StandardOrderPadMatTableViewController.h"
#import "NewOrderDataManager.h"
#import "PackageTableViewController.h"

@interface NewOrderViewController : UIViewController<FormDetailDelegate, FormRowDividerDelegate, OrderFormNavigationControllerBackButtonDelegate, BranchLeafProductNavigationTitleDelegate, CustomisePresentViewControllerDelegate,ModalPresentViewControllerDelegate, PackageTableViewControllerDelegate> {
    UINavigationBar* _tableNavigationBar;
    UILabel* _locationName;
    UILabel* _locationAddress;
    UIBarButtonItem* _planogramButton;
//    UIPopoverController* _orderPadsPopover;
    UIButton* _orderPadsButton;
    OrderBaseTableViewController* _orderBaseTableViewController;
    UIView* _orderBaseContentView;
    UITableView* _orderBaseTableContentView;
    FormDetailTableViewController* _fdtvc;
    FormRowsTableViewController* _frtvc;    
    UIBarButtonItem* _orderPadsBarButton;
    UIScrollView* _orderBaseScrollContentView;
    UINavigationController* _globalNavigationController;
    UINavigationController* _orderPadsNavigationController;
    ProductSearchDataManager* _productSearchDataManager;
    ImageFormRowsDataManager* _imageFormRowsDataManager;
    NSThread* _downloadThread;
    NSThread* _saveDataThread;
    BOOL _isNotFirstLoaded;
    ArcosRootViewController* _myRootViewController;
    BOOL _isOrderSaved;
    UILabel* _custNameHeaderLabel;
    UILabel* _custAddrHeaderLabel;
    NewOrderDataManager* _myNewOrderDataManager;
}

@property(nonatomic, retain) IBOutlet UINavigationBar* tableNavigationBar;
@property(nonatomic, retain) IBOutlet UILabel* locationName;
@property(nonatomic, retain) IBOutlet UILabel* locationAddress;
@property(nonatomic, retain) UIBarButtonItem* planogramButton;
//@property(nonatomic, retain) UIPopoverController* orderPadsPopover;
@property(nonatomic, retain) IBOutlet UIButton* orderPadsButton;
@property(nonatomic, retain) IBOutlet OrderBaseTableViewController* orderBaseTableViewController;
@property(nonatomic, retain) IBOutlet UIView* orderBaseContentView;
@property(nonatomic, retain) IBOutlet UITableView* orderBaseTableContentView;
@property(nonatomic, retain) FormDetailTableViewController* fdtvc;
@property(nonatomic, retain) FormRowsTableViewController* frtvc;
@property(nonatomic, retain) UIBarButtonItem* orderPadsBarButton;
@property(nonatomic, retain) IBOutlet UIScrollView* orderBaseScrollContentView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UINavigationController* orderPadsNavigationController;
@property(nonatomic, retain) ProductSearchDataManager* productSearchDataManager;
@property(nonatomic, retain) ImageFormRowsDataManager* imageFormRowsDataManager;
@property(nonatomic, retain) NSThread* downloadThread;
@property(nonatomic, retain) NSThread* saveDataThread;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) ArcosRootViewController* myRootViewController;
@property(nonatomic, assign) BOOL isOrderSaved;
@property(nonatomic, retain) UILabel* custNameHeaderLabel;
@property(nonatomic, retain) UILabel* custAddrHeaderLabel;
@property(nonatomic, retain) NewOrderDataManager* myNewOrderDataManager;

-(void)orderPadsPressed:(id)sender;
-(void)createBlankOrderPad;
-(void)traditionalOrderPadSelection:(int)aFormTypeNumber cellData:(NSDictionary*)aCellDataDict;
-(void)resetNavigationTitleToBeginStatus;
-(void)controlBackButtonAndNavigationTitle;

@end
