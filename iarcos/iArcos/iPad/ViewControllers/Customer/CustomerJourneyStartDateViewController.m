//
//  CustomerJourneyStartDateViewController.m
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyStartDateViewController.h"

@implementation CustomerJourneyStartDateViewController
@synthesize myTableView = _myTableView;
@synthesize myNavigationItem = _myNavigationItem;
@synthesize saveButton = _saveButton;
@synthesize callGenericServices = _callGenericServices;
@synthesize updateButton = _updateButton;
@synthesize delegate = _delegate;
@synthesize customerJourneyStartDateDataManager = _customerJourneyStartDateDataManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    if (self.myTableView != nil) { self.myTableView = nil; }
    if (self.myNavigationItem != nil) { self.myNavigationItem = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.updateButton != nil) { self.updateButton = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.customerJourneyStartDateDataManager != nil) { self.customerJourneyStartDateDataManager = nil; }
    
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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)] autorelease];
    self.myNavigationItem.rightBarButtonItem = self.saveButton;        
    /*
    self.updateButton = [[[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updatePressed:)] autorelease];
    self.myNavigationItem.leftBarButtonItem = self.updateButton;
    */
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.myNavigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.myTableView != nil) { self.myTableView = nil; }
    if (self.myNavigationItem != nil) { self.myNavigationItem = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.callGenericServices == nil) {        
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
    }
    self.customerJourneyStartDateDataManager = [[[CustomerJourneyStartDateDataManager alloc] init] autorelease];
    [self.myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)savePressed:(id)sender {
    /*   
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSLog(@"employeeDict: %@", employeeDict);
    [self.callGenericServices getData:@"select * from iPadSavedFilters"];
    */
    [self.customerJourneyStartDateDataManager getChangedDataList];
    if ([self.customerJourneyStartDateDataManager.changedDataList count] <= 0) {
//        [ArcosUtils showMsg:@"There is no change." delegate:nil];
        [ArcosUtils showDialogBox:@"There is no change." title:@"" target:self handler:nil];
        return;
    }
    NSMutableDictionary* cellDataDict = [self.customerJourneyStartDateDataManager.changedDataList objectAtIndex:0];
    self.customerJourneyStartDateDataManager.changedJourneyStartDate = [cellDataDict objectForKey:@"FieldData"];
    [self.callGenericServices updateRecord:@"Employee" iur:[self.customerJourneyStartDateDataManager.employeeIUR intValue] fieldName:@"JourneyStartDate" newContent:[ArcosUtils stringFromDate:self.customerJourneyStartDateDataManager.changedJourneyStartDate format:[GlobalSharedClass shared].dateFormat]];
}

-(void)updatePressed:(id)sender {
    [self.callGenericServices updateRecord:@"Employee" iur:1002 fieldName:@"JourneyStartDate" newContent:@"03/06/2013"];
}

-(void)cancelPressed:(id)sender {
    [self.delegate dismissJourneyStartDatePopoverController];
}

#pragma mark GetDataGenericDelegate
-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {     
        [[ArcosCoreData sharedArcosCoreData] editEmployeeWithIUR:self.customerJourneyStartDateDataManager.employeeIUR journeyStartDate:self.customerJourneyStartDateDataManager.changedJourneyStartDate];
        [self.delegate refreshParentContentForJourneyStartDate];
        [self cancelPressed:nil];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }    
}

-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    NSLog(@"result: %@", result);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{    
    return @"";
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
    return [self.customerJourneyStartDateDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerJourneyStartDateTableCell";
    
    CustomerJourneyStartDateTableCell *cell=(CustomerJourneyStartDateTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerJourneyStartDateTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerJourneyStartDateTableCell class]] && [[(CustomerJourneyStartDateTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerJourneyStartDateTableCell *) nibItem;                
                cell.delegate = self;
            }
        }
	}
    
    // Configure the cell...
    NSMutableDictionary* cellDataDict = [self.customerJourneyStartDateDataManager.displayList objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    [cell configCellWithData:cellDataDict];
    
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
#pragma mark - OrderDetailTypesTableCellDelegate CustomerJourneyStartDateTableCellDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    [self.customerJourneyStartDateDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
}

- (UIViewController*)retrieveCustomerJourneyStartDateParentViewController {
    return self;
}

@end
