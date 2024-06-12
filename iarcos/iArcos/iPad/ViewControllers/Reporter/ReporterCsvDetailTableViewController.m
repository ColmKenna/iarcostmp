//
//  ReporterCsvDetailTableViewController.m
//  iArcos
//
//  Created by Richard on 11/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReporterCsvDetailTableViewController.h"

@interface ReporterCsvDetailTableViewController ()

@end

@implementation ReporterCsvDetailTableViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize attrNameList = _attrNameList;
@synthesize bodyFieldList = _bodyFieldList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    
    self.tableView.allowsSelection = NO;
}

- (void)dealloc {
    self.attrNameList = nil;
    self.bodyFieldList = nil;
    
    [super dealloc];
}

- (void)backPressed {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount = 0;
    int tmpRowCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.attrNameList count]] - 1;
    if (tmpRowCount > 0) {
        rowCount = tmpRowCount;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdGenericUITableDetailTableCell";
    
    GenericUITableDetailTableCell* cell=(GenericUITableDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericUITableDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericUITableDetailTableCell class]] && [[(GenericUITableDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (GenericUITableDetailTableCell *) nibItem;
            }
        }
    }
    // Configure the cell...
    cell.attributeName.text = [self.attrNameList objectAtIndex:indexPath.row];
    cell.attributeValue.text = [self.bodyFieldList objectAtIndex:indexPath.row];
    
    return cell;
}

@end
