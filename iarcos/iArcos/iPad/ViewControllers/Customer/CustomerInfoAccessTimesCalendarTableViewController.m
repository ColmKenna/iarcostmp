//
//  CustomerInfoAccessTimesCalendarTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarTableViewController.h"

@interface CustomerInfoAccessTimesCalendarTableViewController ()

@end

@implementation CustomerInfoAccessTimesCalendarTableViewController
@synthesize cancelDelegate = _cancelDelegate;
@synthesize actionDelegate = _actionDelegate;
@synthesize calendarHeaderView = _calendarHeaderView;
@synthesize calendarDataManager = _calendarDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize accessTimesCalendarType = _accessTimesCalendarType;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        self.calendarDataManager = [[[CustomerInfoAccessTimesCalendarDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Access Times";
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    if (self.accessTimesCalendarType == AccessTimesCalendarTypeDefault) {
        UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
        [self.navigationItem setRightBarButtonItem:saveButton];
        [saveButton release];
    }
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
    
}

- (void)cancelPressed:(id)sender {
    [self.cancelDelegate didDismissSelectionCancelPopover];
}

- (void)savePressed:(id)sender {
    NSString* auxAccessTimes = [self.calendarDataManager saveButtonPressed];
    if ([auxAccessTimes isEqualToString:[self.calendarDataManager.recordDataDict objectForKey:@"Access Times"]]) {
        [ArcosUtils showDialogBox:@"There is no change" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    [self.calendarDataManager.baseDataManager saveAccessTimesToDB:auxAccessTimes iur:[self.calendarDataManager.recordDataDict objectForKey:self.calendarDataManager.iURName]];
    [self.calendarDataManager.baseDataManager updateResultWithNumber:[NSNumber numberWithInt:99] iur:[self.calendarDataManager.recordDataDict objectForKey:self.calendarDataManager.iURName]];
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
    [self.callGenericServices updateRecord:self.calendarDataManager.tableName iur:[[self.calendarDataManager.recordDataDict objectForKey:self.calendarDataManager.iURName] intValue] fieldName:@"AccessTimes" newContent:auxAccessTimes];
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.calendarDataManager.baseDataManager updateResultWithNumber:[NSNumber numberWithInt:0] iur:[self.calendarDataManager.recordDataDict objectForKey:self.calendarDataManager.iURName]];
        [self.actionDelegate closeCalendarPopoverViewController];
    } else if(result.ErrorModel.Code <= 0) {
        [self.calendarDataManager.baseDataManager updateResultWithNumber:[NSNumber numberWithInt:99] iur:[self.calendarDataManager.recordDataDict objectForKey:self.calendarDataManager.iURName]];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}
- (UIViewController*)retrieveCallGenericServicesParentViewController {
    return self;
}

- (void)dealloc {
    self.calendarHeaderView = nil;
    self.calendarDataManager = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.calendarDataManager.sectionList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.calendarHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* calendarCellIdentifier = @"IdCustomerInfoAccessTimesCalendarTableViewCell";
    
    CustomerInfoAccessTimesCalendarTableViewCell* cell = (CustomerInfoAccessTimesCalendarTableViewCell*) [tableView dequeueReusableCellWithIdentifier:calendarCellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerInfoAccessTimesCalendarTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerInfoAccessTimesCalendarTableViewCell class]] && [[(CustomerInfoAccessTimesCalendarTableViewCell *)nibItem reuseIdentifier] isEqualToString: calendarCellIdentifier]) {
                cell = (CustomerInfoAccessTimesCalendarTableViewCell*) nibItem;
                break;
            }
        }
    }
    cell.actionDelegate = self;
    cell.indexPath = indexPath;
    NSMutableDictionary* sectionData = [self.calendarDataManager.sectionList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithData:self.calendarDataManager.groupDataDict sectionData:sectionData];
    
    return cell;
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewCellDelegate
- (void)inputFinishedWithIndexPath:(NSIndexPath *)anIndexPath labelIndex:(int)aLabelIndex colorType:(NSNumber *)aColorType {
    [self.calendarDataManager updateInputWithIndexPath:anIndexPath labelIndex:aLabelIndex colorType:aColorType];
    [self.tableView reloadData];
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



@end
