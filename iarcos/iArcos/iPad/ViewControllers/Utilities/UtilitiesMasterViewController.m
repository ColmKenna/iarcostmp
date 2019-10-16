//
//  UtilitiesMasterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMasterViewController.h"
#import "ArcosSplitViewController.h"

@implementation UtilitiesMasterViewController
@synthesize navigationDelegate = _navigationDelegate;
@synthesize theTableView;
@synthesize utilities;
@synthesize updateDetailView;
@synthesize settingDetailView;
@synthesize tablesDetailView;
@synthesize presenterDetailView;
@synthesize descriptionDetailView;
@synthesize memoryDetailView;
@synthesize configurationDetailView;
@synthesize detailViewController = _detailViewController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;
@synthesize storeNewsDateDataManager = _storeNewsDateDataManager;
@synthesize updateCenterTitle = _updateCenterTitle;
@synthesize settingTitle = _settingTitle;
@synthesize tablesTitle = _tablesTitle;
@synthesize resourcesTitle = _resourcesTitle;
@synthesize descriptionTitle = _descriptionTitle;
@synthesize configurationTitle = _configurationTitle;
@synthesize newsTitle = _newsTitle;

- (void)dealloc
{
    if (self.updateDetailView != nil) { self.updateDetailView = nil; }
    if (self.settingDetailView != nil) { self.settingDetailView = nil; }    
    if (self.tablesDetailView != nil) { self.tablesDetailView = nil; }        
    if (self.presenterDetailView != nil) { self.presenterDetailView = nil; }
    if (self.descriptionDetailView != nil) { self.descriptionDetailView = nil; }
    self.memoryDetailView = nil;
    self.configurationDetailView = nil;
    self.detailViewController = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    self.storeNewsDateDataManager = nil;
    self.updateCenterTitle = nil;
    self.settingTitle = nil;
    self.tablesTitle = nil;
    self.resourcesTitle = nil;
    self.descriptionTitle = nil;
    self.configurationTitle = nil;
    self.newsTitle = nil;
    
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
    currentSelectIndex=0;
    self.myRootViewController = [ArcosUtils getRootView];
    self.storeNewsDateDataManager = [[[StoreNewsDateDataManager alloc] init] autorelease];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.updateCenterTitle = @"UpdateCenter";
    self.settingTitle = @"Setting";
    self.tablesTitle = @"Tables";
    self.resourcesTitle = @"Resources";
    self.descriptionTitle = @"Description";
    self.configurationTitle = @"Configuration";
    self.newsTitle = @"News";
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
    /*
     *FileName
     *Title
     *SubTitle
     */
    
    ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
    if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
        NSMutableDictionary* switchDict = [self createMasterCellDataWithFilename:@"Switch.png" title:@"Switch to Enterprise" subTitle:@""];
        self.utilities = [NSMutableArray arrayWithCapacity:1];
        [self.utilities addObject:switchDict];
    } else {
        NSMutableDictionary* updateCenterDict = [self createMasterCellDataWithFilename:@"UpdateCenter.png" title:self.updateCenterTitle subTitle:@""];
        NSMutableDictionary* settingDict = [self createMasterCellDataWithFilename:@"Configuration.png" title:self.settingTitle subTitle:@""];
        NSMutableDictionary* tableDict = [self createMasterCellDataWithFilename:@"Table.png" title:self.tablesTitle subTitle:@""];
        NSMutableDictionary* resourcesDict = [self createMasterCellDataWithFilename:@"Resources.png" title:self.resourcesTitle subTitle:@""];
        NSMutableDictionary* descDict = [self createMasterCellDataWithFilename:@"Description.png" title:self.descriptionTitle subTitle:@""];
//        NSMutableDictionary* memoryDict = [self createMasterCellDataWithFilename:@"Analysis.png" title:@"Memory" subTitle:@""];
        NSMutableDictionary* configurationDict = [self createMasterCellDataWithFilename:@"Configuration.png" title:self.configurationTitle subTitle:@""];
        self.utilities=[NSMutableArray arrayWithObjects:updateCenterDict,settingDict,tableDict,resourcesDict,descDict,configurationDict, nil];//,memoryDict
        if ([ArcosSystemCodesUtils myNewsOptionExistence]) {
            NSMutableDictionary* myNewsDict = [self createMasterCellDataWithFilename:@"News.png" title:self.newsTitle subTitle:@""];
            [self.utilities addObject:myNewsDict];
        }
    }
    [self.theTableView reloadData];
    if ([self.utilities count] > 1) {
        [self.theTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.utilities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//     NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    static NSString *CellIdentifier = @"IdUtilitiesMasterTableCell";
    
    UtilitiesMasterTableCell *cell=(UtilitiesMasterTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesMasterTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesMasterTableCell class]] && [[(UtilitiesMasterTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (UtilitiesMasterTableCell *) nibItem;
            }
        }
	}
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.utilities objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData];
//    cell.textLabel.text=[self.utilities objectAtIndex:indexPath.row];
    
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
    
    if (indexPath.row == 0) {
        ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
        NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
        if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
            ActivateEnterpriseViewController* activateEnterpriseViewController = [[ActivateEnterpriseViewController alloc] initWithNibName:@"ActivateEnterpriseViewController" bundle:nil];
            activateEnterpriseViewController.presentDelegate = self;
            activateEnterpriseViewController.enterpriseRequestSource = EnterpriseRequestSourceSwitch;
//            UINavigationController* wrapperNavigationController = [[UINavigationController alloc] initWithRootViewController:activateEnterpriseViewController];
            
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:activateEnterpriseViewController] autorelease];
            CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
            self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
            [self.myRootViewController addChildViewController:self.globalNavigationController];
            [self.myRootViewController.view addSubview:self.globalNavigationController.view];
            [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
            
            [activateEnterpriseViewController release];
            [UIView animateWithDuration:0.3f animations:^{
                self.globalNavigationController.view.frame = parentNavigationRect;
            } completion:^(BOOL finished){
                
            }];
            
//            [self.myRootViewController presentViewController:wrapperNavigationController animated:YES completion:nil];
//            [activateEnterpriseViewController release];
//            [wrapperNavigationController release];
            return;
        }
    }
    NSMutableDictionary* itemDict = [self.utilities objectAtIndex:indexPath.row];
    if ([[itemDict objectForKey:@"Title"] isEqualToString:self.newsTitle]) {
        [self.storeNewsDateDataManager saveStoreNewsDate];
        [self openNews:nil];
        return;
    }
    if (currentSelectIndex==indexPath.row) {
        return;
    }
    
