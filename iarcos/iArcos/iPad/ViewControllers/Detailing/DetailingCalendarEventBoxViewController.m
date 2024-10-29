//
//  DetailingCalendarEventBoxViewController.m
//  iArcos
//
//  Created by Richard on 25/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxViewController.h"
#import "ArcosRootViewController.h"

@interface DetailingCalendarEventBoxViewController ()

@end

@implementation DetailingCalendarEventBoxViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize templateView = _templateView;
@synthesize auxBodyBackgroundView = _auxBodyBackgroundView;
@synthesize auxFooterBackgroundView = _auxFooterBackgroundView;
@synthesize journeyDateDesc = _journeyDateDesc;
@synthesize journeyDateValue = _journeyDateValue;
@synthesize nextAppointmentDesc = _nextAppointmentDesc;
@synthesize nextAppointmentValue = _nextAppointmentValue;
@synthesize calendarDateDesc = _calendarDateDesc;
@synthesize calendarDateValue = _calendarDateValue;
@synthesize calendarDatePicker = _calendarDatePicker;

@synthesize myBarButtonItem = _myBarButtonItem;
@synthesize myNavigationItem = _myNavigationItem;
@synthesize myNavigationBar = _myNavigationBar;

@synthesize listingView = _listingView;
@synthesize listingNavigationBar = _listingNavigationBar;
@synthesize listingTableView = _listingTableView;

@synthesize detailingCalendarEventBoxViewDataManager = _detailingCalendarEventBoxViewDataManager;
@synthesize HUD = _HUD;
@synthesize widgetFactory = _widgetFactory;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize addEventBarButtonItem = _addEventBarButtonItem;
@synthesize updateButton = _updateButton;
@synthesize cancelButton = _cancelButton;
@synthesize detailingCalendarEventBoxListingDataManager = _detailingCalendarEventBoxListingDataManager;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize imageButton = _imageButton;
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize calendarUtilityDataManager = _calendarUtilityDataManager;
@synthesize utilitiesMailDataManager = _utilitiesMailDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.detailingCalendarEventBoxViewDataManager = [[[DetailingCalendarEventBoxViewDataManager alloc] init] autorelease];
        self.customerJourneyDataManager = [[[CustomerJourneyDataManager alloc] init] autorelease];
        [self.customerJourneyDataManager processCalendarJourneyData];
        self.calendarUtilityDataManager = [[[CalendarUtilityDataManager alloc] init] autorelease];
        self.utilitiesMailDataManager = [[[UtilitiesMailDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    UIColor* barBackgroundColor = [UIColor colorWithRed:209.0/255.0 green:224.0/255.0 blue:251.0/255.0 alpha:1.0];
    UIColor* barForegroundColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:barBackgroundColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:barForegroundColor, NSForegroundColorAttributeName, nil]];
        self.myNavigationBar.standardAppearance = customNavigationBarAppearance;
        self.myNavigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.myNavigationBar setTintColor:barForegroundColor];
    } else {
        // Fallback on earlier versions
        [self.myNavigationBar setBarTintColor:barBackgroundColor];
        [self.myNavigationBar setTintColor:barForegroundColor];
    }
    self.detailingCalendarEventBoxListingDataManager = [[[DetailingCalendarEventBoxListingDataManager alloc] init] autorelease];
    self.detailingCalendarEventBoxListingDataManager.actionDelegate = self;
    self.listingTableView.delegate = self.detailingCalendarEventBoxListingDataManager;
    self.listingTableView.dataSource = self.detailingCalendarEventBoxListingDataManager;
    NSMutableArray* buttonList = [NSMutableArray array];
