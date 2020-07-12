//
//  CustomerContactModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactModalViewController.h"
@interface CustomerContactModalViewController ()
- (void)alertActionCallBack;
- (void)handleErrorMessage:(NSString*)aMessage;
- (void)retrieveContactRecordInfo;
@end

@implementation CustomerContactModalViewController
@synthesize myDelegate = _myDelegate;
@synthesize delegate = _delegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize locationIUR = _locationIUR;
@synthesize titleTypeIUR = _titleTypeIUR;
@synthesize globalPopoverController = _globalPopoverController;
@synthesize contactTypeIUR = _contactTypeIUR;
@synthesize fieldValueList = _fieldValueList;
@synthesize fieldNameList = _fieldNameList;
@synthesize recordTableView;
@synthesize tableCellData = _tableCellData;
@synthesize submitButton;
@synthesize actionType = _actionType;
@synthesize contactGenericClass = _contactGenericClass;
@synthesize customerContactTypesDataManager = _customerContactTypesDataManager;
@synthesize cellFactory = _cellFactory;
@synthesize contactGenericReturnObject = _contactGenericReturnObject;
@synthesize contactIUR = _contactIUR;
@synthesize changedDataArray = _changedDataArray;
@synthesize changedFieldName = _changedFieldName;
@synthesize changedActualContent = _changedActualContent;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize brandNewContactIUR = _brandNewContactIUR;
@synthesize deleteLinkButton = _deleteLinkButton;
@synthesize CCLHVC = _CCLHVC;
@synthesize customerAccessTimesUtils = _customerAccessTimesUtils;
@synthesize contactDict = _contactDict;
@synthesize actionDelegate = _actionDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.locationIUR != nil) { self.locationIUR = nil; }     
    
    if (self.titleTypeIUR != nil) { self.titleTypeIUR = nil; }     
    if (self.globalPopoverController != nil) { self.globalPopoverController = nil; }
    
    if (self.contactTypeIUR != nil) { self.contactTypeIUR = nil; } 
    if (callGenericServices != nil) { [callGenericServices release]; } 
    if (self.fieldValueList != nil) { self.fieldValueList = nil; }    
    if (self.fieldNameList != nil) { self.fieldNameList = nil; }
        
    if (arcosCreateRecordObject != nil) { [arcosCreateRecordObject release]; }
    
//    if (self.tableCellList != nil) { self.tableCellList = nil; } 
    if (self.tableCellData != nil) { self.tableCellData = nil; }
    if (self.submitButton != nil) { self.submitButton = nil; }     
//    if (self.delegate != nil) { self.delegate = nil; }     
//    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }         
    
    if (self.actionType != nil) { self.actionType = nil; }
    if (self.contactGenericClass != nil) { self.contactGenericClass = nil; }
    if (self.customerContactTypesDataManager != nil) { self.customerContactTypesDataManager = nil; }
    if (self.cellFactory != nil) { self.cellFactory = nil; }
    if (self.contactGenericReturnObject != nil) { self.contactGenericReturnObject = nil; }
    if (self.contactIUR != nil) { self.contactIUR = nil; }
    if (self.changedDataArray != nil) { self.changedDataArray = nil; }    
    if (self.changedFieldName != nil) { self.changedFieldName = nil; }   
    if (self.changedActualContent != nil) { self.changedActualContent = nil; }
    if (self.brandNewContactIUR != nil) { self.brandNewContactIUR = nil; }
    if (self.deleteLinkButton != nil) { self.deleteLinkButton = nil; }
    if (self.CCLHVC != nil) {
        [self.CCLHVC willMoveToParentViewController:nil];
        [self.CCLHVC removeFromParentViewController];
        self.CCLHVC = nil;
    }
    self.customerAccessTimesUtils = nil;
    self.contactDict = nil;
    
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
    self.customerAccessTimesUtils = [[[CustomerAccessTimesUtils alloc] init] autorelease];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    rowPointer = 0;    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
    
    NSMutableArray* rightButtonList = [NSMutableArray array];
    self.submitButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(submitPressed:)] autorelease];
    [rightButtonList addObject:self.submitButton];
    if ([self.actionType isEqualToString:@"edit"]) {
        self.deleteLinkButton = [[[UIBarButtonItem alloc] initWithTitle:@"DeleteLink" style:UIBarButtonItemStylePlain target:self action:@selector(deleteLinkPressed:)] autorelease];
        [rightButtonList addObject:self.deleteLinkButton];
        self.CCLHVC = [[[CustomerContactLinkHeaderViewController alloc] initWithNibName:@"CustomerContactLinkHeaderViewController" bundle:nil] autorelease];
        [self addChildViewController:self.CCLHVC];
        [self.CCLHVC didMoveToParentViewController:self];
        self.CCLHVC.linkHeaderViewControllerDelegate = self;
    }    
    [self.navigationItem setRightBarButtonItems:rightButtonList];    
                
    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    self.fieldValueList = [NSMutableArray array];
    self.fieldNameList = [NSMutableArray array];
    
    arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
    
