//
//  DetailingCalendarEventBoxViewController.m
//  iArcos
//
//  Created by Richard on 25/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxViewController.h"

@interface DetailingCalendarEventBoxViewController ()

@end

@implementation DetailingCalendarEventBoxViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize templateView = _templateView;
@synthesize journeyDateDesc = _journeyDateDesc;
@synthesize journeyDateValue = _journeyDateValue;
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.detailingCalendarEventBoxViewDataManager = [[[DetailingCalendarEventBoxViewDataManager alloc] init] autorelease];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray* buttonList = [NSMutableArray array];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [buttonList addObject:closeButton];
    [closeButton release];
    self.addEventBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonPressed:)] autorelease];
    [buttonList addObject:self.addEventBarButtonItem];
    [self.myNavigationItem setLeftBarButtonItems:buttonList];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        self.calendarDateDesc.hidden = YES;
        self.calendarDateValue.hidden = YES;
        self.myNavigationItem.rightBarButtonItem = nil;
    }
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.templateView] autorelease];
    self.HUD.dimBackground = YES;
    [self.templateView addSubview:self.HUD];
//    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.templateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)];
//    
//    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.templateView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.templateView.layer.mask = maskLayer;
//    [maskLayer release];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    int mergeIdValue = [[employeeDict objectForKey:@"MergeID"] intValue];
    self.detailingCalendarEventBoxViewDataManager.journeyDateData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
    self.detailingCalendarEventBoxViewDataManager.calendarDateData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
    self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    self.journeyDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.journeyDateData format:[GlobalSharedClass shared].dateFormat];
    self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
    self.calendarDatePicker.date = self.detailingCalendarEventBoxViewDataManager.calendarDateData;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.calendarDateValue addGestureRecognizer:singleTap];
    [singleTap release];
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
}

- (void)closePressed:(id)sender {
    [self.actionDelegate didDismissViewProcessor];
}

- (void)addBarButtonPressed:(id)sender {
    NSLog(@"addPressed");
    ArcosCalendarEventEntryDetailTemplateViewController* ACEEDTVC = [[ArcosCalendarEventEntryDetailTemplateViewController alloc] initWithNibName:@"ArcosCalendarEventEntryDetailTemplateViewController" bundle:nil];
    ACEEDTVC.actionDelegate = self;
    ACEEDTVC.presentDelegate = self;
    ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.actionType = ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.createText;
    [ACEEDTVC.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveCreateDataWithDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData title:[self.actionDelegate retrieveDetailingContactName] location:[self.actionDelegate retrieveDetailingLocationName]];
    NSMutableArray* templateListingDisplayList = [self.detailingCalendarEventBoxViewDataManager retrieveTemplateListingDisplayList];
//    for (int i = 0; i < [self.detailingCalendarEventBoxViewDataManager.listingDisplayList count]; i++) {
//        NSMutableDictionary* resultCellDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
//        NSDictionary* myCellData = [self.detailingCalendarEventBoxViewDataManager.listingDisplayList objectAtIndex:i];
//        NSDictionary* myCellStartDict = [myCellData objectForKey:@"start"];
//        NSString* myCellStartDateStr = [myCellStartDict objectForKey:@"dateTime"];
//        NSDate* myCellStartDate = [ArcosUtils dateFromString:myCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
//        [resultCellDataDict setObject:[ArcosUtils convertNilDateToNull:myCellStartDate] forKey:@"Date"];
//        [resultCellDataDict setObject:[ArcosUtils convertNilToEmpty:[myCellData objectForKey:@"subject"]] forKey:@"Name"];
//        NSNumber* myLocationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:myCellData];
//        [resultCellDataDict setObject:[ArcosUtils convertNilToZero:myLocationIUR] forKey:@"LocationIUR"];
//        [templateListingDisplayList addObject:resultCellDataDict];
//    }
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.displayList = templateListingDisplayList;
    ACEEDTVC.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ACEEDTVC];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.barButtonItem = self.addEventBarButtonItem;
    tmpNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:tmpNavigationController animated:YES completion:nil];
    [ACEEDTVC release];
    [tmpNavigationController release];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self retrieveCalendarEventEntries];
}

- (void)dealloc {
    self.templateView = nil;
    self.journeyDateDesc = nil;
    self.journeyDateValue = nil;
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
        [self editPressed];
    }
}

- (void)retrieveCalendarEventEntries {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
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
                [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    [weakSelf.HUD hide:YES];
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
                    
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        [weakSelf.HUD hide:YES];
                    }];
                });
            } else {
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
//                NSLog(@"eventList %@", eventList);
                int firstEventIndex = 0;
                BOOL eventFoundFlag = false;
                NSNumber* firstEventLocationIUR = [NSNumber numberWithInt:0];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        self.detailingCalendarEventBoxViewDataManager.originalEventDataDict = [self.detailingCalendarEventBoxViewDataManager populateCalendarEventEntryWithData:auxEventDict];
                        self.detailingCalendarEventBoxViewDataManager.calendarDateData = [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"StartDate"];
                        eventFoundFlag = true;
                        firstEventIndex = i;
                        firstEventLocationIUR = [NSNumber numberWithInt:[locationIUR intValue]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
                            self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.nextAppointmentText;
                            self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
                            self.calendarDatePicker.date = self.detailingCalendarEventBoxViewDataManager.calendarDateData;
                        });
                        break;
                    }
                }
                
