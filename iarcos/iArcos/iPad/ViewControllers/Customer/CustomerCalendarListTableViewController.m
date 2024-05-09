//
//  CustomerCalendarListTableViewController.m
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerCalendarListTableViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@interface CustomerCalendarListTableViewController ()

@end

@implementation CustomerCalendarListTableViewController
@synthesize HUD = _HUD;
@synthesize customerCalendarListDataManager = _customerCalendarListDataManager;
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize checkLocationIURTemplateProcessor = _checkLocationIURTemplateProcessor;
@synthesize customerCalendarListHeaderView = _customerCalendarListHeaderView;
@synthesize detailingCalendarEventBoxViewDataManager = _detailingCalendarEventBoxViewDataManager;
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize calendarUtilityDataManager = _calendarUtilityDataManager;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize globalNavigationController = _globalNavigationController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.customerCalendarListDataManager = [[[CustomerCalendarListDataManager alloc] init] autorelease];
        self.detailingCalendarEventBoxViewDataManager = [[[DetailingCalendarEventBoxViewDataManager alloc] init] autorelease];
        self.customerJourneyDataManager = [[[CustomerJourneyDataManager alloc] init] autorelease];
        self.calendarUtilityDataManager = [[[CalendarUtilityDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List3.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithObjects:backButton, nil];
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    [backButton release];
    self.mySegmentedControl = [[[ArcosNoBgSegmentedControl alloc] initWithItems:self.customerCalendarListDataManager.statusItems] autorelease];
    
    @try {
        [self.mySegmentedControl setImage:[UIImage imageNamed:@"Arrow-DoubleBackward.png"] forSegmentAtIndex:0];
        [self.mySegmentedControl setImage:[UIImage imageNamed:@"Arrow-Back.png"] forSegmentAtIndex:1];
        [self.mySegmentedControl setImage:[UIImage imageNamed:@"Arrow-Forward.png"] forSegmentAtIndex:3];
        [self.mySegmentedControl setImage:[UIImage imageNamed:@"Arrow-DoubleForward.png"] forSegmentAtIndex:4];
    } @catch (NSException *exception) {
        
    }    
    [self.mySegmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.mySegmentedControl.frame = CGRectMake(0, 0, 300, 30);
    self.mySegmentedControl.momentary = YES;
    self.navigationItem.titleView = self.mySegmentedControl;
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    self.customerCalendarListDataManager.startDatePointer = [NSDate date];
    self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
    self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.startDatePointer];
    self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
    [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
    self.checkLocationIURTemplateProcessor = [[[CheckLocationIURTemplateProcessor alloc] initWithParentViewController:self] autorelease];
    self.checkLocationIURTemplateProcessor.delegate = self;
}

- (void)backButtonPressed:(id)sender {
    [self filterPressed:sender];
}

- (void)dealloc {    
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.customerCalendarListDataManager = nil;
    self.mySegmentedControl = nil;
    self.checkLocationIURTemplateProcessor = nil;
    self.customerCalendarListHeaderView = nil;
    self.detailingCalendarEventBoxViewDataManager = nil;
    self.customerJourneyDataManager = nil;
    self.calendarUtilityDataManager = nil;
    self.arcosRootViewController = nil;
    self.globalNavigationController = nil;
    
    [super dealloc];
}

- (void)segmentedControlAction:(id)sender {
    UISegmentedControl* tmpSegmentedControl = (UISegmentedControl*)sender;
    switch (tmpSegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addDays:-7 date:self.customerCalendarListDataManager.startDatePointer];
            self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListDataManager.startDatePointer = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
            [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
            [self.tableView reloadData];
        }
            break;
        case 1: {
            self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addDays:-1 date:self.customerCalendarListDataManager.startDatePointer];
            self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListDataManager.startDatePointer = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
            [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
        }
            break;
        case 2: {
            self.customerCalendarListDataManager.startDatePointer = [NSDate date];
            self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.startDatePointer];
            self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
            [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
        }
            break;
        case 3: {
            self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.startDatePointer];
            self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListDataManager.startDatePointer = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
            [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
        }
            break;
        case 4: {
            self.customerCalendarListDataManager.currentStartDate = [ArcosUtils addDays:7 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListDataManager.currentEndDate = [ArcosUtils addDays:1 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListDataManager.startDatePointer = [ArcosUtils addHours:0 date:self.customerCalendarListDataManager.currentStartDate];
            self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
            [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.HUD.frame = self.navigationController.view.bounds;
    }];
}

- (void)retrieveCalendarEventEntriesWithStartDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSString* startDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSString* endDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:anEndDate format:[GlobalSharedClass shared].utcDateFormat]];
//    NSLog(@"xx %@ %@", startDateString, endDateString);
    NSURL* url = [NSURL URLWithString:[self.customerCalendarListDataManager.calendarUtilityDataManager retrieveCalendarURIWithStartDate:startDateString endDate:endDateString]];
//    NSLog(@"absoluteString %@", url.absoluteString);
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"outlook.timezone=\"%@\"", [GlobalSharedClass shared].ieTimeZone] forHTTPHeaderField:@"Prefer"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    
                }];
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
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        
                    }];
                });
            } else {
                self.customerCalendarListDataManager.displayList = [NSMutableArray array];
                self.customerCalendarListDataManager.locationIURList = [NSMutableArray array];
                self.customerCalendarListDataManager.locationIURHashMap = [NSMutableDictionary dictionary];
                self.customerCalendarListDataManager.eventDictList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.eventDictList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.journeyDictList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                if ([eventList count] > 0) {
//                    self.customerCalendarListDataManager.displayList = [NSMutableArray arrayWithArray:eventList];
                    NSString* aDateFormatText = [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].dateFormat];
                    self.customerCalendarListDataManager.eventDictList = [NSMutableArray arrayWithArray:eventList];
                    self.detailingCalendarEventBoxViewDataManager.eventDictList = [NSMutableArray arrayWithArray:eventList];
                    self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];
                    self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [self.calendarUtilityDataManager processDataListWithDateFormatText:aDateFormatText journeyDictList:self.detailingCalendarEventBoxViewDataManager.journeyDictList eventDictList:self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList bodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];
                }
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.customerCalendarListDataManager.calendarUtilityDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([locationIUR intValue] != 0) {
                        [self.customerCalendarListDataManager.locationIURList addObject:locationIUR];
                    }
                }
                
                NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] locationsWithIURList:self.customerCalendarListDataManager.locationIURList];
                for (int i = 0; i < [objectArray count]; i++) {
                    NSDictionary* tmpLocationDict = [objectArray objectAtIndex:i];
                    NSNumber* tmpLocationIUR = [ArcosUtils convertNilToZero:[tmpLocationDict objectForKey:@"LocationIUR"]];
                    if ([tmpLocationIUR intValue] != 0) {
                        [self.customerCalendarListDataManager.locationIURHashMap setObject:tmpLocationIUR forKey:tmpLocationIUR];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [weakSelf.HUD hide:YES];
                });
            }
        }
    }];
    [downloadTask resume];
}


