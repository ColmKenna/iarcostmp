//
//  DashboardGenericTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardGenericTableViewController.h"

@interface DashboardGenericTableViewController ()

@end

@implementation DashboardGenericTableViewController
@synthesize dashboardGenericDataManager = _dashboardGenericDataManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.dashboardGenericDataManager = [[[DashboardGenericDataManager alloc] init] autorelease];
    [self.dashboardGenericDataManager createBasicData];
}

- (void)dealloc {
    self.dashboardGenericDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dashboardGenericDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdDashboardGenericTableViewCell";
    DashboardGenericTableViewCell* cell = (DashboardGenericTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardGenericTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardGenericTableViewCell class]] && [[(DashboardGenericTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (DashboardGenericTableViewCell *) nibItem;                
            }
        }
    }
    NSMutableArray* cellDataList = [self.dashboardGenericDataManager.displayList objectAtIndex:indexPath.row];
    [cell configCellWithDataList:cellDataList];
    
    return cell;
}



/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
