//
//  DatePickerHourMinuteWidgetViewController.m
//  iArcos
//
//  Created by David Kilmartin on 15/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "DatePickerHourMinuteWidgetViewController.h"

@interface DatePickerHourMinuteWidgetViewController ()

@end

@implementation DatePickerHourMinuteWidgetViewController
@synthesize myDatePicker = _myDatePicker;
@synthesize myBarButtonItem = _myBarButtonItem;
@synthesize myNavigationItem = _myNavigationItem;
@synthesize myNavigationBar = _myNavigationBar;
@synthesize defaultPickerDate = _defaultPickerDate;
@synthesize widgetType = _widgetType;
@synthesize minDate = _minDate;
@synthesize maxDate = _maxDate;

- (instancetype)initWithType:(DatePickerHourMinuteWidgetType)aWidgetType datePickerValue:(NSDate*)aDatePickerValue minDate:(NSDate*)aMinDate maxDate:(NSDate*)aMaxDate {
    self = [super init];
    if (self != nil) {
        self.widgetType = aWidgetType;
        self.defaultPickerDate = aDatePickerValue;
        self.minDate = aMinDate;
        self.maxDate = aMaxDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.widgetType == DatePickerHourMinuteAccessTimesType) {
        NSArray* minuteItemList = [NSArray arrayWithObjects:@"0 min", @"15 min", @"30 min", @"45 min", nil];
        UISegmentedControl* mySegmentedController = [[UISegmentedControl alloc] initWithItems:minuteItemList];
        [mySegmentedController addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
        mySegmentedController.frame = CGRectMake(0, 0, 200, 30);
        mySegmentedController.momentary = YES;
        self.myNavigationItem.titleView = mySegmentedController;
        [mySegmentedController release];
    } else {
        self.myNavigationItem.title = @"Time";
    }
    
    if (self.defaultPickerDate != nil) {
        self.myDatePicker.date = self.defaultPickerDate;
    }
    if (self.minDate != nil) {
        self.myDatePicker.minimumDate = self.minDate;
    }
    if (self.maxDate != nil) {
        self.myDatePicker.maximumDate = self.maxDate;
    }
}

- (void)segmentedAction:(id)sender {
    UISegmentedControl* segmentedController = (UISegmentedControl*)sender;
    NSDate* auxDate = [ArcosUtils configDateWithMinute:[ArcosUtils convertNSIntegerToInt:segmentedController.selectedSegmentIndex] * 15 date:self.myDatePicker.date];
    BOOL resultFlag = NO;
    if (self.minDate != nil) {
        if ([auxDate compare:self.minDate] == NSOrderedDescending || [auxDate compare:self.minDate] == NSOrderedSame) {
            resultFlag = YES;
        }
    }
    if (self.maxDate != nil) {
        if ([auxDate compare:self.maxDate] == NSOrderedAscending || [auxDate compare:self.maxDate] == NSOrderedSame) {
            resultFlag = YES;
        }
    }
    if (self.minDate == nil && self.maxDate == nil) {
        resultFlag = YES;
    }
    if (resultFlag) {
        self.myDatePicker.date = auxDate;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myDatePicker = nil;
    self.myBarButtonItem = nil;
    self.myNavigationItem = nil;
    self.myNavigationBar = nil;
    self.defaultPickerDate = nil;
    self.minDate = nil;
    self.maxDate = nil;
    
    [super dealloc];
}

- (IBAction)operationDone:(id)sender {
    [self.delegate operationDone:self.myDatePicker.date];
}

@end