//    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Scroll" style:UIBarButtonItemStylePlain target:self action:@selector(scrollPressed:)];
//    [buttonList addObject:closeButton];
//    [closeButton release];
//    self.addEventBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonPressed:)] autorelease];
    self.addEventBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlusCircle.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonPressed:)] autorelease];
    [buttonList addObject:self.addEventBarButtonItem];
    [self.myNavigationItem setRightBarButtonItems:buttonList];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        self.calendarDateDesc.hidden = YES;
        self.calendarDateValue.hidden = YES;
        self.myNavigationItem.rightBarButtonItem = nil;
    }
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.view addSubview:self.HUD];
//    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.templateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)];
//    
//    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.templateView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.templateView.layer.mask = maskLayer;
//    [maskLayer release];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    int mergeIdValue = [[employeeDict objectForKey:@"MergeID"] intValue];
//    self.detailingCalendarEventBoxViewDataManager.nextAppointmentData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
//    self.detailingCalendarEventBoxViewDataManager.journeyDateData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
    NSDate* tmpCalendarDateValue = [self.detailingCalendarEventBoxViewDataManager retrieveNextFifteenMinutesWithDate:[NSDate date]];
    if (mergeIdValue > 0) {
        tmpCalendarDateValue = [ArcosUtils addDays:mergeIdValue * 7 date:tmpCalendarDateValue];
    }
    self.detailingCalendarEventBoxViewDataManager.calendarDateData = tmpCalendarDateValue;
//    self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
//    self.journeyDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.journeyDateData format:[GlobalSharedClass shared].dateFormat];
    self.nextAppointmentValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
//    self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
    self.calendarDatePicker.date = self.detailingCalendarEventBoxViewDataManager.calendarDateData;
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    [self.calendarDateValue addGestureRecognizer:singleTap];
//    [singleTap release];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSuggestedAppointmentDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.calendarDateDesc addGestureRecognizer:doubleTap];
    [doubleTap release];
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
    
}

- (void)handleSuggestedAppointmentDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* auxRecognizer = (UITapGestureRecognizer*)sender;
    if (auxRecognizer.state == UIGestureRecognizerStateEnded) {
        [self scrollToAppointmentPositionProcessor];
    }
}

- (void)scrollToAppointmentPositionProcessor {
    @try {
        int tmpRow = 16;
        for (int i = 0; i < [self.detailingCalendarEventBoxListingDataManager.displayList count]; i++) {
            NSMutableDictionary* resDataDict = [self.detailingCalendarEventBoxListingDataManager.displayList objectAtIndex:i];
            NSNumber* cellType = [resDataDict objectForKey:@"CellType"];
            if ([cellType intValue] == 2 || [cellType intValue] == 5) {
                tmpRow = i - 1;
                break;
            }
        }
        [self.listingTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"exception %@", [exception reason]);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.HUD.frame = self.view.bounds;
    }];
}

- (void)scrollPressed:(id)sender {
//    [self.actionDelegate didDismissViewProcessor];
    
}

- (void)addBarButtonPressed:(id)sender {
    NSLog(@"addPressed");
    if (self.detailingCalendarEventBoxViewDataManager.popoverOpenFlag) {
        return;
    }
    self.detailingCalendarEventBoxViewDataManager.popoverOpenFlag = YES;
    ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
    ACEEDTVC.actionDelegate = self;
    ACEEDTVC.presentDelegate = self;
    ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.actionType = ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.createText;
    [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveCreateDataWithDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData title:[self.actionDelegate retrieveDetailingContactName] location:[self.actionDelegate retrieveDetailingLocationName]];
    
    
//    NSMutableArray* templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];

//    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList = templateListingDisplayList;
    NSString* aDateFormatText = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
    if (auxJourneyDict != nil) {
        [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
    }
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.eventDictList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];
    
    [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:aDateFormatText];
    
    [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].weekdayDateFormat];

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

#pragma mark ArcosCalendarEventEntryDetailTemplateViewControllerDelegate
- (void)refreshCalendarTableViewController {
    [self retrieveOneDayCalendarEventEntriesWithDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData];
}

- (NSString*)retrieveLocationUriTemplateDelegate {
    return [NSString stringWithFormat:@"%d:%d", [[self.actionDelegate retrieveDetailingLocationIUR] intValue], [[self.actionDelegate retrieveDetailingContactIUR] intValue]];
}

- (NSNumber*)retrieveLocationIURTemplateDelegate {
    return [self.actionDelegate retrieveDetailingLocationIUR];
}

