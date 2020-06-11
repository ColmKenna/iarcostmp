//
//  CustomerListingViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "CustomerListingViewController.h"
#import "CustomerGroupViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@interface CustomerListingViewController () {
//    BOOL _intersectFlag;
//    BOOL _isNotFinishedAnimation;
//    CustomerGroupViewController* _customerGroupViewController;
//    UINavigationController* _customerGroupNavigationController;
    NSTimer* _orderRestoredTimer;
}

//@property(nonatomic, assign) BOOL intersectFlag;
//@property(nonatomic, assign) BOOL isNotFinishedAnimation;
//@property(nonatomic, retain) CustomerGroupViewController* customerGroupViewController;
//@property(nonatomic, retain) UINavigationController* customerGroupNavigationController;
@property(nonatomic, retain) NSTimer* orderRestoredTimer;
- (void)alertViewCallBack;
@end

@implementation CustomerListingViewController

@synthesize myCustomers;
@synthesize mySearchBar;
@synthesize customerNames;
@synthesize sortKeys;
@synthesize customerSections = _customerSections;
@synthesize searchedData;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize showLocationCode = _showLocationCode;
@synthesize storeNewsDateDataManager = _storeNewsDateDataManager;
@synthesize checkLocationIURTemplateProcessor = _checkLocationIURTemplateProcessor;
@synthesize arcosOrderRestoreUtils = _arcosOrderRestoreUtils;
@synthesize restoredLocationIndexPath = _restoredLocationIndexPath;
@synthesize orderRestoredTimer = _orderRestoredTimer;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
//@synthesize intersectFlag = _intersectFlag;
//@synthesize isNotFinishedAnimation = _isNotFinishedAnimation;
//@synthesize customerGroupViewController = _customerGroupViewController;
//@synthesize customerGroupNavigationController = _customerGroupNavigationController;
@synthesize callGenericServices = _callGenericServices;
@synthesize customerTypesDataManager = _customerTypesDataManager;
@synthesize myArcosAdminEmail = _myArcosAdminEmail;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        tableData = [[NSMutableArray alloc]init];
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
    self.searchedData=nil;
    [tableData release];
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.showLocationCode != nil) { self.showLocationCode = nil; }
    [connectivityCheck release];
    self.storeNewsDateDataManager = nil;
    self.checkLocationIURTemplateProcessor = nil;
    self.arcosOrderRestoreUtils = nil;
    self.restoredLocationIndexPath = nil;
    [self.orderRestoredTimer invalidate];
    self.orderRestoredTimer = nil;
//    self.customerGroupViewController = nil;
//    self.customerGroupNavigationController = nil;
    
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
//    id result = [ArcosXMLParser doXMLParse:@"Survey0" deserializeTo:[[ArcosArrayOfSurveyBO alloc] autorelease]];
//    ArcosArrayOfSurveyBO* arcosArrayOfSurveyBO = (ArcosArrayOfSurveyBO*)result;
//    for (ArcosSurveyBO* arcosSurveyBO in arcosArrayOfSurveyBO) {
//        [[ArcosCoreData sharedArcosCoreData] loadSurveyWithSoapOB:arcosSurveyBO];
//    }
//    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,1024,44)];
//    mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    mySearchBar.delegate = self;
    needIndexView=YES;
    
    self.tableView.tableHeaderView=self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
    //initialize the two arrays; dataSource will be initialized and populated by appDelegate
    
//    tableData = [[NSMutableArray alloc]init]; 
    
    
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    NSMutableArray* buttonList = [NSMutableArray arrayWithObjects:addButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonList];
    [addButton release];
    connectivityCheck=[[ConnectivityCheck alloc]init];
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
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    self.showLocationCode = [configDict objectForKey:@"ShowlocationCode"];
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (UIDeviceOrientationIsPortrait(orientation)||orientation==0) {
//        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
//            self.navigationItem.leftBarButtonItem=myBarButtonItem;
//        }
//    }else{
//        if (self.navigationItem.leftBarButtonItem!=nil) {
//            self.navigationItem.leftBarButtonItem=nil;
//        }
//    }
    
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
/**    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
*/
}

