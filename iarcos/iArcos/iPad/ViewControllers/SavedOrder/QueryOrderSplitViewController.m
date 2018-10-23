//
//  QueryOrderSplitViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderSplitViewController.h"

@interface QueryOrderSplitViewController ()

- (void)layoutSubviews;

@end

@implementation QueryOrderSplitViewController
@synthesize splitDividerLabel = _splitDividerLabel;
@synthesize queryOrderMasterTableViewController = _queryOrderMasterTableViewController;
@synthesize queryOrderDetailTableViewController = _queryOrderDetailTableViewController;
@synthesize masterWidth = _masterWidth;
@synthesize dividerWidth = _dividerWidth;
@synthesize masterNavigationController = _masterNavigationController;
@synthesize detailNavigationController = _detailNavigationController;
@synthesize queryOrderSource = _queryOrderSource;
@synthesize animateDelegate = _animateDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.queryOrderSource == QueryOrderHomePage) {
//        [ArcosUtils configEdgesForExtendedLayout:self];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.dividerWidth = 2.0f;
    self.navigationController.navigationBar.hidden = YES;
    if (self.queryOrderSource == QueryOrderHomePage) {
        self.navigationController.navigationBar.hidden = NO;
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
        self.navigationItem.rightBarButtonItem = backButton;
        [backButton release];
    }
    self.queryOrderMasterTableViewController = [[[QueryOrderMasterTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    self.queryOrderMasterTableViewController.queryOrderSource = self.queryOrderSource;
    self.queryOrderMasterTableViewController.animateDelegate = self;
//    self.queryOrderMasterTableViewController.delegate = self;
    self.masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.queryOrderMasterTableViewController] autorelease];
    self.queryOrderDetailTableViewController = [[[QueryOrderDetailTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    self.detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.queryOrderDetailTableViewController] autorelease];
    self.splitDividerLabel = [[[SplitDividerUILabel alloc] init] autorelease];
    [self.tableView addSubview:self.masterNavigationController.view];
    
    [self.tableView addSubview:self.splitDividerLabel];
    [self.tableView addSubview:self.detailNavigationController.view];
}

- (void)dealloc {
    self.splitDividerLabel = nil;
    self.queryOrderMasterTableViewController = nil;
    self.queryOrderDetailTableViewController = nil;
    self.masterNavigationController = nil;
    self.detailNavigationController = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    float yOrigin = self.tableView.bounds.origin.y;
    if (self.queryOrderSource == QueryOrderHomePage) {
        yOrigin = 0.0f;
    }    
    self.masterWidth = self.tableView.frame.size.width / 2.0;
    float tableViewHeight = self.tableView.bounds.size.height;
    self.masterNavigationController.view.frame = CGRectMake(0, yOrigin, self.masterWidth-1, tableViewHeight);
    self.splitDividerLabel.frame = CGRectMake(self.masterWidth-1, yOrigin, self.dividerWidth, tableViewHeight);
    self.detailNavigationController.view.frame = CGRectMake(self.masterWidth, yOrigin, self.masterWidth, tableViewHeight);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutSubviews];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

#pragma mark QueryOrderMasterTableViewControllerDelegate
- (void)selectQueryOrderMasterRecord {
    [self.queryOrderDetailTableViewController loadDataForTableView:0];
}

//- (CGRect)getParentFrameFromChild {
//    return self.navigationController.view.frame;
//}

#pragma mark SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)backButtonPressed:(id)sender {
//    [self.presentDelegate didDismissPresentView];
}




@end
