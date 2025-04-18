//
//  ArcosCalendarEventEntryDetailTableViewController.m
//  iArcos
//
//  Created by Richard on 12/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailTableViewController.h"

@interface ArcosCalendarEventEntryDetailTableViewController ()

@end

@implementation ArcosCalendarEventEntryDetailTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize presentDelegate = _presentDelegate;
@synthesize arcosCalendarEventEntryDetailDataManager = _arcosCalendarEventEntryDetailDataManager;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize HUD = _HUD;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arcosCalendarEventEntryDetailDataManager = [[[ArcosCalendarEventEntryDetailDataManager alloc] init] autorelease];
        self.tableCellFactory = [[[ArcosCalendarEventEntryDetailTableViewCellFactory alloc] init] autorelease];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.arcosCalendarEventEntryDetailDataManager = [[[ArcosCalendarEventEntryDetailDataManager alloc] init] autorelease];
        self.tableCellFactory = [[[ArcosCalendarEventEntryDetailTableViewCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    
    if ([self.arcosCalendarEventEntryDetailDataManager.actionType isEqualToString:self.arcosCalendarEventEntryDetailDataManager.createText]) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addPressed)];
        [self.navigationItem setRightBarButtonItem:addButton];
        [addButton release];
    } else {
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editPressed)];
        [self.navigationItem setRightBarButtonItem:editButton];
        [editButton release];
    }
}

- (void)dealloc {
//    NSLog(@"ArcosCalendarEventEntryDetailTableViewController dealloc");
    self.arcosCalendarEventEntryDetailDataManager = nil;
    self.tableCellFactory = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    [super dealloc];
}

- (void)cancelPressed {
    [self.presentDelegate didDismissModalPresentViewController];
}

