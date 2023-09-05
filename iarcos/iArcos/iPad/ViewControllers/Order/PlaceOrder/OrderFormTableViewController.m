//
//  OrderFormTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderFormTableViewController.h"
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"
#import "ArcosAppDelegate_iPad.h"

@implementation OrderFormTableViewController
@synthesize tableData;
@synthesize myGroups;
@synthesize groupName;
@synthesize sortKeys;
@synthesize groupSelections;
@synthesize headerView;
@synthesize frtvc;
@synthesize currentIndexPath;
//code from master
@synthesize splitViewController, rootPopoverButtonItem;
@synthesize orderTableViewHeader;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize imageFormRowsDataManager = _imageFormRowsDataManager;

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
    [orderTableViewHeader release];
    [ myGroups release];
    [ groupName release];
    [ sortKeys release];
    [ groupSelections release];
    if (self.arcosCustomiseAnimation != nil) { self.arcosCustomiseAnimation = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.imageFormRowsDataManager != nil) { self.imageFormRowsDataManager = nil; }
    
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
    self.imageFormRowsDataManager = [[[ImageFormRowsDataManager alloc] init] autorelease];
//    [self.imageFormRowsDataManager createImageFormRowsData];
    self.myGroups=[[ArcosCoreData sharedArcosCoreData]orderForms];
    [self sortGroups];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.orderTableViewHeader=[[OrderTableViewHeader alloc]initWithNibName:@"OrderTableViewHeader" bundle:nil];
    self.orderTableViewHeader.name=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
    self.orderTableViewHeader.address=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    self.orderTableViewHeader.phone=[[OrderSharedClass sharedOrderSharedClass]currentCustomerPhoneNumber];
    
    //set default index path
    //select the default form
    //NSNumber* currentFormIUR=[OrderSharedClass sharedOrderSharedClass].currentFormIUR;
    //NSNumber* defaultFormIUR=[[GlobalSharedClass shared].appSetting objectForKey:@"DefaultFormIUR"];
    NSNumber* defaultFormIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:7];

    int index=0;
    for (int i=0;i<[self.groupName count];i++) {
        NSString* aName=[self.groupName objectAtIndex:i];
        NSNumber* anIUR=[self.myGroups objectForKey:aName];
        if ([anIUR isEqualToNumber:defaultFormIUR]) {
            index=i;
        }
    }
    
    self.currentIndexPath=[NSIndexPath indexPathForRow:index inSection:0 ];
    [self selectCurrentForm];
    
    
    //set the global form view
    [GlobalSharedClass shared].orderFormViewController=self;
    
    self.arcosCustomiseAnimation = [[[ArcosCustomiseAnimation alloc] init] autorelease];
    self.rootView = [ArcosUtils getRootView];
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
    
    self.orderTableViewHeader.name=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
    self.orderTableViewHeader.address=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    self.orderTableViewHeader.phone=[[OrderSharedClass sharedOrderSharedClass]currentCustomerPhoneNumber];

    
    [self.tableView reloadData];
    [self.frtvc clearData]; 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //if no form select then select default