#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.customerCalendarListHeaderView.startdatePointerLabel.text = [ArcosUtils stringFromDate:self.customerCalendarListDataManager.startDatePointer format:@"EEEE dd MMMM yyyy"];
    return self.customerCalendarListHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.customerCalendarListDataManager.eventDictList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IdCustomerCalendarListTableViewCell";
    
    CustomerCalendarListTableViewCell* cell = (CustomerCalendarListTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerCalendarListTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerCalendarListTableViewCell class]] && [[(CustomerCalendarListTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerCalendarListTableViewCell *) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSDictionary* eventDict = [self.customerCalendarListDataManager.eventDictList objectAtIndex:indexPath.row];
    NSNumber* auxLocationIUR = [self.customerCalendarListDataManager.calendarUtilityDataManager retrieveLocationIURWithEventDict:eventDict];
    if ([self.customerCalendarListDataManager.locationIURHashMap objectForKey:auxLocationIUR] != nil) {
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.addressLabel.textColor = [UIColor blackColor];
    } else {
        cell.nameLabel.textColor = [UIColor lightGrayColor];
        cell.addressLabel.textColor = [UIColor lightGrayColor];
    }
    //Location
    NSDictionary* locationDict = [eventDict objectForKey:@"location"];
    cell.nameLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"displayName"]]];
    //Time
    NSDictionary* cellStartDict = [eventDict objectForKey:@"start"];
    NSString* tmpCellStartDateStr = [cellStartDict objectForKey:@"dateTime"];
    NSDate* tmpCellStartDate = [ArcosUtils dateFromString:tmpCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    cell.locationCodeLabel.text = [ArcosUtils stringFromDate:tmpCellStartDate format:[GlobalSharedClass shared].datetimehmFormat];
    
    //Title
    cell.addressLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[eventDict objectForKey:@"subject"]]];
    
    [cell.locationStatusButton setImage:nil forState:UIControlStateNormal];
    [cell.creditStatusButton setImage:nil forState:UIControlStateNormal];
    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [cell.contentView addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [cell.contentView addGestureRecognizer:doubleTap];
    [doubleTap release];
    [singleTap release];
    
    return cell;
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        NSDictionary* eventDict = [self.customerCalendarListDataManager.eventDictList objectAtIndex:swipedIndexPath.row];
        NSNumber* auxLocationIUR = [self.customerCalendarListDataManager.calendarUtilityDataManager retrieveLocationIURWithEventDict:eventDict];
        NSDictionary* locationDict = [eventDict objectForKey:@"location"];
        if ([self.customerCalendarListDataManager.locationIURHashMap objectForKey:auxLocationIUR] != nil) {
            [self.checkLocationIURTemplateProcessor checkLocationIUR:auxLocationIUR locationName:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"displayName"]]] indexPath:swipedIndexPath];
        }
    }
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        
        NSMutableDictionary* cellFieldValueData = [self.detailingCalendarEventBoxViewDataManager.listingDisplayList objectAtIndex:swipedIndexPath.row];
        NSDate* startDate = [cellFieldValueData objectForKey:@"Date"];
        NSString* aDateFormatText = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].dateFormat];
        ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
        ACEEDTVC.actionDelegate = self;
        ACEEDTVC.presentDelegate = self;
        [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditDataWithCellData:cellFieldValueData];
        [self.customerJourneyDataManager processCalendarJourneyData];
        NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
        if (auxJourneyDict != nil) {
            [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
            ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
        }
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.eventDictList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];
        
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:aDateFormatText];
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];
        
        
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].weekdayDateFormat];
        ACEEDTVC.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ACEEDTVC] autorelease];
        [ACEEDTVC release];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.arcosRootViewController addChildViewController:self.globalNavigationController];
        [self.arcosRootViewController.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.arcosRootViewController];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark ArcosCalendarEventEntryDetailTemplateViewControllerDelegate
