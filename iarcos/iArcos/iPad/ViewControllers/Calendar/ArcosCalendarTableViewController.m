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
@synthesize arcosService = _arcosService;
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize utilitiesMailDataManager = _utilitiesMailDataManager;
@synthesize myTableView = _myTableView;
@synthesize listingTemplateView = _listingTemplateView;
@synthesize listingTitleLabel = _listingTitleLabel;
@synthesize listingTableView = _listingTableView;
@synthesize arcosCalendarEventEntryDetailListingDataManager = _arcosCalendarEventEntryDetailListingDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arcosCalendarEventEntryDetailListingDataManager = [[[ArcosCalendarEventEntryDetailListingDataManager alloc] init] autorelease];
        self.arcosCalendarEventEntryDetailListingDataManager.actionDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.arcosCalendarTableDataManager = [[[ArcosCalendarTableDataManager alloc] init] autorelease];
    self.listingTableView.dataSource = self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager;
    self.listingTableView.delegate = self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager;
    self.listingTitleLabel.text = @"";
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.arcosService = [ArcosService service];
    self.utilitiesMailDataManager = [[[UtilitiesMailDataManager alloc] init] autorelease];
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
    UIBarButtonItem* toggleListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleListButtonPressed:)];
    NSMutableArray* buttonList = [NSMutableArray arrayWithObjects:toggleListButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonList];
    [toggleListButton release];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    [self showCurrentMonth];
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
//    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    self.customerJourneyDataManager = [[[CustomerJourneyDataManager alloc] init] autorelease];
    [self.customerJourneyDataManager processCalendarJourneyData];
    [self retrieveCalendarInfoWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)dealloc {
    self.arcosCalendarTableDataManager = nil;
    self.arcosCalendarTableHeaderView = nil;
    self.arcosRootViewController = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.arcosService = nil;
    self.customerJourneyDataManager = nil;
    self.globalNavigationController = nil;
    self.utilitiesMailDataManager = nil;
    self.myTableView = nil;
    self.listingTemplateView = nil;
    self.listingTitleLabel = nil;
    self.listingTableView = nil;
    self.arcosCalendarEventEntryDetailListingDataManager = nil;
    
    [super dealloc];
}

- (void)toggleListButtonPressed:(id)sender {
    self.arcosCalendarTableDataManager.listingTemplateViewVisibleFlag = !self.arcosCalendarTableDataManager.listingTemplateViewVisibleFlag;
    int listingTemplateViewWidth = [self calculateListingTemplateViewWidth];
    if (self.arcosCalendarTableDataManager.listingTemplateViewVisibleFlag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width - listingTemplateViewWidth, 0, listingTemplateViewWidth, self.view.frame.size.height);
            [self configListingTemplateSubViews];
        } completion:^(BOOL finished){
            
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width, 0, listingTemplateViewWidth, self.view.frame.size.height);
            [self configListingTemplateSubViews];
        } completion:^(BOOL finished){
            
        }];
    }
}

- (int)calculateListingTemplateViewWidth {
    return (int)self.view.frame.size.width * 2 / 7;
}

- (void)configListingTemplateSubViews {
    self.listingTitleLabel.frame = CGRectMake(3, 0, self.listingTemplateView.frame.size.width - 3, 50);
    self.listingTableView.frame = CGRectMake(2, 50, self.listingTemplateView.frame.size.width - 2, self.listingTemplateView.frame.size.height - 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    int listingTemplateViewWidth = [self calculateListingTemplateViewWidth];
    if (self.arcosCalendarTableDataManager.listingTemplateViewVisibleFlag) {
        self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width - listingTemplateViewWidth, 0, listingTemplateViewWidth, self.view.frame.size.height);
        [self configListingTemplateSubViews];
    } else {
        self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width, 0, listingTemplateViewWidth, self.view.frame.size.height);
        [self configListingTemplateSubViews];
    }
    
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
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    } else {
        // Fallback on earlier versions
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setBarTintColor:[GlobalSharedClass shared].myAppBlueColor];
        [self.arcosRootViewController.customerMasterViewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)todayPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentSelectedDate = self.arcosCalendarTableDataManager.todayDate;
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [self.arcosCalendarTableDataManager createThirdDayNoonDateWithDate:self.arcosCalendarTableDataManager.todayDate thirdDayFlag:YES];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.myTableView reloadData];
    [self showCurrentMonth];
//    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self retrieveCalendarInfoWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)prevPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [ArcosUtils addMonths:-1 date:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.myTableView reloadData];
    [self showCurrentMonth];
