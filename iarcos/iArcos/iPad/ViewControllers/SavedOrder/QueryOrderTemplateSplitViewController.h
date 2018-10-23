//
//  QueryOrderTemplateSplitViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitDividerUILabel.h"
#import "QueryOrderMasterTableViewController.h"
#import "QueryOrderDetailTableViewController.h"
#import "OrderDetailViewController.h"
@class ArcosRootViewController;

@interface QueryOrderTemplateSplitViewController : UIViewController<QueryOrderMasterTableViewControllerDelegate, SlideAcrossViewAnimationDelegate,UISplitViewControllerDelegate,SubstitutableDetailViewController, QueryOrderDetailTableViewControllerDelegate> {
    SplitDividerUILabel* _splitDividerLabel;
    QueryOrderMasterTableViewController* _queryOrderMasterTableViewController;
    QueryOrderDetailTableViewController* _queryOrderDetailTableViewController;
    float _masterWidth;
    float _detailWidth;
    float _dividerWidth;
    
    UINavigationController* _masterNavigationController;
    UINavigationController* _detailNavigationController;
    QueryOrderSource _queryOrderSource;
    RefreshRequestSource _refreshRequestSource;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UITableView* _masterTableview;
    MBProgressHUD* _HUD;
    ArcosRootViewController* _myRootViewController;
    NSNumber* _locationIUR;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) SplitDividerUILabel* splitDividerLabel;
@property(nonatomic, retain) IBOutlet QueryOrderMasterTableViewController* queryOrderMasterTableViewController;
@property(nonatomic, retain) QueryOrderDetailTableViewController* queryOrderDetailTableViewController;
@property(nonatomic, assign) float masterWidth;
@property(nonatomic, assign) float detailWidth;
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, retain) UINavigationController* masterNavigationController;
@property(nonatomic, retain) UINavigationController* detailNavigationController;
@property(nonatomic, assign) QueryOrderSource queryOrderSource;
@property(nonatomic, assign) RefreshRequestSource refreshRequestSource;
@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) IBOutlet UITableView* masterTableview;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) ArcosRootViewController* myRootViewController;
@property(nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic, assign) BOOL isNotFirstLoaded;

@end