#pragma mark ModalPresentViewControllerDelegate
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
        self.detailingCalendarEventBoxViewDataManager.popoverOpenFlag = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSString* myTmpNavigationBarTitle = @"Event";
    NSString* myTmpLocationName = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.actionDelegate retrieveDetailingLocationName]]];
    if (![myTmpLocationName isEqualToString:@""]) {
        myTmpNavigationBarTitle = myTmpLocationName;
        NSString* myTmpContactName = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.actionDelegate retrieveDetailingContactName]]];
        if (![myTmpContactName isEqualToString:@""]) {
            myTmpNavigationBarTitle = [NSString stringWithFormat:@"%@/%@",myTmpLocationName,myTmpContactName];
        }
        self.myNavigationBar.topItem.title = myTmpNavigationBarTitle;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.myNavigationBar.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.myNavigationBar.bounds;
    maskLayer.path = maskPath.CGPath;
    self.myNavigationBar.layer.mask = maskLayer;
    [maskLayer release];
    
    
    UIBezierPath* tablemaskPath = [UIBezierPath bezierPathWithRoundedRect:self.auxFooterBackgroundView.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* tablemaskLayer = [[CAShapeLayer alloc] init];
    tablemaskLayer.frame = self.auxFooterBackgroundView.bounds;
    tablemaskLayer.path = tablemaskPath.CGPath;
    self.auxFooterBackgroundView.layer.mask = tablemaskLayer;
    [tablemaskLayer release];
    
    [self retrieveCalendarEventEntries];
}

- (void)dealloc {
    self.templateView = nil;
    self.auxBodyBackgroundView = nil;
    self.auxFooterBackgroundView = nil;
    self.journeyDateDesc = nil;
    self.journeyDateValue = nil;
    self.nextAppointmentDesc = nil;
    self.nextAppointmentValue = nil;
    self.calendarDateDesc = nil;
    for (UIGestureRecognizer* recognizer in self.calendarDateValue.gestureRecognizers) {
        [self.calendarDateValue removeGestureRecognizer:recognizer];
    }
    self.calendarDateValue = nil;
    self.calendarDatePicker = nil;
    
    self.myBarButtonItem = nil;
    self.myNavigationItem = nil;
    self.myNavigationBar = nil;
    
    self.listingView = nil;
    self.listingNavigationBar = nil;
    self.listingTableView = nil;
    
    self.detailingCalendarEventBoxViewDataManager = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.widgetFactory = nil;
    self.globalWidgetViewController = nil;
    self.addEventBarButtonItem = nil;
    self.updateButton = nil;
    self.cancelButton = nil;
    self.detailingCalendarEventBoxListingDataManager = nil;
    self.arcosRootViewController = nil;
    self.globalNavigationController = nil;
    self.imageButton = nil;
    self.customerJourneyDataManager = nil;
    self.calendarUtilityDataManager = nil;
    self.utilitiesMailDataManager = nil;
    
    [super dealloc];
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.globalWidgetViewController = [self.widgetFactory CreateDateCalendarStyleWidgetWithDataSource:WidgetDataSourceNormalDate pickerFormatType:DatePickerFormatForceDateTime defaultPickerDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData];
        if (self.globalWidgetViewController != nil) {
            self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
            self.globalWidgetViewController.popoverPresentationController.sourceView = self.calendarDateValue;
            self.globalWidgetViewController.popoverPresentationController.sourceRect = self.calendarDateValue.bounds;
            self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.globalWidgetViewController.popoverPresentationController.delegate = self;
            [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
        }
    }
}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.detailingCalendarEventBoxViewDataManager.calendarDateData = data;
    self.calendarDateValue.text = [ArcosUtils stringFromDate:data format:[GlobalSharedClass shared].datetimehmFormat];
}

