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
@synthesize refreshDelegate = _refreshDelegate;
@synthesize presentDelegate = _presentDelegate;
@synthesize arcosCalendarEventEntryDetailDataManager = _arcosCalendarEventEntryDetailDataManager;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize HUD = _HUD;

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
    NSLog(@"ArcosCalendarEventEntryDetailTableViewController dealloc");
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
    NSLog(@"addPressed");
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = [self.arcosCalendarEventEntryDetailDataManager retrieveEventDict];
    NSMutableDictionary* startResultDict = [eventDict objectForKey:@"start"];
    NSString* startResultData = [startResultDict objectForKey:@"dateTime"];
    NSDate* startDate = [ArcosUtils dateFromString:startResultData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
    NSMutableDictionary* endResultDict = [eventDict objectForKey:@"end"];
    NSString* endResultData = [endResultDict objectForKey:@"dateTime"];
    NSDate* endDate = [ArcosUtils dateFromString:endResultData format:[GlobalSharedClass shared].stdUtcDateTimeFormat];
    
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
    NSLog(@"aux %@", auxError);
    
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
                    [weakSelf.refreshDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)editPressed {
    NSLog(@"editPressed");
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
    return 38.0f;
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
    [self.tableView reloadData];
}


@end
