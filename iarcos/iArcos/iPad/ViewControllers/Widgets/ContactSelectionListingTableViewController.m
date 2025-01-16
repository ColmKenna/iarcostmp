//
//  ContactSelectionListingTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 25/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "ContactSelectionListingTableViewController.h"

@interface ContactSelectionListingTableViewController ()

@end

@implementation ContactSelectionListingTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize originalContactList = _originalContactList;
@synthesize myContactList = _myContactList;
//@synthesize myCustomers = _myCustomers;
@synthesize tableData = _tableData;
@synthesize searchedData = _searchedData;
@synthesize customerNames = _customerNames;
@synthesize sortKeys = _sortKeys;
@synthesize customerSections = _customerSections;
@synthesize needIndexView = _needIndexView;
@synthesize mySearchBar = _mySearchBar;
@synthesize locationButton = _locationButton;
@synthesize selectedLocationIUR = _selectedLocationIUR;
@synthesize selectedLocationDict = _selectedLocationDict;
@synthesize popoverOpenFlag = _popoverOpenFlag;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize customerContactTypesDataManager = _customerContactTypesDataManager;
@synthesize contactGenericReturnObject = _contactGenericReturnObject;
@synthesize myArcosAdminEmail = _myArcosAdminEmail;
@synthesize emailActionType = _emailActionType;
@synthesize emailContactIUR = _emailContactIUR;
@synthesize callGenericServices = _callGenericServices;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needIndexView = YES;
        self.tableData = [[[NSMutableArray alloc] init] autorelease];
        self.popoverOpenFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.rootView = [ArcosUtils getRootView];
    self.title = @"Contact Selection";
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    /*
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:3];
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    [rightButtonList addObject:addButton];
    [rightButtonList addObject:saveButton];
    [saveButton release];
    [addButton release];
    self.locationButton = [[[UIBarButtonItem alloc] initWithTitle:@"Location" style:UIBarButtonItemStylePlain target:self action:@selector(locationButtonPressed:)] autorelease];
    [rightButtonList addObject:self.locationButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    */
    [self configRightBarButtonItems];
    self.tableView.tableHeaderView = self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
}

- (void)dealloc {
    self.originalContactList = nil;
    self.myContactList = nil;
//    self.myCustomers = nil;
    self.tableData = nil;
    self.searchedData = nil;
    self.customerNames = nil;
    self.sortKeys = nil;
    self.customerSections = nil;
    self.mySearchBar = nil;
    self.locationButton = nil;
    self.selectedLocationIUR = nil;
    self.selectedLocationDict = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.contactGenericReturnObject = nil;
    self.customerContactTypesDataManager = nil;
    self.myArcosAdminEmail = nil;
    self.emailActionType = nil;
    self.emailContactIUR = nil;
    self.callGenericServices = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
        self.callGenericServices.isNotRecursion = NO;
    }
}

- (void)configRightBarButtonItems {
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:3];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    if ([self.selectedLocationIUR intValue] != 0) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
        [rightButtonList addObject:addButton];
        [addButton release];
    }
    [rightButtonList addObject:saveButton];
    [saveButton release];
    
    self.locationButton = [[[UIBarButtonItem alloc] initWithTitle:@"Location" style:UIBarButtonItemStylePlain target:self action:@selector(locationButtonPressed:)] autorelease];
    [rightButtonList addObject:self.locationButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
}

-(void)addPressed:(id)sender {
//    NSLog(@"addPressed");
    if (self.popoverOpenFlag) {
        return;
    }
    self.popoverOpenFlag = YES;
    if ([self.selectedLocationIUR intValue] == 0) {
        [ArcosUtils showDialogBox:@"Location not selected" title:@"" target:self handler:^(UIAlertAction *action) {
            self.popoverOpenFlag = NO;
        }];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableCreateContactByEmailFlag]) {
        self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
        self.emailActionType = @"create";
        self.emailContactIUR = [NSNumber numberWithInt:0];
        [self.callGenericServices getRecord:@"Contact" iur:[self.emailContactIUR intValue] filter:@""];
        return;
    }
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.myDelegate = self;
//    ccwmvc.delegate = self;
    ccwmvc.refreshDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Create Contact for %@", [self.selectedLocationDict objectForKey:@"Name"]];
    ccwmvc.locationIUR = self.selectedLocationIUR;
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
}