//    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self retrieveCalendarInfoWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (void)nextPressed:(id)sender {
    self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate = [ArcosUtils addMonths:1 date:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.arcosCalendarTableDataManager calculateCalendarData:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self.myTableView reloadData];
    [self showCurrentMonth];
//    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
    [self retrieveCalendarInfoWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
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

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//                                         duration:(NSTimeInterval)duration {
//    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
//    NSLog(@"willAnimateRotationToInterfaceOrientation");
//    [self.tableView reloadData];
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.HUD.frame = self.navigationController.view.bounds;
        int listingTemplateViewWidth = [self calculateListingTemplateViewWidth];
        if (self.arcosCalendarTableDataManager.listingTemplateViewVisibleFlag) {
            self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width - listingTemplateViewWidth, 0, listingTemplateViewWidth, self.view.frame.size.height);
            [self configListingTemplateSubViews];
        } else {
            self.listingTemplateView.frame = CGRectMake(self.view.frame.size.width, 0, listingTemplateViewWidth, self.view.frame.size.height);
            [self configListingTemplateSubViews];
        }        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdArcosCalendarTableViewCell";
    
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
    cell.myIndexPath = indexPath;
    cell.actionDelegate = self;
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
            if ([auxDate compare:self.arcosCalendarTableDataManager.currentSelectedDate] == NSOrderedSame) {
                auxLabel.backgroundColor = [GlobalSharedClass shared].mySystemBlueColor;
                auxLabel.textColor = [UIColor whiteColor];
            }
            NSMutableDictionary* journeyDataDict = [dayDataDict objectForKey:@"Journey"];
//            NSLog(@"%d %@", i, journeyDataDict);
            NSNumber* amIUR = [ArcosUtils convertStringToNumber:[journeyDataDict objectForKey:@"Am"]];
            NSNumber* pmIUR = [ArcosUtils convertStringToNumber:[journeyDataDict objectForKey:@"Pm"]];
            NSMutableDictionary* btnDict = [cell.btnList objectAtIndex:i];
            UIButton* btnAm = [btnDict objectForKey:@"AmBtn"];
            UIButton* btnPm = [btnDict objectForKey:@"PmBtn"];
            
            if ([amIUR intValue] != 0) {
                UIImage* amImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:amIUR];
                if (amImage != nil) {
                    [btnAm setImage:amImage forState:UIControlStateNormal];
                }
                if ([pmIUR intValue] != [amIUR intValue]) {
                    UIImage* pmImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:pmIUR];
                    if (pmImage != nil) {
                        [btnPm setImage:pmImage forState:UIControlStateNormal];
                    }
                }
            }
            
            NSMutableArray* eventDataList = [dayDataDict objectForKey:@"Event"];
            if ([eventDataList count] > 1) {
                NSSortDescriptor* startDateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES selector:@selector(compare:)] autorelease];
                [eventDataList sortUsingDescriptors:[NSArray arrayWithObjects:startDateDescriptor, nil]];
            }            
            ArcosCalendarCellBaseTableViewDataManager* baseTableViewDataManager = [cell.dataManagerList objectAtIndex:i];
            baseTableViewDataManager.actionDelegate = self;
//            baseTableViewDataManager.weekOfMonthIndexPath = indexPath;
//            baseTableViewDataManager.weekdaySeqIndex = i;
            baseTableViewDataManager.displayList = eventDataList;
            baseTableViewDataManager.journeyDataDict = journeyDataDict;
            baseTableViewDataManager.dateFormatText = [ArcosUtils stringFromDate:auxDate format:[GlobalSharedClass shared].dateFormat];
            UITableView* auxTableView = [cell.tableViewList objectAtIndex:i];
            [auxTableView reloadData];
        }
    }
    
    return cell;
}

