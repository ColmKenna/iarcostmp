//
//  MeetingDetailsTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingDetailsTableViewController.h"

@interface MeetingDetailsTableViewController ()

@end

@implementation MeetingDetailsTableViewController
@synthesize meetingDetailsDataManager = _meetingDetailsDataManager;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingDetailsDataManager = [[[MeetingDetailsDataManager alloc] init] autorelease];
        [self.meetingDetailsDataManager createBasicData];
        self.tableCellFactory = [[[MeetingMainTableCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    self.meetingDetailsDataManager = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* cellData = [self.meetingDetailsDataManager.displayList objectAtIndex:indexPath.row];
    if ([[cellData objectForKey:@"CellType"] intValue] == 5) {
        return 124;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.meetingDetailsDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingDetailsDataManager.displayList objectAtIndex:indexPath.row];
    MeetingBaseTableViewCell* cell = (MeetingBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (MeetingBaseTableViewCell*)[self.tableCellFactory createMeetingBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    [cell configCellWithData:cellData];
    
    return cell;
}

#pragma mark MeetingBaseTableViewCellDelegate
- (NSMutableDictionary*)retrieveHeadOfficeDataObjectDict {
    return self.meetingDetailsDataManager.headOfficeDataObjectDict;
}

- (void)meetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    
}



@end
