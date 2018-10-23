//
//  TemplateDashboardViewController.h
//  iArcos
//
//  Created by David Kilmartin on 03/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "DashboardJourneyTableViewController.h"
#import "QueryOrderTemplateSplitViewController.h"
#import "CustomerNewsTaskTableViewController.h"
#import "CustomerWeeklyMainModalViewController.h"
#import "DashboardPromotionTableViewController.h"
#import "DashboardStockoutTableViewController.h"
#import "TemplateDashboardDataManager.h"
#import "DashboardVanStocksViewController.h"
#import "WeeklyMainTemplateViewController.h"

@interface TemplateDashboardViewController : UIViewController {
    UISegmentedControl* _mySegmentedControl;
    UILabel* _descrHeaderLabel;
    UITableView* _myTableView;
    DashboardJourneyTableViewController* _dashboardJourneyTableViewController;
    UIViewController* _globalViewController;
    UIImageView* _headerImageView;
    UIImageView* _footerImageView;
    TemplateDashboardDataManager* _templateDashboardDataManager;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UILabel* descrHeaderLabel;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) DashboardJourneyTableViewController* dashboardJourneyTableViewController;
@property(nonatomic, retain) UIViewController* globalViewController;
@property(nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property(nonatomic, retain) IBOutlet UIImageView* footerImageView;
@property(nonatomic, retain) TemplateDashboardDataManager* templateDashboardDataManager;

- (void)processIssuesRecord;
- (void)processNewsRecord;
- (void)processVanStocksRecord;

@end