#pragma mark - ArcosCalendarCellBaseTableViewDataManagerDelegate
- (void)eventEntryInputFinishedWithIndexPath:(NSIndexPath*)anIndexPath dataList:(NSMutableArray *)aDataList dateFormatText:(NSString*)aDateFormatText sourceView:(UIView *)aView {
    @try {
        if (self.arcosCalendarTableDataManager.popoverOpenFlag) {
            return;
        }
        self.arcosCalendarTableDataManager.popoverOpenFlag = YES;
        NSMutableDictionary* eventDataDict = [aDataList objectAtIndex:anIndexPath.row];
        if (eventDataDict == nil) return;
//        NSLog(@"eventDataDict %@", eventDataDict);
//        ArcosCalendarEventEntryDetailTableViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
        ACEEDTVC.actionDelegate = self;
        ACEEDTVC.presentDelegate = self;
        [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditDataWithCellData:eventDataDict];
        NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
        if (auxJourneyDict != nil) {
            [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
            ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
        }
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.eventDictList = aDataList;
        
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:aDateFormatText];
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:[eventDataDict objectForKey:@"StartDate"] format:[GlobalSharedClass shared].weekdayDateFormat];
//        [ACEEDTVC.arcosCalendarEventEntryDetailDataManager retrieveEditDataWithCellData:eventDataDict];
//        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ACEEDTVC];
//        tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
//        tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
//        tmpNavigationController.popoverPresentationController.sourceView = aView;
//        
//        
//        [self presentViewController:tmpNavigationController animated:YES completion:nil];
//        [ACEEDTVC release];
//        [tmpNavigationController release];
//        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.showBorderFlag = YES;
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
    } @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
    }
}

#pragma mark - ArcosCalendarTableViewCellDelegate
- (void)inputFinishedWithIndexPath:(NSIndexPath*)anIndexPath labelIndex:(int)aLabelIndex {
    @try {
        NSMutableDictionary* weekDataDict = [self.arcosCalendarTableDataManager.matrixDataList objectAtIndex:anIndexPath.row];
        NSNumber* weekDay = [self.arcosCalendarTableDataManager.weekdaySeqList objectAtIndex:aLabelIndex];
        NSMutableDictionary* dayDataDict = [weekDataDict objectForKey:weekDay];
        if (dayDataDict == nil) return;
//        NSLog(@"inputFinishedWithIndexPath");
        self.arcosCalendarTableDataManager.currentSelectedDate = [dayDataDict objectForKey:@"Date"];
        [self.myTableView reloadData];
        self.listingTitleLabel.text = [ArcosUtils stringFromDate:self.arcosCalendarTableDataManager.currentSelectedDate format:[GlobalSharedClass shared].weekdayDateFormat];
        self.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = nil;
        self.arcosCalendarEventEntryDetailListingDataManager.eventDictList = nil;
        NSString* auxDateFormatText = [ArcosUtils stringFromDate:[dayDataDict objectForKey:@"Date"] format:[GlobalSharedClass shared].dateFormat];
        NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:auxDateFormatText];
        if (auxJourneyDict != nil) {
            [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
            self.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:auxDateFormatText];
        }
        NSMutableArray* eventDataList = [dayDataDict objectForKey:@"Event"];
        if ([eventDataList count] > 1) {
            NSSortDescriptor* startDateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES selector:@selector(compare:)] autorelease];
            [eventDataList sortUsingDescriptors:[NSArray arrayWithObjects:startDateDescriptor, nil]];
        }
        self.arcosCalendarEventEntryDetailListingDataManager.eventDictList = eventDataList;
        
        [self.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:auxDateFormatText];
        [self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:self.arcosCalendarEventEntryDetailListingDataManager.displayList];
        [self.listingTableView reloadData];
        [self scrollToAppointmentPositionProcessor];
    } @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
    }
    
}

- (void)longInputFinishedWithIndexPath:(NSIndexPath*)anIndexPath sourceView:(UIView*)aView {
    @try {
        if (self.arcosCalendarTableDataManager.popoverOpenFlag) {
            return;
        }
        self.arcosCalendarTableDataManager.popoverOpenFlag = YES;
        NSMutableDictionary* weekDataDict = [self.arcosCalendarTableDataManager.matrixDataList objectAtIndex:anIndexPath.row];
        NSNumber* weekDay = [self.arcosCalendarTableDataManager.weekdaySeqList objectAtIndex:aView.tag];
        NSMutableDictionary* dayDataDict = [weekDataDict objectForKey:weekDay];
        if (dayDataDict == nil) return;
//        NSLog(@"longInputFinishedWithIndexPath");
//        ArcosCalendarEventEntryDetailTableViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
        ACEEDTVC.actionDelegate = self;
        ACEEDTVC.presentDelegate = self;
        ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.actionType = ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.createText;
        [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveCreateDataWithDate:[dayDataDict objectForKey:@"Date"] title:@"" location:@""];
        //
        NSString* auxDateFormatText = [ArcosUtils stringFromDate:[dayDataDict objectForKey:@"Date"] format:[GlobalSharedClass shared].dateFormat];
        NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:auxDateFormatText];
        if (auxJourneyDict != nil) {
            [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
            ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:auxDateFormatText];
        }
        NSMutableArray* eventDataList = [dayDataDict objectForKey:@"Event"];
        if ([eventDataList count] > 1) {
            NSSortDescriptor* startDateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES selector:@selector(compare:)] autorelease];
            [eventDataList sortUsingDescriptors:[NSArray arrayWithObjects:startDateDescriptor, nil]];
        }
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.eventDictList = eventDataList;
        
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:auxDateFormatText];
        [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:[dayDataDict objectForKey:@"Date"] format:[GlobalSharedClass shared].weekdayDateFormat];
