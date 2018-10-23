//
//  OrderSplitViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderSplitViewController.h"
#import "WebServiceSharedClass.h"
#import "FormSelectionTableViewController.h"
#import "OrderSharedClass.h"
#import "GlobalSharedClass.h"
@implementation OrderSplitViewController
@synthesize theFormView;
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
    
    FormRowsTableViewController *myDetailView = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
    myDetailView.title=@"Place Order";
    UINavigationController *navigationController_detail = [[UINavigationController alloc] initWithRootViewController:myDetailView];
    
    
    OrderFormTableViewController *myFormView = [[OrderFormTableViewController alloc] init];
    self.theFormView=myFormView;
    UINavigationController *navigationController_master = [[UINavigationController alloc] initWithRootViewController:myFormView];
    myFormView.frtvc=myDetailView;
    myFormView.title=@"Order Pads";
    myFormView.splitViewController=self;
    //myMasterView.myOrderDetailViewController=myDetailView;
    
    
    self.delegate = myFormView;
    self.viewControllers = [NSArray arrayWithObjects:navigationController_master, navigationController_detail, nil];
    
    [myFormView release];
    [myDetailView release];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    if (self.theFormView==nil) {
        return;
    }
    //select the default form
//    NSNumber* currentFormIUR=[OrderSharedClass sharedOrderSharedClass].currentFormIUR;
//    NSNumber* defaultFormIUR=[[GlobalSharedClass shared].appSetting objectForKey:@"DefaultFormIUR"];
//    int index=0;
//    for (int i=0;i<[self.theFormView.groupName count];i++) {
//        NSString* aName=[self.theFormView.groupName objectAtIndex:i];
//        NSNumber* anIUR=[self.theFormView.myGroups objectForKey:aName];
//        if ([anIUR isEqualToNumber:defaultFormIUR]) {
//            index=i;
//        }
//    }
//    //if no form select then select default
//    if (currentFormIUR==nil) {
//        // [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0 ]animated:NO scrollPosition:UITableViewScrollPositionBottom];
//        if(self.theFormView.navigationController.topViewController==self.theFormView){//top controller is form table
//            [self.theFormView selectFormWithIndexpath:[NSIndexPath indexPathForRow:index inSection:0 ]];
//        }else{//top controller is selection table
//            [self.theFormView.navigationController popToRootViewControllerAnimated:NO];
//            [self.theFormView selectFormWithIndexpath:[NSIndexPath indexPathForRow:index inSection:0 ]];
//        }
//    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
@end
