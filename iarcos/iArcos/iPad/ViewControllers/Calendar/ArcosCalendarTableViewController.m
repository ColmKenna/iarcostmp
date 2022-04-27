//
//  ArcosCalendarTableViewController.m
//  iArcos
//
//  Created by Richard on 15/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarTableViewController.h"
#import "ArcosRootViewController.h"

@interface ArcosCalendarTableViewController ()

@end

@implementation ArcosCalendarTableViewController
@synthesize arcosCalendarTableDataManager = _arcosCalendarTableDataManager;
@synthesize arcosCalendarTableHeaderView = _arcosCalendarTableHeaderView;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize HUD = _HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[UIColor whiteColor]];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    } else {
        // Fallback on earlier versions
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    }
    self.arcosCalendarTableDataManager = [[[ArcosCalendarTableDataManager alloc] init] autorelease];
    UIBarButtonItem* todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(todayPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithCapacity:1];
    [leftButtonList addObject:todayButton];
    [todayButton release];
    UIBarButtonItem* prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous.png"] style:UIBarButtonItemStylePlain target:self action:@selector(prevPressed:)];
    [leftButtonList addObject:prevButton];
    [prevButton release];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPressed:)];
    [leftButtonList addObject:nextButton];
    [nextButton release];
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    [self showCurrentMonth];
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)dealloc {
    self.arcosCalendarTableDataManager = nil;
    self.arcosCalendarTableHeaderView = nil;
    self.arcosRootViewController = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[UIColor whiteColor]];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    } else {
        // Fallback on earlier versions
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[UIColor colorWithRed:0.0 green:150.0/255.0 blue:214.0/255.0 alpha:1.0]];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    } else {
        // Fallback on earlier versions
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0 green:150.0/255.0 blue:214.0/255.0 alpha:1.0]];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)todayPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [self.arcosCalendarTableDataManager createThirdDayNoonDateWithDate:self.arcosCalendarTableDataManager.todayDate thirdDayFlag:YES];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.tableView reloadData];
    [self showCurrentMonth];
}

- (void)prevPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [ArcosUtils addMonths:-1 date:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.tableView reloadData];
    [self showCurrentMonth];
    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)nextPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [ArcosUtils addMonths:1 date:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.tableView reloadData];
    [self showCurrentMonth];
    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)showCurrentMonth {
    self.title = [NSString stringWithFormat:@"%@", [ArcosUtils stringFromDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate format:@"MMMM yyyy"]];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.arcosCalendarTableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
    float diff = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height + 44;
    
    return (parentNavigationRect.size.height - diff) / 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arcosCalendarTableDataManager.matrixDataList count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IdArcosCalendarTableViewCell";
    
    ArcosCalendarTableViewCell* cell = (ArcosCalendarTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosCalendarTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ArcosCalendarTableViewCell class]] && [[(ArcosCalendarTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (ArcosCalendarTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    [cell makeCellReadyToUse];
    NSMutableDictionary* weekDataDict = [self.arcosCalendarTableDataManager.matrixDataList objectAtIndex:indexPath.row];
    for (int i = 0; i < [self.arcosCalendarTableDataManager.weekdaySeqList count]; i++) {
        NSNumber* weekDay = [self.arcosCalendarTableDataManager.weekdaySeqList objectAtIndex:i];
        NSMutableDictionary* dayDataDict = [weekDataDict objectForKey:weekDay];
        if (dayDataDict != nil) {
            NSNumber* day = [dayDataDict objectForKey:@"Day"];
            UILabel* auxLabel = [cell.labelList objectAtIndex:i];
            auxLabel.text = [day stringValue];
            NSDate* auxDate = [dayDataDict objectForKey:@"Date"];
            if ([auxDate compare:self.arcosCalendarTableDataManager.todayDate] == NSOrderedAscending) {
                UIView* auxView = [cell.viewList objectAtIndex:i];
                auxView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:0.5];
            }
            NSMutableArray* eventDataList = [dayDataDict objectForKey:@"Event"];
            if ([eventDataList count] > 1) {
                NSSortDescriptor* startDateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES selector:@selector(compare:)] autorelease];
                [eventDataList sortUsingDescriptors:[NSArray arrayWithObjects:startDateDescriptor, nil]];
            }            
            ArcosCalendarCellBaseTableViewDataManager* baseTableViewDataManager = [cell.dataManagerList objectAtIndex:i];
            baseTableViewDataManager.displayList = eventDataList;
            UITableView* auxTableView = [cell.tableViewList objectAtIndex:i];
            [auxTableView reloadData];
        }
    }
//    for (int i = 0; i < 2; i++) {
//        NSNumber* weekDay = [self.arcosCalendarTableDataManager.weekdaySeqList objectAtIndex:i];
//        NSMutableDictionary* dayDataDict = [weekDataDict objectForKey:weekDay];
//        if (dayDataDict != nil) {
//            NSMutableArray* eventDataList = [dayDataDict objectForKey:@"Event"];
//            ArcosCalendarCellBaseTableViewDataManager* baseTableViewDataManager = [cell.dataManagerList objectAtIndex:i];
//            baseTableViewDataManager.displayList = eventDataList;
//            UITableView* auxTableView = [cell.tableViewList objectAtIndex:i];
//            [auxTableView reloadData];
//        }
//    }
    
    return cell;
}

- (void)retrieveCalendarEntriesWithDate:(NSDate*)aDate {
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.HUD hide:YES];
        return;
    }
    [self.HUD show:YES];
    __weak typeof(self) weakSelf = self;
    NSURL* url = [NSURL URLWithString:[self.arcosCalendarTableDataManager retrieveCalendarURIWithDate:aDate]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"outlook.timezone=\"Europe/Dublin\"" forHTTPHeaderField:@"Prefer"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
//            NSLog(@"sendMsg error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
            });
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int statusCode = [ArcosUtils convertNSIntegerToInt:[httpResponse statusCode]];
//            NSLog(@"sendMsg response status code: %d", statusCode);
            if (statusCode != 200) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries test %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSDictionary* errorResultDict = [resultDict objectForKey:@"error"];
                NSString* errorMsg = [errorResultDict objectForKey:@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hide:YES];
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* eventDict = [eventList objectAtIndex:i];
                    [self.arcosCalendarTableDataManager populateCalendarEntryWithData:eventDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [weakSelf.HUD hide:YES];                    
                });
            }
        }
    }];
    [downloadTask resume];
}



@end
