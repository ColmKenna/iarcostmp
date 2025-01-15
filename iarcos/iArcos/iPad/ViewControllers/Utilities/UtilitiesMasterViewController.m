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
@synthesize emailDetailView = _emailDetailView;
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
@synthesize emailTitle = _emailTitle;

- (void)dealloc
{
    if (self.updateDetailView != nil) { self.updateDetailView = nil; }
    if (self.settingDetailView != nil) { self.settingDetailView = nil; }    
    if (self.tablesDetailView != nil) { self.tablesDetailView = nil; }        
    if (self.presenterDetailView != nil) { self.presenterDetailView = nil; }
    if (self.descriptionDetailView != nil) { self.descriptionDetailView = nil; }
    self.memoryDetailView = nil;
    self.configurationDetailView = nil;
    self.emailDetailView = nil;
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
    self.emailTitle = nil;
    
    [BackHolder release];
    [ResizeHolder release];
    [utilitiesHolder release];
    [ResizeImage release];
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

    
        [self setDefaultBackgroundColor];
//    self.view.backgroundColor = [UIColor colorWithRed:0.82 green:0.88 blue:0.98 alpha:1.0];
 
    
    self.updateCenterTitle = @"UpdateCenter";
    self.settingTitle = @"Setting";
    self.tablesTitle = @"Tables";
    self.resourcesTitle = @"Resources";
    self.descriptionTitle = @"Description";
    self.configurationTitle = @"Configuration";
    self.newsTitle = @"News";
    self.emailTitle = @"Email";
    
    ResizeHolder.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTableViewVisibility)];
    [ResizeHolder addGestureRecognizer:tapGesture];
  
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleButton.frame = ResizeImage.bounds;
    [toggleButton addTarget:self action:@selector(toggleTableViewVisibility) forControlEvents:UIControlEventTouchUpInside];
    toggleButton.backgroundColor = [UIColor clearColor];
    [ResizeHolder addSubview:toggleButton];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
}



- (void)setDefaultBackgroundColor {
    UIColor *defaultBackgroundColor = [UIColor colorWithRed:0.82 green:0.88 blue:0.98 alpha:1.0];
    self.theTableView.backgroundColor = defaultBackgroundColor;
    ResizeHolder.backgroundColor = defaultBackgroundColor;
    BackHolder.backgroundColor = defaultBackgroundColor;
    tableHolder.backgroundColor = defaultBackgroundColor;
    
}

- (void)setWhiteBackgroundColor {
    UIColor *whiteColor = [UIColor whiteColor];
    
    self.theTableView.backgroundColor = whiteColor;
    ResizeHolder.backgroundColor = whiteColor;
    BackHolder.backgroundColor = whiteColor;
    tableHolder.backgroundColor = whiteColor;
}


- (void)toggleTableViewVisibility {
    // Toggle the visibility of the table view
    self.theTableView.hidden = !self.theTableView.hidden;
    if(self.theTableView.hidden){
        [self.arcosSplitViewController shrinkUtilitiesOptions];
        
        [self setWhiteBackgroundColor];
    }
    else{
        [self setDefaultBackgroundColor];
     
        [self.arcosSplitViewController growUtilitiesOptions];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; // Use default style, or UIStatusBarStyleLightContent for a light status bar
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
     *FileName
     *Title
     *SubTitle
     */
    
    // Get the window of this view controller
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //self.view.backgroundColor=    self.navigationController.navigationBar.backgroundColor;
    

    

    

    
    ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
    if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
        NSMutableDictionary* switchDict = [self createMasterCellDataWithFilename:@"Switch.png" title:@"Switch to Enterprise" subTitle:@""];
        self.utilities = [NSMutableArray arrayWithCapacity:1];
        [self.utilities addObject:switchDict];
    } else {
        [self createTableList];
    }
    [self.theTableView reloadData];
    if ([self.utilities count] > 1) {
        [self.theTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    

}

- (void)createTableList {
    /*NSMutableDictionary* updateCenterDict = [self createMasterCellDataWithFilename:@"UpdateCenter.png" title:self.updateCenterTitle subTitle:@""];
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
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        NSMutableDictionary* myEmailDict = [self createMasterCellDataWithFilename:@"office_365.png" title:self.emailTitle subTitle:@""];
        [self.utilities addObject:myEmailDict];
    }*/

    NSMutableDictionary* updateCenterDict = [self createMasterCellDataWithFilename:@"one.png" title:self.updateCenterTitle subTitle:@""];
    NSMutableDictionary* settingDict = [self createMasterCellDataWithFilename:@"two.png" title:self.settingTitle subTitle:@""];
    NSMutableDictionary* tableDict = [self createMasterCellDataWithFilename:@"three.png" title:self.tablesTitle subTitle:@""];
    NSMutableDictionary* resourcesDict = [self createMasterCellDataWithFilename:@"four.png" title:self.resourcesTitle subTitle:@""];
    NSMutableDictionary* descDict = [self createMasterCellDataWithFilename:@"five.png" title:self.descriptionTitle subTitle:@""];
//        NSMutableDictionary* memoryDict = [self createMasterCellDataWithFilename:@"Analysis.png" title:@"Memory" subTitle:@""];
    NSMutableDictionary* configurationDict = [self createMasterCellDataWithFilename:@"six.png" title:self.configurationTitle subTitle:@""];
    self.utilities=[NSMutableArray arrayWithObjects:updateCenterDict,settingDict,tableDict,resourcesDict,descDict,configurationDict, nil];//,memoryDict
    if ([ArcosSystemCodesUtils myNewsOptionExistence]) {
        NSMutableDictionary* myNewsDict = [self createMasterCellDataWithFilename:@"News.png" title:self.newsTitle subTitle:@""];
        [self.utilities addObject:myNewsDict];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        NSMutableDictionary* myEmailDict = [self createMasterCellDataWithFilename:@"seven.png" title:self.emailTitle subTitle:@""];
        [self.utilities addObject:myEmailDict];
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
    
//    cell.backgroundColor = [UIColor colorWithRed:0.82 green:0.88 blue:0.98 alpha:1.0];

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
        self.configurationDetailView = (UtilitiesConfigurationTableViewController*)self.detailViewController;
        self.detailViewController.navigationDelegate = self;
        self.configurationDetailView.saveDelegate = self;
    }
    else if ([[itemDict objectForKey:@"Title"] isEqualToString:self.emailTitle]) {
        self.emailDetailView = (UtilitiesDetailViewController*)[[[UtilitiesMailViewController alloc] initWithNibName:@"UtilitiesMailViewController" bundle:nil] autorelease];
        ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController.parentViewController;
        UINavigationController* navDetailController=[arcosSplitViewController.rcsViewControllers objectAtIndex:1];
        navDetailController.viewControllers=[NSMutableArray arrayWithObject:self.emailDetailView];
        arcosSplitViewController.rcsViewControllers = [NSArray arrayWithObjects:[arcosSplitViewController.rcsViewControllers objectAtIndex:0], navDetailController, nil];
        currentSelectIndex=indexPath.row;
        return;
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


#pragma mark UtilitiesConfigurationTableViewControllerDelegate
- (void)didSaveButtonPressed {
    [self createTableList];
    [self.theTableView reloadData];
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
