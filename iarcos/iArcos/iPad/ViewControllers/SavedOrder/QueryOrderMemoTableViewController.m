//
//  QueryOrderMemoTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMemoTableViewController.h"

@interface QueryOrderMemoTableViewController ()
- (void)updateTaskWhenIssueClosedChanged;
@end

@implementation QueryOrderMemoTableViewController
@synthesize myDelegate = _myDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize editDelegate = _editDelegate;
@synthesize actionType = _actionType;
@synthesize IUR = _IUR;
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize queryOrderMemoDataManager = _queryOrderMemoDataManager;
@synthesize cellFactory = _cellFactory;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize employeeName = _employeeName;
@synthesize locationIUR = _locationIUR;
@synthesize taskIUR = _taskIUR;
@synthesize contactIUR = _contactIUR;
@synthesize memoEmployeeIUR = _memoEmployeeIUR;
@synthesize taskCompletionDate = _taskCompletionDate;
@synthesize taskCurrentIndexPath = _taskCurrentIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelection = NO;
    UIBarButtonItem* tmpBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:tmpBackButton];
    [tmpBackButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.employeeSecurityLevel = [self getEmployeeSecurityLevel];
    self.queryOrderMemoDataManager = [[[QueryOrderMemoDataManager alloc] init] autorelease];
    self.queryOrderMemoDataManager.contactIUR = self.contactIUR;
    self.queryOrderMemoDataManager.taskCompletionDateString = self.taskCompletionDate;
    self.cellFactory = [QueryOrderMemoCellFactory factory];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
    
}

- (void)dealloc {
    self.actionType = nil;
    self.IUR = nil;
    self.callGenericServices = nil;
    self.queryOrderMemoDataManager = nil;
    self.cellFactory = nil;
    self.employeeName = nil;
    self.locationIUR = nil;
    self.taskIUR = nil;
    self.contactIUR = nil;
    self.memoEmployeeIUR = nil;
    self.taskCompletionDate = nil;
    self.taskCurrentIndexPath = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [self.callGenericServices getRecord:@"Memo" iur:[self.IUR intValue]];
}

