//
//  FlagsContactTableViewController.m
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactTableViewController.h"

@interface FlagsContactTableViewController ()

@end

@implementation FlagsContactTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize originalContactList = _originalContactList;
@synthesize myContactList = _myContactList;
@synthesize tableData = _tableData;
@synthesize searchedData = _searchedData;
@synthesize customerNames = _customerNames;
@synthesize sortKeys = _sortKeys;
@synthesize customerSections = _customerSections;
@synthesize needIndexView = _needIndexView;
@synthesize mySearchBar = _mySearchBar;
@synthesize flagsContactDataManager = _flagsContactDataManager;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.needIndexView = YES;
        self.tableData = [[[NSMutableArray alloc] init] autorelease];
        self.flagsContactDataManager = [[[FlagsContactDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Contact Selection";
    self.tableView.tableHeaderView = self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView setContentOffset:CGPointMake(0, self.mySearchBar.frame.size.height) animated:NO];
}

- (void)dealloc {
    self.originalContactList = nil;
    self.myContactList = nil;
    self.tableData = nil;
    self.searchedData = nil;
    self.customerNames = nil;
    self.sortKeys = nil;
    self.customerSections = nil;
    self.mySearchBar = nil;
    self.flagsContactDataManager = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.customerSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* aKey=[self.sortKeys objectAtIndex:section+1];
    NSMutableArray* aSectionArray=[self.customerSections objectForKey:aKey];
    
    return [aSectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
//    NSNumber* contactIUR = [aCust objectForKey:@"IUR"];
//    NSString* cartKey = [NSString stringWithFormat:@"%@", [contactIUR stringValue]];
//    NSMutableDictionary* existingContactDict = [[self.actionDelegate retrieveContactParentOrderCart] objectForKey:cartKey];
//    if (existingContactDict != nil) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    cell.textLabel.text =[aCust objectForKey:@"Name"];
    //Address
    /*
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
    */
    return cell;
}

/*
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
*/
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
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
    [self.actionDelegate didSelectFlagsContactRecord:cellData];    
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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.needIndexView=NO;
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [self.tableData removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    self.needIndexView=YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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
//        NSString* fullAddress=[[ArcosCoreData sharedArcosCoreData]fullAddressWith:cust];
//        fullAddress = [NSString stringWithFormat:@"%@ %@", [cust objectForKey:@"LocationName"], fullAddress];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        //ignore case search
        NSRange aRangeName = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        NSRange aRangeAddress = [fullAddress rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if ((aRangeName.location !=NSNotFound)) {//||(aRangeAddress.location !=NSNotFound)
            [self.tableData addObject:cust];
        }
        
//        counter++;
        [pool release];
    }
    //    NSLog(@"%d record found!",[tableData count]);
    [self resetList:self.tableData];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)refreshContactList {
    for (int i = 0; i < [self.myContactList count]; i++) {
        NSMutableDictionary* contactDict = [self.myContactList objectAtIndex:i];
        NSNumber* contactIUR = [contactDict objectForKey:@"IUR"];
        NSString* cartKey = [NSString stringWithFormat:@"%@", [contactIUR stringValue]];
        NSMutableDictionary* existingContactDict = [[self.actionDelegate retrieveContactParentOrderCart] objectForKey:cartKey];
        if (existingContactDict != nil) {
            [contactDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        } else {
            [contactDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        }
    }
    [self.tableView reloadData];
}

@end
