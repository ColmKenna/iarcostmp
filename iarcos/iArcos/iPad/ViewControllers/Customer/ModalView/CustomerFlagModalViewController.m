//
//  CustomerFlagModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerFlagModalViewController.h"
#import "ArcosStackedViewController.h"

@implementation CustomerFlagModalViewController
@synthesize locationIUR = _locationIUR;
@synthesize customerFlagDataManager = _customerFlagDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize connectivityCheck = _connectivityCheck;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    if (self.locationIUR != nil) { self.locationIUR = nil; }        
    if (self.customerFlagDataManager != nil) { self.customerFlagDataManager = nil; }
    
    if (self.callGenericServices != nil) {
        self.callGenericServices.delegate = nil;
        self.callGenericServices = nil;
    }
    if (self.connectivityCheck != nil) { self.connectivityCheck = nil; }
    
    [super dealloc];
}    

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    
    self.customerFlagDataManager = [[[CustomerFlagDataManager alloc] initWithLocationIUR:self.locationIUR] autorelease];

    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
    
/**    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    //init a connectivity check
    self.connectivityCheck = [[[ConnectivityCheck alloc]init] autorelease];
    [self.connectivityCheck statusLog];
*/     
    NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where LocationIUR = %@", self.locationIUR];
    [self.callGenericServices getData: sqlStatement];
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
    if (self.customerFlagDataManager.displayList != nil) {
        return [self.customerFlagDataManager.displayList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerFlagTableCell";
    
    CustomerFlagTableCell* cell = (CustomerFlagTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerFlagTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerFlagTableCell class]] && [[(CustomerFlagTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerFlagTableCell *) nibItem;
            }
        }
	}    
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.customerFlagDataManager.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData];
    cell.indexPath = indexPath;
    if ([[cellData objectForKey:@"LocationFlag"] intValue] == 0) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.myImageView.image = nil;
    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.myImageView.image = [UIImage imageNamed:@"Flags.png"];
    }
    if ([[cellData objectForKey:@"Active"] intValue] == 0) {
        cell.flagText.textColor = [UIColor redColor];
    } else {
        cell.flagText.textColor = [UIColor blackColor];
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
    NSNumber* locationFlag = [NSNumber numberWithInt:0];    
    NSMutableDictionary* cellData = [self.customerFlagDataManager.displayList objectAtIndex:indexPath.row];
    NSString* detail = [cellData objectForKey:@"Detail"];
    if ([detail containsString:@"*"]) {
        [ArcosUtils showDialogBox:[cellData objectForKey:@"Tooltip"] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];        
        [self.tableView reloadData];
        return;
    }
    if ([[cellData objectForKey:@"LocationFlag"] intValue] == 0) {
        locationFlag = [NSNumber numberWithInt:1];
    }
    [self.customerFlagDataManager updateChangedData:locationFlag indexPath:indexPath];
    [self.tableView reloadData];
}


//connectivity notification back
/**
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != self.connectivityCheck) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (check.serviceCallAvailable) {
        NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where LocationIUR = %@", self.locationIUR];
        [self.callGenericServices getData: sqlStatement];
    } else {
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
    [check stop];
}
*/

-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        [self.customerFlagDataManager processRawData:result.ArrayOfData];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (void)savePressed:(id)sender {
    [self.customerFlagDataManager getChangedDataList];
//    NSLog(@"changedDataList is %@", self.customerFlagDataManager.changedDataList);
    if ([self.customerFlagDataManager.changedDataList count] == 0) {
        [ArcosUtils showMsg:@"There is no change." delegate:nil];
        return;
    }
    [self.callGenericServices createMultipleRecords:@"Flag" records:self.customerFlagDataManager.changedDataList];
}

-(void)setCreateMultipleRecordsResult:(NSMutableArray*) result {
    if (result == nil) {
        return;
    }
    [ArcosUtils showMsg:@"Completed" delegate:self];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){  
        //Code that will run after you press ok button 
//        [self.navigationController popViewControllerAnimated:YES];
        [self.rcsStackedController popTopNavigationController:YES];
    }
}

@end
