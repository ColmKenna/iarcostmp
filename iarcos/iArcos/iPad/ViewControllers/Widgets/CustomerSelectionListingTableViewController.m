//
//  CustomerSelectionListingTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 08/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerSelectionListingTableViewController.h"

@implementation CustomerSelectionListingTableViewController
@synthesize myCustomers;
@synthesize mySearchBar;
@synthesize customerNames;
@synthesize sortKeys;
@synthesize customerSections = _customerSections;
@synthesize searchedData;
@synthesize selectionDelegate = _selectionDelegate;
@synthesize allLocationRecordDict = _allLocationRecordDict;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize isNotShowingAllButton = _isNotShowingAllButton;
@synthesize showLocationCode = _showLocationCode;

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
    if (self.allLocationRecordDict != nil) { self.allLocationRecordDict = nil; }
    if (self.showLocationCode != nil) { self.showLocationCode = nil; }
    
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
    
//    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,1024,44)];
//    mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    mySearchBar.delegate = self;
    
//    needIndexView=YES;
    
    self.tableView.tableHeaderView=self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //initialize the two arrays; dataSource will be initialized and populated by appDelegate
    
//    tableData = [[NSMutableArray alloc]init]; 
    
//    self.rootView = [[[self parentViewController] parentViewController] parentViewController];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    if (!self.isNotShowingAllButton) {
        UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(allPressed:)];
        [self.navigationItem setRightBarButtonItem:allButton];
        [allButton release];
    }
    
    self.title = @"Customer Selection";
    self.allLocationRecordDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [self.allLocationRecordDict setObject:@"All" forKey:@"Name"];
    [self.allLocationRecordDict setObject:[NSNumber numberWithInt:0] forKey:@"LocationIUR"];
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    self.showLocationCode = [configDict objectForKey:@"ShowlocationCode"];
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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
    [super viewWillAppear:animated];
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    self.showLocationCode = [configDict objectForKey:@"ShowlocationCode"];
}

- (void)viewDidAppear:(BOOL)animated
{       
    [super viewDidAppear:animated];
    if (!self.isNotFirstLoaded) {
        [self scrollBehindSearchSection];
        self.isNotFirstLoaded = YES;
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
    
    //Customer Name
    
    if ([self.showLocationCode boolValue]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]", [aCust objectForKey:@"Name"], [ArcosUtils trim:[aCust objectForKey:@"LocationCode"]]];
    } else {
        cell.textLabel.text =[aCust objectForKey:@"Name"];
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
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];
    //Image
    //NSNumber* anIUR=[aCust objectForKey:@"ImageIUR"];
    //UIImage* anImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:anIUR];
    //cell.imageView.image=anImage;
    
    
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
        
    NSString* aKey=[sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    NSMutableDictionary* aCust=[aSectionArray objectAtIndex:indexPath.row];
    [self.selectionDelegate didSelectCustomerSelectionListingRecord:aCust];    
}

#pragma mark - additional functions
-(void)resetCustomer:(NSMutableArray*)customers{
    
    self.myCustomers=customers;
    //    if ([tableData count]>0) {
    //        
    //    }
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:self.myCustomers];//on launch it should display all the records 
    [self resetList:tableData];
        
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

- (void)cancelPressed:(id)sender {
    [self.selectionDelegate didDismissSelectionPopover];
}

- (void)allPressed:(id)sender {
    [self.selectionDelegate didSelectCustomerSelectionListingRecord:self.allLocationRecordDict];    
}

- (void)scrollBehindSearchSection {
    if ([self.customerSections count] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

@end