//    customerContactDataManager = [[CustomerContactDataManager alloc] init];
    NSLog(@"actionType %@", self.actionType);
      
    self.customerContactTypesDataManager = [[[CustomerContactTypesDataManager alloc] init] autorelease];
    self.customerContactTypesDataManager.actionType = self.actionType;
    self.customerContactTypesDataManager.iur = self.contactIUR;
    self.cellFactory = [CustomerContactTypesTableCellFactory factory];
    [self.customerContactTypesDataManager createCustomerContactActionDataManager:self.actionType];
    self.customerContactTypesDataManager.orderedFieldTypeList = self.customerContactTypesDataManager.customerContactActionBaseDataManager.orderedFieldTypeList;
    [self retrieveContactRecordInfo];
//    NSLog(@"orderedFieldTypeList: %@",self.customerContactTypesDataManager.orderedFieldTypeList);
//    callGenericServices.isNotRecursion = NO;
//    [callGenericServices getRecord:@"Contact" iur:[[self.tableCellData objectForKey:@"IUR"] intValue]];
    self.employeeSecurityLevel = [self getEmployeeSecurityLevel];
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
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    callGenericServices.isNotRecursion = NO;
    [callGenericServices getRecord:@"Contact" iur:[[self.tableCellData objectForKey:@"IUR"] intValue]];
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
    NSLog(@"contact animate");
    if (self.CCLHVC != nil && self.CCLHVC.view != nil) {
        [self.CCLHVC willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

#pragma mark - Table view data source

-(void)closePressed:(id)sender {
//    NSLog(@"closePressed is pressed");
//    [self.delegate didDismissModalView];
    [self.myDelegate didDismissCustomisePresentView];
}

-(void)submitPressed:(id)sender {
    [self.view endEditing:YES];
    ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    NSNumber* appStatusNumber = [activateAppStatusManager getAppStatus];
    if ([appStatusNumber isEqualToNumber:activateAppStatusManager.demoAppStatusNum]) {
        [ArcosUtils showDialogBox:@"Save function not available in Demo Edition" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (![self.customerContactTypesDataManager checkAllowedStringField:@"Surname" cellDictList:[self.customerContactTypesDataManager.groupedDataDict objectForKey:@"System.String"]] && ![self.customerContactTypesDataManager checkAllowedStringField:@"Forename" cellDictList:[self.customerContactTypesDataManager.groupedDataDict objectForKey:@"System.String"]]) {
        [ArcosUtils showDialogBox:@"Please enter a Forename or Surname." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (![self.customerContactTypesDataManager checkAllowedStringField:@"Initial" cellDictList:[self.customerContactTypesDataManager.groupedDataDict objectForKey:@"System.String"] maxDigitNum:2]) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Please enter no more than 2 characters for Initial."] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
        
    [self.customerContactTypesDataManager getFlagChangedDataList];
    self.changedDataArray = [self.customerContactTypesDataManager getChangedDataList];
//    NSLog(@"changedDataList %@ %@", self.customerContactTypesDataManager.changedDataList, self.customerContactTypesDataManager.flagChangedDataList);
    if ([self.actionType isEqualToString:@"edit"]) {        
        if ([self.customerContactTypesDataManager.changedDataList count] == 0 && [self.customerContactTypesDataManager.flagChangedDataList count] == 0) {
            [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
    }
//    self.submitButton.enabled = NO;
    [self submitProcessCenter];
}

-(void)submitProcessCenter {
    callGenericServices.isNotRecursion = NO;
    self.customerContactTypesDataManager.employeeIUR = [SettingManager employeeIUR];
    if (![self.actionType isEqualToString:@"edit"]) {
        [self.customerContactTypesDataManager prepareToCreateNewContact:self.changedDataArray];                
        arcosCreateRecordObject.FieldNames = self.customerContactTypesDataManager.createdFieldNameList;
        arcosCreateRecordObject.FieldValues = self.customerContactTypesDataManager.createdFieldValueList;
        [arcosCreateRecordObject.FieldNames addObject:@"LocationIUR"];
        [arcosCreateRecordObject.FieldValues addObject:[self.locationIUR stringValue]];
        [arcosCreateRecordObject.FieldNames addObject:@"EmployeeIUR"];
        [arcosCreateRecordObject.FieldValues addObject:[self.customerContactTypesDataManager.employeeIUR stringValue]];
        [callGenericServices createRecord:@"Contact" fields:arcosCreateRecordObject];
    } else {//edit action
        if ([self.customerContactTypesDataManager.changedDataList count] == 0) {
            [callGenericServices createMultipleRecords:@"Flag" records:self.customerContactTypesDataManager.flagChangedDataList]; 
        } else {
            [self submitChangedDataList: self.changedDataArray];
        }        
    }
}

#pragma mark popover delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        //        [activityIndicator stopAnimating];
        [callGenericServices.HUD hide:YES];
        return;
    }
    NSLog(@"%@, %@", result.Field1, result.Field2);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
//        [[ArcosCoreData sharedArcosCoreData] contactWithDataList:self.fieldValueList contactIUR:[ArcosUtils convertStringToNumber:result.Field1] titleTypeIUR:self.titleTypeIUR contactTypeIUR:self.contactTypeIUR locationIUR:self.locationIUR];
        self.brandNewContactIUR = [ArcosUtils convertStringToNumber:result.Field1];
        [[ArcosCoreData sharedArcosCoreData] contactWithFieldNameList:self.customerContactTypesDataManager.createdFieldNameList fieldValueList:self.customerContactTypesDataManager.createdFieldValueList iur:[ArcosUtils convertStringToNumber:result.Field1]];
        [[ArcosCoreData sharedArcosCoreData] conLocLinkWithIUR:[ArcosUtils convertStringToNumber:result.Field2] contactIUR:[ArcosUtils convertStringToNumber:result.Field1] locationIUR:self.locationIUR];    
        if ([self.customerContactTypesDataManager.flagChangedDataList count] > 0) {
            self.customerContactTypesDataManager.iur = [ArcosUtils convertStringToNumber:result.Field1];
            [self.customerContactTypesDataManager getFlagChangedDataList];
            [callGenericServices createMultipleRecords:@"Flag" records:self.customerContactTypesDataManager.flagChangedDataList]; 
        } else {     
            callGenericServices.isNotRecursion = YES;
            [callGenericServices.HUD hide:YES];
            NSString* message = @"New contact has been created.";
            [ArcosUtils showDialogBox:message title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
                [self alertActionCallBack];
            }];
        }
    } else {
        [callGenericServices.HUD hide:YES];
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

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if(buttonIndex == 0){
//        //Code that will run after you press ok button
//        [self alertActionCallBack];
//    }
    if (alertView.tag == 999) {
        [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
    } else if (alertView.tag == 99999) {
        [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
        [self alertActionCallBack];
    } else if (buttonIndex == 0) {
        [self alertActionCallBack];
    }
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if([self.actionType isEqualToString:@"edit"] && [fieldType isEqualToString:self.customerContactTypesDataManager.flagsAlias] && [self.customerContactTypesDataManager.displayList count] != 0) {
        return 25.0f;
    }
    return 0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.customerContactTypesDataManager.orderedFieldTypeList != nil) {
        return [self.customerContactTypesDataManager.orderedFieldTypeList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.customerContactTypesDataManager.displayList count] == 0) {
        return 0;
    }
    
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if ([fieldType isEqualToString:self.customerContactTypesDataManager.accessTimesSectionTitle]) {
        return 1;
    } else if ([fieldType isEqualToString:self.customerContactTypesDataManager.flagsAlias]) {
        return [self.customerContactTypesDataManager.flagDisplayList count];
    } else if([fieldType isEqualToString:self.customerContactTypesDataManager.linksAlias]) {
        return [self.customerContactTypesDataManager.linksLocationList count];
    } else {
        NSMutableArray* tmpDataArray = [self.customerContactTypesDataManager.groupedDataDict objectForKey:fieldType];
        return [tmpDataArray count];
    }    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.customerContactTypesDataManager.orderedFieldTypeList != nil && [self.customerContactTypesDataManager.displayList count] != 0) {
        return [self.customerContactTypesDataManager.constantFieldTypeTranslateDict objectForKey:[self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:section]];
    }
    return @"";
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
//    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:section];
//    if([fieldType isEqualToString:self.customerContactTypesDataManager.linksAlias] && [self.customerContactTypesDataManager.displayList count] != 0) {
//        self.CCLHVC.linkTextValue = [self tableView:tableView titleForHeaderInSection:section].uppercaseString;
//        return self.CCLHVC.view;
//    }    
//    return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:section];
    if([self.actionType isEqualToString:@"edit"] && [fieldType isEqualToString:self.customerContactTypesDataManager.flagsAlias] && [self.customerContactTypesDataManager.displayList count] != 0) {
        return self.CCLHVC.view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:indexPath.section];
    if ([fieldType isEqualToString:self.customerContactTypesDataManager.accessTimesSectionTitle]) {
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
        cell.infoTitle.text = self.customerContactTypesDataManager.accessTimesSectionTitle;
        cell.infoValue.text = [self.customerAccessTimesUtils retrieveAccessTimesInfoValue:[self.contactDict objectForKey:self.customerContactTypesDataManager.accessTimesSectionTitle]];
        [cell configCellWithData:self.contactDict code:@"Contact"];
        return cell;
    }
    if ([fieldType isEqualToString:self.customerContactTypesDataManager.flagsAlias]) {
        NSString *CellIdentifier = @"IdCustomerFlagTableCell";
        CustomerFlagTableCell* cell = (CustomerFlagTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerFlagTableCell" owner:self options:nil];
            
            for (id nibItem in nibContents) {
                if ([nibItem isKindOfClass:[CustomerFlagTableCell class]] && [[(CustomerFlagTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                    cell= (CustomerFlagTableCell *) nibItem;
                }
            }
        }        
        
        // Configure the cell...
        NSMutableDictionary* cellData = [self.customerContactTypesDataManager.flagDisplayList objectAtIndex:indexPath.row];
        [cell configCellWithData:cellData];
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[cellData objectForKey:@"ContactFlag"] intValue] == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([[cellData objectForKey:@"Active"] intValue] == 0) {
            cell.flagText.textColor = [UIColor redColor];
        } else {
            cell.flagText.textColor = [UIColor blackColor];
        }
        return cell;
    } else if([fieldType isEqualToString:self.customerContactTypesDataManager.linksAlias]) {
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
        NSDictionary* cellData = [self.customerContactTypesDataManager.linksLocationList objectAtIndex:indexPath.row];
        NSMutableDictionary* newCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
//        cell.linkText.text = [cellData objectForKey:@"Name"];
        cell.linkText.text = [NSString stringWithFormat:@"%@ %@",[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[newCellData objectForKey:@"Name"]]], [ArcosUtils trim:[[ArcosCoreData sharedArcosCoreData] fullAddressWith:newCellData]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSMutableDictionary* cellData = [self.customerContactTypesDataManager cellDataWithIndexPath:indexPath];    
        CustomerBaseTableCell* cell = (CustomerBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
        if (cell == nil) {        
            cell = (CustomerBaseTableCell*)[self.cellFactory createCustomerContactBaseTableCellWithData:cellData];
            cell.delegate = self;
        }
        // Configure the cell...
        cell.employeeSecurityLevel = self.employeeSecurityLevel;
        cell.indexPath = indexPath;
        [cell configCellWithData:cellData];              
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }    
}


 // Override to support conditional editing of the table view.
/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.     
     return NO;
 }
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:indexPath.section];
    if([fieldType isEqualToString:self.customerContactTypesDataManager.linksAlias]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;    
}
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {     
     if (editingStyle == UITableViewCellEditingStyleDelete) {         
         NSMutableDictionary* cellData = [self.customerContactTypesDataManager.linksLocationList objectAtIndex:indexPath.row];
         self.customerContactTypesDataManager.currentLinkIndexPathRow = indexPath.row;
         UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to remove link to %@", [cellData objectForKey:@"Name"]] delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Remove" otherButtonTitles:@"Cancel", nil];
         [actionSheet showInView:self.view];
//         [actionSheet showFromRect:[ArcosUtils fromRect4ActionSheet:[self.tableView cellForRowAtIndexPath:indexPath]] inView:self.view animated:YES];
         [actionSheet release];
     }     
 }


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.    
    NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:indexPath.section];
    if (![fieldType isEqualToString:self.customerContactTypesDataManager.flagsAlias]) return;
    NSNumber* contactFlag = [NSNumber numberWithInt:0];    
    NSMutableDictionary* cellData = [self.customerContactTypesDataManager.flagDisplayList objectAtIndex:indexPath.row];
    if ([[cellData objectForKey:@"ContactFlag"] intValue] == 0) {
        contactFlag = [NSNumber numberWithInt:1];
    }
    [self.customerContactTypesDataManager updateChangedData:contactFlag indexPath:indexPath];    
    [self.tableView reloadData];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0:{//ok button remove current link
            if ([self.customerContactTypesDataManager.linksLocationList count] == 1) {
                [ArcosUtils showDialogBox:@"You can not remove the link as the contact needs at least one link." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return;
            }
            NSMutableDictionary* linkLocDict = [self.customerContactTypesDataManager.linksLocationList objectAtIndex:self.customerContactTypesDataManager.currentLinkIndexPathRow];
            callGenericServices.isNotRecursion = YES;
            [callGenericServices genericDeleteRecord:@"ConLocLink" iur:[[linkLocDict objectForKey:@"LocLinkIUR"] intValue] action:@selector(setDeleteRecordDataResult:) target:self];
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
        NSMutableDictionary* linkLocDict = [self.customerContactTypesDataManager.linksLocationList objectAtIndex:self.customerContactTypesDataManager.currentLinkIndexPathRow];
        [[ArcosCoreData sharedArcosCoreData] deleteConLocLinkWithIUR:[linkLocDict objectForKey:@"LocLinkIUR"]];
        [self.customerContactTypesDataManager getLinkData];
        [self.tableView reloadData];
    } else {
        [ArcosUtils showDialogBox:result.Message title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {   
        [[ArcosCoreData sharedArcosCoreData] updateContactWithFieldName:self.changedFieldName withActualContent:self.changedActualContent withContactIUR:self.contactIUR];
        rowPointer++;
        if (rowPointer == [self.changedDataArray count]) {
            if ([self.customerContactTypesDataManager.flagChangedDataList count] > 0) {
               [callGenericServices createMultipleRecords:@"Flag" records:self.customerContactTypesDataManager.flagChangedDataList]; 
            } else {     
                callGenericServices.isNotRecursion = YES;
                [callGenericServices.HUD hide:YES];
                [self endOnSaveAction];
            }   
        }
        [self submitChangedDataList:self.changedDataArray];
    } else if(result.ErrorModel.Code <= 0) {
        [callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

-(void)setCreateMultipleRecordsResult:(NSMutableArray*) result {
    callGenericServices.isNotRecursion = YES;
    [callGenericServices.HUD hide:YES];
    if (result == nil) {
        return;
    }    
    if ([self.actionType isEqualToString:@"edit"]) {
        [self endOnSaveAction];
        return;
    }
    NSString* message = @"New contact has been created.";
    [ArcosUtils showDialogBox:message title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
        [self alertActionCallBack];
    }];
}

#pragma mark - setGetRecordDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [callGenericServices.HUD hide:YES];
        return;
    }    
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.contactGenericReturnObject = result;
        self.contactGenericClass = [result.ArrayOfData objectAtIndex:0];
        if (![self.actionType isEqualToString:@"edit"]) {
            [callGenericServices.HUD hide:YES];
            [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:[NSMutableArray arrayWithCapacity:0]];
            [self.tableView reloadData];
            return;
        }
        NSString* flagSqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where ContactIUR = %@", self.contactIUR];
        [callGenericServices genericGetData:flagSqlStatement action:@selector(setFlagGenericGetDataResult:) target:self];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [callGenericServices.HUD hide:YES];
    }   
}

#pragma mark - setFlagGenericGetDataResult
-(void)setFlagGenericGetDataResult:(ArcosGenericReturnObject*)result {
    [callGenericServices.HUD hide:YES];
    result = [callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:result.ArrayOfData];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark CustomerTypeTableCellDelegate

-(void)inputFinishedWithData:(id)contentString actualData:(id)actualData forIndexpath:(NSIndexPath *)theIndexpath {
    [self.customerContactTypesDataManager updateChangedData:contentString actualContent:actualData withIndexPath:theIndexpath];
}

- (void)submitChangedDataList:(NSMutableArray*)aChangedDataList {
    if (rowPointer == [aChangedDataList count]) return;
    NSMutableDictionary* dataCell = [aChangedDataList objectAtIndex:rowPointer];
    self.changedFieldName = [self.customerContactTypesDataManager fieldNameWithIndex:[[dataCell objectForKey:@"originalIndex"] intValue] - 1];
    self.changedActualContent = [dataCell objectForKey:@"actualContent"];
    [callGenericServices updateRecord:[NSString stringWithFormat:@"Contact,%d",[self.customerContactTypesDataManager.employeeIUR intValue]] iur:[self.contactIUR intValue] fieldName:self.changedFieldName newContent:self.changedActualContent];
}

#pragma mark - check employee SecurityLevel
- (int)getEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    return [securityLevel intValue];
}

- (void)endOnSaveAction {
    [self.refreshDelegate refreshParentContent];
    [self closePressed:nil];
}

- (void)deleteLinkPressed:(id)sender {
    [self scrollToLinkSection];
    if (self.customerContactTypesDataManager.isTableViewEditable) {
        [self.tableView setEditing:NO animated:YES];
        [self.deleteLinkButton setTitle:@"DeleteLink"];
        [self.deleteLinkButton setStyle:UIBarButtonItemStylePlain];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.deleteLinkButton setTitle:@"Done"];
        [self.deleteLinkButton setStyle:UIBarButtonItemStyleDone];
    }
    [self.tableView reloadData];    
    self.customerContactTypesDataManager.isTableViewEditable = !self.customerContactTypesDataManager.isTableViewEditable;        
}

#pragma mark CustomerContactLinkHeaderViewControllerDelegate
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    BOOL existFlag = [self.customerContactTypesDataManager isLocationExistent:aCustDict];
    if (existFlag) {
        NSString* message = [NSString stringWithFormat:@"The link to %@ already exists.", [aCustDict objectForKey:@"Name"]];
        [ArcosUtils showDialogBox:message title:@"" delegate:self target:self.CCLHVC.locationPopover.contentViewController tag:999 handler:^(UIAlertAction *action) {
            [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
        }];
        return;
    }
    self.customerContactTypesDataManager.linkLocationIUR = [NSNumber numberWithInt:[[aCustDict objectForKey:@"LocationIUR"] intValue]];    
    ArcosCreateRecordObject* ACRO = [[[ArcosCreateRecordObject alloc] init] autorelease];
    NSMutableArray* fieldNameList = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* fieldValueList = [NSMutableArray arrayWithCapacity:2];
    [fieldNameList addObject:@"ContactIUR"];
    [fieldValueList addObject:[self.contactIUR stringValue]];
    [fieldNameList addObject:@"LocationIUR"];
    [fieldValueList addObject:[self.customerContactTypesDataManager.linkLocationIUR stringValue]];
    ACRO.FieldNames = fieldNameList;
    ACRO.FieldValues = fieldValueList;
    callGenericServices.isNotRecursion = YES;
    [callGenericServices genericCreateRecord:@"ConLocLink" fields:ACRO action:@selector(setCreateConLocLinkRecordResult:) target:self];
}

-(void)setCreateConLocLinkRecordResult:(ArcosGenericClass*) result {
    result = [callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
        return;
    }
//    NSLog(@"setCreateConLocLinkRecordResult: %@", result);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {        
        [[ArcosCoreData sharedArcosCoreData] conLocLinkWithIUR:[ArcosUtils convertStringToNumber:result.Field1] contactIUR:self.contactIUR locationIUR:self.customerContactTypesDataManager.linkLocationIUR];
        [self.customerContactTypesDataManager getLinkData];
        [self.tableView reloadData];
        [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            NSString* message = [errorArcosGenericClass Field2];
            [self handleErrorMessage:message];
        } else {
            [self handleErrorMessage:@"The operation could not be completed."];
        }
    }
}

- (void)scrollToLinkSection {
    int linkSectionIndex = -1;
    NSUInteger sectionLength = [self.customerContactTypesDataManager.orderedFieldTypeList count];
    for (int i = 0; i < sectionLength; i++) {
        NSString* fieldType = [self.customerContactTypesDataManager.orderedFieldTypeList objectAtIndex:i];
        if ([fieldType isEqualToString:self.customerContactTypesDataManager.linksAlias]) {
            linkSectionIndex = i;
            break;
        }
    }
    if (linkSectionIndex != -1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:linkSectionIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];        
    }    
}

- (void)alertActionCallBack {
    if ([self.actionType isEqualToString:@"createFromContactPopover"]) {
        [self.refreshDelegate refreshParentContentWithIUR:self.brandNewContactIUR];
    } else {
        [self.refreshDelegate refreshParentContent];
    }
    [self closePressed:nil];
}

- (void)handleErrorMessage:(NSString*)aMessage {
    [ArcosUtils showDialogBox:aMessage title:@"" delegate:self target:self.CCLHVC.locationPopover.contentViewController tag:99999 handler:^(UIAlertAction *action) {
        [self.CCLHVC.locationPopover dismissPopoverAnimated:YES];
        [self alertActionCallBack];
    }];
}

- (void)retrieveContactRecordInfo {
    NSMutableArray* auxContactDictList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:self.contactIUR];
    if ([auxContactDictList count] > 0) {
        self.contactDict = [NSMutableDictionary dictionaryWithDictionary:[auxContactDictList objectAtIndex:0]];
        [self.contactDict setObject:[ArcosUtils convertNilToEmpty:[self.contactDict objectForKey:@"accessTimes"]] forKey:self.customerContactTypesDataManager.accessTimesSectionTitle];
    }
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self retrieveContactRecordInfo];
    [self.tableView reloadData];
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

@end
