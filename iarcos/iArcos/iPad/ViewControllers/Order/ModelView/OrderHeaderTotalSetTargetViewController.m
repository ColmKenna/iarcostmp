//
//  OrderHeaderTotalSetTargetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "OrderHeaderTotalSetTargetViewController.h"

@implementation OrderHeaderTotalSetTargetViewController
@synthesize delegate = _delegate;
@synthesize displayList = _displayList;
@synthesize targetTableView = _targetTableView;
@synthesize tableNavigationItem;
@synthesize settingManager;
@synthesize settingGroups;
@synthesize cellFactory;
@synthesize saveButton;
@synthesize extendedSettingManager = _extendedSettingManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.displayList != nil) { self.displayList = nil; }        
    if (self.targetTableView != nil) { self.targetTableView = nil; }
    if (self.tableNavigationItem != nil) { self.tableNavigationItem = nil; }
    if (self.settingManager != nil) { self.settingManager = nil; }
    if (self.settingGroups != nil) { self.settingGroups = nil; }
    if (self.cellFactory != nil) { self.cellFactory = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }
    if (self.extendedSettingManager != nil) { self.extendedSettingManager = nil; }
    
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
//    NSLog(@"_targetFlags.allowActionsToQueue: %d", _testTargetFlags.allowActionsToQueue);
//    _testTargetFlags.verticalAlignment = 3;
//    NSLog(@"_targetFlags.verticalAlignment: %d", _testTargetFlags.verticalAlignment);
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.tableNavigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)] autorelease];
    [self.tableNavigationItem setRightBarButtonItem:saveButton];
    self.targetTableView.allowsSelection = NO;
    self.settingGroups = [NSArray arrayWithObjects:@"Personal", nil];
    self.cellFactory = [SettingTableCellFactory factory];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.targetTableView != nil) { self.targetTableView = nil; }
    if (self.tableNavigationItem != nil) { self.tableNavigationItem = nil; }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    self.settingManager = [SettingManager setting];
    self.extendedSettingManager = [[[ExtendedSettingManager alloc] init] autorelease];    
    [self.targetTableView reloadData];
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{    
    return @"Personal";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.settingManager != nil && self.extendedSettingManager != nil) {
        NSString* tmpKeypath = [NSString stringWithFormat:@"PersonalSetting.%@", [self.settingGroups objectAtIndex:section]];
        return [self.settingManager numberOfItemsOnKeypath:tmpKeypath] - 1 + [self.extendedSettingManager numberOfItemsOnKeypath:tmpKeypath];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* groupName=[self.settingGroups objectAtIndex:indexPath.section];
    NSString* keypath = [NSString stringWithFormat:@"PersonalSetting.%@",groupName];
    //NSLog(@"setting manage is %@",self.settingManager.settingDict);
    NSMutableDictionary* item = nil;
    if (indexPath.row == 0) {
        item = [self.extendedSettingManager getSettingForKeypath:keypath atIndex:indexPath.row];
    } else {
        item = [self.settingManager getSettingForKeypath:keypath atIndex:indexPath.row];
    } 
    
    
    
    //static NSString *CellIdentifier = @"Cell";
    
    SettingInputCell* cell = (SettingInputCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:item]];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = (SettingInputCell*)[self.cellFactory createSettingInputCellWithData:item];
        cell.delegate = self;
    }
    
    // Configure the cell...
    
    //cell.textLabel.text=[item objectForKey:@"Label"];
    cell.indexPath = indexPath;
    [cell configCellWithData:item];
    
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

#pragma mark setting input cell delegate
-(void)editStartForIndexpath:(NSIndexPath*)theIndexpath{
    self.saveButton.enabled=NO;
}
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath{
    NSString* groupName = [self.settingGroups objectAtIndex:theIndexpath.section];    
    NSString* keypath = [NSString stringWithFormat:@"PersonalSetting.%@",groupName];
    if (theIndexpath.row == 0) {
        [self.extendedSettingManager updateSettingForKeypath:keypath atIndex:theIndexpath.row withData:data];
    } else {
        [self.settingManager updateSettingForKeypath:keypath atIndex:theIndexpath.row withData:data];
    }    
    self.saveButton.enabled=YES;
}
-(void)invalidDataForIndexpath:(NSString*)theIndexpath{
    
}
-(void)popoverShows:(UIPopoverController*)aPopover{

}

-(void)cancelPressed {
    [self.delegate dismissPopoverController];
}

-(void)savePressed:(id)sender {
    BOOL isSuccess = [self.settingManager saveSetting];
    BOOL isExtendedSuccessful = [self.extendedSettingManager saveSetting];
    if (isSuccess && isExtendedSuccessful) {
        [ArcosUtils showMsg:@"Target is saved." delegate:self];        
    } else {
        [ArcosUtils showMsg:@"Fail to save the Target." delegate:nil];
    }    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //Code that will run after you press ok button        
        [self.delegate refreshParentContent];
        [self.delegate dismissPopoverController];
    }
}

@end
