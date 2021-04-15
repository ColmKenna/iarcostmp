//
//  ProductSelectionListingTableViewController.m
//  iArcos
//
//  Created by Richard on 13/04/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ProductSelectionListingTableViewController.h"

@interface ProductSelectionListingTableViewController ()

@end

@implementation ProductSelectionListingTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize productSelectionListingDataManager = _productSelectionListingDataManager;
//@synthesize originalObjectList = _originalObjectList;
@synthesize myObjectList = _myObjectList;
@synthesize tableData = _tableData;
@synthesize sortKeys = _sortKeys;
@synthesize objectSections = _objectSections;
@synthesize needIndexView = _needIndexView;
@synthesize mySearchBar = _mySearchBar;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needIndexView = YES;
        self.tableData = [[[NSMutableArray alloc] init] autorelease];
        self.productSelectionListingDataManager = [[[ProductSelectionListingDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Product Selection";
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    [rightButtonList addObject:saveButton];
    [saveButton release];
    UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(allButtonPressed:)];
    [rightButtonList addObject:allButton];
    [allButton release];
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonPressed:)];
    [rightButtonList addObject:clearButton];
    [clearButton release];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    self.tableView.tableHeaderView = self.mySearchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
}

- (void)dealloc {
    self.productSelectionListingDataManager = nil;
    self.myObjectList = nil;
    self.tableData = nil;
    self.sortKeys = nil;
    self.objectSections = nil;
    self.mySearchBar = nil;
    
    [super dealloc];
}

- (void)cancelButtonPressed:(id)sender {
    [self.actionDelegate didDismissProductSelectionPopover];
}

- (void)allButtonPressed:(id)sender {
    [self.actionDelegate didPressProductAllButton];
    [self.actionDelegate didDismissProductSelectionPopover];
}

- (void)clearButtonPressed:(id)sender {
    for (int i = 0; i < [self.myObjectList count]; i++) {
        NSMutableDictionary* tmpObject = [self.myObjectList objectAtIndex:i];
        [tmpObject setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    }
    [self.tableView reloadData];
}

- (void)saveButtonPressed:(id)sender {
    NSMutableArray* selectedObjectList = [NSMutableArray array];
    for (int i = 0; i < [self.myObjectList count]; i++) {
        NSMutableDictionary* tmpObject = [self.myObjectList objectAtIndex:i];
        if ([[tmpObject objectForKey:@"IsSelected"] boolValue]) {
            [selectedObjectList addObject:tmpObject];
        }
    }
    [self.actionDelegate didPressProductSaveButtonSelectionListing:selectedObjectList];
    [self.actionDelegate didDismissProductSelectionPopover];
}

- (void)resetProduct:(NSMutableArray*)aProductList {
    self.myObjectList = aProductList;
//    self.originalObjectList = [NSMutableArray arrayWithArray:aProductList];
    
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myObjectList];
    [self resetList:self.tableData];
}

- (void)resetList:(NSMutableArray*)aList{
    [self sortObjects:aList];
    [self.tableView reloadData];
}

