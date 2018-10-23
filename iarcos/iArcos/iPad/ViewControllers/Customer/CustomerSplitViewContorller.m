//
//  CustomerSplitViewContorller.m
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "CustomerSplitViewContorller.h"


@implementation CustomerSplitViewContorller


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
  
    /*
    CustomerListingViewController *myListingView = [[CustomerListingViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myListingView];
    myListingView.title=@"Customers";
    */
    
   
   
    /*
    CustomerInfoViewController* infoView=[[CustomerInfoViewController alloc]init];
    UINavigationController *myInfoView = [[UINavigationController alloc] initWithRootViewController:infoView];
    myGroupView.myCustomerInfoViewController=infoView;
     */
    
    CustomerListingViewController *myListingView = [[CustomerListingViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController_detail = [[UINavigationController alloc] initWithRootViewController:myListingView];
    myListingView.title=@"Group Name";
    [myListingView release];
    
    CustomerGroupViewController *myGroupView = [[CustomerGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    myGroupView.myCustomerListingViewController=myListingView;
    UINavigationController *navigationController_master = [[UINavigationController alloc] initWithRootViewController:myGroupView];
    myGroupView.title=@"Customer Groups";
    myGroupView.splitViewController=self;
    [myGroupView release];
    
    //myCustomerSplitViewController = [[UISplitViewController alloc] init];
    self.delegate = myGroupView;
    self.viewControllers = [NSArray arrayWithObjects:navigationController_master, navigationController_detail, nil];
    [navigationController_master release];
    [navigationController_detail release];
       
    //[self.view addSubview:myCustomerSplitViewController.view];
    // Do any additional setup after loading the view from its nib.
    
    //testing date and time in global share
    NSLog(@"today---%@",[[GlobalSharedClass shared] today]);
    NSLog(@"this week---%@",[[GlobalSharedClass shared] thisWeek]);
    NSLog(@"this month---%@",[[GlobalSharedClass shared] thisMonth]);
    NSLog(@"this this year---%@",[[GlobalSharedClass shared] thisYear]);



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
