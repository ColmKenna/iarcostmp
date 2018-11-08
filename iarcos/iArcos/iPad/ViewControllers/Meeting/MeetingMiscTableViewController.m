//
//  MeetingMiscTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMiscTableViewController.h"

@interface MeetingMiscTableViewController ()

@end

@implementation MeetingMiscTableViewController
@synthesize meetingMiscDataManager = _meetingMiscDataManager;
@synthesize sectionViewFactory = _sectionViewFactory;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingMiscDataManager = [[[MeetingMiscDataManager alloc] init] autorelease];
        [self.meetingMiscDataManager createBasicData];
        self.sectionViewFactory = [[[MeetingMainSectionViewFactory alloc] init] autorelease];
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
    self.meetingMiscDataManager = nil;
    self.sectionViewFactory = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.meetingMiscDataManager.sectionTitleList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingMiscDataManager cellDataWithIndexPath:indexPath];
    if ([[cellData objectForKey:@"CellType"] intValue] == 5) {
        return 124;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }
    return [self.meetingMiscDataManager.sectionTitleList objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* tmpSectionTitle = [self.meetingMiscDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* tmpDisplayList = [self.meetingMiscDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingMiscDataManager cellDataWithIndexPath:indexPath];    
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
    return self.meetingMiscDataManager.headOfficeDataObjectDict;
}


@end