#pragma mark - CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self didDismissViewControllerProcessor];
}

- (void)didDismissViewControllerProcessor {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
        self.popoverOpenFlag = NO;
    }];
}

#pragma mark - ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self didDismissViewControllerProcessor];
}

#pragma mark - MFMailComposeViewControllerDelegate
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
        [ArcosUtils showDialogBox:message title:title target:controller handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertViewCallBack {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.popoverOpenFlag = NO;
    }];
}

#pragma mark - GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    [self resetContact:[self.actionDelegate retrieveContactLocationObjectList]];
    self.needIndexView = YES;
    [self.myContactList removeAllObjects];
    [self.tableData removeAllObjects];
    for(NSMutableDictionary* cust in self.originalContactList) {
        NSNumber* locationIUR = [cust objectForKey:@"LocationIUR"];
        if ([self.selectedLocationIUR isEqualToNumber:locationIUR]) {
            [self.myContactList addObject:cust];
            [self.tableData addObject:cust];
        }
    }
    [self resetList:self.tableData];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        self.popoverOpenFlag = NO;
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.contactGenericReturnObject = result;
//        self.contactGenericClass = [result.ArrayOfData objectAtIndex:0];
        self.customerContactTypesDataManager = [[[CustomerContactTypesDataManager alloc] init] autorelease];
        self.customerContactTypesDataManager.myCustDict = self.selectedLocationDict;
        [self.customerContactTypesDataManager createCustomerContactActionDataManager:self.emailActionType];
        self.customerContactTypesDataManager.orderedFieldTypeList = self.customerContactTypesDataManager.customerContactActionBaseDataManager.orderedFieldTypeList;
        if (![self.emailActionType isEqualToString:@"edit"]) {
            [self.callGenericServices.HUD hide:YES];
            [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:[NSMutableArray arrayWithCapacity:0]];
            [self createEmailComposeViewControllerWithType:self.emailActionType];
            return;
        }
//        NSString* flagSqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where ContactIUR = %@", self.emailContactIUR];
//        [self.callGenericServices genericGetData:flagSqlStatement action:@selector(setFlagGenericGetDataResult:) target:self];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.callGenericServices.HUD hide:YES];
        self.popoverOpenFlag = NO;
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
        self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.globalNavigationController animated:YES completion:nil];
        [amwvc release];
        return;
    }
    
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) {
        self.popoverOpenFlag = NO;
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
    [self presentViewController:mailController animated:YES completion:nil];
}

- (void)cancelButtonPressed:(id)sender {
    [self.actionDelegate didDismissContactSelectionPopover];
}

- (void)saveButtonPressed:(id)sender {
    NSMutableArray* resultDictList = [NSMutableArray array];
    for (int i = 0; i < [self.customerSections count]; i++) {
        NSString* aKey = [self.sortKeys objectAtIndex:i+1];
        NSMutableArray* aSectionArray = [self.customerSections objectForKey:aKey];
        for (int j = 0; j < [aSectionArray count]; j++) {
            NSMutableDictionary* aContactDict = [aSectionArray objectAtIndex:j];
            if ([[aContactDict objectForKey:@"IsSelected"] boolValue]) {
                [resultDictList addObject:aContactDict];
            }
        }
    }
    [self.actionDelegate didSelectContactSelectionListing:resultDictList];
    [self.actionDelegate didDismissContactSelectionPopover];
}

