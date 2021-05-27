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
@class ArcosRootViewController;

@interface DashboardServerViewController : UIViewController <UIScrollViewDelegate> {
    DashboardServerDataManager* _dashboardServerDataManager;
    MBProgressHUD* _HUD;
    NSTimer* _resourcesTimer;
    ArcosService* _arcosService;
    NSMutableArray* _viewItemControllerList;
    UIScrollView* _myScrollView;
    ArcosRootViewController* _arcosRootViewController;
}

@property(nonatomic, retain) DashboardServerDataManager* dashboardServerDataManager;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) NSTimer* resourcesTimer;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic,retain) NSMutableArray* viewItemControllerList;
@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;

@end

