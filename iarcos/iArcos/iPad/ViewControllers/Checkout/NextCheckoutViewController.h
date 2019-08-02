//
//  NextCheckoutViewController.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "NextCheckoutDataManager.h"
#import "OrderSharedClass.h"
#import "OrderlinesIarcosTableCellFactory.h"
#import "LeftBorderUILabel.h"
#import "NextCheckoutOrderInfoHeaderView.h"
#import "NextCheckoutOrderInfoTableViewController.h"
#import "CoreLocationController.h"
#import "CheckoutDataManager.h"
@class ArcosRootViewController;
#import <AVFoundation/AVFoundation.h>
#import "ModalPresentViewControllerDelegate.h"

@interface NextCheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NextCheckoutOrderInfoDelegate, CoreLocationControllerDelegate, WidgetFactoryDelegate, AVAudioPlayerDelegate, CustomisePresentViewControllerDelegate,ModalPresentViewControllerDelegate,UIPopoverControllerDelegate>{
    UITableView* _orderInfoTableView;
    LeftBorderUILabel* _tableDivider;
    UITableView* _orderlinesTableView;
    NextCheckoutDataManager* _nextCheckoutDataManager;
    OrderlinesIarcosTableCellFactory* _tableCellFactory;
    NextCheckoutOrderInfoHeaderView* _orderDetailsHeaderView;
    NextCheckoutOrderInfoHeaderView* _contactDetailsHeaderView;
    NextCheckoutOrderInfoHeaderView* _commentsHeaderView;
    NextCheckoutOrderInfoHeaderView* _followUpHeaderView;
    NSMutableArray* _headerViewList;
    NextCheckoutOrderInfoTableViewController* _orderInfoTableViewController;
    CoreLocationController* _CLController;
    CheckoutDataManager* _checkoutDataManager;
    UIPopoverController* _thePopover;
    WidgetFactory* _widgetFactory;
    ArcosRootViewController* _myRootViewController;
    AVAudioPlayer* _myAVAudioPlayer;
    BOOL _isCheckoutSuccessful;
    UIBarButtonItem* _discountButton;
}

@property(nonatomic, retain) IBOutlet UITableView* orderInfoTableView;
@property(nonatomic, retain) IBOutlet LeftBorderUILabel* tableDivider;
@property(nonatomic, retain) IBOutlet UITableView* orderlinesTableView;
@property(nonatomic, retain) NextCheckoutDataManager* nextCheckoutDataManager;
@property(nonatomic, retain) OrderlinesIarcosTableCellFactory* tableCellFactory;
@property(nonatomic, retain) IBOutlet NextCheckoutOrderInfoHeaderView* orderDetailsHeaderView;
@property(nonatomic, retain) IBOutlet NextCheckoutOrderInfoHeaderView* contactDetailsHeaderView;
@property(nonatomic, retain) IBOutlet NextCheckoutOrderInfoHeaderView* commentsHeaderView;
@property(nonatomic, retain) IBOutlet NextCheckoutOrderInfoHeaderView* followUpHeaderView;
@property(nonatomic, retain) NSMutableArray* headerViewList;
@property(nonatomic, retain) NextCheckoutOrderInfoTableViewController* orderInfoTableViewController;
@property(nonatomic, retain) CoreLocationController* CLController;
@property(nonatomic, retain) CheckoutDataManager* checkoutDataManager;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) ArcosRootViewController* myRootViewController;
@property(nonatomic,retain) AVAudioPlayer* myAVAudioPlayer;
@property(nonatomic, assign) BOOL isCheckoutSuccessful;
@property(nonatomic,retain) UIBarButtonItem* discountButton;


@end
