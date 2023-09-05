//
//  OrderMasterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderMasterViewController.h"
#import "GlobalSharedClass.h"
#import "ArcosAppDelegate_iPad.h"
#import "OrderSharedClass.h"
@implementation OrderMasterViewController
//@synthesize myOrderDetailViewController;
@synthesize splitViewController, rootPopoverButtonItem;
@synthesize headerView;
@synthesize locationName;
@synthesize locationPhone;
@synthesize locationAddress;
@synthesize detailView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [popoverController release];
    [rootPopoverButtonItem release];
    [tableRows release];
    [headerView release];
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
    tableRows=[[NSArray alloc]initWithObjects:@"Place Orders",@"Saved Orders", nil];//@"Previous Orders",
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //customer name and address
    locationName.text=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
    locationAddress.text=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    locationPhone.text=[[OrderSharedClass sharedOrderSharedClass]currentCustomerPhoneNumber];
    
    NSLog(@"view will appear on master view");
    
    //reload the data for detail view
    //UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    //UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    //[detailViewController reloadTableData];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"view did appear on master view");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[tableRows objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
    
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
    if (row == 0) {
        FormRowsTableViewController *newDetailViewController = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
        //don't need any record now
        newDetailViewController.dividerIUR=[NSNumber numberWithInt:-1];
        detailViewController = newDetailViewController;
        detailViewController.title=@"Place Orders";
        
        //push the form view
        OrderFormTableViewController* oftvc=[[OrderFormTableViewController alloc]init];
        oftvc.frtvc=newDetailViewController;
        oftvc.headerView=self.headerView;
        oftvc.title=@"Form";
        
        if ([GlobalSharedClass shared].currentSelectedLocationIUR !=nil){
            //push the form view
            [self.navigationController pushViewController:oftvc animated:YES];
        }else{
            // open a dialog
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Plese select a customer first!"
                                                                     delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Select Customer"
                                                            otherButtonTitles:@"Cancel",nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            
            [actionSheet showInView:self.parentViewController.parentViewController.view];
            [actionSheet release];
        }
        [oftvc release];
        
    }
    
    if (row == 1) {
        SavedOrderDetailViewController *newDetailViewController = [[SavedOrderDetailViewController alloc] initWithNibName:@"SavedOrderDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
        detailViewController.title=@"Saved Orders";
    }
    
    if (row == 2) {
        PreviousOrderDetailViewController *newDetailViewController = [[PreviousOrderDetailViewController alloc] initWithNibName:@"PreviousOrderDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
        detailViewController.title=@"Previous Orders";
    }
    
    // Update the split view controller's view controllers array.
    UINavigationController *navigationController_detail = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, navigationController_detail, nil];
    
    splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    
    // Dismiss the popover if it's present.
//    if (popoverController != nil) {
//        [popoverController dismissPopoverAnimated:YES];
//    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
    
    self.detailView=(UITableViewController*) detailViewController;
    [detailViewController release];
    [navigationController_detail release];
}
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
    //root tab bar
    /*
    ArcosAppDelegate_iPad *delegate = [[UIApplication sharedApplication] delegate];
    */
    UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0://ok button remove current order use the new form
            
            //redirct to the customer pad
            tabbar.selectedIndex=1;  
            break;   
        default:
            break;
    }
}

#pragma mark - Split view controller delegate
/*
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Order Pads";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
    
    NSLog(@"order master view need hide the splite view!");
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
    
    NSLog(@"order master view need show the splite view!");

}
*/
//actions
- (IBAction)allOnHeaderViewPressed:(id)sender{
    [GlobalSharedClass shared].currentSelectedLocationIUR=nil;
    //reload the data for detail view
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 

    [detailViewController reloadTableData];
}
@end