- (IBAction)saveToCalendarButtonPressed {
    if (self.detailingCalendarEventBoxViewDataManager.originalEventDataDict == nil) {
        [self addPressed];
    } else {
        void (^leftActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self editPressed];
        };
        void (^rightActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self addBarButtonPressed:nil];
        };
        
        NSDate* originalStartDate = [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"StartDate"];
        NSString* originalStartDateString = [ArcosUtils stringFromDate:originalStartDate format:[GlobalSharedClass shared].datetimehmFormat];
        NSString* currentStartDateString = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
        if (![originalStartDateString isEqualToString:currentStartDateString] && [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"StartDate"] != [NSNull null]) {
            [ArcosUtils showTwoBtnsDialogBox:@"" title:@"" target:self lBtnText:@"AMEND THIS EVENT" rBtnText:@"ADD NEW ENTRY" lBtnHandler:leftActionHandler rBtnHandler:rightActionHandler];
        } else {
            [self editPressed];
        }
    }
}

- (void)retrieveCalendarEventEntries {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSDate* startDate = [NSDate date];
    NSDate* endDate = [ArcosUtils addDays:101 date:startDate];
    NSString* startDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSString* endDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:endDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSURL* url = [NSURL URLWithString:[self.detailingCalendarEventBoxViewDataManager retrieveCalendarURIWithStartDate:startDateString endDate:endDateString locationName:[self.actionDelegate retrieveDetailingLocationName]]];
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
//            NSLog(@"sendMsg error %@", error);
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
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
//                        
//                    }];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:^(UIAlertAction *action) {
                            
                        }];
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
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
//                NSLog(@"eventList %@", eventList);
//                int firstEventIndex = 0;
//                BOOL eventFoundFlag = false;
                self.detailingCalendarEventBoxViewDataManager.eventForCurrentLocationFoundFlag = NO;
//                NSNumber* firstEventLocationIUR = [NSNumber numberWithInt:0];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        self.detailingCalendarEventBoxViewDataManager.originalEventDataDict = [self.detailingCalendarEventBoxViewDataManager populateCalendarEventEntryWithData:auxEventDict];
                        self.detailingCalendarEventBoxViewDataManager.calendarDateData = [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"StartDate"];
//                        eventFoundFlag = true;
                        self.detailingCalendarEventBoxViewDataManager.eventForCurrentLocationFoundFlag = YES;
//                        firstEventIndex = i;
//                        firstEventLocationIUR = [NSNumber numberWithInt:[locationIUR intValue]];
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
//                            self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.nextAppointmentText;
                            [self.imageButton setImage:[UIImage imageNamed:@"List2.png"] forState:UIControlStateNormal];
                            self.nextAppointmentValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
//                            self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
                            self.calendarDatePicker.date = self.detailingCalendarEventBoxViewDataManager.calendarDateData;
                        });
                        break;
                    }
                }
                if (!self.detailingCalendarEventBoxViewDataManager.eventForCurrentLocationFoundFlag) {
                    self.detailingCalendarEventBoxViewDataManager.journeyForCurrentLocationFoundFlag = NO;
                    [self.detailingCalendarEventBoxViewDataManager calculateJourneyDateWithLocationIUR:[self.actionDelegate retrieveDetailingLocationIUR]];
                    if (!self.detailingCalendarEventBoxViewDataManager.journeyForCurrentLocationFoundFlag) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.nextAppointmentDesc.hidden = YES;
                            self.nextAppointmentValue.hidden = YES;
                        });
                    } else {                        
                        self.detailingCalendarEventBoxViewDataManager.calendarDateData = self.detailingCalendarEventBoxViewDataManager.journeyDateForCurrentLocation;
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
                            [self.imageButton setImage:[UIImage imageNamed:@"JourneyCar.png"] forState:UIControlStateNormal];
                            self.nextAppointmentValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
                            self.calendarDatePicker.date = self.detailingCalendarEventBoxViewDataManager.calendarDateData;
                        });
                    }
                }
                
                [self retrieveInternalOneDayCalendarEventEntriesWithDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData];

            }
        }
    }];
    [downloadTask resume];
}

