//
//  SavedOrderSplitViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SavedOrderSplitViewController.h"


@implementation SavedOrderSplitViewController

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
    SavedOrderDetailViewController *myDetailView = [[SavedOrderDetailViewController alloc] initWithNibName:@"SavedOrderDetailViewController" bundle:nil];
    //myDetailView.title=@"Place Order";
    UINavigationController *navigationController_detail = [[UINavigationController alloc] initWithRootViewController:myDetailView];
    [myDetailView release];
    
    SavedOrderMasterViewController *myMasterView = [[SavedOrderMasterViewController alloc] initWithNibName:@"SavedOrderMasterViewController" bundle:nil];
    
    UINavigationController *navigationController_master = [[UINavigationController alloc] initWithRootViewController:myMasterView];
    [myMasterView release];
    
   // myFormView.frtvc=myDetailView;
    myMasterView.title=@"Listings";
//    myMasterView.splitViewController=self;
    //myMasterView.myOrderDetailViewController=myDetailView;
    
    myDetailView.delegate=myMasterView;
//    self.delegate = myMasterView;
    self.rcsViewControllers = [NSArray arrayWithObjects:navigationController_master, navigationController_detail, nil];
    [navigationController_detail release];
    [navigationController_master release];
    
    //date testing 
//    NSLog(@"today is %@",[[GlobalSharedClass shared]today]);
//    NSLog(@"this week is %@",[[GlobalSharedClass shared]thisWeek]);
//    NSLog(@"this month is %@",[[GlobalSharedClass shared]thisMonth]);
//    NSLog(@"this year is %@",[[GlobalSharedClass shared]thisYear]);

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

@end
