//
//  TemplateDashboardViewController.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "TemplateDashboardViewController.h"

@interface TemplateDashboardViewController ()
@end

@implementation TemplateDashboardViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize descrHeaderLabel = _descrHeaderLabel;
@synthesize myTableView = _myTableView;
@synthesize dashboardJourneyTableViewController = _dashboardJourneyTableViewController;
@synthesize globalViewController = _globalViewController;
@synthesize headerImageView = _headerImageView;
@synthesize footerImageView = _footerImageView;
@synthesize templateDashboardDataManager = _templateDashboardDataManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.templateDashboardDataManager = [[[TemplateDashboardDataManager alloc] init] autorelease];
//    NSArray* statusItems = [NSArray arrayWithObjects:@"TODAY",@"ISSUES",@"NEWS",@"STOCK OUTS",@"PROMOTION",@"STATS",@"COMMENTS",nil];
    UIFont* font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.mySegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.mySegmentedControl removeAllSegments];
    for (int i = 0; i < [self.templateDashboardDataManager.segmentItemList count]; i++) {
        [self.mySegmentedControl insertSegmentWithTitle:[self.templateDashboardDataManager.segmentItemList objectAtIndex:i] atIndex:i animated:NO];
    }
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    [self.myTableView.layer setBorderColor:[myColor CGColor]];
    [self.myTableView.layer setBorderWidth:1.0];
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.myTableView setSeparatorColor:myColor];
    self.mySegmentedControl.selectedSegmentIndex = 0;
    [self.mySegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.descrHeaderLabel = nil;
    self.myTableView = nil;
    self.dashboardJourneyTableViewController = nil;
    self.globalViewController = nil;
    self.headerImageView = nil;
    self.footerImageView = nil;
    self.templateDashboardDataManager = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self processIssuesRecord];
    [self processNewsRecord];
    [self processVanStocksRecord];
}

-(void)segmentedAction:(id)sender {
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    if (self.globalViewController != nil) {
        [self.globalViewController willMoveToParentViewController:nil];
        [self.globalViewController.view removeFromSuperview];
        [self.globalViewController removeFromParentViewController];
        self.globalViewController = nil;
        self.descrHeaderLabel.text = @"";
    }
    NSString* selectedSegmentTitle = [self.templateDashboardDataManager.segmentItemList objectAtIndex:segmentedControl.selectedSegmentIndex];
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.todayTitle]) {
        self.descrHeaderLabel.text = [NSString stringWithFormat:@"Today's Calls - %@", [ArcosUtils stringFromDate:[NSDate date] format:@"EEEE dd MMMM yyyy"]];
        self.dashboardJourneyTableViewController = [[[DashboardJourneyTableViewController alloc] initWithNibName:@"DashboardJourneyTableViewController" bundle:nil] autorelease];
        NSMutableArray* journeyList = [[ArcosCoreData sharedArcosCoreData] allJourney];
        [self.dashboardJourneyTableViewController.customerJourneyDataManager dashboardProcessRawData:journeyList];
        self.globalViewController = self.dashboardJourneyTableViewController;
        self.dashboardJourneyTableViewController = nil;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.issuesTitle]) {
        QueryOrderTemplateSplitViewController* queryOrderTemplateSplitViewController = [[QueryOrderTemplateSplitViewController alloc] initWithNibName:@"QueryOrderTemplateSplitViewController" bundle:nil];
        queryOrderTemplateSplitViewController.queryOrderSource = QueryOrderListings;
        queryOrderTemplateSplitViewController.refreshRequestSource = RefreshRequestListings;
        queryOrderTemplateSplitViewController.queryOrderMasterTableViewController.taskTypeInstance = 6;
        queryOrderTemplateSplitViewController.queryOrderMasterTableViewController.masterInputRequestSource = MasterInputRequestSourceDashboard;
        queryOrderTemplateSplitViewController.queryOrderDetailTableViewController.detailInputRequestSource = DetailInputRequestSourceDashboard;
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:queryOrderTemplateSplitViewController];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [queryOrderTemplateSplitViewController release];
        [tmpNavigationController release];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.newsTitle]) {
        CustomerNewsTaskTableViewController* cnttvc = [[CustomerNewsTaskTableViewController alloc] initWithNibName:@"CustomerNewsTaskTableViewController" bundle:nil];
        cnttvc.customerNewsTaskRequestSource = CustomerNewsTaskDashboard;
        UINavigationController* tmpNavigationController  = [[UINavigationController alloc] initWithRootViewController:cnttvc];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [cnttvc release];
        [tmpNavigationController release];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.stockoutsTitle]) {
        DashboardStockoutTableViewController* cstvc = [[DashboardStockoutTableViewController alloc] initWithNibName:@"DashboardStockoutTableViewController" bundle:nil];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cstvc];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [cstvc release];
        [tmpNavigationController release];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.vanStocksTitle]) {
        DashboardVanStocksViewController* dvsvc = [[DashboardVanStocksViewController alloc] initWithNibName:@"DashboardVanStocksViewController" bundle:nil];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:dvsvc];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [dvsvc release];
        [tmpNavigationController release];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.promotionTitle]) {
        DashboardPromotionTableViewController* cptvc = [[DashboardPromotionTableViewController alloc] initWithNibName:@"DashboardPromotionTableViewController" bundle:nil];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cptvc];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [cptvc release];
        [tmpNavigationController release];
    }
    if ([selectedSegmentTitle isEqualToString:self.templateDashboardDataManager.commentsTitle]) {
//        CustomerWeeklyMainModalViewController* cwmmvc = [[CustomerWeeklyMainModalViewController alloc] initWithNibName:@"CustomerWeeklyMainModalViewController" bundle:nil];        
//        cwmmvc.weeklyInputRequestSource = WeeklyInputRequestSourceDashboard;
        WeeklyMainTemplateViewController* wmtvc = [[WeeklyMainTemplateViewController alloc] initWithNibName:@"WeeklyMainTemplateViewController" bundle:nil];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:wmtvc];
        self.globalViewController = tmpNavigationController;
        [self addChildViewController:self.globalViewController];
        [self.myTableView addSubview:self.globalViewController.view];
        self.globalViewController.view.frame = self.myTableView.bounds;
        [self.globalViewController didMoveToParentViewController:self];
        [wmtvc release];
        [tmpNavigationController release];
    }
}

