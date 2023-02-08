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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arcosCalendarEventEntryDetailTableViewController = [[[ArcosCalendarEventEntryDetailTableViewController alloc] init] autorelease];
        self.arcosCalendarEventEntryDetailTableViewController.actionDelegate = self;
        self.arcosCalendarEventEntryDetailListingDataManager = [[[ArcosCalendarEventEntryDetailListingDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    if ([self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.actionType isEqualToString:self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager.createText]) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addPressed)];
        [self.navigationItem setRightBarButtonItem:addButton];
        [addButton release];
    } else {
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editPressed)];
        [self.navigationItem setRightBarButtonItem:editButton];
        [editButton release];
    }
    
    self.eventTableView.dataSource = self.arcosCalendarEventEntryDetailTableViewController;
    self.eventTableView.delegate = self.arcosCalendarEventEntryDetailTableViewController;
    self.listingTableView.dataSource = self.arcosCalendarEventEntryDetailListingDataManager;
    self.listingTableView.delegate = self.arcosCalendarEventEntryDetailListingDataManager;
}

- (void)dealloc {
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
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [ArcosUtils maskTemplateViewWithView:self.eventTemplateView];
    [ArcosUtils maskTemplateViewWithView:self.listingTemplateView];
}

- (void)cancelPressed {
    [self.presentDelegate didDismissModalPresentViewController];
}

- (void)editPressed {
//    NSLog(@"editPressed");
    [self.HUD show:YES];
    [self.view endEditing:YES];
    if ([[ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEditEventDict];
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
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        return;
    }
    NSMutableDictionary* eventDict = [self.arcosCalendarEventEntryDetailTableViewController.arcosCalendarEventEntryDetailDataManager retrieveEventDict];
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
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:nil];
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

@end
