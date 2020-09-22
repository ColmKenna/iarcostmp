//
//  CustomerJourneyDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailViewController.h"
#import "CustomerGroupViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@implementation CustomerJourneyDetailViewController
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize actionPopoverController = _actionPopoverController;
@synthesize cjsdvc = _cjsdvc;
@synthesize actionButton = _actionButton;
@synthesize auxNavigationController = _auxNavigationController;
@synthesize checkLocationIURTemplateProcessor = _checkLocationIURTemplateProcessor;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.customerJourneyDataManager != nil) { self.customerJourneyDataManager = nil; }
    if (self.actionPopoverController != nil) { self.actionPopoverController = nil; }
    if (self.cjsdvc != nil) { self.cjsdvc = nil; }
    if (self.actionButton != nil) { self.actionButton = nil; }
    if (self.auxNavigationController != nil) { self.auxNavigationController = nil; }
    self.checkLocationIURTemplateProcessor = nil;
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.actionButton;
    
    self.cjsdvc = [[[CustomerJourneyStartDateViewController alloc] initWithNibName:@"CustomerJourneyStartDateViewController" bundle:nil] autorelease];
    self.cjsdvc.delegate = self;
    self.auxNavigationController = [[UINavigationController alloc] initWithRootViewController:self.cjsdvc];

    self.actionPopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.auxNavigationController] autorelease];
    self.actionPopoverController.popoverContentSize = CGSizeMake(700.0f, 360.0f);
    self.checkLocationIURTemplateProcessor = [[[CheckLocationIURTemplateProcessor alloc] initWithParentViewController:self] autorelease];
    self.checkLocationIURTemplateProcessor.delegate = self;
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
    [self.customerJourneyDataManager getLocationsWithJourneyDict:self.customerJourneyDataManager.currentJourneyDict];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.customerJourneyDataManager.sectionTitleList != nil) {
        return [self.customerJourneyDataManager.sectionTitleList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.customerJourneyDataManager.locationListDict != nil) {
        NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:section];
        NSMutableArray* locationList = [self.customerJourneyDataManager.locationListDict objectForKey:sectionTitle];
        return [locationList count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   // fixed font style. use custom view (UILabel) if you want something different
    if (self.customerJourneyDataManager.sectionTitleTextList != nil) {
        return [self.customerJourneyDataManager.sectionTitleTextList objectAtIndex:section];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
    static NSString *CellIdentifier = @"IdCustomerListingTableCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerListingTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;                
            }
        }
    }
    
    // Configure the cell...    
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    //Customer Name
    cell.nameLabel.text =[aCust objectForKey:@"Name"];    
    //Address
    if ([aCust objectForKey:@"Address1"]==nil) {
        [aCust setObject:@"" forKey:@"Address1"];
    }
    if ([aCust objectForKey:@"Address2"]==nil) {
        [aCust setObject:@"" forKey:@"Address2"];
    }
    if ([aCust objectForKey:@"Address3"]==nil) {
        [aCust setObject:@"" forKey:@"Address3"];
    }
    if ([aCust objectForKey:@"Address4"]==nil) {
        [aCust setObject:@"" forKey:@"Address4"];
    }
    if ([aCust objectForKey:@"Address5"]==nil) {
        [aCust setObject:@"" forKey:@"Address5"];
    }
    cell.addressLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];

    [cell.locationStatusButton setImage:nil forState:UIControlStateNormal];
    [cell.creditStatusButton setImage:nil forState:UIControlStateNormal];
    NSNumber* locationStatusIUR = [aCust objectForKey:@"lsiur"];
    NSNumber* creditStatusIUR = [aCust objectForKey:@"CSiur"];
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithObjects:locationStatusIUR, creditStatusIUR, nil];
    NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:descrDetailIURList];
    NSMutableDictionary* descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
    for (int i = 0; i < [descrDetailDictList count]; i++) {        
        NSDictionary* auxDescrDetailDict = [descrDetailDictList objectAtIndex:i];
        NSNumber* auxCodeType = [auxDescrDetailDict objectForKey:@"CodeType"];
        if ([auxCodeType intValue] == 0) continue;
        NSNumber* auxDescrDetailIUR = [auxDescrDetailDict objectForKey:@"DescrDetailIUR"];
        NSNumber* auxImageIUR = [auxDescrDetailDict objectForKey:@"ImageIUR"];
        [descrDetailDictHashMap setObject:auxImageIUR forKey:auxDescrDetailIUR];
    }
    NSNumber* locationStatusImageIUR = [descrDetailDictHashMap objectForKey:locationStatusIUR];
    if ([locationStatusImageIUR intValue] != 0) {
        UIImage* locationStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:locationStatusImageIUR];
        if (locationStatusImage != nil) {
            [cell.locationStatusButton setImage:locationStatusImage forState:UIControlStateNormal];
        }
    }
    NSNumber* creditStatusImageIUR = [descrDetailDictHashMap objectForKey:creditStatusIUR];
    if ([creditStatusImageIUR intValue] != 0) {
        UIImage* creditStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:creditStatusImageIUR];
        if (creditStatusImage != nil) {
            [cell.creditStatusButton setImage:creditStatusImage forState:UIControlStateNormal];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* orderQtyList = [self.customerJourneyDataManager.orderQtyListDict objectForKey:sectionTitle];
    NSNumber* orderQty = [orderQtyList objectAtIndex:indexPath.row];
    //0:no order 1:call 2:order
    if ([orderQty intValue] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    } else if([orderQty intValue] == 1) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
    } else if ([orderQty intValue] == 2){
        cell.backgroundColor = [UIColor colorWithRed:0.59375 green:0.98046875 blue:0.59375 alpha:1.0]; 
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
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
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    [self.checkLocationIURTemplateProcessor checkLocationIUR:[aCust objectForKey:@"LocationIUR"] locationName:[aCust objectForKey:@"Name"] indexPath:indexPath];
    
    
}

