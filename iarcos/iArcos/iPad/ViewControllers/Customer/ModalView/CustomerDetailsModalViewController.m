//
//  CustomerDetailsModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 03/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsModalViewController.h"
@interface CustomerDetailsModalViewController ()
- (void)alertViewCallBack;
- (void)retrieveLocationRecordInfo;
@end

@implementation CustomerDetailsModalViewController
@synthesize myDelegate = _myDelegate;
@synthesize delegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize locationIUR;
@synthesize customerDict = _customerDict;
@synthesize detailsListView;
@synthesize cellFactory;
@synthesize changedDataArray = _changedDataArray;
@synthesize changedFieldName = _changedFieldName;
@synthesize changedActualContent = _changedActualContent;
@synthesize actionType = _actionType;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize CCLHVC = _CCLHVC;
@synthesize deleteLinkButton = _deleteLinkButton;
@synthesize customerAccessTimesUtils = _customerAccessTimesUtils;
@synthesize actionDelegate = _actionDelegate;

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
//    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }    
    self.locationIUR = nil;
    self.customerDict = nil;
    self.detailsListView = nil;
    if (callGenericServices != nil) { [callGenericServices release]; }          
//    if (activityIndicator != nil) { [activityIndicator release]; }  
    if (self.cellFactory != nil) { self.cellFactory = nil; }  
    if (cdimvc != nil) { [cdimvc release]; }
    if (self.changedDataArray != nil) { self.changedDataArray = nil; }    
    if (self.changedFieldName != nil) { self.changedFieldName = nil; }   
    if (self.changedActualContent != nil) { self.changedActualContent = nil; }    
    if (customerTypesDataManager != nil) { [customerTypesDataManager release]; }       
    if (arcosCreateRecordObject != nil) { [arcosCreateRecordObject release]; }
    if (connectivityCheck != nil) { [connectivityCheck release]; }    
    if (self.actionType != nil) { self.actionType = nil; }
    if (self.CCLHVC != nil) {
        [self.CCLHVC willMoveToParentViewController:nil];
        [self.CCLHVC removeFromParentViewController];
        self.CCLHVC = nil;
    }
    self.deleteLinkButton = nil;
    self.customerAccessTimesUtils = nil;
    
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
    //get a factory
    NSLog(@"actionType is %@", self.actionType);
    self.customerAccessTimesUtils = [[[CustomerAccessTimesUtils alloc] init] autorelease];
    self.cellFactory = [CustomerTypesTableCellFactory factory];
    customerTypesDataManager = [[CustomerTypesDataManager alloc] init];
    [customerTypesDataManager createCustomerDetailsActionDataManager:self.actionType];
    customerTypesDataManager.orderedFieldTypeList = customerTypesDataManager.customerDetailsActionBaseDataManager.orderedFieldTypeList;
    [self retrieveLocationRecordInfo];
            
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    
    [self.navigationItem setLeftBarButtonItem:closeButton];    
    [closeButton release];
    self.employeeSecurityLevel = [self getEmployeeSecurityLevel];
//    NSLog(@"securityLevel is %d", securityLevel);
//    if ( self.employeeSecurityLevel > 90) {        
//    }
    NSMutableArray* rightButtonList = [NSMutableArray array];
    UIBarButtonItem* updateButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(updatePressed:)];
    [rightButtonList addObject:updateButton];
//    [self.navigationItem setRightBarButtonItem:updateButton];
    [updateButton release];
    if (![self.actionType isEqualToString:@"create"]) {
        self.CCLHVC = [[[CustomerContactLinkHeaderViewController alloc] initWithNibName:@"CustomerContactLinkHeaderViewController" bundle:nil] autorelease];
        [self addChildViewController:self.CCLHVC];
        [self.CCLHVC didMoveToParentViewController:self];
        self.CCLHVC.linkHeaderViewControllerDelegate = self;
        customerTypesDataManager.locationIUR = self.locationIUR;
        self.CCLHVC.linkHeaderRequestSource = CustomerContactLinkHeaderRequestLocation;
        self.deleteLinkButton = [[[UIBarButtonItem alloc] initWithTitle:@"DeleteLink" style:UIBarButtonItemStylePlain target:self action:@selector(deleteLinkPressed:)] autorelease];
        [rightButtonList addObject:self.deleteLinkButton];
    }
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    detailsListView.allowsSelection = NO;
    detailsListView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
 
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
//    [activityIndicator startAnimating];
    
    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    self.changedDataArray = [[[NSMutableArray alloc] init] autorelease];
    rowPointer = 0;
    
    arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
    //set the notification
