//
//  UtilitiesSplitViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UtilitiesSplitViewController.h"


@implementation UtilitiesSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    
    //myDetailView.title=@"Place Order";
    
    
    
    UtilitiesMasterViewController *myMasterView = [[UtilitiesMasterViewController alloc] initWithNibName:@"UtilitiesMasterViewController" bundle:nil];
    
    UINavigationController *navigationController_master = [[UINavigationController alloc] initWithRootViewController:myMasterView];
    [myMasterView release];
    // myFormView.frtvc=myDetailView;
    myMasterView.title=@"Utilities";
    myMasterView.splitViewController=self;
    myMasterView.navigationDelegate = self;
    //myMasterView.myOrderDetailViewController=myDetailView;
    
    
    self.delegate = myMasterView;
    self.viewControllers = [NSArray arrayWithObjects:navigationController_master, navigationController_detail, nil];
    [navigationController_master release];
    [navigationController_detail release];

    self.preferredPrimaryColumnWidthFraction = 0.1; // 30% of the screen width
    self.maximumPrimaryColumnWidth = 20; // Maximum width of 320 points

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];    
            
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
}


- (void)showNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
}

- (void)hideNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];    
}

@end