//    if (currentFormIUR==nil) {
//        // [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0 ]animated:NO scrollPosition:UITableViewScrollPositionBottom];
//        if(self.navigationController.topViewController==self){//top controller is form table
//            [self selectFormWithIndexpath:[NSIndexPath indexPathForRow:index inSection:0 ]];
//        }else{//top controller is selection table
//            [self.navigationController popToRootViewControllerAnimated:NO];
//            [self selectFormWithIndexpath:[NSIndexPath indexPathForRow:index inSection:0 ]];
//        }
//    }
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
    return self.orderTableViewHeader.view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 132;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.groupName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString* aGroupName=[self.groupName objectAtIndex: indexPath.row];
    NSNumber* aFormIUR = [self.myGroups objectForKey:aGroupName];
    cell.textLabel.text = aGroupName;
    
    //highlight the selected form
    if ([[OrderSharedClass sharedOrderSharedClass].currentFormIUR isEqualToNumber:aFormIUR]) {
        cell.textLabel.textColor=[UIColor redColor];
    }else{
        cell.textLabel.textColor=[UIColor blackColor];
    }
    
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */    
    self.currentIndexPath=indexPath;
    [self selectFormWithIndexpath:indexPath];
}
-(void)selectCurrentForm{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self selectFormWithIndexpath:self.currentIndexPath];
}
-(void)selectFormWithIndexpath:(NSIndexPath*)indexPath{  
    if ([self.myGroups count]<=0) {
        return;
    }
    
    FormSelectionTableViewController* newfstvc=[[FormSelectionTableViewController alloc]init];
    fstvc=newfstvc;
    
    fstvc.frtvc=self.frtvc;
    NSString* name=[self.groupName objectAtIndex:indexPath.row];
    NSNumber* anIUR=[self.myGroups objectForKey:name];
    
    NSLog(@"cell seleted with form iur %d",[anIUR intValue]);
    
    
    fstvc.formIUR=anIUR;
    fstvc.formName=name;
    fstvc.title=@"Selections";
    [OrderSharedClass sharedOrderSharedClass].currentFormIUR=anIUR;
    
    //save form to the global dictionary
    
//    NSLog(@"orederformview %d form in the dict",[[OrderSharedClass sharedOrderSharedClass].currentOrderForm count]);
    
    
    //select form conditions
    if ([GlobalSharedClass shared].currentSelectedLocationIUR !=nil){
        if ([SettingManager restrictOrderForm]) {
            [self oneOrderFormBranch:name];
        } else {
            [self multipleOrderFormBranch:name];
        }        
    }else{
        [OrderSharedClass sharedOrderSharedClass].currentFormIUR=nil;
        // open a dialog
        if (theActionSheet!=nil) {
            [theActionSheet dismissWithClickedButtonIndex:8 animated:NO];
            [theActionSheet release];
            theActionSheet=nil;
        }
        theActionSheet = [[UIActionSheet alloc] initWithTitle:@"Plese select a customer first!"
                                                                 delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Select Customer"
                                                        otherButtonTitles:@"Cancel",nil];
        theActionSheet.tag=1;
        theActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        [theActionSheet showInView:self.parentViewController.parentViewController.view];
        //[actionSheet release];
    }
    
    [[OrderSharedClass sharedOrderSharedClass]debugOrderForm];
}
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
    if (actionSheet.tag==0) {//select form action
        switch (buttonIndex) {
            case 1:{//cancel button do nothing
                //[self.navigationController pushViewController:fstvc animated:YES];
                [self.tableView deselectRowAtIndexPath:self.currentIndexPath animated:NO];
                NSLog(@"action sheet tag is 0 and cancel button is pressed.");
                NSString* formName = [[OrderSharedClass sharedOrderSharedClass] getFormName];
                if (![formName isEqualToString:@""]) {
                    NSNumber* anIUR = [self.myGroups objectForKey:formName];
                    [OrderSharedClass sharedOrderSharedClass].currentFormIUR = anIUR;
                }
            }
                break;
            case 0://ok button remove current order use the new form
                [[OrderSharedClass sharedOrderSharedClass]clearCurrentOrder];//??
                if ([self showMATFormRow:[self.groupName objectAtIndex:self.currentIndexPath.row]]) return;
                if ([self showImageFormRow:[self.groupName objectAtIndex:self.currentIndexPath.row]]) return;
                [[OrderSharedClass sharedOrderSharedClass]insertForm:fstvc.formName];
                [self.navigationController pushViewController:fstvc animated:YES];
                [fstvc selectDefaultSelection];

                break;   
            default:
                break;
        }
    }
    if (actionSheet.tag==1) {//select customer action
        //root tab bar
        /*
        ArcosAppDelegate_iPad *delegate = [[UIApplication sharedApplication] delegate];
        */
        UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
        
        switch (buttonIndex) {
            case 1://cancel button do nothing
                [OrderSharedClass sharedOrderSharedClass].currentFormIUR=nil;
                break;
            case 0://ok button remove current order use the new form
                
                //redirct to the customer pad
                tabbar.selectedIndex=1;  
                break;   
            default:
                break;
        }
        
    }

    [fstvc release];
    
    [[OrderSharedClass sharedOrderSharedClass]debugOrderForm];

}
//addtional funcitons
-(void)sortGroups{
    //release the old selections
    if (groupSelections!=nil) {
        [groupSelections removeAllObjects];
        [groupSelections release];
    }
    //reinitialize the customer sections
    groupSelections=[[NSMutableDictionary alloc]init];
    
    //a temp sorted group name
    NSMutableArray* sortedGroupNameArray=nil;
    sortedGroupNameArray=[[[[self.myGroups allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy]autorelease];
    
    //reinitialize the sort key
    if (self.sortKeys ==nil) {
        self.sortKeys=[[[NSMutableArray alloc]init]autorelease];
    }else{
        [self.sortKeys removeAllObjects];
    }
    
    
    //get the first char of the  list
    NSString* currentChar=@"";
    if ([sortedGroupNameArray count]>0) {
        NSString* name=[sortedGroupNameArray objectAtIndex:0];
        currentChar =[name substringToIndex:1];
        //add first Char
        if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
            [self.sortKeys addObject:currentChar]; 
        }
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=0;
    
    //start sorting the customer in to the sections
    for (int i=0; i<[sortedGroupNameArray count]; i++) {
        //sotring the name into the array
        NSString* name=[sortedGroupNameArray objectAtIndex:i];
        if (name==nil||[name isEqualToString:@""]) {
            name=@"Unknown Group";
        }
        
        //sorting
        length++;
        if ([currentChar isEqualToString:[name substringToIndex:1]]) {
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [groupSelections setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=i+1;
            length=0;
            //get the current char
            currentChar=[name substringToIndex:1];
            //add char to sort key
            if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
                [self.sortKeys addObject:currentChar]; 
            }
        }
    }
    
    //assgin the customer names
    self.groupName=sortedGroupNameArray;
    
    NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [groupSelections setObject:tempArray forKey:currentChar];
    }
    
    [tempArray release];
    //add char to sort key
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [self.sortKeys addObject:currentChar]; 
    }

    
    
    for (NSString* akey in self.sortKeys) {
        NSLog(@"sort key %@",akey);
    }
    
}

