//
//  DashboardPromotionTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "DashboardPromotionTableViewCell.h"
#import "DashboardPromotionHeaderView.h"
#import "ProductDetailViewController.h"

@interface DashboardPromotionTableViewController : UITableViewController <GetDataGenericDelegate, PresentViewControllerDelegate> {
    CallGenericServices* _callGenericServices;
    BOOL _isNotFirstLoaded;
    NSMutableArray* _displayList;
    DashboardPromotionHeaderView* _myHeaderView;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}

@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) IBOutlet DashboardPromotionHeaderView* myHeaderView;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* rootView;

@end
