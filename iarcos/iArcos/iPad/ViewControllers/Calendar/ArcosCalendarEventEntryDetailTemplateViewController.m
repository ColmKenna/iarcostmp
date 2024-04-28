//
//  ArcosCalendarEventEntryDetailTemplateViewController.m
//  iArcos
//
//  Created by Richard on 31/01/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailTemplateViewController.h"

@interface ArcosCalendarEventEntryDetailTemplateViewController ()

@end

@implementation ArcosCalendarEventEntryDetailTemplateViewController
@synthesize mainTemplateView = _mainTemplateView;
@synthesize mainNavigationBar = _mainNavigationBar;
@synthesize eventTemplateView = _eventTemplateView;
@synthesize listingTemplateView = _listingTemplateView;
@synthesize actionDelegate = _actionDelegate;
@synthesize presentDelegate = _presentDelegate;
@synthesize eventNavigationBar = _eventNavigationBar;
@synthesize eventTableView = _eventTableView;
@synthesize arcosCalendarEventEntryDetailTableViewController = _arcosCalendarEventEntryDetailTableViewController;
@synthesize HUD = _HUD;
@synthesize listingNavigationBar = _listingNavigationBar;
@synthesize listingTableView = _listingTableView;
@synthesize arcosCalendarEventEntryDetailListingDataManager = _arcosCalendarEventEntryDetailListingDataManager;
@synthesize listingTitleLabel = _listingTitleLabel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arcosCalendarEventEntryDetailTableViewController = [[[ArcosCalendarEventEntryDetailTableViewController alloc] init] autorelease];
        self.arcosCalendarEventEntryDetailTableViewController.actionDelegate = self;
        self.arcosCalendarEventEntryDetailListingDataManager = [[[ArcosCalendarEventEntryDetailListingDataManager alloc] init] autorelease];
        self.arcosCalendarEventEntryDetailListingDataManager.actionDelegate = self;
    }
    return self;
}

#pragma mark - ArcosCalendarEventEntryDetailListingDataManagerDelegate
- (NSNumber*)retrieveEventEntryDetailListingLocationIUR {
    return [self.actionDelegate retrieveLocationIURTemplateDelegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    UIColor* barBackgroundColor = [UIColor colorWithRed:209.0/255.0 green:224.0/255.0 blue:251.0/255.0 alpha:1.0];
    UIColor* barForegroundColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    if (self.arcosCalendarEventEntryDetailListingDataManager.showBorderFlag) {
        [self.mainTemplateView.layer setBorderColor:[barForegroundColor CGColor]];
        [self.mainTemplateView.layer setBorderWidth:1.0];
    }    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:barBackgroundColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:barForegroundColor, NSForegroundColorAttributeName, nil]];
        self.mainNavigationBar.standardAppearance = customNavigationBarAppearance;
        self.mainNavigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
        [self.mainNavigationBar setTintColor:barForegroundColor];
    } else {
        // Fallback on earlier versions
        [self.mainNavigationBar setBarTintColor:barBackgroundColor];
        [self.mainNavigationBar setTintColor:barForegroundColor];
    }
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.mainNavigationBar.topItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    if ([self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.actionType isEqualToString:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.createText]) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addPressed)];
        [self.mainNavigationBar.topItem setRightBarButtonItem:addButton];
        [addButton release];
    } else {
        if (!self.arcosCalendarEventEntryDetailListingDataManager.hideEditButtonFlag) {
            UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(editPressed)];
            [self.mainNavigationBar.topItem setRightBarButtonItem:editButton];
            [editButton release];
        }
    }
    
    self.eventTableView.dataSource = self.arcosCalendarEventEntryDetailTableViewController;
    self.eventTableView.delegate = self.arcosCalendarEventEntryDetailTableViewController;
//    self.listingTableView.dataSource = self.arcosCalendarEventEntryDetailListingDataManager;
//    self.listingTableView.delegate = self.arcosCalendarEventEntryDetailListingDataManager;
    self.listingTableView.dataSource = self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager;
    self.listingTableView.delegate = self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager;
//    self.listingNavigationBar.topItem.title = self.arcosCalendarEventEntryDetailListingDataManager.barTitleContent;
    self.listingTitleLabel.text = self.arcosCalendarEventEntryDetailListingDataManager.barTitleContent;
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleListingTitleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.listingTitleLabel addGestureRecognizer:doubleTap];
    [doubleTap release];
}

- (void)handleListingTitleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* auxRecognizer = (UITapGestureRecognizer*)sender;
    if (auxRecognizer.state == UIGestureRecognizerStateEnded) {
        [self scrollToAppointmentPositionProcessor];
    }
}

