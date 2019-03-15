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
@synthesize meetingAttendeesOthersHeaderViewController = _meetingAttendeesOthersHeaderViewController;
//@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingAttendeesDataManager = [[[MeetingAttendeesDataManager alloc] init] autorelease];
//        self.tableCellFactory = [[[MeetingMainTableCellFactory alloc] init] autorelease];
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
    [self.meetingAttendeesOthersHeaderViewController willMoveToParentViewController:nil];
    [self.meetingAttendeesOthersHeaderViewController.view removeFromSuperview];
    [self.meetingAttendeesOthersHeaderViewController removeFromParentViewController];
    self.meetingAttendeesOthersHeaderViewController = nil;
//    self.tableCellFactory = nil;
    
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
    self.meetingAttendeesOthersHeaderViewController = [[[MeetingAttendeesOthersHeaderViewController alloc] initWithNibName:@"MeetingAttendeesOthersHeaderViewController" bundle:nil] autorelease];
    self.meetingAttendeesOthersHeaderViewController.actionDelegate = self;
    [self addChildViewController:self.meetingAttendeesOthersHeaderViewController];
    [self.meetingAttendeesOthersHeaderViewController didMoveToParentViewController:self];
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
    if ([sectionTitle isEqualToString:self.meetingAttendeesDataManager.contactTitle]) {
        return self.meetingAttendeesOthersHeaderViewController.view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* attendeeCellIdentifier = @"IdMeetingAttendeesTableViewCell";
    ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [self.meetingAttendeesDataManager cellDataWithIndexPath:indexPath];
    MeetingAttendeesTableViewCell* cell = (MeetingAttendeesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:attendeeCellIdentifier];
    if (cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingAttendeesTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MeetingAttendeesTableViewCell class]] && [[(MeetingAttendeesTableViewCell *)nibItem reuseIdentifier] isEqualToString:attendeeCellIdentifier]) {
                cell = (MeetingAttendeesTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithArcosAttendeeWithDetails:auxArcosAttendeeWithDetails];
    
    return cell;
}

#pragma mark MeetingBaseTableViewCellDelegate
- (NSMutableDictionary*)retrieveHeadOfficeDataObjectDict {
    return nil;
}

- (void)meetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    
}

- (void)meetingAttendeeEmployeeSelectFinishedWithData:(id)aData atIndexPath:(NSIndexPath *)anIndexPath {
    self.meetingAttendeesDataManager.currentSelectedCellData = aData;
    self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath = anIndexPath;
    void (^deleteEmployeeActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteEmployeeProcessor];
    };
    void (^cancelEmployeeActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to delete %@", [aData objectForKey:@"Title"]] title:@"" delegate:self target:self tag:101 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelEmployeeActionHandler rBtnHandler:deleteEmployeeActionHandler];
}

- (void)deleteEmployeeProcessor {
    NSString* tmpSectionTitle = [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.meetingAttendeesDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    [tmpDisplayList removeObjectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.row];
    [self.tableView reloadData];
}

- (void)meetingAttendeeContactSelectFinishedWithData:(id)aData atIndexPath:(NSIndexPath *)anIndexPath {
    self.meetingAttendeesDataManager.currentSelectedCellData = aData;
    self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath = anIndexPath;
    void (^deleteContactActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteContactProcessor];
    };
    void (^cancelContactActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to delete %@", [aData objectForKey:@"Name"]] title:@"" delegate:self target:self tag:100 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelContactActionHandler rBtnHandler:deleteContactActionHandler];
}

- (void)deleteContactProcessor {
    NSString* tmpSectionTitle = [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.meetingAttendeesDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    [tmpDisplayList removeObjectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.row];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex] && alertView.tag == 100) {
        [self deleteContactProcessor];
    }
    if (buttonIndex != [alertView cancelButtonIndex] && alertView.tag == 101) {
        [self deleteEmployeeProcessor];
    }
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
            ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [currentEmployeeList objectAtIndex:j];
            NSNumber* currentEmployeeIUR = [NSNumber numberWithInt:arcosAttendeeWithDetails.EmployeeIUR];
            if ([selectedEmployeeIUR isEqualToNumber:currentEmployeeIUR]) {
                foundFlag = YES;
                break;
            }
        }
        if (!foundFlag) {
            [currentEmployeeList addObject:[self.meetingAttendeesDataManager attendeeAdaptorWithEmployee:selectedEmployeeDict]];
        }
    }
    NSSortDescriptor* foreNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [currentEmployeeList sortUsingDescriptors:[NSArray arrayWithObjects:foreNameDescriptor,nil]];
    [self.meetingAttendeesDataManager.groupedDataDict setObject:currentEmployeeList forKey:self.meetingAttendeesDataManager.employeeTitle];
    [self.tableView reloadData];
}