- (void)viewDidAppear:(BOOL)animated
{       
    [super viewDidAppear:animated];
    if (self.rootView == nil) {
        self.rootView = [ArcosUtils getRootView];
    }
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
    }
//    if (self.currentIndexPath != nil) {
//        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }
    if (!self.isNotFirstLoaded && [self.arcosOrderRestoreUtils orderRestorePlistExistent]) {
//        [self.arcosOrderRestoreUtils loadExistingOrderline];
        self.isNotFirstLoaded = YES;
        if (self.restoredLocationIndexPath.section != -1 && self.restoredLocationIndexPath.row != -1) {
            [self.tableView selectRowAtIndexPath:self.restoredLocationIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            self.orderRestoredTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(selectRestoreCustomer)
                                           userInfo:nil
                                            repeats:NO];
        }
        [self.arcosOrderRestoreUtils removeOrderRestorePlist];
    }
    self.isNotFirstLoaded = YES;
    self.storeNewsDateDataManager = [StoreNewsDateDataManager storeNewsDateInstance];
    if ([ArcosSystemCodesUtils myNewsOptionExistence]) {
        NSDate* storedNewsDate = [self.storeNewsDateDataManager.storeNewsDateDict objectForKey:@"Date"];
        NSNumber* notFirstTime = [self.storeNewsDateDataManager.storeNewsDateDict objectForKey:@"NotFirstTime"];
        if (![notFirstTime boolValue]) {
            [self.storeNewsDateDataManager saveStoreNewsDate];
            [self openNews:nil];
            return;
        }
        NSDate* currentDate = [NSDate date];
        NSTimeInterval diff = [currentDate timeIntervalSinceDate:storedNewsDate];
        float hourDiff = diff / 60.0 / 60.0;
        
        NSNumber* hourInterval = [ArcosSystemCodesUtils retrieveHourNumberInNewsOption];
        if (hourDiff > [hourInterval floatValue]) {
            [self.storeNewsDateDataManager saveStoreNewsDate];
            [self openNews:nil];
        }
    }
}

- (void)selectRestoreCustomer {
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.restoredLocationIndexPath];
    [[OrderSharedClass sharedOrderSharedClass]resetTheWholesellerWithLocation:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [[OrderSharedClass sharedOrderSharedClass]refreshCurrentOrderDate];
    [self configWholesalerLogo];
    [ArcosUtils showMsg:@"Order has been restored." delegate:nil];
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
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

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
    static NSString *CellIdentifier = @"IdCustomerListingTableCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerListingTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;                
            }
        }
    }
    
    // Configure the cell...
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
    
    //Customer Name            
//    if ([self.showLocationCode boolValue]) {
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@ [%@]", [aCust objectForKey:@"Name"], [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCust objectForKey:@"LocationCode"]]]];
//    } else {
//        cell.nameLabel.text =[aCust objectForKey:@"Name"];
//    }
    cell.nameLabel.text =[aCust objectForKey:@"Name"];
    if ([self.showLocationCode boolValue]) {
        cell.locationCodeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCust objectForKey:@"LocationCode"]]];
    } else {
        cell.locationCodeLabel.text = @"";
    }
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
    cell.addressLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];
    //Image
    //NSNumber* anIUR=[aCust objectForKey:@"ImageIUR"];
    //UIImage* anImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:anIUR];
    //cell.imageView.image=anImage;
    [cell.locationStatusButton setImage:nil forState:UIControlStateNormal];
    [cell.creditStatusButton setImage:nil forState:UIControlStateNormal];
    NSNumber* locationStatusIUR = [aCust objectForKey:@"lsiur"];
    NSNumber* creditStatusIUR = [aCust objectForKey:@"CSiur"];
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithObjects:locationStatusIUR, creditStatusIUR, nil];
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
    NSNumber* locationStatusImageIUR = [descrDetailDictHashMap objectForKey:locationStatusIUR];
    if ([locationStatusImageIUR intValue] != 0) {
        UIImage* locationStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:locationStatusImageIUR];
        if (locationStatusImage != nil) {
            [cell.locationStatusButton setImage:locationStatusImage forState:UIControlStateNormal];
        }
    }
    NSNumber* creditStatusImageIUR = [descrDetailDictHashMap objectForKey:creditStatusIUR];
    if ([creditStatusImageIUR intValue] != 0) {
        UIImage* creditStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:creditStatusImageIUR];
        if (creditStatusImage != nil) {
            [cell.creditStatusButton setImage:creditStatusImage forState:UIControlStateNormal];
        }
    }
    
    return cell;
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
    [self.checkLocationIURTemplateProcessor checkLocationIUR:[aCust objectForKey:@"LocationIUR"] locationName:[aCust objectForKey:@"Name"] indexPath:indexPath];
}




