//
//  CustomerContactInfoTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactInfoTableViewController.h"
#import "ArcosConfigDataManager.h"

@implementation CustomerContactInfoTableViewController
@synthesize locationIUR = _locationIUR;
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize aCustDict = _aCustDict;
@synthesize tableHeader;
@synthesize callGenericServices = _callGenericServices;
@synthesize customerContactTypesDataManager = _customerContactTypesDataManager;
@synthesize contactGenericReturnObject = _contactGenericReturnObject;
@synthesize myArcosAdminEmail = _myArcosAdminEmail;
@synthesize emailActionType = _emailActionType;
@synthesize emailContactIUR = _emailContactIUR;
@synthesize customerAccessTimesUtils = _customerAccessTimesUtils;
@synthesize customerContactInfoDataManager = _customerContactInfoDataManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    if (self.locationIUR != nil) { self.locationIUR = nil; }        
    if (self.displayList != nil) { self.displayList = nil; }
    self.originalDisplayList = nil;
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.aCustDict != nil) { self.aCustDict = nil; }
    if (self.tableHeader != nil) { self.tableHeader = nil; }
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.customerContactTypesDataManager = nil;
    self.contactGenericReturnObject = nil;
    self.myArcosAdminEmail = nil;
    self.emailActionType = nil;
    self.emailContactIUR = nil;
    self.customerAccessTimesUtils = nil;
    self.customerContactInfoDataManager = nil;
    
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
    self.displayList = [[ArcosCoreData sharedArcosCoreData] orderContactsWithLocationIUR: self.locationIUR];
    self.originalDisplayList = [NSMutableArray arrayWithArray:self.displayList];
//    NSLog(@"self.displayList: %@", self.displayList);

    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    [addButton release];
    
    [self createActiveOnlyButton];
    self.customerContactInfoDataManager = [[[CustomerContactInfoDataManager alloc] init] autorelease];
}

- (void)activeOnlyButtonPressed:(id)sender {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1"];
    NSArray* tmpArray = [self.originalDisplayList filteredArrayUsingPredicate:predicate];
    self.displayList = [NSMutableArray arrayWithArray:tmpArray];
    [self.tableView reloadData];
    [self createAllButton];
}

- (void)allButtonPressed:(id)sender {
    self.displayList = [NSMutableArray arrayWithArray:self.originalDisplayList];
    [self.tableView reloadData];
    [self createActiveOnlyButton];
}

- (void)createActiveOnlyButton {
    UIBarButtonItem* activeOnlyButton = [[UIBarButtonItem alloc] initWithTitle:@"Active Only" style:UIBarButtonItemStylePlain target:self action:@selector(activeOnlyButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:activeOnlyButton];
    [activeOnlyButton release];
}

- (void)createAllButton {
    UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(allButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:allButton];
    [allButton release];
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
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
        self.callGenericServices.isNotRecursion = NO;
    }
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
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return tableHeader;
    
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
    NSString *CellIdentifier = @"IdCustomerContactInfoTableCell";
    
    CustomerContactInfoTableCell *cell=(CustomerContactInfoTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactInfoTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerContactInfoTableCell class]] && [[(CustomerContactInfoTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerContactInfoTableCell *) nibItem;                                            
            }
        }
	}
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    NSString* forename = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"Forename"]];
    NSString* surname = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"Surname"]];
    cell.fullname.text = [NSString stringWithFormat:@"%@ %@", forename, surname];
    if ([[cellData objectForKey:@"Active"] boolValue]) {
        cell.fullname.textColor = [UIColor darkTextColor];
    } else {
        cell.fullname.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }
    cell.accessTimesDays.text = [self.customerAccessTimesUtils retrieveAccessTimesInfoValue:[cellData objectForKey:@"accessTimes"]];
//    cell.phoneNumber.text = [cellData objectForKey:@"PhoneNumber"];
//    cell.mobileNumber.text = [cellData objectForKey:@"MobileNumber"];
    cell.contactNumber.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:[cellData objectForKey:@"PhoneNumber"]], [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"MobileNumber"]]]];
    if ([[cellData objectForKey:@"COiur"] intValue] != 0) {
        NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrDetailIUR:[cellData objectForKey:@"COiur"]];
        if ([descrDetailList count] > 0) {
            cell.contactType.text = [[descrDetailList objectAtIndex:0] objectForKey:@"Detail"];
        } else {
            cell.contactType.text = @"";
        }
    } else {
        cell.contactType.text = @"";
    }
    
