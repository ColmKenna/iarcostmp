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

@synthesize myBarButtonItem = _myBarButtonItem;
@synthesize myNavigationItem = _myNavigationItem;
@synthesize myNavigationBar = _myNavigationBar;

@synthesize detailingCalendarEventBoxViewDataManager = _detailingCalendarEventBoxViewDataManager;
@synthesize HUD = _HUD;
@synthesize widgetFactory = _widgetFactory;
@synthesize globalWidgetViewController = _globalWidgetViewController;

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
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        self.calendarDateDesc.hidden = YES;
        self.calendarDateValue.hidden = YES;
        self.myNavigationItem.rightBarButtonItem = nil;
    }
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.templateView] autorelease];
    self.HUD.dimBackground = YES;
    [self.templateView addSubview:self.HUD];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.templateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.templateView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.templateView.layer.mask = maskLayer;
    [maskLayer release];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    int mergeIdValue = [[employeeDict objectForKey:@"MergeID"] intValue];
    self.detailingCalendarEventBoxViewDataManager.journeyDateData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
    self.detailingCalendarEventBoxViewDataManager.calendarDateData = [ArcosUtils addDays:mergeIdValue * 7 date:[NSDate date]];
    self.journeyDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.journeyDateData format:[GlobalSharedClass shared].dateFormat];
    self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.calendarDateValue addGestureRecognizer:singleTap];
    [singleTap release];
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
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
    
    self.myBarButtonItem = nil;
    self.myNavigationItem = nil;
    self.myNavigationBar = nil;
    
    self.detailingCalendarEventBoxViewDataManager = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.widgetFactory = nil;
    self.globalWidgetViewController = nil;
    
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
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
            [self.actionDelegate didDismissViewProcessor];
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
                    [weakSelf.actionDelegate didDismissViewProcessor];
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
                        [weakSelf.actionDelegate didDismissViewProcessor];
                    }];
                });
            } else {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//                NSLog(@"calendar entries res %@ -- %@", result, data);
                NSDictionary* resultDict = (NSDictionary*)result;
                NSArray* eventList = [resultDict objectForKey:@"value"];
//                NSLog(@"eventList %@", eventList);
                for (int i = 0; i < [eventList count]; i++) {
                    NSDictionary* tmpEventDict = [eventList objectAtIndex:i];
                    NSDictionary* locationDict = [tmpEventDict objectForKey:@"location"];
                    NSString* locationUriStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]]];
                    NSNumber* locationIUR = [NSNumber numberWithInt:0];
                    NSArray* locationUriChildArray = [locationUriStr componentsSeparatedByString:@":"];
                    if ([locationUriChildArray count] == 2) {
                        NSString* tmpLocationIURStr = [locationUriChildArray objectAtIndex:0];
                        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
                    }
                    if ([[self.actionDelegate retrieveDetailingLocationIUR] isEqualToNumber:locationIUR]) {
                        self.detailingCalendarEventBoxViewDataManager.originalEventDataDict = [self.detailingCalendarEventBoxViewDataManager populateCalendarEventEntryWithData:tmpEventDict];
                        self.detailingCalendarEventBoxViewDataManager.calendarDateData = [self.detailingCalendarEventBoxViewDataManager.originalEventDataDict objectForKey:@"StartDate"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.calendarDateValue.text = [ArcosUtils stringFromDate:self.detailingCalendarEventBoxViewDataManager.calendarDateData format:[GlobalSharedClass shared].datetimehmFormat];
                        });
                        break;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
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
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
            [self.actionDelegate didDismissViewProcessor];
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
                    [weakSelf.actionDelegate didDismissViewProcessor];
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
                        [weakSelf.actionDelegate didDismissViewProcessor];
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
        [ArcosUtils showDialogBox:@"Email account not set up" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.HUD hide:YES];
            [self.actionDelegate didDismissViewProcessor];
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
                    [weakSelf.actionDelegate didDismissViewProcessor];
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
                        [weakSelf.actionDelegate didDismissViewProcessor];
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

@end
