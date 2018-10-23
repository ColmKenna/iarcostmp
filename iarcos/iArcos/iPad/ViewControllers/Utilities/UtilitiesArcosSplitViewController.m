//
//  UtilitiesArcosSplitViewController.m
//  iArcos
//
//  Created by David Kilmartin on 07/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "UtilitiesArcosSplitViewController.h"

@interface UtilitiesArcosSplitViewController ()

@end

@implementation UtilitiesArcosSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationController *navigationController_detail = nil;
    
    ActivateAppStatusManager* appStatusManager = [ActivateAppStatusManager appStatusInstance];
    if ([[appStatusManager getAppStatus] isEqualToNumber:appStatusManager.demoAppStatusNum]) {
        PlaceHolderTableViewController* placeHolderDetailView = [[PlaceHolderTableViewController alloc] initWithStyle:UITableViewStylePlain];
        navigationController_detail = [[UINavigationController alloc] initWithRootViewController:placeHolderDetailView];
        [placeHolderDetailView release];
    } else {
        UtilitiesUpdateDetailViewController *myDetailView = [[UtilitiesUpdateDetailViewController alloc] initWithNibName:@"UtilitiesUpdateDetailViewController" bundle:nil];
        navigationController_detail = [[UINavigationController alloc] initWithRootViewController:myDetailView];
        [myDetailView release];
    }
    
    UtilitiesMasterViewController *myMasterView = [[UtilitiesMasterViewController alloc] initWithNibName:@"UtilitiesMasterViewController" bundle:nil];
    
    UINavigationController *navigationController_master = [[UINavigationController alloc] initWithRootViewController:myMasterView];
    [myMasterView release];
    myMasterView.title=@"Utilities";
//    myMasterView.splitViewController=self;
//    myMasterView.navigationDelegate = self;
    
    
//    self.delegate = myMasterView;
    self.rcsViewControllers = [NSArray arrayWithObjects:navigationController_master, navigationController_detail, nil];
    [navigationController_master release];
    [navigationController_detail release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