- (void)dealloc {
    self.mainTemplateView = nil;
    self.mainNavigationBar = nil;
    self.eventTemplateView = nil;
    self.listingTemplateView = nil;
    self.eventNavigationBar = nil;
    self.eventTableView = nil;
    self.arcosCalendarEventEntryDetailTableViewController = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.listingNavigationBar = nil;
    self.listingTableView = nil;
    self.arcosCalendarEventEntryDetailListingDataManager = nil;
    self.listingTitleLabel = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.listingTableView reloadData];
//    [self.listingTableView layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToAppointmentPositionProcessor];
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [ArcosUtils maskTemplateViewWithView:self.eventTemplateView];
//    [ArcosUtils maskTemplateViewWithView:self.listingTemplateView];
    self.HUD.frame = self.navigationController.view.frame;
    
//    [self.listingTableView layoutIfNeeded];
//    [self scrollToAppointmentPositionProcessor];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mainTemplateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mainTemplateView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mainTemplateView.layer.mask = maskLayer;
    [maskLayer release];
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

- (void)cancelPressed {
    [self.presentDelegate didDismissModalPresentViewController];
}

- (void)editPressed {
//    NSLog(@"editPressed");
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditEventDictWithLocationUri:[self.actionDelegate retrieveLocationUriTemplateDelegate]];
    if ([eventDict count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSString* allDayFlag = [eventDict objectForKey:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.allDayKey];
    if (allDayFlag == nil) {
        NSString* originalAllDayInt = [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"IsAllDay"];
        allDayFlag = @"true";
        if (![originalAllDayInt isEqualToString:@"1"]) {
            allDayFlag = @"false";
        }
    }
//    NSLog(@"allDayFlag %@", allDayFlag);
//    NSLog(@"allDayFlag 2 %@ %@", self.arcosCalendarEventEntryDetailDataManager.editEndDate, self.arcosCalendarEventEntryDetailDataManager.editStartDate);
    if ([allDayFlag isEqualToString:@"true"] && [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.editEndDate compare:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.editStartDate] != NSOrderedDescending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    if ([self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.editEndDate compare:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.editStartDate] == NSOrderedAscending) {
        [ArcosUtils showDialogBox:@"The start date must be before the end date" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI, [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"Id"]]];
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
                    [weakSelf.actionDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)addPressed {
//    NSLog(@"addPressed");
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEventDictWithLocationUri:[self.actionDelegate retrieveLocationUriTemplateDelegate]];
    NSString* allDayFlag = [eventDict objectForKey:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.allDayKey];
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
                    [weakSelf.actionDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

#pragma mark - ArcosCalendarEventEntryDetailTableViewControllerDelegate

- (void)deleteButtonPressedDelegate {
    void (^deleteActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteEventProcessor];
    };
    void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure you want to delete this event?" title:@"" delegate:nil target:self tag:0 lBtnText:@"Cancel" rBtnText:@"Delete Event" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
}

- (void)deleteEventProcessor {
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[ArcosConstantsDataManager sharedArcosConstantsDataManager].acctNotSignInMsg title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[ArcosConstantsDataManager sharedArcosConstantsDataManager].kGraphEventURI, [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.originalEventDataDict objectForKey:@"Id"]]];
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
                    [weakSelf.actionDelegate refreshCalendarTableViewController];
                    [weakSelf.presentDelegate didDismissModalPresentViewController];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (UITableView*)retrieveEventTableView {
    return self.eventTableView;
}

- (UIViewController*)retrieveArcosCalendarEventEntryDetailTemplateViewController {
    return self;
}

- (void)refreshTableRightHandSideBarWithDate:(NSDate*)aDate {
    self.arcosCalendarEventEntryDetailListingDataManager.barTitleContent = [ArcosUtils stringFromDate:aDate format:[GlobalSharedClass shared].weekdayDateFormat];
//    self.listingNavigationBar.topItem.title = self.arcosCalendarEventEntryDetailListingDataManager.barTitleContent;
    self.listingTitleLabel.text = self.arcosCalendarEventEntryDetailListingDataManager.barTitleContent;;
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
    NSURL* url = [NSURL URLWithString:[self.arcosCalendarEventEntryDetailListingDataManager retrieveCalendarURIWithStartDate:startDateString endDate:endDateString]];
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
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
                [self.arcosCalendarEventEntryDetailListingDataManager createTemplateListingDisplayListWithEventList:eventList];
                [self.arcosCalendarEventEntryDetailListingDataManager.detailingCalendarEventBoxListingDataManager createBasicDataForTemplateWithDataList:self.arcosCalendarEventEntryDetailListingDataManager.displayList];
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

@end
