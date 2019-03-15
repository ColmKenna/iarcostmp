//
//  MeetingAttachmentsTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsTableViewController.h"

@interface MeetingAttachmentsTableViewController ()

@end

@implementation MeetingAttachmentsTableViewController
@synthesize meetingAttachmentsDataManager = _meetingAttachmentsDataManager;
@synthesize meetingAttachmentsHeaderViewController = _meetingAttachmentsHeaderViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingAttachmentsDataManager = [[[MeetingAttachmentsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.meetingAttachmentsHeaderViewController = [[[MeetingAttachmentsHeaderViewController alloc] initWithNibName:@"MeetingAttachmentsHeaderViewController" bundle:nil] autorelease];
    [self addChildViewController:self.meetingAttachmentsHeaderViewController];
    [self.meetingAttachmentsHeaderViewController didMoveToParentViewController:self];
}

- (void)dealloc {
    self.meetingAttachmentsDataManager = nil;
    self.meetingAttachmentsHeaderViewController = nil;
    [self.meetingAttachmentsHeaderViewController willMoveToParentViewController:nil];
    [self.meetingAttachmentsHeaderViewController.view removeFromSuperview];
    [self.meetingAttachmentsHeaderViewController removeFromParentViewController];
    self.meetingAttachmentsHeaderViewController = nil;
    
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.meetingAttachmentsDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* tmpSectionTitle = [self.meetingAttachmentsDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* tmpDisplayList = [self.meetingAttachmentsDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString* sectionTitle = [self.meetingAttachmentsDataManager.sectionTitleList objectAtIndex:section];
    if ([sectionTitle isEqualToString:self.meetingAttachmentsDataManager.emptyTitle]) {
        return self.meetingAttachmentsHeaderViewController.view;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* attachmentsCellIdentifier = @"IdMeetingAttachmentsTableViewCell";
    
    NSString* tmpSectionTitle = [self.meetingAttachmentsDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* tmpDisplayList = [self.meetingAttachmentsDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    ArcosAttachmentSummary* auxArcosAttachmentSummary = [tmpDisplayList objectAtIndex:indexPath.row];
    MeetingAttachmentsTableViewCell* cell = (MeetingAttachmentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:attachmentsCellIdentifier];
    if (cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingAttachmentsTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MeetingAttachmentsTableViewCell class]] && [[(MeetingAttachmentsTableViewCell *)nibItem reuseIdentifier] isEqualToString:attachmentsCellIdentifier]) {
                cell = (MeetingAttachmentsTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
//    cell.actionDelegate = self;
//    cell.myIndexPath = indexPath;
    [cell configCellWithArcosAttachmentSummary:auxArcosAttachmentSummary];
    
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


@end