- (void)retrieveInternalOneDayCalendarEventEntriesWithDate:(NSDate*)aStartDate {
    __weak typeof(self) weakSelf = self;
    
    
    NSDate* endDate = [ArcosUtils addDays:1 date:aStartDate];
    NSString* startDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSString* endDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:endDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSURL* url = [NSURL URLWithString:[self.detailingCalendarEventBoxViewDataManager retrieveCalendarURIWithStartDate:startDateString endDate:endDateString]];
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
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
//                        
//                    }];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:^(UIAlertAction *action) {
                            
                        }];
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
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.journeyDictList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.eventDictList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        [self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                    }
//                    [self.detailingCalendarEventBoxViewDataManager.listingDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                    [self.detailingCalendarEventBoxViewDataManager.eventDictList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                }
                
                NSString* aDateFormatText = [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].dateFormat];
                NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
                if (auxJourneyDict != nil) {
                    [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
                    self.detailingCalendarEventBoxViewDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
                }
                self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyCellType];
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [self.calendarUtilityDataManager processDataListWithDateFormatText:aDateFormatText journeyDictList:self.detailingCalendarEventBoxViewDataManager.journeyDictList eventDictList:self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList bodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyCellType];
                
//                self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyCellType];
                [self.detailingCalendarEventBoxListingDataManager createBasicDataWithDataList:self.detailingCalendarEventBoxViewDataManager.listingDisplayList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listingTableView reloadData];
                    [weakSelf.HUD hide:YES];
                    [self scrollToAppointmentPositionProcessor];
                    
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)retrieveOneDayCalendarEventEntriesWithDate:(NSDate*)aStartDate {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    
    NSDate* endDate = [ArcosUtils addDays:1 date:aStartDate];
    NSString* startDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSString* endDateString = [NSString stringWithFormat:@"%@T00:00:00.000Z", [ArcosUtils stringFromDate:endDate format:[GlobalSharedClass shared].utcDateFormat]];
    NSURL* url = [NSURL URLWithString:[self.detailingCalendarEventBoxViewDataManager retrieveCalendarURIWithStartDate:startDateString endDate:endDateString]];
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
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
//                        
//                    }];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:^(UIAlertAction *action) {
                            
                        }];
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
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.eventDictList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.journeyDictList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        [self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                    }
                    [self.detailingCalendarEventBoxViewDataManager.eventDictList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                }
                
                NSString* aDateFormatText = [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].dateFormat];
                NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
                if (auxJourneyDict != nil) {
                    [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
                    self.detailingCalendarEventBoxViewDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
                }
                self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyCellType];
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [self.calendarUtilityDataManager processDataListWithDateFormatText:aDateFormatText journeyDictList:self.detailingCalendarEventBoxViewDataManager.journeyDictList eventDictList:self.detailingCalendarEventBoxViewDataManager.templateListingDisplayList bodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyCellType];
                [self.detailingCalendarEventBoxListingDataManager createBasicDataWithDataList:self.detailingCalendarEventBoxViewDataManager.listingDisplayList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listingTableView reloadData];
                    [weakSelf.HUD hide:YES];
                    [self scrollToAppointmentPositionProcessor];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)addPressed {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
//            [self.actionDelegate didDismissViewProcessor];
        }];
        return;
    }
    NSMutableDictionary* eventDict = [self.detailingCalendarEventBoxViewDataManager retrieveEventDictWithLocationName:[self.actionDelegate retrieveDetailingLocationName] contactName:[self.actionDelegate retrieveDetailingContactName] locationIUR:[self.actionDelegate retrieveDetailingLocationIUR] contactIUR:[self.actionDelegate retrieveDetailingContactIUR]];
    
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
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    
//                    [weakSelf.actionDelegate didDismissViewProcessor];
                }];
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
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        
//                        [weakSelf.actionDelegate didDismissViewProcessor];
//                    }];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:^(UIAlertAction *action) {
                            
                        }];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.actionDelegate didDismissViewProcessor];                    
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)editPressed {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
//            [self.actionDelegate didDismissViewProcessor];
        }];
        return;
    }
    NSMutableDictionary* eventDict = [self.detailingCalendarEventBoxViewDataManager retrieveEditEventDictWithLocationName:[self.actionDelegate retrieveDetailingLocationName] contactName:[self.actionDelegate retrieveDetailingContactName] locationIUR:[self.actionDelegate retrieveDetailingLocationIUR] contactIUR:[self.actionDelegate retrieveDetailingContactIUR]];
    
    
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI, [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"Id"]]];
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
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    
//                    [weakSelf.actionDelegate didDismissViewProcessor];
                }];
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
//                    [weakSelf.HUD hide:YES];
//                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
//                        
////                        [weakSelf.actionDelegate didDismissViewProcessor];
//                    }];
                    void (^myFailureHandler)(void) = ^ {
                        [weakSelf.HUD hide:YES];
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" target:weakSelf handler:^(UIAlertAction *action) {
                            
                        }];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.actionDelegate didDismissViewProcessor];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (IBAction)dateComponentPicked:(id)sender {
    UIDatePicker* picker = (UIDatePicker*)sender;
    
//    NSLog(@"date: %@ %@", picker.date, self.presentedViewController);
    NSString* existingDateDatePartString = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    NSString* nextDateDatePartString = [ArcosUtils stringFromDate:picker.date format:[GlobalSharedClass shared].dateFormat];
    self.detailingCalendarEventBoxViewDataManager.calendarDateData = picker.date;
//    self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    if (![existingDateDatePartString isEqualToString:nextDateDatePartString]) {
//        self.detailingCalendarEventBoxViewDataManager.calendarDateData = picker.date;
        if (self.presentedViewController != nil) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^ {
                [self retrieveOneDayCalendarEventEntriesWithDate:picker.date];
            }];
        } else {
            [self retrieveOneDayCalendarEventEntriesWithDate:picker.date];
        }
    } else {
//        self.detailingCalendarEventBoxViewDataManager.calendarDateData = picker.date;
    }
    
