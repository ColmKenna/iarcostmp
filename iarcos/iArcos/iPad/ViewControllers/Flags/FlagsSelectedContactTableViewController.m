//
//  FlagsSelectedContactTableViewController.m
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsSelectedContactTableViewController.h"

@interface FlagsSelectedContactTableViewController ()

@end

@implementation FlagsSelectedContactTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize flagsSelectedContactDataManager = _flagsSelectedContactDataManager;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.flagsSelectedContactDataManager = [[[FlagsSelectedContactDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIBarButtonItem* flagsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flags_banner.png"] style:UIBarButtonItemStylePlain target:self action:@selector(flagsButtonPressed)];
    NSMutableArray* buttonList = [NSMutableArray arrayWithObjects:flagsButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonList];
    [flagsButton release];
}

- (void)flagsButtonPressed {
    
}

- (void)dealloc {
    self.flagsSelectedContactDataManager = nil;
    
    [super dealloc];
}

- (void)resetSelectedContact:(NSMutableArray*)aContactList {
    self.flagsSelectedContactDataManager.displayList = aContactList;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.flagsSelectedContactDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSMutableDictionary* tmpContactDict = [self.flagsSelectedContactDataManager.displayList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [tmpContactDict objectForKey:@"LocationName"];
    cell.detailTextLabel.text = [tmpContactDict objectForKey:@"Name"];
    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.contentView addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    return cell;
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        NSMutableDictionary* tmpContactDict = [self.flagsSelectedContactDataManager.displayList objectAtIndex:swipedIndexPath.row];
        [tmpContactDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        [self.actionDelegate didSelectFlagsSelectedContactRecord:tmpContactDict];
    }
}

@end
