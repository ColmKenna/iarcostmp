//
//  MeetingAttendeesTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesTableViewController.h"

@interface MeetingAttendeesTableViewController ()

@end

@implementation MeetingAttendeesTableViewController
@synthesize meetingAttendeesDataManager = _meetingAttendeesDataManager;
@synthesize meetingAttendeesEmployeesHeaderViewController = _meetingAttendeesEmployeesHeaderViewController;
@synthesize meetingAttendeesContactsHeaderViewController = _meetingAttendeesContactsHeaderViewController;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingAttendeesDataManager = [[[MeetingAttendeesDataManager alloc] init] autorelease];
        self.tableCellFactory = [[[MeetingMainTableCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.meetingAttendeesDataManager = nil;
    [self.meetingAttendeesEmployeesHeaderViewController willMoveToParentViewController:nil];
    [self.meetingAttendeesEmployeesHeaderViewController.view removeFromSuperview];
    [self.meetingAttendeesEmployeesHeaderViewController removeFromParentViewController];
    self.meetingAttendeesEmployeesHeaderViewController = nil;
    [self.meetingAttendeesContactsHeaderViewController willMoveToParentViewController:nil];
    [self.meetingAttendeesContactsHeaderViewController.view removeFromSuperview];
    [self.meetingAttendeesContactsHeaderViewController removeFromParentViewController];
    self.meetingAttendeesContactsHeaderViewController = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.meetingAttendeesEmployeesHeaderViewController = [[[MeetingAttendeesEmployeesHeaderViewController alloc] initWithNibName:@"MeetingAttendeesEmployeesHeaderViewController" bundle:nil] autorelease];
    self.meetingAttendeesEmployeesHeaderViewController.actionDelegate = self;
    [self addChildViewController:self.meetingAttendeesEmployeesHeaderViewController];
    [self.meetingAttendeesEmployeesHeaderViewController didMoveToParentViewController:self];
    self.meetingAttendeesContactsHeaderViewController = [[[MeetingAttendeesContactsHeaderViewController alloc] initWithNibName:@"MeetingAttendeesContactsHeaderViewController" bundle:nil] autorelease];
    self.meetingAttendeesContactsHeaderViewController.actionDelegate = self;
    [self addChildViewController:self.meetingAttendeesContactsHeaderViewController];
    [self.meetingAttendeesContactsHeaderViewController didMoveToParentViewController:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.meetingAttendeesDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* tmpSectionTitle = [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* tmpDisplayList = [self.meetingAttendeesDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString* sectionTitle = [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:section];
    if ([sectionTitle isEqualToString:self.meetingAttendeesDataManager.emptyTitle]) {
        return self.meetingAttendeesEmployeesHeaderViewController.view;
    }
    if ([sectionTitle isEqualToString:self.meetingAttendeesDataManager.employeeTitle]) {
        return self.meetingAttendeesContactsHeaderViewController.view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingAttendeesDataManager cellDataWithIndexPath:indexPath];
    MeetingBaseTableViewCell* cell = (MeetingBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (MeetingBaseTableViewCell*)[self.tableCellFactory createMeetingBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
//    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithData:cellData];
    
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

#pragma mark MeetingAttendeesEmployeesHeaderViewControllerDelegate
- (void)meetingAttendeesEmployeesOperationDone:(NSMutableArray *)selectedEmployeeList {
    NSMutableArray* currentEmployeeList = [self.meetingAttendeesDataManager.groupedDataDict  objectForKey:self.meetingAttendeesDataManager.employeeTitle];
    for (int i = 0; i < [selectedEmployeeList count]; i++) {
        NSMutableDictionary* selectedEmployeeDict = [selectedEmployeeList objectAtIndex:i];
        NSNumber* selectedEmployeeIUR = [selectedEmployeeDict objectForKey:@"IUR"];
        BOOL foundFlag = NO;
        for (int j = 0; j < [currentEmployeeList count]; j++) {
            NSMutableDictionary* currentEmployeeDict = [currentEmployeeList objectAtIndex:j];
            NSNumber* currentEmployeeIUR = [currentEmployeeDict objectForKey:@"IUR"];
            if ([selectedEmployeeIUR isEqualToNumber:currentEmployeeIUR]) {
                foundFlag = YES;
                break;
            }
        }
        if (!foundFlag) {
            [currentEmployeeList addObject:selectedEmployeeDict];
        }
    }
    NSSortDescriptor* foreNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"ForeName" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [currentEmployeeList sortUsingDescriptors:[NSArray arrayWithObjects:foreNameDescriptor,nil]];
    [self.meetingAttendeesDataManager processAttendeesEmployeesCellDataDictList:currentEmployeeList];
    [self.meetingAttendeesDataManager.groupedDataDict setObject:currentEmployeeList forKey:self.meetingAttendeesDataManager.employeeTitle];
    [self.tableView reloadData];
}

#pragma mark MeetingAttendeesContactsHeaderViewControllerDelegate
- (UIViewController*)retrieveParentViewController {
    return self;
}


@end