-(void)resetTableList:(NSString*)aJourneyDate {
    [self.tableView reloadData];
    if ([aJourneyDate isEqualToString:@"All"]) {
        int sectionIndex = [self.customerJourneyDataManager getSectionIndexWithDate:[NSDate date]]; 
        if (sectionIndex != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* locationList = [self.customerJourneyDataManager.locationListDict objectForKey:sectionTitle];
    return [locationList objectAtIndex:anIndexPath.row];
}

#pragma mark ModelViewDelegate
- (void) didDismissModalView {
    
}

#pragma mark GenericRefreshParentContentDelegate
- (void) refreshParentContent {

}

- (void)refreshParentContentByEdit {

}

-(void)actionButtonPressed:(id)sender {
    if ([self.actionPopoverController isPopoverVisible]) {
        [self.actionPopoverController dismissPopoverAnimated:YES];        
    } else {        
        [self.actionPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    }
}

#pragma mark CustomerJourneyStartDateDelegate
- (void)dismissJourneyStartDatePopoverController {
    [self.actionPopoverController dismissPopoverAnimated:YES];
}

- (void)refreshParentContentForJourneyStartDate {
    //click the journey button
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];    
    groupViewController.segmentBut.selectedSegmentIndex = 1;
    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged]; 
    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
    [groupViewController processJourneyWithIndexPath:groupViewController.auxJourneyIndexPath];
}

-(NSMutableDictionary*)getSelectedCellData {
    return [self getCustomerWithIndexPath:self.currentIndexPath];
}

#pragma mark CheckLocationIURTemplateDelegate
- (void)succeedToCheckSameLocationIUR:(NSIndexPath*)indexPath {
    [GlobalSharedClass shared].startRecordingDate = [NSDate date];
    self.currentIndexPath = indexPath;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    CustomerInfoTableViewController* CITVC=[[CustomerInfoTableViewController alloc]initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
    CITVC.refreshDelegate = self;
    CITVC.title = @"Customer Information Page";
    CITVC.custIUR=[aCust objectForKey:@"LocationIUR"];
    
    UINavigationController* CITVCNavigationController = [[UINavigationController alloc] initWithRootViewController:CITVC];
    [self.rcsStackedController pushNavigationController:CITVCNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController processSubMenuByCustomerListing:aCust reqSourceName:self.requestSourceName];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [CITVC release];
    [CITVCNavigationController release];
}
- (void)succeedToCheckNewLocationIUR:(NSIndexPath*)indexPath {
    [self succeedToCheckSameLocationIUR:indexPath];
    [GlobalSharedClass shared].currentSelectedContactIUR = nil;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    [self resetCurrentOrderAndWholesaler:[aCust objectForKey:@"LocationIUR"]];
    [self configWholesalerLogo];
    [self syncCustomerContactViewController];
}
- (void)failToCheckLocationIUR:(NSString*)aTitle {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController.selectedSubMenuTableViewController selectBottomRecordByTitle:aTitle];
}

@end
