//
//  UtilitiesDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDetailViewController.h"
#import "ArcosSplitViewController.h"

@implementation UtilitiesDetailViewController
@synthesize myBarButtonItem;
@synthesize navigationDelegate = _navigationDelegate;
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
//    if (self.navigationDelegate != nil) {
//        self.navigationDelegate = nil;
//    }
    self.myBarButtonItem = nil;
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
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsPortrait(orientation)||orientation==0) {
        if (self.myBarButtonItem!=nil&&self.navigationController.navigationBar.topItem.leftBarButtonItem==nil) {
            //[self.navigationController.navigationBar.topItem setLeftBarButtonItem:self.myBarButtonItem animated:NO];
            self.navigationItem.leftBarButtonItem=self.myBarButtonItem;

        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
    */
    /* come back later
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (self.myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=self.myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
    */
    [self controlLeftBarButtonItem];
    
}

- (void)leftBarButtonPressed {
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController;
    [arcosSplitViewController rightMoveMasterViewController];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self controlLeftBarButtonItem];
}

- (void)controlLeftBarButtonItem {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController.parentViewController;
        UIViewController* masterViewController = [arcosSplitViewController.rcsViewControllers objectAtIndex:0];
        UIBarButtonItem* leftBarButton = [[[UIBarButtonItem alloc] initWithTitle:masterViewController.title style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed)] autorelease];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }else{
        self.navigationItem.leftBarButtonItem=nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
    //    [itemsArray insertObject:barButtonItem atIndex:0];
    //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
    //    [itemsArray release];
//    self.navigationItem.leftBarButtonItem=self.myBarButtonItem;
    self.navigationItem.leftBarButtonItem=barButtonItem;
    self.myBarButtonItem=barButtonItem;
    
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
    //    [itemsArray removeObject:barButtonItem];
    //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
    //    [itemsArray release];
    //self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    
}
- (void)reloadTableData{
    
}
- (void)reloadTableDataWithData:(NSMutableArray*)theData{
    
}
@end