- (void)addPressed {
//    NSLog(@"addPressed");not used
    
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = nil;//[self.arcosCalendarEventEntryDetailDataManager retrieveEventDict];
    NSString* allDayFlag = [eventDict objectForKey:self.arcosCalendarEventEntryDetailDataManager.allDayKey];
    NSMutableDictionary* startResultDict = [eventDict objectForKey:@"start"];
    NSString* startResultData = [startResultDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startResultData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
    NSMutableDictionary* endResultDict = [eventDict objectForKey:@"end"];
    NSString* endResultData = [endResultDict objectForKey:@"dateTime"];
    NSDate* endDate = [ArcosUtils dateFromString:endResultData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
    if ([allDayFlag isEqualToString:@"true"] && [endDate compare:startDate] != NSOrderedDescending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    if ([endDate compare:startDate] == NSOrderedAscending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    __weak typeof(self) weakSelf = self;
    
    
    NSError* auxError = nil;
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:eventDict options:NSJSONWritingPrettyPrinted error:&auxError];
//    NSLog(@"aux %@", auxError);
    
    [request setHTTPBody:payloadData];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"response status code: %d", statusCode);
            if (statusCode != 201) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"test %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.refreshDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
    
}

- (void)editPressed {
//    NSLog(@"editPressed");not used
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = nil;//[self.arcosCalendarEventEntryDetailDataManager retrieveEditEventDict];
    if ([eventDict count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSString* allDayFlag = [eventDict objectForKey:self.arcosCalendarEventEntryDetailDataManager.allDayKey];
    if (allDayFlag == nil) {
        NSString* originalAllDayInt = [self.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"IsAllDay"];
        allDayFlag = @"true";
        if (![originalAllDayInt isEqualToString:@"1"]) {
            allDayFlag = @"false";
        }
    }
//    NSLog(@"allDayFlag %@", allDayFlag);
//    NSLog(@"allDayFlag 2 %@ %@", self.arcosCalendarEventEntryDetailDataManager.editEndDate, self.arcosCalendarEventEntryDetailDataManager.editStartDate);
    if ([allDayFlag isEqualToString:@"true"] && [self.arcosCalendarEventEntryDetailDataManager.editEndDate compare:self.arcosCalendarEventEntryDetailDataManager.editStartDate] != NSOrderedDescending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    if ([self.arcosCalendarEventEntryDetailDataManager.editEndDate compare:self.arcosCalendarEventEntryDetailDataManager.editStartDate] == NSOrderedAscending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI, [self.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"Id"]]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"PATCH"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    __weak typeof(self) weakSelf = self;
    
    
    NSError* auxError = nil;
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:eventDict options:NSJSONWritingPrettyPrinted error:&auxError];
//    NSLog(@"aux %@", auxError);
    
    [request setHTTPBody:payloadData];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"response status code: %d", statusCode);
            if (statusCode != 200) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"test %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.refreshDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* cellData = [self.arcosCalendarEventEntryDetailDataManager cellDataWithIndexPath:indexPath];
    if ([[cellData objectForKey:@"CellType"] intValue] == 2) {
        return 138;
    }
    return 44;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arcosCalendarEventEntryDetailDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* tmpSectionTitle = [self.arcosCalendarEventEntryDetailDataManager.sectionTitleList objectAtIndex:section];
    NSMutableArray* tmpDisplayList = [self.arcosCalendarEventEntryDetailDataManager.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.arcosCalendarEventEntryDetailDataManager cellDataWithIndexPath:indexPath];
    ArcosCalendarEventEntryDetailBaseTableViewCell* cell = (ArcosCalendarEventEntryDetailBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (ArcosCalendarEventEntryDetailBaseTableViewCell*)[self.tableCellFactory createEventEntryDetailBaseTableCellWithData:cellData];
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithData:cellData];
    
    return cell;
}

#pragma mark - ArcosCalendarEventEntryDetailBaseTableViewCellDelegate

- (void)detailBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    [self.arcosCalendarEventEntryDetailDataManager dataDetailBaseInputFinishedWithData:aData atIndexPath:anIndexPath];
}

- (void)refreshListWithSwitchReturnValue:(NSString*)aReturnValue {
    [self.arcosCalendarEventEntryDetailDataManager dataRefreshListWithSwitchReturnValue:aReturnValue];
    [[self.actionDelegate retrieveEventTableView] reloadData];
}

- (void)detailDeleteButtonPressed {
    [self.actionDelegate deleteButtonPressedDelegate];
    /*
    void (^deleteActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteEventProcessor];
    };
    void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure you want to delete this event?" title:@"" delegate:nil target:self tag:0 lBtnText:@"Cancel" rBtnText:@"Delete Event" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
    */
}

- (UIViewController*)retrieveCalendarEventEntryDetailParentViewController {
    return [self.actionDelegate retrieveArcosCalendarEventEntryDetailTemplateViewController];
}

- (void)refreshCellRightHandSideBarWithDate:(NSDate*)aDate {
    [self.actionDelegate refreshTableRightHandSideBarWithDate:aDate];
}

- (NSString*)retrieveStartFieldName {
    return self.arcosCalendarEventEntryDetailDataManager.startKey;
}

- (void)resetEndDateWithStartDict:(NSMutableDictionary*)aStartCellDataDict refreshCellRightHandSideTableFlag:(BOOL)aFlag {
    [self.arcosCalendarEventEntryDetailDataManager resetEndDateWithStartDictProcessor:aStartCellDataDict];
    [[self.actionDelegate retrieveEventTableView] reloadData];
    if (aFlag) {
        NSMutableDictionary* startFieldData = [aStartCellDataDict objectForKey:@"FieldData"];
        NSDate* tmpStartDate = [startFieldData objectForKey:@"Date"];
        [self.actionDelegate retrieveOneDayCalendarEventEntriesWithDate:tmpStartDate];
    }
}

- (void)deleteEventProcessor {//not used
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI, [self.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"Id"]]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
            NSLog(@"response status code: %d", statusCode);
            if (statusCode != 204) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSLog(@"test %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.refreshDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

@end
