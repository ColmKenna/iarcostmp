//
//  CustomerNotBuyDetailTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyDetailTableViewController.h"

@interface CustomerNotBuyDetailTableViewController ()

@end

@implementation CustomerNotBuyDetailTableViewController
@synthesize CNBDHV = _CNBDHV;
@synthesize callGenericServices = _callGenericServices;
@synthesize locationIUR = _locationIUR;
@synthesize levelCode = _levelCode;
@synthesize displayList = _displayList;
@synthesize filterLevel = _filterLevel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    [self.callGenericServices genericNotBuy:[self.locationIUR intValue] Level:6 LevelCode:self.levelCode filterLevel:[self.filterLevel intValue] action:@selector(setGenericNotBuyResult:) target:self];
    
}

- (void)dealloc {
    self.CNBDHV = nil;
    self.callGenericServices = nil;
    self.locationIUR = nil;
    self.levelCode = nil;
    self.displayList = nil;
    self.filterLevel = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return self.CNBDHV;    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier = @"IdCustomerNotBuyDetailTableCell";
    
    CustomerNotBuyDetailTableCell* cell = (CustomerNotBuyDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerNotBuyDetailTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerNotBuyDetailTableCell class]] && [[(CustomerNotBuyDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerNotBuyDetailTableCell *)nibItem;                                                            
            }
        }
    }
    
    // Configure the cell...
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.myDescription.text = [cellData Field2];    
    cell.lastOrdered.text = [ArcosUtils convertDatetimeToDate:[cellData Field3]];
    
    return cell;
}


-(void)setGenericNotBuyResult:(ArcosGenericReturnObject*) result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
