//
//  DashboardStockoutTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "DashboardStockoutTableViewCell.h"
#import "DashboardStockoutHeaderView.h"
#import "ProductDetailViewController.h"

@interface DashboardStockoutTableViewController : UITableViewController <GetDataGenericDelegate, PresentViewControllerDelegate> {
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    NSMutableArray* _displayList;
    DashboardStockoutHeaderView* _myHeaderView;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}

@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) IBOutlet DashboardStockoutHeaderView* myHeaderView;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* rootView;

@end
