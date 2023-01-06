//
//  DashboardServerViewController.h
//  iArcos
//
//  Created by Richard on 24/05/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardServerDataManager.h"
#import "MBProgressHUD.h"
#import "ArcosService.h"
#import "GenericWebViewItemViewController.h"
#import "ArcosUtils.h"
#import "ConnectivityCheck.h"
@class ArcosRootViewController;

@interface DashboardServerViewController : UIViewController <UIScrollViewDelegate, ConnectivityDelegate> {
    DashboardServerDataManager* _dashboardServerDataManager;
    MBProgressHUD* _HUD;
    NSTimer* _resourcesTimer;
    ArcosService* _arcosService;
    NSMutableArray* _viewItemControllerList;
    UIScrollView* _myScrollView;
    ArcosRootViewController* _arcosRootViewController;
    ConnectivityCheck* _connectivityCheck;
}

@property(nonatomic, retain) DashboardServerDataManager* dashboardServerDataManager;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) NSTimer* resourcesTimer;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic,retain) NSMutableArray* viewItemControllerList;
@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) ConnectivityCheck* connectivityCheck;

@end