//        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ACEEDTVC];
//        tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
//        tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
//        tmpNavigationController.popoverPresentationController.sourceView = aView;
//        [self presentViewController:tmpNavigationController animated:YES completion:nil];
//        [ACEEDTVC release];
//        [tmpNavigationController release];
//        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.showBorderFlag = YES;
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
    } @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
    }
}
#pragma mark - ArcosCalendarEventEntryDetailListingDataManagerDelegate
- (NSNumber*)retrieveEventEntryDetailListingLocationIUR {
    return [NSNumber numberWithInt:0];
}

#pragma mark - ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
        self.arcosCalendarTableDataManager.popoverOpenFlag = NO;
    }];
}

#pragma mark - ArcosCalendarEventEntryDetailTableViewControllerDelegate ArcosCalendarEventEntryDetailTemplateViewControllerDelegate
- (void)refreshCalendarTableViewController {
    [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
}

- (NSString*)retrieveLocationUriTemplateDelegate {
    return @"";
}

- (NSNumber*)retrieveLocationIURTemplateDelegate {
    return [NSNumber numberWithInt:0];
}

- (void)retrieveCalendarEntriesWithDate:(NSDate*)aDate {
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.myTableView reloadData];
        [self.HUD hide:YES];
        return;
    }
//    [self.HUD show:YES];
    __weak typeof(self) weakSelf = self;
    NSURL* url = [NSURL URLWithString:[self.arcosCalendarTableDataManager retrieveCalendarURIWithDate:aDate]];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"outlook.timezone=\"%@\"", [GlobalSharedClass shared].ieTimeZone] forHTTPHeaderField:@"Prefer"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
//            NSLog(@"sendMsg error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
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
                    [self.myTableView reloadData];
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:nil];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:nil];
                    };
                    void (^mySuccessHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                    };
                    void (^myCompletionHandler)(void) = ^ {
                        weakSelf.HUD.labelText = @"";
                    };
                    weakSelf.HUD.labelText = self.utilitiesMailDataManager.reconnectText;
                    [self.utilitiesMailDataManager renewPressedProcessorWithFailureHandler:myFailureHandler successHandler:mySuccessHandler completionHandler:myCompletionHandler];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                [self.arcosCalendarTableDataManager clearCalendarEventData];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* eventDict = [eventList objectAtIndex:i];
                    [self.arcosCalendarTableDataManager populateCalendarEntryWithData:eventDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.myTableView reloadData];
                    [weakSelf.HUD hide:YES];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)retrieveCalendarInfoWithDate:(NSDate*)aDate {
    [self.HUD show:YES];
    [self.arcosService GetCalendarInfo:self action:@selector(backFromGetCalendarInfo:) Employeeiur:[[SettingManager employeeIUR] intValue] Yearnum:[ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:aDate]] Month:[ArcosUtils convertNSIntegerToInt:[ArcosUtils monthDayWithDate:aDate]]];
}

- (void)backFromGetCalendarInfo:(id)aResult {
    if ([aResult isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anError localizedDescription]] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        [self.HUD hide:YES];
    } else if ([aResult isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[aSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        [self.HUD hide:YES];
    } else {
        ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)aResult;
        if (replyResult.ErrorModel.Code < 0) {
            [ArcosUtils showDialogBox:replyResult.ErrorModel.Message title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
            [self.HUD hide:YES];
        } else {
            [self.arcosCalendarTableDataManager populateJourneyEntryWithDataList:replyResult.ArrayOfData];
            [self retrieveCalendarEntriesWithDate:self.arcosCalendarTableDataManager.currentThirdDayOfMonthDate];
        }
    }
}

- (void)scrollToAppointmentPositionProcessor {
    @try {
        int tmpRow = 16;
        for (int i = 0; i < [self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager.displayList count]; i++) {
            NSMutableDictionary* resDataDict = [self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager.displayList objectAtIndex:i];
            NSNumber* cellType = [resDataDict objectForKey:@"CellType"];
            if ([cellType intValue] == 4 || [cellType intValue] == 5) {
                tmpRow = i - 1;
                break;
            }
        }
        [self.listingTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"exception %@", [exception reason]);
    }
}

@end
