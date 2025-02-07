//
//  FormRowDividerTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FormRowDividerTableViewController.h"
#import "UIColor+Hex.h"

@implementation FormRowDividerTableViewController
@synthesize delegate = _delegate;
@synthesize formIUR = _formIUR;
@synthesize formName = _formName;
@synthesize formRowDividerDataManager = _formRowDividerDataManager;
@synthesize tableNavigationBar = _tableNavigationBar;
@synthesize formRowDividerTableView = _formRowDividerTableView;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.delegate != nil) { self.delegate = nil; }
    if (self.formIUR != nil) { self.formIUR = nil; }
    if (self.formName != nil) { self.formName = nil; }    
    if (self.formRowDividerDataManager != nil) { self.formRowDividerDataManager = nil; }
    if (self.tableNavigationBar != nil) { self.tableNavigationBar = nil; }
    if (self.formRowDividerTableView != nil) { self.formRowDividerTableView = nil; }
    
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
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed)];
    [self.tableNavigationBar.topItem setLeftBarButtonItem:backButton];
    [self.tableNavigationBar.topItem setTitle:self.formName];
    [backButton release];
     */
    self.navigationItem.title = self.formName;
    
    self.formRowDividerDataManager = [[[FormRowDividerDataManager alloc] init] autorelease];
    [self.formRowDividerDataManager createBasicData:self.formIUR];
    
    self.formRowDividerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; // or UITableViewCellSeparatorStyleNone
    self.formRowDividerTableView.separatorColor = [UIColor borderColor]; // Change color as needed
    self.formRowDividerTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15); // Adjust insets

    if (@available(iOS 15.0, *)) {
       self.formRowDividerTableView.separatorInsetReference = UITableViewSeparatorInsetFromCellEdges;
    }

    
    self.navigationController.navigationBar.tintColor = [UIColor headerLabelColor];

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
    [self.formRowDividerDataManager createBasicData:self.formIUR];
    self.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.formRowDividerDataManager.displayList != nil) {
        return [self.formRowDividerDataManager.displayList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
//    NSLog(@"currentSelectionIUR: %@", [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR);
    NSMutableDictionary* cellData = [self.formRowDividerDataManager.displayList objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellData objectForKey:@"Details"];
    if ([[[OrderSharedClass sharedOrderSharedClass] currentFormIUR] isEqualToNumber:self.formIUR] && [[OrderSharedClass sharedOrderSharedClass].currentSelectionIUR isEqualToNumber:[cellData objectForKey:@"SequenceDivider"]]) {
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
    NSMutableDictionary* cellData = [self.formRowDividerDataManager.displayList objectAtIndex:indexPath.row];
    [self.delegate didSelectFormRowDividerRow:cellData formIUR:self.formIUR];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