//    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
//        
//    }];   
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.detailingCalendarEventBoxViewDataManager.listingDisplayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdArcosCalendarEventEntryDetailListingTableViewCell";
    
    ArcosCalendarEventEntryDetailListingTableViewCell* cell = (ArcosCalendarEventEntryDetailListingTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosCalendarEventEntryDetailListingTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ArcosCalendarEventEntryDetailListingTableViewCell class]] && [[(ArcosCalendarEventEntryDetailListingTableViewCell*)nibItem reuseIdentifier] isEqualToString:CellIdentifier]) {
                cell = (ArcosCalendarEventEntryDetailListingTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSDictionary* cellData = [self.detailingCalendarEventBoxViewDataManager.listingDisplayList objectAtIndex:indexPath.row];
    NSDictionary* cellStartDict = [cellData objectForKey:@"start"];
    NSString* tmpCellStartDateStr = [cellStartDict objectForKey:@"dateTime"];
    NSDate* tmpCellStartDate = [ArcosUtils dateFromString:tmpCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    cell.timeLabel.text = [ArcosUtils stringFromDate:tmpCellStartDate format:[GlobalSharedClass shared].hourMinuteFormat];
//    NSDictionary* cellLocationDict = [cellData objectForKey:@"location"];
    cell.nameLabel.text = [cellData objectForKey:@"subject"];
    NSNumber* tmpLocationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:cellData];
    if ([tmpLocationIUR intValue] != 0 && [tmpLocationIUR isEqualToNumber:[self.actionDelegate retrieveDetailingLocationIUR]]) {
        cell.timeLabel.textColor = [UIColor blueColor];
    } else {
        cell.timeLabel.textColor = [UIColor blackColor];
    }
    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.contentView addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    return cell;
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        /*
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.listingTableView];
        NSDictionary* cellData = [self.detailingCalendarEventBoxViewDataManager.listingDisplayList objectAtIndex:swipedIndexPath.row];
        ArcosCalendarEventEntryDetailListingTableViewCell* cell = (ArcosCalendarEventEntryDetailListingTableViewCell*)[self.listingTableView cellForRowAtIndexPath:swipedIndexPath];
        NSMutableDictionary* eventDataDict = [self.detailingCalendarEventBoxViewDataManager createEditEventEntryDetailTemplateData:cellData];
        ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
        ACEEDTVC.actionDelegate = self;
        ACEEDTVC.presentDelegate = self;
        NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:cellData];
        if (![[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
            ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.hideEditButtonFlag = YES;
        }
        [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditDataWithCellData:eventDataDict];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayList];
        NSDictionary* startDict = [cellData objectForKey:@"start"];
        NSString* startDateStr = [startDict objectForKey:@"dateTime"];
        NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].dateFormat];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ACEEDTVC];
        tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
        tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
        tmpNavigationController.popoverPresentationController.sourceView = cell.contentView;
        tmpNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:tmpNavigationController animated:YES completion:nil];
        [ACEEDTVC release];
        [tmpNavigationController release];
         */
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.actionDelegate didDismissViewProcessor];
}