- (void)sortObjects:(NSMutableArray*)anObjects {
    if ([anObjects count] <= 0) {
        if (self.objectSections != nil) {
            [self.objectSections removeAllObjects];
        }
        [self.sortKeys removeAllObjects];
        [self.sortKeys insertObject:UITableViewIndexSearch atIndex:0];
        return;
    }
    if (self.objectSections != nil) {
        [self.objectSections removeAllObjects];
        self.objectSections = nil;
    }
    self.objectSections = [[[NSMutableDictionary alloc] init] autorelease];
        
    
    if (self.sortKeys == nil) {
        self.sortKeys = [[[NSMutableArray alloc] init]autorelease];
    } else {
        [self.sortKeys removeAllObjects];
    }
    
    @try {
        NSString* currentChar = @"";
        if ([anObjects count] > 0) {
            NSMutableDictionary* anObj = [anObjects objectAtIndex:0];
            NSString* name = [anObj objectForKey:@"Description"];
            currentChar = [name substringToIndex:1];
            [self.sortKeys addObject:currentChar];
        }
        //location and length used to get the sub array of object list
        int location = 0;
        int length = 1;
        
        //start sorting the object in to the sections
        for (int i = 1; i < [anObjects count]; i++) {
            //sotring the name into the array
            NSMutableDictionary* anObj = [anObjects objectAtIndex:i];
            NSString* name = [anObj objectForKey:@"Description"];
            
            //sorting
            if ([currentChar caseInsensitiveCompare:[name substringToIndex:1]] == NSOrderedSame) {
                                
            } else {
                //store the sub array of customer to the section dictionary
                NSMutableArray* tempArray = [[anObjects subarrayWithRange:NSMakeRange(location, length)] mutableCopy];
                [self.objectSections setObject:tempArray forKey:currentChar];
                [tempArray release];
                //reset the location and length
                location = location + length;//bug fit to duplicate outlet entry
                length = 0;
                //get the current char
                currentChar = [name substringToIndex:1];
                //add char to sort key
                [self.sortKeys addObject:currentChar];
            }
            length++;
        }
        NSMutableArray* tempArray = [[anObjects subarrayWithRange:NSMakeRange(location, length)] mutableCopy];
        [self.objectSections setObject:tempArray forKey:currentChar];
        [tempArray release];
        [self.sortKeys addObject:@""];
        //add the search char into the sort key, it will cause the sort key index for others to increase one space
        [self.sortKeys insertObject: UITableViewIndexSearch atIndex:0];
    } @catch (NSException *exception) {
        [self.actionDelegate didShowErrorMsg:[exception reason]];
    } @finally {
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.objectSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString* aKey = [self.sortKeys objectAtIndex:section + 1];
    NSMutableArray* aSectionArray = [self.objectSections objectForKey:aKey];
    
    return [aSectionArray count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.needIndexView) {
        return self.sortKeys;
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   // fixed font style. use custom view (UILabel) if you want something different
    if (self.needIndexView) {
        return [self.sortKeys objectAtIndex:section + 1];
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString* key = [self.sortKeys objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
        [tableView scrollRectToVisible:self.mySearchBar.frame animated:NO];
        return NSNotFound;
    } else {
        return index - 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"IdProductSelectionListingTableViewCell";
    
    ProductSelectionListingTableViewCell* cell = (ProductSelectionListingTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ProductSelectionListingTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ProductSelectionListingTableViewCell class]] && [[(ProductSelectionListingTableViewCell *)nibItem reuseIdentifier] isEqualToString:CellIdentifier]) {
                cell = (ProductSelectionListingTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSString* aKey = [self.sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray = [self.objectSections objectForKey:aKey];
    NSMutableDictionary* anObj = [aSectionArray objectAtIndex:indexPath.row];
    
    if ([[anObj objectForKey:@"IsSelected"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.productCode.text = [anObj objectForKey:@"ProductCode"];
    cell.descriptionLabel.text = [anObj objectForKey:@"Description"];
    
    return cell;
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey = [self.sortKeys objectAtIndex:indexPath.section+1];
    NSMutableArray* aSectionArray = [self.objectSections objectForKey:aKey];
    NSMutableDictionary* cellData = [aSectionArray objectAtIndex:indexPath.row];
    NSNumber* selectedNumber = [cellData objectForKey:@"IsSelected"];
    if ([selectedNumber boolValue]) {
        [cellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    } else {
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    }
    [self.tableView reloadData];
}




#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.needIndexView = NO;
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.tableData removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    self.needIndexView = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.needIndexView = YES;
    [self.tableData removeAllObjects];
    if([searchText isEqualToString:@""] || searchText == nil){
        [self.tableData addObjectsFromArray:self.myObjectList];
        [self resetList:self.tableData];
        return;
    }
    for(NSMutableDictionary* obj in self.myObjectList) {
        NSString* name = [obj objectForKey:@"Description"];
        NSString* productCode = [obj objectForKey:@"ProductCode"];
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSRange aRangeName = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange aRangeProductCode = [productCode rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if ((aRangeName.location != NSNotFound) || (aRangeProductCode.location != NSNotFound)) {
            [self.tableData addObject:obj];
        }
        [pool release];
    }
    [self resetList:self.tableData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.needIndexView = YES;
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:self.myObjectList];
    [self resetList:self.tableData];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
