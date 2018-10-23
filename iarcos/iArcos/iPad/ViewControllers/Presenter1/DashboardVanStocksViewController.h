//
//  DashboardVanStocksViewController.h
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardVanStocksHeaderView.h"
#import "CallGenericServices.h"
#import "DashboardVanStocksDataManager.h"
#import "DashboardVanStocksTableViewCell.h"
#import "ProductDetailViewController.h"
#import "DashboardVanStocksDetailTableViewController.h"
#import "DashboardVanStocksDetailViewController.h"
@class ArcosRootViewController;

@interface DashboardVanStocksViewController : UIViewController <PresentViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, DashboardVanStocksDetailTableViewControllerDelegate, UIPopoverControllerDelegate> {
    DashboardVanStocksHeaderView* _dashboardVanStocksHeaderView;
    CallGenericServices* _callGenericServices;
    DashboardVanStocksDataManager* _dashboardVanStocksDataManager;
    UIButton* _updateVanStockButton;    
    UIProgressView* _progressBar;
    UITableView* _vanStockTableView;
    UINavigationController* _globalNavigationController;
    ArcosRootViewController* _rootView;
    NSTimer* _saveRecordTimer;
    HorizontalBlueSeparatorUILabel* _mainCellSeparator;
    UIButton* _orderButton;
    UIPopoverController* _inputPopover;
//    DashboardVanStocksDetailTableViewController* _dvsdtvc;
    DashboardVanStocksDetailViewController* _dvsdvc;
}

@property(nonatomic, retain) IBOutlet DashboardVanStocksHeaderView* dashboardVanStocksHeaderView;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) DashboardVanStocksDataManager* dashboardVanStocksDataManager;
@property(nonatomic, retain) IBOutlet UIButton* updateVanStockButton;    
@property(nonatomic, retain) IBOutlet UIProgressView* progressBar;
@property(nonatomic, retain) IBOutlet UITableView* vanStockTableView;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) ArcosRootViewController* rootView;
@property(nonatomic,retain) NSTimer* saveRecordTimer;
@property(nonatomic,retain) IBOutlet HorizontalBlueSeparatorUILabel* mainCellSeparator;
@property(nonatomic,retain) IBOutlet UIButton* orderButton;
@property(nonatomic,retain) UIPopoverController* inputPopover;
//@property(nonatomic,retain) DashboardVanStocksDetailTableViewController* dvsdtvc;
@property(nonatomic,retain) DashboardVanStocksDetailViewController* dvsdvc;


- (IBAction)updateVanStockButtonPressed:(id)sender;
- (IBAction)orderButtonPressed:(id)sender;


@end