#pragma mark DetailingCalendarEventBoxListingDataManagerDelegate
- (NSNumber*)retrieveDetailingCalendarEventBoxListingDataManagerLocationIUR {
    return [self.actionDelegate retrieveDetailingLocationIUR];
}

- (NSNumber*)retrieveDetailingCalendarEventBoxListingLocationIURWithEventDict:(NSDictionary*)anEventDict {
    return [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:anEventDict];
}

- (void)doubleTapListingBodyLabelWithIndexPath:(NSIndexPath *)anIndexPath {
    if (self.detailingCalendarEventBoxViewDataManager.popoverOpenFlag) {
        return;
    }
    self.detailingCalendarEventBoxViewDataManager.popoverOpenFlag = YES;
    NSMutableDictionary* cellData = [self.detailingCalendarEventBoxListingDataManager.displayList objectAtIndex:anIndexPath.row];
    NSMutableDictionary* cellFieldValueData = [cellData objectForKey:@"FieldValue"];
//    NSLog(@"aa %@", cellFieldValueData);
//    NSDictionary* startDict = [cellFieldValueData objectForKey:@"start"];
//    NSString* startDateStr = [startDict objectForKey:@"dateTime"];
//    NSDate* startDate = [ArcosUtils dateFromString:startDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    NSDate* startDate = [cellFieldValueData objectForKey:@"Date"];
    NSString* aDateFormatText = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].dateFormat];
//    DetailingCalendarEventBoxListingBaseTableCell* cell = (DetailingCalendarEventBoxListingBaseTableCell*)[self.listingTableView cellForRowAtIndexPath:anIndexPath];
//    NSMutableDictionary* eventDataDict = [self.detailingCalendarEventBoxViewDataManager createEditEventEntryDetailTemplateData:cellFieldValueData];
    ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
    ACEEDTVC.actionDelegate = self;
    ACEEDTVC.presentDelegate = self;
//    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:cellFieldValueData];
//    NSNumber* locationIUR = [cellFieldValueData objectForKey:@"LocationIUR"];
//    if (![[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
//        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.hideEditButtonFlag = YES;
//    }
    
    [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditDataWithCellData:cellFieldValueData];
//    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayList];
    NSMutableDictionary* auxJourneyDict = [self.customerJourneyDataManager.journeyDictHashMap objectForKey:aDateFormatText];
    if (auxJourneyDict != nil) {
        [self.customerJourneyDataManager getLocationsWithJourneyDict:auxJourneyDict];
        ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.journeyDictList = [self.customerJourneyDataManager.locationListDict objectForKey:aDateFormatText];
    }
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.eventDictList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayListWithBodyCellType:self.detailingCalendarEventBoxViewDataManager.bodyTemplateCellType];
    
    [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager processDataListWithDateFormatText:aDateFormatText];
    [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];    
    
//    [ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList];
    
    
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:startDate format:[GlobalSharedClass shared].weekdayDateFormat];
//    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ACEEDTVC];
//    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
//    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
//    tmpNavigationController.popoverPresentationController.sourceView = cell.fieldValueLabel;
//    tmpNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    
//    [self presentViewController:tmpNavigationController animated:YES completion:nil];
//    [ACEEDTVC release];
//    [tmpNavigationController release];
//    ACEEDTVC.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
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

@end