//select defqult form
-(void)selectDefaultForm{
    
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
    
    NSLog(@"hide the split view in form view");
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
    
    NSLog(@"show the split view in form view");

}
*/
-(BOOL)showMATFormRow:(NSString*)aGroupName {
    NSRange range = [aGroupName rangeOfString:@"Dynamic"];
    if (range.length > 0) {
        [[OrderSharedClass sharedOrderSharedClass] insertForm:aGroupName];
        [self.tableView reloadData];
        [self.frtvc resetDataWithDividerIUR:[NSNumber numberWithInt:-1] withDividerName:@"All" locationIUR:nil];
        MATFormRowsTableViewController* matfrtvc = [[MATFormRowsTableViewController alloc] initWithNibName:@"MATFormRowsTableViewController" bundle:nil];
        matfrtvc.title = @"MAT Order Pad";
        matfrtvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        matfrtvc.animateDelegate = self;
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:matfrtvc] autorelease];        
        [matfrtvc release];
        [self.arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];   
        return YES;
    }
    return NO;
}

-(BOOL)showImageFormRow:(NSString*)aGroupName {
    NSRange range = [aGroupName rangeOfString:@"Image"];
    if (range.length > 0) {
        [[OrderSharedClass sharedOrderSharedClass] insertForm:aGroupName];
        [self.tableView reloadData];
        [self.frtvc resetDataWithDividerIUR:[NSNumber numberWithInt:-1] withDividerName:@"All" locationIUR:nil];
        ImageFormRowsTableViewController* imagefrtvc = [[ImageFormRowsTableViewController alloc] initWithNibName:@"ImageFormRowsTableViewController" bundle:nil];
        imagefrtvc.title = @"Image Order Pad";
        imagefrtvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        imagefrtvc.animateDelegate = self;
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:imagefrtvc] autorelease];
        self.globalNavigationController.view.tag = [[GlobalSharedClass shared] tag4RemovedRootSubview];
        [imagefrtvc release];
        [self.arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];   
        return YES;
    }
    return NO;
}


#pragma mark SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

-(void)oneOrderFormBranch:(NSString*)name {
    NSLog(@"oneOrderFormBranch");
    if (![[OrderSharedClass sharedOrderSharedClass]anyForm]) {//not form saved
        NSLog(@"no form existed.");
        if ([self showMATFormRow:name]) return;
        if ([self showImageFormRow:name]) return;
        [[OrderSharedClass sharedOrderSharedClass] insertForm:name];            
        [self.navigationController pushViewController:fstvc animated:YES];
        [fstvc selectDefaultSelection];
        [fstvc release];
        
    }else{//a form is saved
        
        if (![[OrderSharedClass sharedOrderSharedClass]isFormExist:name]) {//attempt to use other form
            // open a dialog
            if ([[OrderSharedClass sharedOrderSharedClass]anyOrderLine]) {
                if (theActionSheet!=nil) {
                    [theActionSheet dismissWithClickedButtonIndex:8 animated:NO];
                    [theActionSheet release];
                    theActionSheet=nil;
                }
                theActionSheet = [[UIActionSheet alloc] initWithTitle:@"Your have an order in progress,Only one form is allowed for each order!\n Do you want to delete current order?"
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                    otherButtonTitles:@"Cancel",nil];
                theActionSheet.tag=0;
                theActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [theActionSheet showInView:self.parentViewController.parentViewController.view];
                //[theActionSheet release];
            }else{
                NSLog(@"form existed and have orderline.");
                NSLog(@"form existed and does not have orderline.");
                [[OrderSharedClass sharedOrderSharedClass]clearCurrentOrder];//??
                if ([self showMATFormRow:name]) return;
                if ([self showImageFormRow:name]) return;
                [[OrderSharedClass sharedOrderSharedClass]insertForm:fstvc.formName];
                [self.navigationController pushViewController:fstvc animated:YES];
                [fstvc selectDefaultSelection];
            }
        }else{//same form pressed
            NSLog(@"same form.");
            if ([self showMATFormRow:name]) return;
            if ([self showImageFormRow:name]) return;
            [self.navigationController pushViewController:fstvc animated:YES];
            [fstvc release];
        }
    }
}

-(void)multipleOrderFormBranch:(NSString*)name {
    NSLog(@"multipleOrderFormBranch");
    if ([self showMATFormRow:name]) return;
    if ([self showImageFormRow:name]) return;
    [[OrderSharedClass sharedOrderSharedClass] insertForm:name];            
    [self.navigationController pushViewController:fstvc animated:YES];
    [fstvc selectDefaultSelection];
    [fstvc release];
}
@end
