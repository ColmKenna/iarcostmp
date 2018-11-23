//
//  MeetingExpenseDetailsViewController.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsViewController.h"

@interface MeetingExpenseDetailsViewController ()

@end

@implementation MeetingExpenseDetailsViewController
@synthesize modalDelegate = _modalDelegate;
@synthesize meetingExpenseDetailsDataManager = _meetingExpenseDetailsDataManager;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize myTableView = _myTableView;
@synthesize myNavigationBar = _myNavigationBar;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingExpenseDetailsDataManager = [[[MeetingExpenseDetailsDataManager alloc] init] autorelease];
        [self.meetingExpenseDetailsDataManager createSkeletonData];
        self.tableCellFactory = [[[MeetingExpenseDetailsTableCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.myNavigationBar.topItem.leftBarButtonItem = cancelBarButtonItem;
    [cancelBarButtonItem release];
    
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.myNavigationBar.topItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
    
}

- (void)dealloc {
    self.meetingExpenseDetailsDataManager = nil;
    self.tableCellFactory = nil;
    self.myTableView = nil;
    self.myNavigationBar = nil;
    
    [super dealloc];
}

- (void)cancelButtonPressed {
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)saveButtonPressed {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.meetingExpenseDetailsDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingExpenseDetailsDataManager.displayList objectAtIndex:indexPath.row];
    MeetingExpenseDetailsBaseTableViewCell* cell = (MeetingExpenseDetailsBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (MeetingExpenseDetailsBaseTableViewCell*)[self.tableCellFactory createMeetingExpenseDetailsBaseTableCellWithData:cellData];
    }
    // Configure the cell...
    cell.myIndexPath = indexPath;
    cell.baseDelegate = self;
    [cell configCellWithData:cellData];
    
    return cell;
}

#pragma mark MeetingExpenseDetailsBaseTableViewCellDelegate
- (void)inputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    [self.meetingExpenseDetailsDataManager dataInputFinishedWithData:aData atIndexPath:anIndexPath];
}

@end
