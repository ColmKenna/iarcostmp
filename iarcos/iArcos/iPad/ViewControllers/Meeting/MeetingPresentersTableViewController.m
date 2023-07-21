//
//  MeetingPresentersTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 11/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersTableViewController.h"

@interface MeetingPresentersTableViewController ()

@end

@implementation MeetingPresentersTableViewController
@synthesize meetingPresentersDataManager = _meetingPresentersDataManager;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingPresentersDataManager = [[[MeetingPresentersDataManager alloc] init] autorelease];
        self.tableCellFactory = [[[MeetingPresentersTableCellFactory alloc] init] autorelease];
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
    self.meetingPresentersDataManager = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.meetingPresentersDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    static NSString* presenterCellIdentifier = @"IdMeetingPresentersTableViewCell";
    ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [self.meetingPresentersDataManager.displayList objectAtIndex:indexPath.row];
    MeetingPresentersTableViewCell* cell = (MeetingPresentersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:presenterCellIdentifier];
    if (cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingPresentersTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MeetingPresentersTableViewCell class]] && [[(MeetingPresentersTableViewCell *)nibItem reuseIdentifier] isEqualToString:presenterCellIdentifier]) {
                cell = (MeetingPresentersTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithArcosPresenterForMeeting:auxArcosPresenterForMeeting];
     */
    MeetingPresentersCompositeObject* cellData = [self.meetingPresentersDataManager.displayList objectAtIndex:indexPath.row];
    MeetingPresentersBaseTableViewCell* cell = (MeetingPresentersBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (MeetingPresentersBaseTableViewCell*)[self.tableCellFactory createMeetingPresentersBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithMeetingPresentersCompositeObject:cellData];
    
    return cell;
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

- (void)reloadCustomiseTableView {
    [self.tableView reloadData];
}

#pragma mark MeetingPresentersTableViewCellDelegate
- (void)presenterHeaderPressedWithIndexPath:(NSIndexPath*)anIndexpath {
    MeetingPresentersCompositeObject* cellData = [self.meetingPresentersDataManager.displayList objectAtIndex:anIndexpath.row];
    BOOL openFlag = [cellData.openFlag boolValue];
    if ([cellData.cellType intValue] == 2) return;
    [self.meetingPresentersDataManager resetBranchData];
    cellData.openFlag = [NSNumber numberWithBool:!openFlag];
    
    self.meetingPresentersDataManager.displayList = [NSMutableArray array];
    for (int i = 0; i < [self.meetingPresentersDataManager.originalPresentationsDisplayList count]; i++) {
        MeetingPresentersCompositeObject* tmpCellData = [self.meetingPresentersDataManager.originalPresentationsDisplayList objectAtIndex:i];
        [self.meetingPresentersDataManager.displayList addObject:tmpCellData];
        BOOL tmpOpenFlag = [tmpCellData.openFlag boolValue];
        if (tmpOpenFlag) {
            NSMutableArray* tmpLeafDataList = [self.meetingPresentersDataManager.presentationsHashMap objectForKey:[NSNumber numberWithInt:tmpCellData.presenterData.Locationiur]];
            for (int j = 0; j < [tmpLeafDataList count]; j++) {
                MeetingPresentersCompositeObject* tmpMeetingPresentersCompositeObject = [[MeetingPresentersCompositeObject alloc] initPresenterWithData:[tmpLeafDataList objectAtIndex:j]];
                [self.meetingPresentersDataManager.displayList addObject:tmpMeetingPresentersCompositeObject];
                [tmpMeetingPresentersCompositeObject release];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)meetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath {
    [self.meetingPresentersDataManager dataMeetingPresentersLinkToMeeting:aLinkToMeetingFlag atIndexPath:anIndexPath];
    [self.tableView reloadData];
}

- (BOOL)meetingPresenterParentHasShownChild:(int)aLocationIUR {
    return [self.meetingPresentersDataManager meetingPresenterParentHasShownChildProcessor:aLocationIUR];
}

@end
