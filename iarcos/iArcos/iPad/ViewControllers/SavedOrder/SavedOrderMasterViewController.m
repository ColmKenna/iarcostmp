//
//  SavedOrderMasterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SavedOrderMasterViewController.h"
#import "ArcosSplitViewController.h"

@implementation SavedOrderMasterViewController
@synthesize splitViewController, rootPopoverButtonItem;
@synthesize tableRows;
@synthesize currentIndexPath;
@synthesize savedOrderMasterDataManager = _savedOrderMasterDataManager;
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
    self.savedOrderMasterDataManager = nil;
    
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
    self.tableRows=[NSArray arrayWithObjects:@"All",@"Today",@"This Week",@"This Month",@"This Year",@"MAT", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.currentIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self selectOnIndexPath:self.currentIndexPath];
    [self highlightSelectRow];
    
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
    self.savedOrderMasterDataManager = [[[SavedOrderMasterDataManager alloc] init] autorelease];
    [self.savedOrderMasterDataManager createDataToDisplay];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.savedOrderMasterDataManager.sectionTitleList count] == 1) {
        return 44.0f;
    }
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.savedOrderMasterDataManager.sectionTitleList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.savedOrderMasterDataManager.sectionTitleList objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.savedOrderMasterDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* contentList = [self.savedOrderMasterDataManager.groupDataDict objectForKey:sectionTitle];
    
    return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdGenericPlainTableCell";
    
    GenericPlainTableCell *cell=(GenericPlainTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericPlainTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericPlainTableCell class]] && [[(GenericPlainTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (GenericPlainTableCell *) nibItem;
            }
        }
	}
    NSString* sectionTitle = [self.savedOrderMasterDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* contentList = [self.savedOrderMasterDataManager.groupDataDict objectForKey:sectionTitle];
    
    cell.myTextLabel.text = [contentList objectAtIndex:indexPath.row ];
    
    if([cell.myTextLabel.text isEqualToString:@"All"]) {
        cell.myImageView.image = [UIImage imageNamed:@"asterisk_orange.png"];
        cell.myImageView.alpha = 1.0;
    } else {
        UIImage* anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:138]];
        if (anImage == nil) {
            anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
        }
        cell.myImageView.image = anImage;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == self.currentIndexPath.section && indexPath.row == self.currentIndexPath.row) {
        cell.myTextLabel.textColor = [UIColor redColor];
    } else {
        cell.myTextLabel.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}


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
    GenericPlainTableCell* cell=(GenericPlainTableCell*)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    cell.myTextLabel.textColor=[UIColor blackColor];
    
    cell=(GenericPlainTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.myTextLabel.textColor=[UIColor redColor];
    BOOL sameSectionFlag = YES;
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController.parentViewController;
    if (self.currentIndexPath.section != indexPath.section) {
        sameSectionFlag = NO;
//        NSArray* controllers = self.splitViewController.viewControllers;
        NSArray* controllers = arcosSplitViewController.rcsViewControllers;
        UINavigationController* navDetailController = [controllers objectAtIndex:1];
//        OrderDetailViewController* myDetailView = nil;
        if (indexPath.section == 0 ) {
            SavedOrderDetailViewController* myDetailView = [[SavedOrderDetailViewController alloc] initWithNibName:@"SavedOrderDetailViewController" bundle:nil];
            navDetailController.viewControllers = [NSMutableArray arrayWithObject:myDetailView];
            [myDetailView release];
        } else {
            QueryOrderTemplateSplitViewController* myDetailView = [[QueryOrderTemplateSplitViewController alloc] initWithNibName:@"QueryOrderTemplateSplitViewController" bundle:nil];
            myDetailView.queryOrderSource = QueryOrderListings;
            myDetailView.refreshRequestSource = RefreshRequestListings;
            myDetailView.queryOrderMasterTableViewController.taskTypeInstance = indexPath.row;
            navDetailController.viewControllers = [NSMutableArray arrayWithObject:myDetailView];
            [myDetailView release];
        }
        
        NSMutableArray* newControllers=[NSMutableArray arrayWithObjects:[controllers objectAtIndex:0],navDetailController, nil];
        
//        self.splitViewController.viewControllers=newControllers;
        arcosSplitViewController.rcsViewControllers = newControllers;
    }
    
    
    
    self.currentIndexPath=indexPath;
    [self selectOnIndexPath:indexPath];
}
-(void)selectOnIndexPath:(NSIndexPath*)indexPath{
//    NSLog(@"order header search select!");
    //UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        [self selectSecondSectionOnIndexPath:indexPath];
        return;
    }
    NSMutableArray* orderData=[NSMutableArray array];
    NSInteger orderDisplayTypeValue = 0;
    switch (indexPath.row) {
        case 0: {
            orderDisplayTypeValue = indexPath.row;
            orderData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:nil withEndDate:nil];
        }
            break;
        case 1: {
            orderDisplayTypeValue = indexPath.row;
            orderData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]today] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
        }
            break;
        case 2: {
            orderDisplayTypeValue = indexPath.row;
            orderData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisWeek] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
        }
            break;
        case 3: {
            orderDisplayTypeValue = indexPath.row;
            orderData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisMonth] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
        }
            break;
        case 4: {
            orderDisplayTypeValue = indexPath.row;
            orderData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisYear] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
        }
            break;
        case 5: {
            orderDisplayTypeValue = 8;            
            NSDate* startDate = [[GlobalSharedClass shared]thisMat];
            orderData = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:startDate withEndDate:[NSDate date]];
        }
            break;
        case 6: {
            orderDisplayTypeValue = 9;
            orderData = [[ArcosCoreData sharedArcosCoreData] retrievePendingOnlyOrders];
        }
            break;
            
        default:
            break;
    }
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController.parentViewController;
//    UINavigationController  *navigationController = [self.splitViewController.viewControllers objectAtIndex:1];
    UINavigationController  *navigationController = [arcosSplitViewController.rcsViewControllers objectAtIndex:1];
    //don't do anything when we are not on the root view
    if ([navigationController.viewControllers count]>1) {
        //return;
    }
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0];
    [detailViewController reloadTableDataWithData:orderData];
    SavedOrderDetailViewController* sodvc=(SavedOrderDetailViewController*)detailViewController;
    sodvc.orderDisplayType=orderDisplayTypeValue;
    sodvc.tableData=orderData;

}

-(void)selectSecondSectionOnIndexPath:(NSIndexPath*)indexPath {
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController.parentViewController;
//    UINavigationController* navigationController = [self.splitViewController.viewControllers objectAtIndex:1];
    UINavigationController* navigationController = [arcosSplitViewController.rcsViewControllers objectAtIndex:1];
    QueryOrderTemplateSplitViewController* templateSplitViewController = [navigationController.viewControllers objectAtIndex:0];
    templateSplitViewController.queryOrderMasterTableViewController.taskTypeInstance = indexPath.row;
    templateSplitViewController.queryOrderMasterTableViewController.refreshRequestSource = RefreshRequestListings;
    [templateSplitViewController.queryOrderMasterTableViewController loadDataByTaskType:indexPath.row];
}

-(void)highlightSelectRow{
    
}
-(void)refreshCurrentIndexpath{
    [self selectOnIndexPath:self.currentIndexPath];
}
#pragma mark - Split view controller delegate
/*
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Listings";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}*/

#pragma mark saved order detail view delegate
-(void)needRefresh{
    NSLog(@"refresh the current order list!");
    [self refreshCurrentIndexpath];
}
@end