- (void)locationButtonPressed:(id)sender {
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = NO;
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
    [CSLTVC resetCustomer:locationList];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.barButtonItem = self.locationButton;
    [self presentViewController:tmpNavigationController animated:YES completion:nil];
    [CSLTVC release];
    [tmpNavigationController release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.customerSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* aKey=[self.sortKeys objectAtIndex:section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    
    return [aSectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString* aKey=[self.sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
    //    NSLog(@"contact dict: %@", aCust);
    //Customer Name
    if ([[aCust objectForKey:@"IsSelected"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    cell.textLabel.text =[aCust objectForKey:@"Name"];
    //Address
    if ([aCust objectForKey:@"Address1"]==nil) {
        [aCust setObject:@"" forKey:@"Address1"];
    }
    if ([aCust objectForKey:@"Address2"]==nil) {
        [aCust setObject:@"" forKey:@"Address2"];
    }
    if ([aCust objectForKey:@"Address3"]==nil) {
        [aCust setObject:@"" forKey:@"Address3"];
    }
    if ([aCust objectForKey:@"Address4"]==nil) {
        [aCust setObject:@"" forKey:@"Address4"];
    }
    if ([aCust objectForKey:@"Address5"]==nil) {
        [aCust setObject:@"" forKey:@"Address5"];
    }
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[aCust objectForKey:@"LocationName"] ,[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];
    
    //Image
    //NSNumber* anIUR=[aCust objectForKey:@"ImageIUR"];
    //UIImage* anImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:anIUR];
    //cell.imageView.image=anImage;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey = [self.sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray = [self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust = [aSectionArray objectAtIndex:indexPath.row];
    //SameContactIUR 1: pale blue others: clearColor
    NSNumber* sameContactIUR = [aCust objectForKey:@"SameContactIUR"];
    if ([sameContactIUR intValue] == 1) {
        cell.backgroundColor = [UIColor colorWithRed:173.0/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [sortKeys objectAtIndex:section];
//}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.needIndexView) {
        
        return self.sortKeys;
    }else{
        return nil;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   // fixed font style. use custom view (UILabel) if you want something different
    if (self.needIndexView) {
        
        return [self.sortKeys objectAtIndex:section+1
                ];
    }else{
        return @"";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = [self.sortKeys objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
        //        [tableView setContentOffset:CGPointZero animated:NO];
//        [tableView setContentOffset:CGPointMake(0.0, -tableView.contentInset.top)];
        [tableView scrollRectToVisible:self.mySearchBar.frame animated:NO];
        return NSNotFound;
    }
    else return index-1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey = [self.sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray = [self.customerSections objectForKey:aKey];
    NSMutableDictionary* cellData = [aSectionArray objectAtIndex:indexPath.row];
    
//    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    NSNumber* selectedNumber = [cellData objectForKey:@"IsSelected"];
    if ([selectedNumber boolValue]) {
        [cellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    } else {
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    }
    [self.tableView reloadData];
}

- (void)resetContact:(NSMutableArray*)aContactList {
    self.myContactList = aContactList;
    self.originalContactList = [NSMutableArray arrayWithArray:aContactList];
    
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myContactList];
    [self resetList:self.tableData];
    
    //back to the root view
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)resetList:(NSMutableArray*)aList{    
    [self sortCustomers:aList];
    [self.tableView reloadData];
}
-(void)sortCustomers:(NSMutableArray*)customers{
    //    NSLog(@"sortCustomers: %@", customers);
    if ([customers count]<=0) {
        if (self.customerSections!=nil) {
            [self.customerSections removeAllObjects];
        }
        [self.sortKeys removeAllObjects];
        [self.sortKeys insertObject: UITableViewIndexSearch atIndex:0];
        return;
    }
    //    NSLog(@"start sorting customer!!");
    
    //release the old selections
    if (self.customerSections!=nil) {
        [self.customerSections removeAllObjects];
        self.customerSections = nil;
    }
    //reinitialize the customer sections
    self.customerSections=[[[NSMutableDictionary alloc]init] autorelease];
    
    //a temp sorted group name
    NSMutableArray* sortedGroupNameArray=[[NSMutableArray alloc]init];
    
    //reinitialize the sort key
    if (self.sortKeys ==nil) {
        self.sortKeys=[[[NSMutableArray alloc]init]autorelease];
    }else{
        [self.sortKeys removeAllObjects];
    }
    
    //get the first char of the  list
    NSString* currentChar=@"";
    if ([customers count]>0) {
        NSMutableDictionary* aCust=[customers objectAtIndex:0];
        NSString* name=[aCust objectForKey:@"Surname"];
        
        if (name != nil) {
            currentChar =[name substringToIndex:1];
        }
        
        //add first Char
        [self.sortKeys addObject:currentChar];
    }
    //location and length used to get the sub array of customer list
    int location=0;
    int length=1;
    
    //start sorting the customer in to the sections
    for (int i=1; i<[customers count]; i++) {
        //sotring the name into the array
        NSMutableDictionary* aCust=[customers objectAtIndex:i];
        NSString* name=[aCust objectForKey:@"Surname"];
        
        //        NSLog(@"customer name is %@",name);
        
        if (name==nil||[name isEqualToString:@""]) {
            name=@"Unknown Shop";
        }
        [sortedGroupNameArray addObject:name];
        
        //sorting
        if ([currentChar caseInsensitiveCompare:[name substringToIndex:1]]==NSOrderedSame) {
            
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray=[[customers subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [self.customerSections setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=location+length;//bug fit to duplicate outlet entry
            length=0;
            //get the current char
            currentChar=[name substringToIndex:1];
            //add char to sort key
            [self.sortKeys addObject:currentChar];
        }
        length++;
    }
    //assgin the customer names
    self.customerNames=sortedGroupNameArray;
    //    NSLog(@"customer is %d",[customers count]);
    NSMutableArray* tempArray=[[customers subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    [self.customerSections setObject:tempArray forKey:currentChar];
    [tempArray release];
    [sortedGroupNameArray release];
    //add char to sort key
    //[self.sortKeys addObject:currentChar];
    [self.sortKeys addObject:@""];
    //add the search char into the sort key, it will cause the sort key index for others to increase one space
    [self.sortKeys insertObject: UITableViewIndexSearch atIndex:0];
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.needIndexView=NO;
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [self.tableData removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    self.needIndexView=YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.needIndexView=YES;
    [self.tableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]||searchText==nil){
        [self resetList:self.myContactList];
        return;
    }
//    NSInteger counter = 0;
    for(NSMutableDictionary *cust in self.myContactList)
    {
        NSString* name=[cust objectForKey:@"Name"];
        NSString* fullAddress=[[ArcosCoreData sharedArcosCoreData]fullAddressWith:cust];
        fullAddress = [NSString stringWithFormat:@"%@ %@", [cust objectForKey:@"LocationName"], fullAddress];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        //ignore case search
        NSRange aRangeName = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange aRangeAddress = [fullAddress rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if ((aRangeName.location !=NSNotFound)||(aRangeAddress.location !=NSNotFound)) {
            [self.tableData addObject:cust];
        }
        
//        counter++;
        [pool release];
    }
    //    NSLog(@"%d record found!",[tableData count]);
    [self resetList:self.tableData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.needIndexView=YES;
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myContactList];
    @try{
        [self resetList:self.tableData];
    }
    @catch(NSException *e){
        
    }
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    
}

// called when Search (in our case "Done") button pressed

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
//    [self.delegate locationInputFinishedWithData:aCustDict forIndexpath:self.indexPath];
    self.needIndexView = YES;
    [self.myContactList removeAllObjects];
    [self.tableData removeAllObjects];
    self.selectedLocationIUR = [aCustDict objectForKey:@"LocationIUR"];
    self.selectedLocationDict = aCustDict;
    [self configRightBarButtonItems];
//    NSLog(@"selectedLocationDict %@", self.selectedLocationDict);
    if ([self.selectedLocationIUR intValue] == 0) {
        self.myContactList = [NSMutableArray arrayWithArray:self.originalContactList];
        self.tableData = [NSMutableArray arrayWithArray:self.originalContactList];
        [self resetList:self.tableData];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    for(NSMutableDictionary* cust in self.originalContactList)
    {
        NSNumber* locationIUR = [cust objectForKey:@"LocationIUR"];
        if ([self.selectedLocationIUR isEqualToNumber:locationIUR]) {
            [self.myContactList addObject:cust];
            [self.tableData addObject:cust];
        }
    }
    //    NSLog(@"%d record found!",[tableData count]);
    [self resetList:self.tableData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