//    UtilitiesDetailViewController* detailViewController;

    if ([[itemDict objectForKey:@"Title"] isEqualToString:self.updateCenterTitle]) {
        if (self.updateDetailView==nil) {
            self.detailViewController=(UtilitiesDetailViewController*)[[[UtilitiesUpdateDetailViewController alloc]initWithNibName:@"UtilitiesUpdateDetailViewController" bundle:nil] autorelease];
            self.updateDetailView=self.detailViewController;
        }else{
            self.detailViewController=self.updateDetailView;
        }
        /*
        detailViewController=(UtilitiesDetailViewController*)[[UtilitiesUpdateDetailViewController alloc]initWithNibName:@"UtilitiesUpdateDetailViewController" bundle:nil];
        self.updateDetailView=detailViewController;
         */
    }else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.settingTitle]) {
        if (self.settingDetailView==nil) {
         self.detailViewController=(UtilitiesDetailViewController*)[[[UtilitiesSettingDetailViewController alloc]initWithNibName:@"UtilitiesSettingDetailViewController" bundle:nil] autorelease];
            self.settingDetailView=self.detailViewController;
        }else{
            self.detailViewController=self.settingDetailView;
        }
    }else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.tablesTitle]){
        self.detailViewController = (UtilitiesDetailViewController*)[[[UtilitiesTablesDetailViewController alloc] initWithNibName:@"UtilitiesTablesDetailViewController" bundle:nil] autorelease];
        self.tablesDetailView = self.detailViewController;
    }else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.resourcesTitle]) {
        self.detailViewController = (UtilitiesDetailViewController*)[[[UtilitiesPresenterDetailViewController alloc]initWithNibName:@"UtilitiesPresenterDetailViewController" bundle:nil] autorelease];
        self.presenterDetailView = self.detailViewController;
    }else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.descriptionTitle]) {
        self.detailViewController = (UtilitiesDetailViewController*)[[[UtilitiesDescriptionViewController alloc]initWithNibName:@"UtilitiesDescriptionViewController" bundle:nil] autorelease];
        self.descriptionDetailView = self.detailViewController;
        self.detailViewController.navigationDelegate = self;
    }