- (void)cancelPressed:(id)sender {
    [self.myDelegate didDismissCustomisePresentView];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* fieldType = [self.queryOrderMemoDataManager.activeSeqFieldTypeList objectAtIndex:indexPath.section];
    if ([fieldType isEqualToString:@"System.String"]) {
        return 212;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.queryOrderMemoDataManager.constantFieldTypeTranslateDict objectForKey:[self.queryOrderMemoDataManager.activeSeqFieldTypeList objectAtIndex:section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.queryOrderMemoDataManager.activeSeqFieldTypeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* fieldType = [self.queryOrderMemoDataManager.activeSeqFieldTypeList objectAtIndex:section];
    NSMutableArray* tmpDataArray = [self.queryOrderMemoDataManager.groupedDataDict objectForKey:fieldType];
    return [tmpDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary* cellData = [self.queryOrderMemoDataManager cellDataWithIndexPath:indexPath];
    QueryOrderTMBaseTableCell* cell = (QueryOrderTMBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (QueryOrderTMBaseTableCell*)[self.cellFactory createCustomerBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.employeeSecurityLevel = self.employeeSecurityLevel;
    cell.indexPath = indexPath;
    cell.locationIUR = self.locationIUR;
    [cell configCellWithData:cellData];
    
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

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        [self.queryOrderMemoDataManager processRawData:result actionType:self.actionType];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

#pragma mark - check employee SecurityLevel
-(int)getEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    self.employeeName = [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
    return [securityLevel intValue];
}

#pragma mark CustomerTypeTableCellDelegate

-(void)inputFinishedWithData:(id)contentString actualData:(id)actualData forIndexpath:(NSIndexPath *)theIndexpath {
    [self.queryOrderMemoDataManager updateChangedData:contentString actualContent:actualData withIndexPath:theIndexpath];
}

-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath {
    return [self.queryOrderMemoDataManager getFieldNameWithIndexPath:theIndexpath];
}

- (UIViewController*)retrieveCustomerTypeParentViewController {
    return self;
}

-(void)savePressed:(id)sender {
    [self.view endEditing:YES];
    if (![self.actionType isEqualToString:@"create"]) {
        if (![self.memoEmployeeIUR isEqualToNumber:[SettingManager employeeIUR]]) {
            [ArcosUtils showDialogBox:@"This memo cannot be amended as you can only amend a memo created by yourself" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
    }
    if (![self.queryOrderMemoDataManager checkAllowedStringField:@"Details" cellDictList:[self.queryOrderMemoDataManager.groupedDataDict objectForKey:@"System.String"]]) {
        [ArcosUtils showDialogBox:@"Please enter details" title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    [self.queryOrderMemoDataManager getChangedDataList];
    if ([self.queryOrderMemoDataManager.changedDataList count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([self.actionType isEqualToString:@"create"]) {//create location
        [self.queryOrderMemoDataManager prepareToCreateRecord];
        if (self.queryOrderMemoDataManager.isIssueClosedChanged) {
            for (int i = 0; i < [self.queryOrderMemoDataManager.createdFieldNameList count]; i++) {
                NSString* tmpFieldName = [self.queryOrderMemoDataManager.createdFieldNameList objectAtIndex:i];
                if ([tmpFieldName isEqualToString:@"Details"]) {
                    NSString* actualDetails = [self.queryOrderMemoDataManager.createdFieldValueList objectAtIndex:i];
                    if (self.queryOrderMemoDataManager.issueClosedActualValue) {
                        actualDetails = [NSString stringWithFormat:@"%@\n\nClosed by %@ on %@",actualDetails, self.employeeName, [ArcosUtils stringFromDate:[NSDate date] format:@"dd MMMM yyyy"]];
                    } else {
                        actualDetails = [NSString stringWithFormat:@"%@\n\nReopen by %@ on %@", actualDetails, self.employeeName, [ArcosUtils stringFromDate:[NSDate date] format:@"dd MMMM yyyy"]];
                    }
                    [self.queryOrderMemoDataManager.createdFieldValueList replaceObjectAtIndex:i withObject:actualDetails];
                }
            }
        }
        
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"LocationIUR"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:[self.locationIUR stringValue]];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"TableIUR"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:[self.taskIUR stringValue]];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"TableName"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:@"Task"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"EmployeeIUR"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:[[SettingManager employeeIUR] stringValue]];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"FullFilled"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:[[NSNumber numberWithBool:NO] stringValue]];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldNames addObject:@"DateEntered"];
        [self.queryOrderMemoDataManager.arcosCreateRecordObject.FieldValues addObject:[ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy:HH:mm"]];
        
        self.callGenericServices.isNotRecursion = NO;
        [self.callGenericServices createRecord:@"Memo" fields:self.queryOrderMemoDataManager.arcosCreateRecordObject];
    } else {
        self.callGenericServices.isNotRecursion = NO;
        [self submitChangedDataList];
    }
}

-(void)submitChangedDataList {
    if (self.queryOrderMemoDataManager.rowPointer == [self.queryOrderMemoDataManager.changedDataList count]) return;
    NSMutableDictionary* dataCell = [self.queryOrderMemoDataManager.changedDataList objectAtIndex:self.queryOrderMemoDataManager.rowPointer];
    self.queryOrderMemoDataManager.changedFieldName = [self.queryOrderMemoDataManager fieldNameWithIndex:[[dataCell objectForKey:@"originalIndex"] intValue] - 1];
    self.queryOrderMemoDataManager.changedActualContent = [dataCell objectForKey:@"actualContent"];
    [self.callGenericServices updateRecord:@"Memo" iur:[self.IUR intValue] fieldName:self.queryOrderMemoDataManager.changedFieldName newContent:self.queryOrderMemoDataManager.changedActualContent];
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        return;
    }
//    NSLog(@"%@ and %@", result.Field1, result);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        if (self.queryOrderMemoDataManager.isIssueClosedChanged) {
            [self updateTaskWhenIssueClosedChanged];
        } else {
            self.callGenericServices.isNotRecursion = YES;
            [self.callGenericServices.HUD hide:YES];
            [self.refreshDelegate refreshParentContent];
            [ArcosUtils showDialogBox:@"New memo has been created." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
                [self cancelPressed:nil];
            }];
        }
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            [ArcosUtils showDialogBox:[errorArcosGenericClass Field2] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        } else {
            [ArcosUtils showDialogBox:@"The operation could not be completed." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.queryOrderMemoDataManager.rowPointer++;
        if (self.queryOrderMemoDataManager.rowPointer == [self.queryOrderMemoDataManager.changedDataList count]) {
            self.callGenericServices.isNotRecursion = YES;
            [self.callGenericServices.HUD hide:YES];
            [self endOnSaveAction];
        }
        [self submitChangedDataList];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //Code that will run after you press ok button
        [self cancelPressed:nil];
    }
}

-(void)endOnSaveAction {
    [self.refreshDelegate refreshParentContent];
    [self cancelPressed:nil];
}

- (void)updateTaskWhenIssueClosedChanged {
    self.queryOrderMemoDataManager.tmpTaskChangedActualContent = @"01/01/1990";
    if (self.queryOrderMemoDataManager.issueClosedActualValue) {
        self.queryOrderMemoDataManager.tmpTaskChangedActualContent = [ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy HH:mm"];
    }
    [self.callGenericServices genericUpdateRecord:@"Task" iur:[self.taskIUR intValue] fieldName:self.queryOrderMemoDataManager.tmpTaskChangedFieldName newContent:self.queryOrderMemoDataManager.tmpTaskChangedActualContent action:@selector(setGenericUpdateRecordResult:) target:self];
}

-(void)setGenericUpdateRecordResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    self.callGenericServices.isNotRecursion = YES;
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.editDelegate editFinishedWithData:self.queryOrderMemoDataManager.tmpTaskChangedActualContent fieldName:self.queryOrderMemoDataManager.tmpTaskChangedFieldName forIndexpath:self.taskCurrentIndexPath];
        [self.refreshDelegate refreshParentContentByCreate:self.taskCurrentIndexPath];
        [self.refreshDelegate refreshParentContent];
        [ArcosUtils showDialogBox:@"New memo has been created." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
            [self cancelPressed:nil];
        }];
    } else {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

@end
