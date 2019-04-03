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
@synthesize actionDelegate = _actionDelegate;
@synthesize meetingAttachmentsDataManager = _meetingAttachmentsDataManager;
@synthesize meetingAttachmentsHeaderViewController = _meetingAttachmentsHeaderViewController;
@synthesize callGenericServices = _callGenericServices;

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
    self.meetingAttachmentsHeaderViewController.actionDelegate = self;
    [self addChildViewController:self.meetingAttachmentsHeaderViewController];
    [self.meetingAttachmentsHeaderViewController didMoveToParentViewController:self];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.view] autorelease];
}

- (void)dealloc {
    self.meetingAttachmentsDataManager = nil;
    self.meetingAttachmentsHeaderViewController = nil;
    [self.meetingAttachmentsHeaderViewController willMoveToParentViewController:nil];
    [self.meetingAttachmentsHeaderViewController.view removeFromSuperview];
    [self.meetingAttachmentsHeaderViewController removeFromParentViewController];
    self.meetingAttachmentsHeaderViewController = nil;
    self.callGenericServices = nil;
    
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
    ArcosAttachmentSummary* auxArcosAttachmentSummary = [self.meetingAttachmentsDataManager cellDataWithIndexPath:indexPath];
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
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
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

#pragma mark MeetingAttachmentsTableViewCellDelegate
- (void)meetingAttachmentsViewButtonPressedWithFileName:(NSString *)aFileName atIndexPath:(NSIndexPath *)anIndexPath {
    self.meetingAttachmentsDataManager.currentFileName = aFileName;
    ArcosAttachmentSummary* auxArcosAttachmentSummary = [self.meetingAttachmentsDataManager cellDataWithIndexPath:anIndexPath];
    if (auxArcosAttachmentSummary.IUR == 0) {
        NSString* auxFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon meetingPath], self.meetingAttachmentsDataManager.currentFileName];
        [self showFileViewControllerWithFilePath:auxFilePath];
        return;
    }
    
    [self.callGenericServices genericGetFromResourcesWithFileName:aFileName action:@selector(setGenericGetFromResourcesResult:) target:self];
}

- (void)setGenericGetFromResourcesResult:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    BOOL saveFileFlag = NO;
    NSString* auxFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon meetingPath], self.meetingAttachmentsDataManager.currentFileName];
    NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
    saveFileFlag = [myNSData writeToFile:auxFilePath atomically:YES];
    if (!saveFileFlag) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Unable to save %@ on the iPad.", self.meetingAttachmentsDataManager.currentFileName] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
    }
    if (!saveFileFlag) return;
    [self showFileViewControllerWithFilePath:auxFilePath];
}

- (void)showFileViewControllerWithFilePath:(NSString*)aFilePath {
    MeetingAttachmentsFileViewController* mafvc = [[MeetingAttachmentsFileViewController alloc] initWithNibName:@"MeetingAttachmentsFileViewController" bundle:nil];
//    mafvc.fileName = self.meetingAttachmentsDataManager.currentFileName;
    mafvc.filePath = aFilePath;
    mafvc.modalDelegate = self;
    UINavigationController* auxNavigationController = [[UINavigationController alloc] initWithRootViewController:mafvc];
    [self presentViewController:auxNavigationController animated:YES completion:nil];
    [auxNavigationController release];
    [mafvc release];
}

- (void)meetingAttachmentsRevertDeleteActionWithIndexPath:(NSIndexPath *)anIndexPath {
    [self.tableView reloadData];
}

- (void)meetingAttachmentsDeleteFinishedWithData:(ArcosAttachmentSummary*)anArcosAttachmentSummary atIndexPath:(NSIndexPath *)anIndexPath {
    self.meetingAttachmentsDataManager.currentSelectedDeleteIndexPath = anIndexPath;
    void (^deleteAttachmentsActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteAttachmentsProcessor];
    };
    void (^cancelAttachmentsActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to delete %@", anArcosAttachmentSummary.FileName] title:@"" delegate:self target:self tag:100 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelAttachmentsActionHandler rBtnHandler:deleteAttachmentsActionHandler];
}

- (void)deleteAttachmentsProcessor {
    NSString* tmpSectionTitle = [self.meetingAttachmentsDataManager.sectionTitleList objectAtIndex:self.meetingAttachmentsDataManager.currentSelectedDeleteIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.meetingAttachmentsDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    ArcosAttachmentSummary* auxArcosAttendeeWithDetails = [tmpDisplayList objectAtIndex:self.meetingAttachmentsDataManager.currentSelectedDeleteIndexPath.row];
    auxArcosAttendeeWithDetails.PCiur = -999;
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex] && alertView.tag == 100) {
        [self deleteAttachmentsProcessor];
    }
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MeetingAttachmentsHeaderViewControllerDelegate
- (UIViewController*)retrieveParentViewController {
    return self;
}

- (NSNumber*)retrieveMeetingAttachmentsHeaderLocationIUR {
    return [self.actionDelegate retrieveMeetingAttachmentsTableLocationIUR];
}

- (void)addMeetingAttachmentsRecordWithFileName:(NSString *)aFileName {
    NSNumber* tmpMeetingIUR = [self.actionDelegate retrieveMeetingAttachmentsMeetingIUR];
    ArcosAttachmentSummary* arcosAttachmentSummary = [[[ArcosAttachmentSummary alloc] init] autorelease];
    
    arcosAttachmentSummary.IUR = 0;
    arcosAttachmentSummary.TableIUR = [tmpMeetingIUR intValue];
    if ([tmpMeetingIUR intValue] > 0) {
        arcosAttachmentSummary.TableName = @"Meeting";
    } else {
        arcosAttachmentSummary.TableName = @"Location";
    }
    arcosAttachmentSummary.FileName = aFileName;
    arcosAttachmentSummary.FileLocation = @"";
    arcosAttachmentSummary.Description = [NSString stringWithFormat:@"Taken on %@'s iPad", [self.meetingAttachmentsDataManager retrieveEmployeeName]];
    arcosAttachmentSummary.LocationIUR = [[self.actionDelegate retrieveMeetingAttachmentsTableLocationIUR] intValue];
    arcosAttachmentSummary.DateAttached = [NSDate date];
    arcosAttachmentSummary.EmployeeIUR = [[SettingManager employeeIUR] intValue];
    arcosAttachmentSummary.PCiur = 0;
    
    NSMutableArray* tmpDisplayList = [self.meetingAttachmentsDataManager.groupedDataDict objectForKey:self.meetingAttachmentsDataManager.attachmentsTitle];
    [tmpDisplayList addObject:arcosAttachmentSummary];
    [self.tableView reloadData];
}

@end