//                if (eventFoundFlag) {
//                    NSDictionary* firstEventDict = [NSDictionary dictionaryWithDictionary:[eventList objectAtIndex:firstEventIndex]];
//                    [self.detailingCalendarEventBoxViewDataManager.listingDisplayList addObject:firstEventDict];
//                    NSString* firstEventStartDateDatePartString = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
//                    for (int j = firstEventIndex + 1; j < [eventList count]; j++) {
//                        NSDictionary* tmpEventDict = [eventList objectAtIndex:j];
//                        NSNumber* tmpLocationIUR = [self retrieveLocationIURWithEventDict:tmpEventDict];
//                        if ([tmpLocationIUR isEqualToNumber:firstEventLocationIUR]) {
//                            NSDictionary* startDict = [tmpEventDict objectForKey:@"start"];
//                            NSString* tmpStartDateStr = [startDict objectForKey:@"dateTime"];
//                            NSDate* tmpStartDate = [ArcosUtils dateFromString:tmpStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
//                            NSString* tmpStartDateDatePartString = [ArcosUtils stringFromDate:tmpStartDate format:[GlobalSharedClass shared].dateFormat];
//                            if ([firstEventStartDateDatePartString isEqualToString:tmpStartDateDatePartString]) {
//                                [self.detailingCalendarEventBoxViewDataManager.listingDisplayList addObject:[NSDictionary dictionaryWithDictionary:tmpEventDict]];
//                            } else {
//                                break;
//                            }
//                        }
//                    }
//                }
                [self retrieveInternalOneDayCalendarEventEntriesWithDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.listingTableView reloadData];
//                    [weakSelf.HUD hide:YES];
//                });
            }
        }
    }];
    [downloadTask resume];
}

//- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict {
//    NSNumber* locationIUR = [NSNumber numberWithInt:0];
//    NSDictionary* locationDict = [anEventDict objectForKey:@"location"];
//    NSString* locationUriStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]]];
//    NSArray* locationUriChildArray = [locationUriStr componentsSeparatedByString:@":"];
//    if ([locationUriChildArray count] == 2) {
//        NSString* tmpLocationIURStr = [locationUriChildArray objectAtIndex:0];
//        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
//    }
//    return locationIUR;
//}

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
                [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    [weakSelf.HUD hide:YES];
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
                    
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        [weakSelf.HUD hide:YES];
                    }];
                });
            } else {
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        [self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                    }
                    [self.detailingCalendarEventBoxViewDataManager.listingDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList count] > 0) {
                        self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.nextAppointmentText;
                    } else {
                        self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.suggestedAppointmentText;
                    }
                    [self.listingTableView reloadData];
                    [weakSelf.HUD hide:YES];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)retrieveOneDayCalendarEventEntriesWithDate:(NSDate*)aStartDate {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
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
                [ArcosUtils showDialogBox:[error localizedDescription] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    [weakSelf.HUD hide:YES];
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
                    
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        [weakSelf.HUD hide:YES];
                    }];
                });
            } else {
                self.detailingCalendarEventBoxViewDataManager.listingDisplayList = [NSMutableArray array];
                self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList = [NSMutableArray array];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* auxEventDict = [eventList objectAtIndex:i];
                    NSNumber* locationIUR = [self.detailingCalendarEventBoxViewDataManager retrieveLocationIURWithEventDict:auxEventDict];
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        [self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                    }
                    [self.detailingCalendarEventBoxViewDataManager.listingDisplayList addObject:[NSDictionary dictionaryWithDictionary:auxEventDict]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.detailingCalendarEventBoxViewDataManager.ownLocationDisplayList count] > 0) {
                        self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.nextAppointmentText;
                    } else {
                        self.calendarDateDesc.text = self.detailingCalendarEventBoxViewDataManager.suggestedAppointmentText;
                    }
                    [self.listingTableView reloadData];
                    [weakSelf.HUD hide:YES];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)addPressed {
    [self.HUD show:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
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
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    [weakSelf.HUD hide:YES];
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
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        [weakSelf.HUD hide:YES];
//                        [weakSelf.actionDelegate didDismissViewProcessor];
                    }];
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
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
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
                [ArcosUtils showDialogBox:[error description] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                    [weakSelf.HUD hide:YES];
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
                    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"HTTP status %d %@", statusCode, [ArcosUtils convertNilToEmpty:errorMsg]] title:@"" delegate:nil target:weakSelf tag:0 handler:^(UIAlertAction *action) {
                        [weakSelf.HUD hide:YES];
//                        [weakSelf.actionDelegate didDismissViewProcessor];
                    }];
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
    self.listingNavigationBar.topItem.title = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].dateFormat];
    if (![existingDateDatePartString isEqualToString:nextDateDatePartString]) {
//        self.detailingCalendarEventBoxViewDataManager.calendarDateData = picker.date;
        [self retrieveOneDayCalendarEventEntriesWithDate:picker.date];
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
    }
}

@end
