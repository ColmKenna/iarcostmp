//
//  StockistParentTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 17/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "StockistParentTableViewController.h"

@implementation StockistParentTableViewController
@synthesize displayList = _displayList;
@synthesize childDelegate = _childDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }    
    
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
    /*
    self.displayList = [NSMutableArray array];
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithObjects:@"L1", @"L2", @"L3", @"L4", @"L5", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode in %@", descrTypeCodeList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"DescrTypeCode", nil];
    self.displayList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    */
    self.title = @"Level Description";
    [self getStockistParentData];
    [self.tableView reloadData];
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
    return [self.displayList count];
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"Detail"]];
    
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
    NSDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    StockistChildTableViewController* sctvc = [[StockistChildTableViewController alloc] initWithNibName:@"StockistChildTableViewController" bundle:nil];
    sctvc.title = [cellData objectForKey:@"Detail"];
    sctvc.childDelegate = self;
    [sctvc descrDetailWithDescrTypeCode:[cellData objectForKey:@"MyDescrTypeCode"]];
    [self.navigationController pushViewController:sctvc animated:YES];
    [sctvc release];
}

#pragma mark StockistChildTableViewDelegate
- (void)didSelectStockistChildWithCellData:(NSDictionary *)aCellData {
    [self.childDelegate didSelectStockistChildWithCellData:aCellData];
}

- (void)getStockistParentData {
    [self getDefaultStockistParentData];
    if ([self.displayList count] == 0) {
        [ArcosUtils showMsg:@"Please create the Level Description." delegate:nil];
    }    
}

- (void)getDefaultStockistParentData {
    self.displayList = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1 and DescrTypeCode = 'LD'"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"DescrTypeCode", nil];
    NSMutableArray* ldDescrDetailList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([ldDescrDetailList count] > 0) {
        for (int i = 0; i < [ldDescrDetailList count]; i++) {
            NSDictionary* ldDescrDetailDict = [ldDescrDetailList objectAtIndex:i];
            NSString* descrDetailCode = [ldDescrDetailDict objectForKey:@"DescrDetailCode"];
            NSNumber* descrDetailCodeNumber = [ArcosUtils convertStringToNumber:descrDetailCode];            
            if ([descrDetailCodeNumber intValue] <= 5) {
                NSMutableDictionary* newLdDescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:ldDescrDetailDict];
                [newLdDescrDetailDict setObject:[NSString stringWithFormat:@"L%d",[descrDetailCodeNumber intValue]] forKey:@"MyDescrTypeCode"];
                [self.displayList addObject:newLdDescrDetailDict];
            }
        }
    }
}

@end