- (void)processIssuesRecord {
    int destIndex = 1;
    NSString* firstItemTitle = [self.templateDashboardDataManager.segmentItemList objectAtIndex:destIndex];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag]) {
        if (![firstItemTitle isEqualToString:self.templateDashboardDataManager.issuesTitle]) {
            [self.templateDashboardDataManager.segmentItemList insertObject:self.templateDashboardDataManager.issuesTitle atIndex:destIndex];
            [self.mySegmentedControl insertSegmentWithTitle:self.templateDashboardDataManager.issuesTitle atIndex:destIndex animated:NO];
        }
    } else {
        if ([firstItemTitle isEqualToString:self.templateDashboardDataManager.issuesTitle]) {
            [self.templateDashboardDataManager.segmentItemList removeObjectAtIndex:destIndex];
            [self.mySegmentedControl removeSegmentAtIndex:destIndex animated:NO];
        }
    }
}

- (void)processNewsRecord {
    int stockoutIndex = [self.templateDashboardDataManager retrieveIndexByTitle:self.templateDashboardDataManager.stockoutsTitle];
    int newsIndex = stockoutIndex - 1;
    NSString* beforeStockoutTitle = [self.templateDashboardDataManager.segmentItemList objectAtIndex:newsIndex];
    if ([ArcosSystemCodesUtils myNewsOptionExistence]) {
        if (![beforeStockoutTitle isEqualToString:self.templateDashboardDataManager.newsTitle]) {
            [self.templateDashboardDataManager.segmentItemList insertObject:self.templateDashboardDataManager.newsTitle atIndex:stockoutIndex];
            [self.mySegmentedControl insertSegmentWithTitle:self.templateDashboardDataManager.newsTitle atIndex:stockoutIndex animated:NO];
        }
    } else {
        if ([beforeStockoutTitle isEqualToString:self.templateDashboardDataManager.newsTitle]) {
            [self.templateDashboardDataManager.segmentItemList removeObjectAtIndex:newsIndex];
            [self.mySegmentedControl removeSegmentAtIndex:newsIndex animated:NO];
        }
    }
}

- (void)processVanStocksRecord {
    int stockoutIndex = [self.templateDashboardDataManager retrieveIndexByTitle:self.templateDashboardDataManager.stockoutsTitle];
    int vanStocksIndex = stockoutIndex + 1;
    NSString* afterStockoutTitle = [self.templateDashboardDataManager.segmentItemList objectAtIndex:vanStocksIndex];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag]) {
        if (![afterStockoutTitle isEqualToString:self.templateDashboardDataManager.vanStocksTitle]) {
            [self.templateDashboardDataManager.segmentItemList insertObject:self.templateDashboardDataManager.vanStocksTitle atIndex:vanStocksIndex];
            [self.mySegmentedControl insertSegmentWithTitle:self.templateDashboardDataManager.vanStocksTitle atIndex:vanStocksIndex animated:NO];
        }
    } else {
        if ([afterStockoutTitle isEqualToString:self.templateDashboardDataManager.vanStocksTitle]) {
            [self.templateDashboardDataManager.segmentItemList removeObjectAtIndex:vanStocksIndex];
            [self.mySegmentedControl removeSegmentAtIndex:vanStocksIndex animated:NO];
        }
    }
}

@end
