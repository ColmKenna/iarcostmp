//
//  CustomerContactDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailViewController.h"
#import "CustomerGroupViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"
@interface CustomerContactDetailViewController()

- (void)syncCustomerLocationViewController;

@end

@implementation CustomerContactDetailViewController
@synthesize myCustomers;
@synthesize mySearchBar;
@synthesize customerNames;
@synthesize sortKeys;
@synthesize customerSections = _customerSections;
@synthesize tableData = _tableData;
@synthesize searchedData;
@synthesize checkLocationIURTemplateProcessor = _checkLocationIURTemplateProcessor;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        needIndexView = YES;
        self.tableData = [[[NSMutableArray alloc]init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.tableView.tableHeaderView = nil;
    self.mySearchBar = nil;
    self.myCustomers=nil;
    self.customerNames=nil;
    self.sortKeys=nil;
    self.customerSections = nil;
    self.tableData = nil;
    self.searchedData=nil;
    self.checkLocationIURTemplateProcessor = nil;
    
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
//    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,1024,44)];
//    mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    mySearchBar.delegate = self;
    
    
    self.tableView.tableHeaderView=self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //initialize the two arrays; dataSource will be initialized and populated by appDelegate
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
    self.checkLocationIURTemplateProcessor = [[[CheckLocationIURTemplateProcessor alloc] initWithParentViewController:self] autorelease];
    self.checkLocationIURTemplateProcessor.delegate = self;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.customerSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* aKey=[sortKeys objectAtIndex:section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    
    return [aSectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
    static NSString *CellIdentifier = @"IdCustomerContactDetailTableCell";
    
    CustomerContactDetailTableCell* cell = (CustomerContactDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerContactDetailTableCell class]] && [[(CustomerContactDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerContactDetailTableCell *) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
//    NSLog(@"contact dict: %@", aCust);
    //Customer Name
    
    cell.nameLabel.text =[aCust objectForKey:@"Name"];
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
    cell.addressLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[aCust objectForKey:@"LocationName"] ,[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];
    
    //Image
    //NSNumber* anIUR=[aCust objectForKey:@"ImageIUR"];
    //UIImage* anImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:anIUR];
    //cell.imageView.image=anImage;
    [cell.cP09Button setImage:nil forState:UIControlStateNormal];
    [cell.cP10Button setImage:nil forState:UIControlStateNormal];
    NSNumber* cP09IUR = [aCust objectForKey:@"cP09"];
    NSNumber* cP10IUR = [aCust objectForKey:@"cP10"];
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithObjects:cP09IUR, cP10IUR, nil];
    NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:descrDetailIURList];
    NSMutableDictionary* descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
    for (int i = 0; i < [descrDetailDictList count]; i++) {
        NSDictionary* auxDescrDetailDict = [descrDetailDictList objectAtIndex:i];
//        NSNumber* auxCodeType = [auxDescrDetailDict objectForKey:@"CodeType"];
//        if ([auxCodeType intValue] == 0) continue;
        NSNumber* auxDescrDetailIUR = [auxDescrDetailDict objectForKey:@"DescrDetailIUR"];
        NSNumber* auxImageIUR = [auxDescrDetailDict objectForKey:@"ImageIUR"];
        [descrDetailDictHashMap setObject:auxImageIUR forKey:auxDescrDetailIUR];
    }
    NSNumber* cP09ImageIUR = [descrDetailDictHashMap objectForKey:cP09IUR];
    if ([cP09ImageIUR intValue] != 0) {
        UIImage* cP09Image = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:cP09ImageIUR];
        if (cP09Image != nil) {
            [cell.cP09Button setImage:cP09Image forState:UIControlStateNormal];
        }
    }
    NSNumber* cP10ImageIUR = [descrDetailDictHashMap objectForKey:cP10IUR];
    if ([cP10ImageIUR intValue] != 0) {
        UIImage* cP10Image = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:cP10ImageIUR];
        if (cP10Image != nil) {
            [cell.cP10Button setImage:cP10Image forState:UIControlStateNormal];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey = [sortKeys objectAtIndex:indexPath.section+1];
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
    if (needIndexView) {
        
        return sortKeys;
    }else{
        return nil;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   // fixed font style. use custom view (UILabel) if you want something different
    if (needIndexView) {
        
        return [sortKeys objectAtIndex:section+1
                ];
    }else{
        return @"";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSString *key = [sortKeys objectAtIndex:index];
	if (key == UITableViewIndexSearch) {
//		[tableView setContentOffset:CGPointZero animated:NO];
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
    if ([self.mySearchBar isFirstResponder]) {
        [self.mySearchBar resignFirstResponder];
    }
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
    [self.checkLocationIURTemplateProcessor checkLocationIUR:[aCust objectForKey:@"LocationIUR"] locationName:[aCust objectForKey:@"LocationName"] indexPath:indexPath];
}




//delegateion





#pragma mark - additional functions
-(void)resetCustomer:(NSMutableArray*)customers{
//    NSLog(@"resetCustomer:%@", customers);
    self.myCustomers=customers;
    //    if ([tableData count]>0) {
    //        
    //    }
//    NSLog(@"tableData: %@", tableData);
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myCustomers];//on launch it should display all the records
//    NSLog(@"tableData2: %@", tableData);
    [self resetList:self.tableData];
    
    //dismiss the popover
//    if (groupPopover!=nil&&[groupPopover isPopoverVisible]) {
//        [groupPopover dismissPopoverAnimated:YES];
//    }
    
    //back to the root view
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)resetList:(NSMutableArray*)aList{
//    NSLog(@"resetList: %@", aList);
//    self.searchedData=[NSMutableArray arrayWithArray: aList];
    
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
    
    
    
    
    
    //debugging
    //        for (NSString* aKey in sortKeys) {
    //            NSLog(@"sorted key %@",aKey);
    //        }
    //    
    //        for (NSString* aKey in customerSections) {
    //            NSMutableArray* temp=[customerSections objectForKey:aKey];
    //            NSLog(@"count of array in group selection is %d for %@",[temp count],aKey);
    //        }
    
//    NSLog(@"end sorting customer!!");
    
}
//return an object with the given name
-(NSMutableDictionary*)objectFromName:(NSString*)name{
    for (NSMutableDictionary* aDict in self.myCustomers) {
        NSString* custName=[aDict objectForKey:@"Name"];
        if ([name isEqualToString:custName]) {
            return aDict;
        }
    }
    return nil;
}
//return the objects with the same name
-(NSMutableArray*)objectsFromName:(NSString*)name{
    NSMutableArray* tempArray=[[[NSMutableArray alloc]init]autorelease];
    
    for (NSMutableDictionary* aDict in self.myCustomers) {
        NSString* custName=[aDict objectForKey:@"Name"];
        if ([name isEqualToString:custName]) {
            [tempArray addObject:aDict];
        }
    }
    return tempArray;
}
#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideCustomerDetailsAfterUpdateFlag] && [self.rcsStackedController.rcsViewControllers count] >= 2) {
        UINavigationController* customerInfoNavController = [self.rcsStackedController.rcsViewControllers objectAtIndex:1];
        CustomerInfoTableViewController* citvc = [customerInfoNavController.viewControllers objectAtIndex:0];
        [citvc addCoverHomePageImageView];
    }
    needIndexView=NO;
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [self.tableData removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    needIndexView=YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    needIndexView=YES;
    [self.tableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]||searchText==nil){
        [self resetList:self.myCustomers];
//        self.searchedData=self.myCustomers;
        return;
    }
    NSInteger counter = 0;
    for(NSMutableDictionary *cust in self.myCustomers)
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
        
        counter++;
        [pool release];
    }
//    NSLog(@"%d record found!",[tableData count]);
    [self resetList:self.tableData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    needIndexView=YES;
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myCustomers];
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

#pragma mark -
#pragma mark Managing the popover
/**
 - (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 
 // Add the popover button to the toolbar.
 //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
 //    [itemsArray insertObject:barButtonItem atIndex:0];
 //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
 //    [itemsArray release];
 myBarButtonItem=barButtonItem;
 self.navigationItem.leftBarButtonItem=barButtonItem;
 }
 
 
 - (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 
 // Remove the popover button from the toolbar.
 //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
 //    [itemsArray removeObject:barButtonItem];
 //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
 //    [itemsArray release];
 //self.navigationItem.leftBarButtonItem=nil;
 self.navigationItem.leftBarButtonItem=nil;
 }
 */

- (void) refreshParentContent {
    //select the independent group;
//    UISplitViewController* viewcontroller = (UISplitViewController*) self.parentViewController.parentViewController;
//    NSLog(@"viewcontroller NSStringFromClass: %@", NSStringFromClass([viewcontroller class]));
//    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
//    UITableViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
//    NSLog(@"groupViewController NSStringFromClass: %@", NSStringFromClass([groupViewController class]));
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
    [groupViewController resetButtonPressed:nil];
//    [groupViewController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [groupViewController.tableView.delegate tableView:groupViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

- (void)refreshParentContentByEdit {    
    //click the group button
//    UISplitViewController* viewcontroller = (UISplitViewController*) self.parentViewController.parentViewController;
//    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
//    
//    CustomerGroupViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
//    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
//    
//    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
//    groupViewController.segmentBut.selectedSegmentIndex = 0;
//    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged]; 
//    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
}

-(NSMutableDictionary*)getSelectedCellData {
    if (self.currentIndexPath == nil) {
        return nil;
    }
    NSString* aKey = [sortKeys objectAtIndex:self.currentIndexPath.section+1];
    NSMutableArray* aSectionArray = [self.customerSections objectForKey:aKey];
    return [aSectionArray objectAtIndex:self.currentIndexPath.row];
}

#pragma mark CheckLocationIURTemplateDelegate
- (void)succeedToCheckSameLocationIUR:(NSIndexPath*)indexPath {
    [GlobalSharedClass shared].startRecordingDate = [NSDate date];
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    self.currentIndexPath = indexPath;
    CustomerInfoTableViewController* CITVC=[[CustomerInfoTableViewController alloc]initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
    CITVC.refreshDelegate = self;
    CITVC.title = @"Customer Information Page";
    CITVC.custIUR=[aCust objectForKey:@"LocationIUR"];
    CITVC.locationDefaultContactIUR = [aCust objectForKey:@"ContactIUR"];
    CITVC.locationDefaultContactName = [aCust objectForKey:@"Name"];
    UINavigationController* CITVCNavigationController = [[UINavigationController alloc] initWithRootViewController:CITVC];
    [self.rcsStackedController pushNavigationController:CITVCNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController processSubMenuByCustomerListing:aCust reqSourceName:self.requestSourceName];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [GlobalSharedClass shared].currentSelectedContactIUR = [aCust objectForKey:@"ContactIUR"];
    
    [CITVC release];
    [CITVCNavigationController release];
}
- (void)succeedToCheckNewLocationIUR:(NSIndexPath *)indexPath {
    [self succeedToCheckSameLocationIUR:indexPath];
    [GlobalSharedClass shared].currentSelectedPackageIUR = nil;
    [GlobalSharedClass shared].packageViewCount = 0;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    [self resetCurrentOrderAndWholesaler:[aCust objectForKey:@"LocationIUR"]];
    [self configWholesalerLogo];
    [self syncCustomerLocationViewController];
}

- (void)failToCheckLocationIUR:(NSString*)aTitle {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController.selectedSubMenuTableViewController selectBottomRecordByTitle:aTitle];
}

- (NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    return [aSectionArray objectAtIndex:indexPath.row];
}

- (void)syncCustomerLocationViewController {
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    int itemIndex = [arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    NSMutableDictionary* locationTabBarCellDict = [arcosRootViewController.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
    ArcosStackedViewController* locationArcosStackedViewController = [locationTabBarCellDict objectForKey:@"MyCustomController"];
    NSArray* tmpControllerList = locationArcosStackedViewController.rcsViewControllers;
    if ([tmpControllerList count] < 2) return;
    UINavigationController* customerInfoNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:1];
    CustomerInfoTableViewController* citvc = [customerInfoNavigationController.viewControllers objectAtIndex:0];
    if ([[GlobalSharedClass shared].currentSelectedLocationIUR isEqualToNumber:citvc.custIUR]) return;
    UINavigationController* auxGroupNavigationController = (UINavigationController*)locationArcosStackedViewController.myMasterViewController.masterViewController;
    CustomerGroupViewController* groupViewController = [auxGroupNavigationController.viewControllers objectAtIndex:0];
    if (![groupViewController.groupType isEqualToString:groupViewController.listTypeText]) {
        groupViewController.segmentBut.selectedSegmentIndex = 0;
        [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged];
        groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    [groupViewController resetButtonPressed:nil];
    UINavigationController* auxCustomerListingNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:0];
    CustomerListingViewController* auxCustomerListingViewController = [auxCustomerListingNavigationController.viewControllers objectAtIndex:0];
    NSIndexPath* myLocationIndexPath = [auxCustomerListingViewController getCustomerIndexWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [auxCustomerListingViewController selectLocationWithIndexPath:myLocationIndexPath];
}


@end
