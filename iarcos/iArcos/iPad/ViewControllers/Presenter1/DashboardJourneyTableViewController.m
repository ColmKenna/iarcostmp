//
//  DashboardJourneyTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardJourneyTableViewController.h"
#import "ArcosRootViewController.h"
#import "CustomerGroupViewController.h"

@interface DashboardJourneyTableViewController ()

@end

@implementation DashboardJourneyTableViewController
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize myHeaderView = _myHeaderView;
@synthesize arcosRootViewController = _arcosRootViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.customerJourneyDataManager = [[[CustomerJourneyDataManager alloc] init] autorelease];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorColor:[UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.customerJourneyDataManager = nil;
    self.myHeaderView = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.customerJourneyDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* locationList = [self.customerJourneyDataManager.locationListDict objectForKey:sectionTitle];
    return [locationList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.myHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* journeyCellIdentifier = @"IdDashboardJourneyTableViewCell";
    
    DashboardJourneyTableViewCell* cell = (DashboardJourneyTableViewCell*) [tableView dequeueReusableCellWithIdentifier:journeyCellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardJourneyTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardJourneyTableViewCell class]] && [[(DashboardJourneyTableViewCell*)nibItem reuseIdentifier] isEqualToString:journeyCellIdentifier]) {
                cell = (DashboardJourneyTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    
    NSMutableDictionary* aCust = [self.customerJourneyDataManager retrieveCustomerWithIndexPath:indexPath];
    //Customer Name
    cell.customerName.text = [aCust objectForKey:@"Name"];
    //Address
    if ([aCust objectForKey:@"Address1"] == nil) {
        [aCust setObject:@"" forKey:@"Address1"];
    }
    if ([aCust objectForKey:@"Address2"] == nil) {
        [aCust setObject:@"" forKey:@"Address2"];
    }
    if ([aCust objectForKey:@"Address3"] == nil) {
        [aCust setObject:@"" forKey:@"Address3"];
    }
    if ([aCust objectForKey:@"Address4"] == nil) {
        [aCust setObject:@"" forKey:@"Address4"];
    }
    if ([aCust objectForKey:@"Address5"] == nil) {
        [aCust setObject:@"" forKey:@"Address5"];
    }
    cell.customerAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];
    NSNumber* orderQtyNumber = [self.customerJourneyDataManager retrieveOrderQtyWithIndexPath:indexPath];
    if ([orderQtyNumber intValue] == 0) {
        cell.customerStatus.text = @"Waiting";
    } else {
        cell.customerStatus.text = @"Called";
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    int itemIndex = [self.arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    [self.arcosRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
    ArcosStackedViewController* myLocationArcosStackedViewController = self.arcosRootViewController.customerMasterViewController.customerMasterDataManager.locationArcosStackedViewController;
//    [myLocationArcosStackedViewController popToRootNavigationController:NO];

    UINavigationController* tmpNavigationController = (UINavigationController*)myLocationArcosStackedViewController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
//    groupViewController.segmentBut.selectedSegmentIndex = 0;
//    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged];
//    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
//    [groupViewController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [groupViewController.tableView.delegate tableView:groupViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [groupViewController resetButtonPressed:nil];
    
    UINavigationController* customerListingNavigationController = [myLocationArcosStackedViewController.rcsViewControllers objectAtIndex:0];
    CustomerListingViewController* customerListingViewController = [customerListingNavigationController.viewControllers objectAtIndex:0];
    NSMutableDictionary* aCustomerDict = [self.customerJourneyDataManager retrieveCustomerWithIndexPath:indexPath];
    NSIndexPath* myJourneyLocationIndexPath = [customerListingViewController getCustomerIndexWithLocationIUR:[aCustomerDict objectForKey:@"LocationIUR"]];
    [customerListingViewController selectLocationWithIndexPath:myJourneyLocationIndexPath];
    
}

@end
