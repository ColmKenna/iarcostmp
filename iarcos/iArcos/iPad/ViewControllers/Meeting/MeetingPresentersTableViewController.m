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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingPresentersDataManager = [[[MeetingPresentersDataManager alloc] init] autorelease];
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
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.meetingPresentersDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)meetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath {
    [self.meetingPresentersDataManager dataMeetingPresentersLinkToMeeting:aLinkToMeetingFlag atIndexPath:anIndexPath];
}

@end