//    else if (indexPath.row == 5) {
//        self.detailViewController = (UtilitiesDetailViewController*)[[[UtilitiesMemoryTableViewController alloc]initWithNibName:@"UtilitiesMemoryTableViewController" bundle:nil] autorelease];
//        self.memoryDetailView = self.detailViewController;
//        self.detailViewController.navigationDelegate = self;
//    }
    else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.configurationTitle]) {
        self.detailViewController = (UtilitiesDetailViewController*)[[[UtilitiesConfigurationTableViewController alloc]initWithNibName:@"UtilitiesConfigurationTableViewController" bundle:nil] autorelease];
        self.configurationDetailView = self.detailViewController;
        self.detailViewController.navigationDelegate = self;
    }
    [self.detailViewController invalidateRootPopoverButtonItem:self.rootPopoverButtonItem];
    self.detailViewController.myBarButtonItem=self.rootPopoverButtonItem;
    //UINavigationController* navDetailController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController.parentViewController;
    UINavigationController* navDetailController=[arcosSplitViewController.rcsViewControllers objectAtIndex:1];
    navDetailController.viewControllers=[NSMutableArray arrayWithObject:self.detailViewController];
    arcosSplitViewController.rcsViewControllers = [NSArray arrayWithObjects:[arcosSplitViewController.rcsViewControllers objectAtIndex:0], navDetailController, nil];
    
    /*
    NSArray* controllers=self.splitViewController.viewControllers;
    UINavigationController* navDetailController=[controllers objectAtIndex:1];
    navDetailController.viewControllers=[NSMutableArray arrayWithObject:self.detailViewController];
    
    NSMutableArray* newControllers=[NSMutableArray arrayWithObjects:[controllers objectAtIndex:0],navDetailController, nil];
    
    self.splitViewController.viewControllers=newControllers;
    */
    //[detailViewController release];
    //[navDetailController release];
    currentSelectIndex=indexPath.row;
}

- (void)showNavigationBar {
    [self.navigationDelegate showNavigationBar];
}

- (void)hideNavigationBar {
    [self.navigationDelegate hideNavigationBar];
}

- (NSMutableDictionary*)createMasterCellDataWithFilename:(NSString*) fileName title:(NSString*)title subTitle:(NSString*)subTitle {
    NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [tmpDict setObject:fileName forKey:@"FileName"];
    [tmpDict setObject:title forKey:@"Title"];
    [tmpDict setObject:subTitle forKey:@"SubTitle"];
    return tmpDict;
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
//    [self.myRootViewController dismissViewControllerAnimated:YES completion:nil];
    [self didDismissCustomisePresentView];
}

- (void)openNews:(id)sender {
    CustomerNewsTaskWrapperViewController* CNTWVC = [[CustomerNewsTaskWrapperViewController alloc] initWithNibName:@"CustomerNewsTaskWrapperViewController" bundle:nil];
    CNTWVC.myDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:CNTWVC] autorelease];
    
    CNTWVC.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:CNTWVC] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    
    [CNTWVC release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

@end