#pragma mark MeetingAttendeesContactsHeaderViewControllerDelegate
- (UIViewController*)retrieveParentViewController {
    return self;
}

- (void)meetingAttendeesDidSelectContactSelectionListing:(NSMutableArray *)selectedContactList {
    NSMutableArray* currentContactList = [self.meetingAttendeesDataManager.groupedDataDict  objectForKey:self.meetingAttendeesDataManager.contactTitle];
    for (int i = 0; i < [selectedContactList count]; i++) {
        NSMutableDictionary* selectedContactDict = [selectedContactList objectAtIndex:i];
        NSNumber* selectedContactIUR = [selectedContactDict objectForKey:@"ContactIUR"];
        BOOL foundFlag = NO;
        for (int j = 0; j < [currentContactList count]; j++) {
            ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [currentContactList objectAtIndex:j];
            NSNumber* currentContactIUR = [NSNumber numberWithInt:arcosAttendeeWithDetails.ContactIUR];
            if ([currentContactIUR isEqualToNumber:selectedContactIUR]) {
                foundFlag = YES;
                break;
            }
        }
        if (!foundFlag) {
            [currentContactList addObject:[self.meetingAttendeesDataManager attendeeAdaptorWithContact:selectedContactDict]];
        }
    }
    NSSortDescriptor* nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [currentContactList sortUsingDescriptors:[NSArray arrayWithObjects:nameDescriptor,nil]];
    [self.meetingAttendeesDataManager.groupedDataDict setObject:currentContactList forKey:self.meetingAttendeesDataManager.contactTitle];
    [self.tableView reloadData];
}

#pragma mark MeetingAttendeesOthersHeaderViewControllerDelegate
- (void)meetingAttendeesOthersWithName:(NSString*)aName organisation:(NSString*)anOrganisation {
    NSMutableArray* currentOthersList = [self.meetingAttendeesDataManager.groupedDataDict  objectForKey:self.meetingAttendeesDataManager.otherTitle];
//    BOOL foundFlag = NO;
//    for (int i = 0; i < [currentOthersList count]; i++) {
//        ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [currentOthersList objectAtIndex:i];
//        NSString* currentName = arcosAttendeeWithDetails.Name;
//        NSString* currentOrganisation = arcosAttendeeWithDetails.Organisation;
//        if ([currentName isEqualToString:aName] && [currentOrganisation isEqualToString:anOrganisation]) {
//            foundFlag = YES;
//        }
//    }
//    if (!foundFlag) {
//
//    }
    [currentOthersList addObject:[self.meetingAttendeesDataManager attendeeOtherAdaptorWithName:aName organisation:anOrganisation]];
    
    NSSortDescriptor* nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [currentOthersList sortUsingDescriptors:[NSArray arrayWithObjects:nameDescriptor,nil]];
    [self.tableView reloadData];
}

- (void)reloadCustomiseTableView {
    [self.tableView reloadData];
}

#pragma mark MeetingAttendeesTableViewCellDelegate
- (void)meetingAttendeeSelectFinishedWithData:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails indexPath:(NSIndexPath*)anIndexPath {
    self.meetingAttendeesDataManager.currentSelectedArcosAttendeeWithDetails = anArcosAttendeeWithDetails;
    self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath = anIndexPath;
    void (^deleteAttendeeActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteAttendeeProcessor];
    };
    void (^cancelAttendeeActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to delete %@", anArcosAttendeeWithDetails.Name] title:@"" delegate:self target:self tag:100 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelAttendeeActionHandler rBtnHandler:deleteAttendeeActionHandler];
}

- (void)deleteAttendeeProcessor {
    NSString* tmpSectionTitle = [self.meetingAttendeesDataManager.sectionTitleList objectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.meetingAttendeesDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [tmpDisplayList objectAtIndex:self.meetingAttendeesDataManager.currentSelectedDeleteIndexPath.row];
    auxArcosAttendeeWithDetails.COiur = -999;
    [self.tableView reloadData];
}

- (void)meetingAttendeeRevertDeleteActionWithIndexPath:(NSIndexPath*)anIndexPath {
    [self.tableView reloadData];
}

- (void)meetingAttendeesInformedFlag:(BOOL)anInformedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    [self.meetingAttendeesDataManager dataMeetingAttendeesInformedFlag:anInformedFlag atIndexPath:anIndexPath];
}

- (void)meetingAttendeesConfirmedFlag:(BOOL)aConfirmedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    [self.meetingAttendeesDataManager dataMeetingAttendeesConfirmedFlag:aConfirmedFlag atIndexPath:anIndexPath];
}

- (void)meetingAttendeesAttendedFlag:(BOOL)anAttendedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    [self.meetingAttendeesDataManager dataMeetingAttendeesAttendedFlag:anAttendedFlag atIndexPath:anIndexPath];
}

@end