//delegateion





#pragma mark - additional functions
-(void)resetCustomer:(NSMutableArray*)customers{

    self.myCustomers=customers;
//    if ([tableData count]>0) {
//        
//    }
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:self.myCustomers];//on launch it should display all the records 
    [self resetList:tableData];
    
    //dismiss the popover
    if (groupPopover!=nil&&[groupPopover isPopoverVisible]) {
        [groupPopover dismissPopoverAnimated:YES];
    }
    
    //back to the root view
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)resetList:(NSMutableArray*)aList{
//    self.searchedData=[NSMutableArray arrayWithArray: aList];

    [self sortCustomers:aList];
    [self.tableView reloadData];
}
-(void)sortCustomers:(NSMutableArray*)customers{
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
        NSString* name=[aCust objectForKey:@"Name"];       
        
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
        NSString* name=[aCust objectForKey:@"Name"];        
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
//        for (NSString* aKey in self.customerSections) {
//            NSMutableArray* temp=[self.customerSections objectForKey:aKey];
//            NSLog(@"count of array in group selection is %lu for %@",[temp count],aKey);
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
    [tableData removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    needIndexView=YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    needIndexView=YES;
    [tableData removeAllObjects];// remove all data that belongs to previous search
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
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];

        //ignore case search
        NSRange aRangeName = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange aRangeAddress = [fullAddress rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (self.showLocationCode) {
            NSString* locationCode = [cust objectForKey:@"LocationCode"];
            NSRange aRangeLocationCode = [locationCode rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if ((aRangeName.location !=NSNotFound)||(aRangeAddress.location !=NSNotFound)||(aRangeLocationCode.location !=NSNotFound)) {
                [tableData addObject:cust];
            }
        } else {
            if ((aRangeName.location !=NSNotFound)||(aRangeAddress.location !=NSNotFound)) {
                [tableData addObject:cust];
            }
        }

         
        
        counter++;
        [pool release];
    }
//    NSLog(@"%d record found!",[tableData count]);
    [self resetList:tableData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    needIndexView=YES;
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:self.myCustomers];
    @try{
        [self resetList:tableData];
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

-(void)addPressed:(id)sender {
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableCreateLocationByEmailFlag]) {
        [self.callGenericServices getRecord:@"Location" iur:0];
        return;
    }
    CustomerDetailsWrapperModalViewController* cdwmvc = [[CustomerDetailsWrapperModalViewController alloc] initWithNibName:@"CustomerDetailsWrapperModalViewController" bundle:nil];
    cdwmvc.actionType = @"create";
    cdwmvc.myDelegate = self;
    cdwmvc.delegate = self;
    cdwmvc.refreshDelegate = self;
    cdwmvc.navgationBarTitle = [NSString stringWithFormat:@"Create New Location"];
    cdwmvc.locationIUR = [NSNumber numberWithInt:0];
    cdwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [cdwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
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
    }];
} 

- (void) didDismissModalView {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

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
//    CustomerGroupViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
    /*
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
    groupViewController.segmentBut.selectedSegmentIndex = 0;
    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged]; 
    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
    */
}

