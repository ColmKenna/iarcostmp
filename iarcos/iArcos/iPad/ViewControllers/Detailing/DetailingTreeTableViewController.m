//
//  DetailingTreeTableViewController.m
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTreeTableViewController.h"

@interface DetailingTreeTableViewController ()

@end

@implementation DetailingTreeTableViewController
@synthesize presentDelegate = _presentDelegate;
@synthesize cellFactory = _cellFactory;
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize branchLeafHashMap = _branchLeafHashMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Cancel"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    
    self.cellFactory = [[[DetailingTreeTableCellFactory alloc] init] autorelease];
    [self createOriginalDisplayList];
    [self createBranchLeafHashMap];
    self.displayList = [NSMutableArray arrayWithArray:self.originalDisplayList];
    
}

- (void)cancelPressed {
    [self.presentDelegate didDismissModalPresentViewController];
}

- (void)createOriginalDisplayList {
    self.originalDisplayList = [NSMutableArray arrayWithCapacity:3];
    [self.originalDisplayList addObject:[self createBranchData:@"a"]];
    [self.originalDisplayList addObject:[self createBranchData:@"b"]];
    [self.originalDisplayList addObject:[self createBranchData:@"c"]];
}

- (void)createBranchLeafHashMap {
    self.branchLeafHashMap = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray* aDataList = [NSMutableArray arrayWithCapacity:3];
    [aDataList addObject:[self createLeafData:@"a0"]];
    [aDataList addObject:[self createLeafData:@"a1"]];
    [aDataList addObject:[self createLeafData:@"a2"]];
    
    NSMutableArray* bDataList = [NSMutableArray arrayWithCapacity:4];
    [bDataList addObject:[self createLeafData:@"b0"]];
    [bDataList addObject:[self createLeafData:@"b1"]];
    [bDataList addObject:[self createLeafData:@"b2"]];
    [bDataList addObject:[self createLeafData:@"b3"]];
    
    NSMutableArray* cDataList = [NSMutableArray arrayWithCapacity:5];
    [cDataList addObject:[self createLeafData:@"c0"]];
    [cDataList addObject:[self createLeafData:@"c1"]];
    [cDataList addObject:[self createLeafData:@"c2"]];
    [cDataList addObject:[self createLeafData:@"c3"]];
    [cDataList addObject:[self createLeafData:@"c4"]];
    
    [self.branchLeafHashMap setObject:aDataList forKey:@"a"];
    [self.branchLeafHashMap setObject:bDataList forKey:@"b"];
    [self.branchLeafHashMap setObject:cDataList forKey:@"c"];
}

- (NSMutableDictionary*)createBranchData:(NSString*)aDesc {
    NSMutableDictionary* branchDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [branchDataDict setObject:aDesc forKey:@"Desc"];
    [branchDataDict setObject:[NSNumber numberWithBool:NO] forKey:@"OpenFlag"];
    [branchDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    
    return branchDataDict;
}

- (NSMutableDictionary*)createLeafData:(NSString*)aDesc {
    NSMutableDictionary* leafDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [leafDataDict setObject:aDesc forKey:@"Desc"];
    [leafDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    
    return leafDataDict;
}

- (void)resetBranchData {
    for (int i = 0; i < [self.originalDisplayList count]; i++) {
        NSMutableDictionary* tmpBranchDict = [self.originalDisplayList objectAtIndex:i];
        [tmpBranchDict setObject:[NSNumber numberWithBool:NO] forKey:@"OpenFlag"];
    }
}

- (void)dealloc {
    self.cellFactory = nil;
    self.displayList = nil;
    self.originalDisplayList = nil;
    self.branchLeafHashMap = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    DetailingTreeBaseTableCell* cell = (DetailingTreeBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (DetailingTreeBaseTableCell*)[self.cellFactory createDetailingTreeBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
    cell.myIndexPath = indexPath;
    [cell configCellWithData:cellData];
    
    return cell;
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    BOOL openFlag = [[cellData objectForKey:@"OpenFlag"] boolValue];
    NSNumber* cellType = [cellData objectForKey:@"CellType"];
    if ([cellType intValue] == 2) return;
    [self resetBranchData];
    [cellData setObject:[NSNumber numberWithBool:!openFlag] forKey:@"OpenFlag"];
    
    self.displayList = [NSMutableArray array];
    for (int i = 0; i < [self.originalDisplayList count]; i++) {
        NSMutableDictionary* tmpCellData = [self.originalDisplayList objectAtIndex:i];
        [self.displayList addObject:tmpCellData];
        BOOL tmpOpenFlag = [[tmpCellData objectForKey:@"OpenFlag"] boolValue];
        if (tmpOpenFlag) {
            NSMutableArray* tmpLeafDataList = [self.branchLeafHashMap objectForKey:[tmpCellData objectForKey:@"Desc"]];
            [self.displayList addObjectsFromArray:tmpLeafDataList];
        }
    }
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