//    NSLog(@"cell data is %@", cellData);
    cell.delegate = self;
    cell.indexPath = indexPath;
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
    if (self.customerContactInfoDataManager.popoverOpenFlag) {
        return;
    }
    self.customerContactInfoDataManager.popoverOpenFlag = YES;
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableEditContactByEmailFlag]) {        
        self.emailActionType = @"edit";
        self.emailContactIUR = [[self.displayList objectAtIndex:indexPath.row] objectForKey:@"IUR"];
        [self.callGenericServices getRecord:@"Contact" iur:[self.emailContactIUR intValue] filter:@""];
        return;
    }
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.tableCellData = [self.displayList objectAtIndex:indexPath.row];
//    NSLog(@"ccwmvc.tableCellData: %@", ccwmvc.tableCellData);
    ccwmvc.actionType = @"edit";
    ccwmvc.myDelegate = self;
    ccwmvc.delegate = self;
    ccwmvc.refreshDelegate = self;
    ccwmvc.actionDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Contact Details for %@", [ccwmvc.tableCellData objectForKey:@"Title"]];
    ccwmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [ccwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    self.displayList = [[ArcosCoreData sharedArcosCoreData] orderContactsWithLocationIUR: self.locationIUR];
    self.originalDisplayList = [NSMutableArray arrayWithArray:self.displayList];
    [self.tableView reloadData];
    [self createActiveOnlyButton];
}

#pragma mark ModelViewDelegate
- (void)didDismissModalView {    
//    [self.rootView dismissModalViewControllerAnimated:YES];
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}
#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self didDismissViewControllerProcessor];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self didDismissViewControllerProcessor];
}

- (void)didDismissViewControllerProcessor {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
    }];
}

-(void)addPressed:(id)sender {
    if (self.customerContactInfoDataManager.popoverOpenFlag) {
        return;
    }
    self.customerContactInfoDataManager.popoverOpenFlag = YES;
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableCreateContactByEmailFlag]) {
        self.emailActionType = @"create";
        self.emailContactIUR = [NSNumber numberWithInt:0];
        [self.callGenericServices getRecord:@"Contact" iur:[self.emailContactIUR intValue] filter:@""];
        return;
    }
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.myDelegate = self;
    ccwmvc.delegate = self;
    ccwmvc.refreshDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Create Contact for %@", [self.aCustDict objectForKey:@"Name"]];
    ccwmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [ccwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

- (void)createEmailComposeViewController:(NSString*)anEmail {
    NSMutableArray* toRecipients = [NSMutableArray array];
    if (anEmail != nil && ![anEmail isEqualToString:@""]) {
        toRecipients = [NSMutableArray arrayWithObjects:anEmail, nil]; 
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
        return;
    }    
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setToRecipients:toRecipients];
    [self.rootView presentViewController:mailComposeViewController animated:YES completion:nil];
    [mailComposeViewController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = @"";
    NSString* title = @"";
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
            title = @"App Email";
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            title = [GlobalSharedClass shared].errorTitle;
        }
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    if (result != MFMailComposeResultFailed) {
        [self alertViewCallBack];
    } else {
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:99 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    [self alertViewCallBack];
//}

- (void)alertViewCallBack {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
    }];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.contactGenericReturnObject = result;
//        self.contactGenericClass = [result.ArrayOfData objectAtIndex:0];
        self.customerContactTypesDataManager = [[[CustomerContactTypesDataManager alloc] init] autorelease];
        self.customerContactTypesDataManager.myCustDict = self.aCustDict;
        [self.customerContactTypesDataManager createCustomerContactActionDataManager:self.emailActionType];
        self.customerContactTypesDataManager.orderedFieldTypeList = self.customerContactTypesDataManager.customerContactActionBaseDataManager.orderedFieldTypeList;
        if (![self.emailActionType isEqualToString:@"edit"]) {
            [self.callGenericServices.HUD hide:YES];
            [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:[NSMutableArray arrayWithCapacity:0]];
            [self createEmailComposeViewControllerWithType:self.emailActionType];
            return;
        }
        NSString* flagSqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where ContactIUR = %@", self.emailContactIUR];
        [self.callGenericServices genericGetData:flagSqlStatement action:@selector(setFlagGenericGetDataResult:) target:self];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.callGenericServices.HUD hide:YES];
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
    }
}

#pragma mark - setFlagGenericGetDataResult
-(void)setFlagGenericGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:result.ArrayOfData];
        [self createEmailComposeViewControllerWithType:self.emailActionType];
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            self.customerContactInfoDataManager.popoverOpenFlag = NO;
        }];
    }
}

- (void)createEmailComposeViewControllerWithType:(NSString*)anEmailActionType {
    NSNumber* employeeIUR = [SettingManager employeeIUR];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
    NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];    
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:self.myArcosAdminEmail, nil];    
    NSString* subject = @"";    
    if ([anEmailActionType isEqualToString:@"edit"]) {
        subject = [NSString stringWithFormat:@"Please Amend Contact Details from %@", employeeName];
    } else {
        subject = [NSString stringWithFormat:@"Please Create a new Contact for %@", employeeName];
    }
    NSString* body = [self.customerContactTypesDataManager buildEmailMessageBody];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = subject;
        amwvc.bodyText = body;
        amwvc.isHTML = YES;
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
        return;
    }
    
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) {
        self.customerContactInfoDataManager.popoverOpenFlag = NO;
        return;
    }
    MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:toRecipients];
    [mailController setSubject:subject];
    [mailController setMessageBody:body isHTML:YES];
    if (@available(iOS 13.0, *)) {
        mailController.modalInPresentation = YES;
    }
    mailController.modalPresentationStyle = UIModalPresentationPageSheet;
    mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.rootView presentViewController:mailController animated:YES completion:nil];
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self refreshParentContent];
}

@end