- (void)openNews:(id)sender {
    CustomerNewsTaskWrapperViewController* CNTWVC = [[CustomerNewsTaskWrapperViewController alloc] initWithNibName:@"CustomerNewsTaskWrapperViewController" bundle:nil];
    CNTWVC.myDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:CNTWVC] autorelease];
    
    CNTWVC.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:CNTWVC] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    
    [CNTWVC release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
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
    self.currentIndexPath = indexPath;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    
    CustomerInfoTableViewController* CITVC=[[CustomerInfoTableViewController alloc]initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
    CITVC.refreshDelegate = self;
    CITVC.title = @"Customer Information Page";
    CITVC.custIUR=[aCust objectForKey:@"LocationIUR"];
    UINavigationController* CITVCNavigationController = [[UINavigationController alloc] initWithRootViewController:CITVC];
    
    [CITVC release];
    
    [self.rcsStackedController pushNavigationController:CITVCNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [CITVCNavigationController release];
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [arcosRootViewController.customerMasterViewController processSubMenuByCustomerListing:aCust reqSourceName:self.requestSourceName];
}
- (void)succeedToCheckNewLocationIUR:(NSIndexPath*)indexPath {
    [self succeedToCheckSameLocationIUR:indexPath];
    [GlobalSharedClass shared].currentSelectedContactIUR = nil;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    [self resetCurrentOrderAndWholesaler:[aCust objectForKey:@"LocationIUR"]];
    [self configWholesalerLogo];
    [self syncCustomerContactViewController];
}
- (void)failToCheckLocationIUR:(NSString*)aTitle {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController.selectedSubMenuTableViewController selectBottomRecordByTitle:aTitle];
}

-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* aKey = [sortKeys objectAtIndex:anIndexPath.section+1];
    NSMutableArray* aSectionArray = [self.customerSections objectForKey:aKey];
    return [aSectionArray objectAtIndex:anIndexPath.row];
}
- (NSIndexPath*)getCustomerIndexWithLocationIUR:(NSNumber*)aLocationIUR {
    int section = -1;
    int row = -1;
    for (int i = 1; i < [sortKeys count]; i++) {
        NSString* aKey = [sortKeys objectAtIndex:i];
        NSMutableArray* dataList = [self.customerSections objectForKey:aKey];
        BOOL isFound = NO;
        for (int j = 0; j < [dataList count]; j++) {
            NSDictionary* dataDict = [dataList objectAtIndex:j];
            if ([[dataDict objectForKey:@"LocationIUR"] isEqualToNumber:[ArcosUtils convertNilToZero:aLocationIUR]]) {
                row = j;
                section = i - 1;
                isFound = YES;
                break;
            }
        }
        if (isFound) break;
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)selectLocationWithIndexPath:(NSIndexPath*)anIndexPath {
    if (anIndexPath.section == -1 || anIndexPath.row == -1) {
        return;
    }
    [self.tableView selectRowAtIndexPath:anIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:anIndexPath];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {        
        self.customerTypesDataManager = [[[CustomerTypesDataManager alloc] init] autorelease];
        [self.customerTypesDataManager createCustomerDetailsActionDataManager:@"create"];
        self.customerTypesDataManager.orderedFieldTypeList = self.customerTypesDataManager.customerDetailsActionBaseDataManager.orderedFieldTypeList;
        [self.customerTypesDataManager processRawData:result withNumOfFields:47];
        NSNumber* employeeIUR = [SettingManager employeeIUR];
        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
        NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
        NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:self.myArcosAdminEmail, nil];
        NSString* subject = [NSString stringWithFormat:@"Please Create a new Location for %@", employeeName];
        NSString* body = [self.customerTypesDataManager buildEmailMessageBody];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
            ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//            amwvc.myDelegate = self;
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
        if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
        MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        mailController.mailComposeDelegate = self;
        
        [mailController setToRecipients:toRecipients];
        [mailController setSubject:subject];
        
        [mailController setMessageBody:body isHTML:YES];
        [self.rootView presentViewController:mailController animated:YES completion:nil];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self alertViewCallBack];
}

- (void)alertViewCallBack {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        
    }];
}

@end