- (void)refreshCalendarTableViewController {
    [self retrieveCalendarEventEntriesWithStartDate:self.customerCalendarListDataManager.currentStartDate endDate:self.customerCalendarListDataManager.currentEndDate];
}

- (NSString*)retrieveLocationUriTemplateDelegate {
    return @"";
}

- (NSNumber*)retrieveLocationIURTemplateDelegate {
    return [NSNumber numberWithInt:0];
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    NSDictionary* eventDict = [self.customerCalendarListDataManager.displayList objectAtIndex:indexPath.row];
//    NSNumber* auxLocationIUR = [self.customerCalendarListDataManager.calendarUtilityDataManager retrieveLocationIURWithEventDict:eventDict];
//    NSDictionary* locationDict = [eventDict objectForKey:@"location"];
//    if ([self.customerCalendarListDataManager.locationIURHashMap objectForKey:auxLocationIUR] != nil) {
//        [self.checkLocationIURTemplateProcessor checkLocationIUR:auxLocationIUR locationName:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"displayName"]]] indexPath:indexPath];
//    }
    
}

#pragma mark - CheckLocationIURTemplateDelegate
- (void)succeedToCheckSameLocationIUR:(NSIndexPath*)indexPath {
    [GlobalSharedClass shared].startRecordingDate = [NSDate date];
    self.currentIndexPath = indexPath;
    NSMutableDictionary* aCust = [self.customerCalendarListDataManager getCustomerWithIndexPath:indexPath];
    CustomerInfoTableViewController* CITVC=[[CustomerInfoTableViewController alloc]initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
    CITVC.refreshDelegate = self;
    CITVC.title = @"Customer Information Page";
    CITVC.custIUR=[aCust objectForKey:@"LocationIUR"];
    
    UINavigationController* CITVCNavigationController = [[UINavigationController alloc] initWithRootViewController:CITVC];
    [self.rcsStackedController pushNavigationController:CITVCNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
//    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [self.arcosRootViewController.customerMasterViewController processSubMenuByCustomerListing:aCust reqSourceName:self.requestSourceName];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [CITVC release];
    [CITVCNavigationController release];
}
- (void)succeedToCheckNewLocationIUR:(NSIndexPath*)indexPath {
    [self succeedToCheckSameLocationIUR:indexPath];
    [GlobalSharedClass shared].currentSelectedContactIUR = nil;
    [GlobalSharedClass shared].currentSelectedPackageIUR = nil;
    [GlobalSharedClass shared].packageViewCount = 0;
    NSMutableDictionary* aCust = [self.customerCalendarListDataManager getCustomerWithIndexPath:indexPath];
    [self resetCurrentOrderAndWholesaler:[aCust objectForKey:@"LocationIUR"]];
    [self configWholesalerLogo];
    [self syncCustomerContactViewController];
}
- (void)failToCheckLocationIUR:(NSString*)aTitle {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
//    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [self.arcosRootViewController.customerMasterViewController.selectedSubMenuTableViewController selectBottomRecordByTitle:aTitle];
}

#pragma mark GenericRefreshParentContentDelegate
- (void) refreshParentContent {

}

- (void)refreshParentContentByEdit {

}


@end
