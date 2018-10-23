//
//  UtilitiesDescriptionDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailViewController.h"

@implementation UtilitiesDescriptionDetailViewController
@synthesize navigationDelegate = _navigationDelegate;
@synthesize descrTypeCode = _descrTypeCode;
@synthesize displayList = _displayList;
@synthesize codeLabel = _codeLabel;
@synthesize detailLabel = _detailLabel;
@synthesize tableHeader;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
//    if (self.navigationDelegate != nil) {
//        self.navigationDelegate = nil;
//    }
    if (self.descrTypeCode != nil) { self.descrTypeCode = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    self.codeLabel = nil;
    self.detailLabel = nil;
    if (self.tableHeader != nil) {
        self.tableHeader = nil;
    }
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
    
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
    self.rootView = [ArcosUtils getRootView];
    
    self.displayList = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:self.descrTypeCode];
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    [addButton release];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return tableHeader;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.displayList != nil) {
        return [self.displayList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdUtilitiesDescriptionDetailTableCell";
    
    UtilitiesDescriptionDetailTableCell* cell=(UtilitiesDescriptionDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesDescriptionDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesDescriptionDetailTableCell class]] && [[(UtilitiesDescriptionDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (UtilitiesDescriptionDetailTableCell *) nibItem;                
            }
        }
	}
    // Configure the cell...
    
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    [cell configCellData:cellData];
    
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
    
    UtilitiesDescriptionDetailEditWrapperViewController* uddewvc = [[UtilitiesDescriptionDetailEditWrapperViewController alloc] initWithNibName:@"UtilitiesDescriptionDetailEditWrapperViewController" bundle:nil];
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    uddewvc.tableCellData = cellData;
    uddewvc.actionType = @"edit";
    uddewvc.myDelegate = self;
    uddewvc.refreshDelegate = self;
    uddewvc.delegate = self;
    uddewvc.navigationDelegate = self;
    uddewvc.descrTypeCode = [cellData objectForKey:@"DescrTypeCode"];
    uddewvc.navgationBarTitle = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"Detail"]];
    
    uddewvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:uddewvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView.view addSubview:self.globalNavigationController.view];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [uddewvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

-(void)addPressed:(id)sender {
    UtilitiesDescriptionDetailEditWrapperViewController* uddewvc = [[UtilitiesDescriptionDetailEditWrapperViewController alloc] initWithNibName:@"UtilitiesDescriptionDetailEditWrapperViewController" bundle:nil];
    uddewvc.navgationBarTitle = [NSString stringWithFormat:@"New %@", self.title];
    uddewvc.myDelegate = self;
    uddewvc.refreshDelegate = self;
    uddewvc.delegate = self;
    uddewvc.navigationDelegate = self;
    uddewvc.descrTypeCode = self.descrTypeCode;
    
    uddewvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:uddewvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView.view addSubview:self.globalNavigationController.view];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [uddewvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController.view removeFromSuperview];
        self.globalNavigationController = nil;
    }];
}

- (void)didDismissModalView {
    [self.rootView dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
    }];
}

#pragma mark ControllNavigationBarDelegate
- (void)showNavigationBar {
    [self.navigationDelegate showNavigationBar];
}

- (void)hideNavigationBar {
    [self.navigationDelegate hideNavigationBar];
}

#pragma mark GenericRefreshParentContentDelegate

- (void)refreshParentContent {
    self.displayList = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:self.descrTypeCode];
    [self.tableView reloadData];
}

@end