/**    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    //init a connectivity check
    connectivityCheck = [[ConnectivityCheck alloc]init];
    [connectivityCheck statusLog];
*/    
//    [callGenericServices getRecord:@"Location" iur:[self.locationIUR intValue]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.detailsListView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [callGenericServices getRecord:@"Location" iur:[self.locationIUR intValue]];
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
    if (self.CCLHVC != nil && self.CCLHVC.view != nil) {
        [self.CCLHVC willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (customerTypesDataManager.orderedFieldTypeList != nil && [customerTypesDataManager.displayList count] != 0) {
        return [customerTypesDataManager.constantFieldTypeTranslateDict objectForKey:[customerTypesDataManager.orderedFieldTypeList objectAtIndex:section]];
    } else {
        return @"";
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:section];
//    if([fieldType isEqualToString:customerTypesDataManager.linksAlias] && [customerTypesDataManager.displayList count] != 0) {
//        self.CCLHVC.linkTextValue = [self tableView:tableView titleForHeaderInSection:section].uppercaseString;
//        return self.CCLHVC.view;
//    }
//    return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if(![self.actionType isEqualToString:@"create"] && [fieldType isEqualToString:@"IUR"] && [customerTypesDataManager.displayList count] != 0) {
        return self.CCLHVC.view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if(![self.actionType isEqualToString:@"create"] && [fieldType isEqualToString:@"IUR"] && [customerTypesDataManager.displayList count] != 0) {
        return 25.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    if (customerTypesDataManager.seqFieldTypeList != nil) {
//        return [customerTypesDataManager.seqFieldTypeList count];
//    } else {
//        return 1;
//    }
    return [customerTypesDataManager.orderedFieldTypeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([customerTypesDataManager.displayList count] == 0) {
        return 0;
    }
    
    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if([fieldType isEqualToString:customerTypesDataManager.linksAlias]) {
        return [customerTypesDataManager.linksLocationList count];
    } else if ([fieldType isEqualToString:customerTypesDataManager.accessTimesSectionTitle]) {
        return 1;
    } else {
        NSMutableArray* tmpDataArray = [customerTypesDataManager.groupedDataDict objectForKey:fieldType];
        return [tmpDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:indexPath.section];
    if([fieldType isEqualToString:customerTypesDataManager.linksAlias]) {
        NSString *CellIdentifier = @"IdCustomerContactLinksTableCell";
        CustomerContactLinksTableCell* cell = (CustomerContactLinksTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactLinksTableCell" owner:self options:nil];
            
            for (id nibItem in nibContents) {
                if ([nibItem isKindOfClass:[CustomerContactLinksTableCell class]] && [[(CustomerContactLinksTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                    cell= (CustomerContactLinksTableCell *) nibItem;
                }
            }
        }
        // Configure the cell...
        NSDictionary* cellData = [customerTypesDataManager.linksLocationList objectAtIndex:indexPath.row];
        NSMutableDictionary* newCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
        cell.linkText.text = [NSString stringWithFormat:@"%@ %@",[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[newCellData objectForKey:@"Name"]]], [ArcosUtils trim:[[ArcosCoreData sharedArcosCoreData] fullAddressWith:newCellData]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([fieldType isEqualToString:customerTypesDataManager.accessTimesSectionTitle]) {
        NSString* CellIdentifier = @"IdCustomerDetailsContactAccessTimesTableViewCell";
        CustomerDetailsContactAccessTimesTableViewCell* cell = (CustomerDetailsContactAccessTimesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerDetailsContactAccessTimesTableViewCell" owner:self options:nil];
            
            for (id nibItem in nibContents) {
                if ([nibItem isKindOfClass:[CustomerDetailsContactAccessTimesTableViewCell class]] && [[(CustomerDetailsContactAccessTimesTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                    cell = (CustomerDetailsContactAccessTimesTableViewCell *) nibItem;
                }
            }
        }
        // Configure the cell...
        cell.actionDelegate = self;
        cell.infoTitle.text = customerTypesDataManager.accessTimesSectionTitle;
        cell.infoValue.text = [self.customerAccessTimesUtils retrieveAccessTimesInfoValue:[self.customerDict objectForKey:customerTypesDataManager.accessTimesSectionTitle]];
        //[self.customerInfoTableDataManager retrieveAccessTimesInfoValue:self.aCustDict];
        [cell configCellWithData:self.customerDict code:@"Location"];
        return cell;
    }
    NSMutableDictionary* cellData = [customerTypesDataManager cellDataWithIndexPath:indexPath];    
    CustomerBaseTableCell* cell = (CustomerBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {        
        cell = (CustomerBaseTableCell*)[self.cellFactory createCustomerBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.employeeSecurityLevel = self.employeeSecurityLevel;
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:indexPath.section];
    if([fieldType isEqualToString:customerTypesDataManager.linksAlias]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableDictionary* cellData = [customerTypesDataManager.linksLocationList objectAtIndex:indexPath.row];
        customerTypesDataManager.currentLinkIndexPathRow = indexPath.row;
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to remove link to %@", [cellData objectForKey:@"Name"]] delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Remove" otherButtonTitles:@"Cancel", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0:{//ok button remove current link
            
            NSMutableDictionary* linkLocDict = [customerTypesDataManager.linksLocationList objectAtIndex:customerTypesDataManager.currentLinkIndexPathRow];
            callGenericServices.isNotRecursion = YES;
            [callGenericServices genericDeleteRecord:@"LocLocLink" iur:[[linkLocDict objectForKey:@"LocLocLinkIUR"] intValue] action:@selector(setDeleteRecordDataResult:) target:self];
        }
            break;
        default:
            break;
    }
}

#pragma mark setDeleteRecordDataResult
-(void)setDeleteRecordDataResult:(ArcosErrorModel*)result {
    result = [callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.Code >= 0) {
        NSMutableDictionary* linkLocDict = [customerTypesDataManager.linksLocationList objectAtIndex:customerTypesDataManager.currentLinkIndexPathRow];
        [customerTypesDataManager deleteLocLocLinkWithIUR:[linkLocDict objectForKey:@"LocLocLinkIUR"]];
        [customerTypesDataManager getLinkData];
        [self.tableView reloadData];
        [self.refreshDelegate refreshParentContentByEdit];
    } else {
        [ArcosUtils showMsg:-1 message:result.Message delegate:nil];
    }
}

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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{        
    NSMutableDictionary* cellData = [customerTypesDataManager cellDataWithIndexPath:indexPath];
    if ([[cellData objectForKey:@"fieldDesc"] isEqualToString:@"Master Location"]) {
        return;
    }
    NSString* originalIndex = [cellData objectForKey:@"originalIndex"];                               
    
    NSString* fieldName = [customerTypesDataManager.fieldNameList objectAtIndex:[originalIndex intValue] - 1];
    NSString* descrTypeCode = [fieldName substringToIndex:2];        
    
    //special case for location profile
    if ([descrTypeCode isEqualToString:@"LP"]) {
        descrTypeCode = [NSString stringWithFormat:@"%d", [[fieldName substringFromIndex:2] intValue] + 20];
    }
         
    cdimvc = [[CustomerDetailsIURModalViewController alloc] initWithNibName:@"CustomerDetailsIURModalViewController" bundle:nil];
    cdimvc.title = [cellData objectForKey:@"fieldDesc"];
    currentRowIndex = indexPath.row;       
    cdimvc.parentContentString = [cellData objectForKey:@"contentString"];
    cdimvc.parentActualContent = [cellData objectForKey:@"actualContent"];
    cdimvc.descrTypeCode = descrTypeCode;
    cdimvc.accessoryIndexPath = indexPath;
    cdimvc.delegate = self;
    [self.navigationController pushViewController:cdimvc animated:YES];        
    
}

-(void)closePressed:(id)sender {
//    [self.delegate didDismissModalView];
    [self.myDelegate didDismissCustomisePresentView];
}

-(void)updatePressed:(id)sender {
    [self.view endEditing:YES];
    ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
    if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
        [ArcosUtils showDialogBox:@"Save function not available in Demo Edition" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    self.changedDataArray = [customerTypesDataManager getChangedDataList];
    if ([self.changedDataArray count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (![self checkBeforeSubmit] ) return;
    if ([self.actionType isEqualToString:@"create"]) {//create a new location
        NSLog(@"create a new location.");        
        [customerTypesDataManager prepareToCreateNewLocation:self.changedDataArray];
        arcosCreateRecordObject.FieldNames = customerTypesDataManager.createdFieldNameList;
        arcosCreateRecordObject.FieldValues = customerTypesDataManager.createdFieldValueList;
        [arcosCreateRecordObject.FieldNames addObject:@"EmployeeIUR"];
        [arcosCreateRecordObject.FieldValues addObject:[[SettingManager employeeIUR] stringValue]];
        [callGenericServices createRecord:@"Location" fields:arcosCreateRecordObject];
    } else {// update an existed record
        callGenericServices.isNotRecursion = NO;
        [self submitChangedDataList: self.changedDataArray];    
    }    
}

-(void)submitChangedDataList:(NSMutableArray*)aChangedDataList{    
    if (rowPointer == [aChangedDataList count]) return;
    NSMutableDictionary* dataCell = [aChangedDataList objectAtIndex:rowPointer];
    self.changedFieldName = [customerTypesDataManager fieldNameWithIndex:[[dataCell objectForKey:@"originalIndex"] intValue] - 1];
    self.changedActualContent = [dataCell objectForKey:@"actualContent"];
//    [activityIndicator startAnimating];
    [callGenericServices updateRecord:@"Location" iur:[self.locationIUR intValue] fieldName:self.changedFieldName newContent:self.changedActualContent];
}  

#pragma mark CustomerDetailsIURDelegate
- (void)detailsIURFinishEditing:(id)aContentString actualContent:(id)anActualContent WithIndexPath:(NSIndexPath *)indexPath {
    [customerTypesDataManager updateChangedData:aContentString actualContent:anActualContent withIndexPath:indexPath];    
    CustomerIURTableCell* currentCell = (CustomerIURTableCell*)[self.detailsListView cellForRowAtIndexPath:indexPath];
    currentCell.contentString.text = aContentString;

}

-(void)updateValue:(id)contentString actualContent:(id)actualContent withIndexPath:(NSIndexPath*)indexPath {
    [customerTypesDataManager updateChangedData:contentString actualContent:actualContent withIndexPath:indexPath];
}

#pragma mark CustomerTypeTableCellDelegate

-(void)inputFinishedWithData:(id)contentString actualData:(id)actualData forIndexpath:(NSIndexPath *)theIndexpath {
    [self updateValue:contentString actualContent:actualData withIndexPath:theIndexpath];
}
 
#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer details");
    if (result == nil) {
        return;
    }    
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {     
        [customerTypesDataManager processRawData:result withNumOfFields:47];
//        NSLog(@"customerTypesDataManager.groupedDataDict %@", customerTypesDataManager.groupedDataDict);
        [self.detailsListView reloadData];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];        
    }  
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer details");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        [callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [[ArcosCoreData sharedArcosCoreData] updateLocationWithFieldName:self.changedFieldName withActualContent:self.changedActualContent withLocationIUR:self.locationIUR];
        rowPointer++;        
        if (rowPointer == [self.changedDataArray count]) {
            callGenericServices.isNotRecursion = YES;
            [callGenericServices.HUD hide:YES];
//            [ArcosUtils showMsg:@"The location has been edited." delegate:self];  
            [self endOnSaveAction];
        }
        [self submitChangedDataList:self.changedDataArray];
    } else if(result.ErrorModel.Code <= 0) {
        [callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
//    [activityIndicator stopAnimating];
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        //        [activityIndicator stopAnimating];
        return;
    }
    NSLog(@"%@ and %@", result.Field1, result);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        [[ArcosCoreData sharedArcosCoreData] locationWithFieldNameList:customerTypesDataManager.createdFieldNameList fieldValueList:customerTypesDataManager.createdFieldValueList iur:[ArcosUtils convertStringToNumber:result.Field1]];
        [ArcosUtils showDialogBox:@"New location has been created." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
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
    
    //    [activityIndicator stopAnimating];
}

#pragma mark - check employee SecurityLevel
-(int)getEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    return [securityLevel intValue];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){  
        //Code that will run after you press ok button 
        [self alertViewCallBack];
    }
}

//connectivity notification back
/**
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSLog(@"enter into the check connection.");
        [check stop];        
        [[NSNotificationCenter defaultCenter]removeObserver:self];        
        [callGenericServices getRecord:@"Location" iur:[self.locationIUR intValue]];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}
*/

-(void)endOnSaveAction {
    if ([self.actionType isEqualToString:@"create"]) {
        [self.refreshDelegate refreshParentContent];
    } else {
        [self.refreshDelegate refreshParentContentByEdit];
    }
    [self closePressed:nil];
}
#pragma mark CustomerContactLinkHeaderViewControllerDelegate
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    BOOL existFlag = [customerTypesDataManager isLocationExistent:aCustDict];
    if (existFlag) {
        [ArcosUtils showMsg:[NSString stringWithFormat:@"The link to %@ already exists.", [aCustDict objectForKey:@"Name"]] delegate:nil];
        return;
    }
    customerTypesDataManager.fromLocationIUR = [aCustDict objectForKey:@"LocationIUR"];
    ArcosCreateRecordObject* ACRO = [[[ArcosCreateRecordObject alloc] init] autorelease];
    NSMutableArray* fieldNameList = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* fieldValueList = [NSMutableArray arrayWithCapacity:2];
    [fieldNameList addObject:@"LocationIUR"];
    [fieldValueList addObject:[self.locationIUR stringValue]];
    [fieldNameList addObject:@"FromLocationIUR"];
    [fieldValueList addObject:[customerTypesDataManager.fromLocationIUR stringValue]];
    [fieldValueList addObject:@"9"];
    [fieldNameList addObject:@"LinkType"];
    ACRO.FieldNames = fieldNameList;
    ACRO.FieldValues = fieldValueList;
    callGenericServices.isNotRecursion = YES;
    [callGenericServices genericCreateRecord:@"LocLocLink" fields:ACRO action:@selector(setCreateLocLocLinkRecordResult:) target:self];
}

-(void)setCreateLocLocLinkRecordResult:(ArcosGenericClass*) result {
    result = [callGenericServices handleResultErrorProcess:result];
    [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
    if (result == nil) {
        return;
    }
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        [customerTypesDataManager addLocLocLinkWithIUR:[ArcosUtils convertStringToNumber:result.Field1] locationIUR:self.locationIUR fromLocationIUR:customerTypesDataManager.fromLocationIUR];
        [customerTypesDataManager getLinkData];
        [self.tableView reloadData];
        [self.refreshDelegate refreshParentContentByEdit];
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            [ArcosUtils showMsg:-1 message:[errorArcosGenericClass Field2] delegate:nil];
        } else {
            [ArcosUtils showMsg:-1 message:@"The operation could not be completed." delegate:nil];
        }
    }
}

- (void)deleteLinkPressed:(id)sender {
    [self scrollToLinkSection];
    if (customerTypesDataManager.isTableViewEditable) {
        [self.tableView setEditing:NO animated:YES];
        [self.deleteLinkButton setTitle:@"DeleteLink"];
        [self.deleteLinkButton setStyle:UIBarButtonItemStylePlain];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.deleteLinkButton setTitle:@"Done"];
        [self.deleteLinkButton setStyle:UIBarButtonItemStyleDone];
    }
    [self.tableView reloadData];
    customerTypesDataManager.isTableViewEditable = !customerTypesDataManager.isTableViewEditable;
}

- (void)scrollToLinkSection {
    int linkSectionIndex = -1;
    NSUInteger sectionLength = [customerTypesDataManager.orderedFieldTypeList count];
    for (int i = 0; i < sectionLength; i++) {
        NSString* fieldType = [customerTypesDataManager.orderedFieldTypeList objectAtIndex:i];
        if ([fieldType isEqualToString:customerTypesDataManager.linksAlias]) {
            linkSectionIndex = i;
            break;
        }
    }
    if (linkSectionIndex != -1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:linkSectionIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

-(BOOL)checkBeforeSubmit {
    NSMutableArray* stringTypeList = [customerTypesDataManager.groupedDataDict objectForKey:@"System.String"];
    for (int i = 0; i < [stringTypeList count]; i++) {
        NSMutableDictionary* cellData = [stringTypeList objectAtIndex:i];
        if ([[customerTypesDataManager fieldNameWithIndex:[[cellData objectForKey:@"originalIndex"] intValue] - 1] isEqualToString:@"Name"]) {
            NSString* contentString = [ArcosUtils trim:[cellData objectForKey:@"contentString"]];
            NSLog(@"contentString is %@", contentString);
            if (contentString == nil || [contentString isEqualToString:@""]) {
                [ArcosUtils showDialogBox:@"Please enter a location name." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return NO;
            }
        }
    }
    return YES;
}

- (void)alertViewCallBack {
    if ([self.actionType isEqualToString:@"create"]) {
        [self.refreshDelegate refreshParentContent];
    } else {
        [self.refreshDelegate refreshParentContentByEdit];
    }
    [self closePressed:nil];
}

- (void)retrieveLocationRecordInfo {
    NSMutableArray* auxLocationDictList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:self.locationIUR];
    if ([auxLocationDictList count] > 0) {
        self.customerDict = [NSMutableDictionary dictionaryWithDictionary:[auxLocationDictList objectAtIndex:0]];
        [self.customerDict setObject:[ArcosUtils convertNilToEmpty:[self.customerDict objectForKey:@"accessTimes"]] forKey:customerTypesDataManager.accessTimesSectionTitle];
    }
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self retrieveLocationRecordInfo];
    [self.tableView reloadData];
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

@end
