//
//  UtilitiesDescriptionDetailEditViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailEditViewController.h"

@implementation UtilitiesDescriptionDetailEditViewController
@synthesize myDelegate = _myDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize delegate = _delegate;
@synthesize tableCellList = _tableCellList;
@synthesize codeCell = _codeCell;
@synthesize detailsCell = _detailsCell;
@synthesize activeCell = _activeCell;
@synthesize forDetailingCell = _forDetailingCell;
@synthesize actionType = _actionType;
@synthesize tableCellData = _tableCellData;
@synthesize dataManager = _dataManager;
@synthesize descrTypecode = _descrTypecode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
//    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }       
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.tableCellList != nil) { self.tableCellList = nil; }
    if (self.codeCell != nil) { self.codeCell = nil; }
    if (self.detailsCell != nil) { self.detailsCell = nil; }
    if (self.activeCell != nil) { self.activeCell = nil; }
    if (self.forDetailingCell != nil) { self.forDetailingCell = nil; }
    if (self.actionType != nil) { self.actionType = nil; }    
    if (self.tableCellData != nil) { self.tableCellData = nil; } 
    if (self.dataManager != nil) { self.dataManager = nil; }     
    if (self.descrTypecode != nil) { self.descrTypecode = nil; }         
    
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    
    self.tableCellList = [[[NSMutableArray alloc] init] autorelease];
    [self.tableCellList addObject:self.codeCell];
    [self.tableCellList addObject:self.detailsCell];
    [self.tableCellList addObject:self.activeCell];
    [self.tableCellList addObject:self.forDetailingCell];
    
    self.dataManager = [[[UtilitiesDescriptionDetailEditViewDataManager alloc] init] autorelease];
    self.tableView.allowsSelection = NO;
    rowPointer = 0;
    isAllowedToShowForDetailing = NO;
    if ([self.descrTypecode isEqualToString:@"L1"] || [self.descrTypecode isEqualToString:@"L2"] || [self.descrTypecode isEqualToString:@"L3"] || [self.descrTypecode isEqualToString:@"L4"] || [self.descrTypecode isEqualToString:@"L5"]) {
        isAllowedToShowForDetailing = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.actionType isEqualToString:@"edit"]) {
        [self.dataManager processRawData:self.tableCellData];
        [self.tableView reloadData];
    }
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
//    if (indexPath.section == 0) {
//        return 60;
//    }
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
    if (self.tableCellList != nil) {
        if (isAllowedToShowForDetailing) {
            return [self.tableCellList count];
        } else {
            return [self.tableCellList count] - 1;
        }        
    }    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{    
    return @"Details";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    NSMutableDictionary* cellData = [self.dataManager.displayList objectAtIndex:indexPath.row];
    CustomerContactBaseTableCell* cell = (CustomerContactBaseTableCell*)[self.tableCellList objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    cell.delegate = self;
    
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

-(void)backPressed:(id)sender {
//    [self.delegate didDismissModalView];
    [self.myDelegate didDismissCustomisePresentView];
}

-(void)inputFinishedWithData:(id)aContentString actualContent:(id)anActualContent WithIndexPath:(NSIndexPath *)anIndexPath {
    [self.dataManager updateChangedData:aContentString actualContent:anActualContent withIndexPath:anIndexPath];
}

-(void)savePressed:(id)sender {
    [self.view endEditing:YES];
    [self submitProcessCenter];
}

- (void)updateDescrDetailRecord {
    if (rowPointer == [self.dataManager.updatedFieldNameList count]) {
        [ArcosUtils showDialogBox:@"Completed." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
            [self.refreshDelegate refreshParentContent];
            [self backPressed:nil];
        }];
        return;
    }
    [[ArcosCoreData sharedArcosCoreData] updateDescrDetailWithFieldName:[self.dataManager.updatedFieldNameList objectAtIndex:rowPointer] fieldValue:[self.dataManager.updatedFieldValueList objectAtIndex:rowPointer] descrTypeCode:[self.tableCellData objectForKey:@"DescrTypeCode"] descrDetailIUR:[self.tableCellData objectForKey:@"DescrDetailIUR"]];
    rowPointer++;
    [self updateDescrDetailRecord];
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //Code that will run after you press ok button
        [self.refreshDelegate refreshParentContent];
        [self backPressed:nil];
    }
}*/

- (void)submitProcessCenter {
    if ([self.dataManager isNewRecord]) {
        [self.dataManager prepareForCreateProcess];
        if ([self validateCreateProcess]) {
            [self createDescrDetailRecord];
        }
    } else {
        if ([self validateUpdateProcess]) {
            [self.dataManager getChangedDataList];
            if ([self.dataManager.updatedFieldNameList count] == 0) {
                [ArcosUtils showDialogBox:@"There is no change." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return;
            }
            [self updateDescrDetailRecord];
        }        
    }
}

- (void)createDescrDetailRecord {
//    NSLog(@"createFieldValueList %@", [self.dataManager createFieldValueList]);
    [[ArcosCoreData sharedArcosCoreData] createDescrDetailWithFieldNameList:[self.dataManager dbFieldNameList] fieldValueList:[self.dataManager createFieldValueList] descrTypeCode:self.descrTypecode];
    [ArcosUtils showDialogBox:@"Completed." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
        [self.refreshDelegate refreshParentContent];
        [self backPressed:nil];
    }];
}

- (BOOL)validateCreateProcess {
    if ([[ArcosUtils trim:[self.dataManager.createFieldValueList objectAtIndex:0]] isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Please enter a code." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        
        }];
        return NO;
    } else if ([[ArcosUtils trim:[self.dataManager.createFieldValueList objectAtIndex:1]] isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Please enter a detail." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return NO;
    }
    return YES;
}

- (BOOL)validateUpdateProcess {
    NSMutableDictionary* codeCellData = [self.dataManager.displayList objectAtIndex:0];
    NSString* code = [ArcosUtils trim:[codeCellData objectForKey:@"actualContent"]];
    if ([code isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"The code is not allowed to be blank." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return NO;
    }
    NSMutableDictionary* detailCellData = [self.dataManager.displayList objectAtIndex:1];
    NSString* detail = [ArcosUtils trim:[detailCellData objectForKey:@"actualContent"]];
    if ([detail isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"The detail is not allowed to be blank." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return NO;
    }
    return YES;
}

@end
