//
//  AccessTimesWidgetViewController.m
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "AccessTimesWidgetViewController.h"

@interface AccessTimesWidgetViewController ()
- (NSMutableDictionary*)createWeekDayDict:(NSString*)aTitle fieldValue:(NSNumber*)aFieldValue;
- (NSMutableDictionary*)retrieveWeekDayDictWithDay:(int)aDay;
- (void)showPopoverProcessor;
- (NSDate*)retrieveQuarterlyDate:(NSDate*)aDate;
- (void)clearAllWeekDayDefaultFlag;
@end

@implementation AccessTimesWidgetViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize weekDayLabel = _weekDayLabel;
@synthesize startTimeTitleLabel = _startTimeTitleLabel;
@synthesize startTimeContentLabel = _startTimeContentLabel;
@synthesize endTimeTitleLabel = _endTimeTitleLabel;
@synthesize endTimeContentLabel = _endTimeContentLabel;
@synthesize weekDayDictList = _weekDayDictList;
@synthesize widgetFactory = _widgetFactory;
@synthesize thePopover = _thePopover;
@synthesize myTitle = _myTitle;
@synthesize currentSelectedLabel = _currentSelectedLabel;
@synthesize weekDayCellDict = _weekDayCellDict;
@synthesize startTimeCellDate = _startTimeCellDate;
@synthesize endTimeCellDate = _endTimeCellDate;
@synthesize auxDefaultKey = _auxDefaultKey;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.auxDefaultKey = @"IsDefault";
        self.weekDayDictList = [NSMutableArray arrayWithCapacity:7];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Sunday" fieldValue:[NSNumber numberWithInt:0]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Monday" fieldValue:[NSNumber numberWithInt:1]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Tuesday" fieldValue:[NSNumber numberWithInt:2]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Wednesday" fieldValue:[NSNumber numberWithInt:3]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Thursday" fieldValue:[NSNumber numberWithInt:4]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Friday" fieldValue:[NSNumber numberWithInt:5]]];
        [self.weekDayDictList addObject:[self createWeekDayDict:@"Saturday" fieldValue:[NSNumber numberWithInt:6]]];
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
        self.myTitle = @"Access Times";
        NSDate* currentDate = [NSDate date];
        int weekDay = [ArcosUtils convertNSIntegerToInt:[ArcosUtils weekDayWithDate:currentDate]] - 1;
        self.weekDayCellDict = [self retrieveWeekDayDictWithDay:weekDay];
        self.startTimeCellDate = [self retrieveQuarterlyDate:currentDate];
        self.endTimeCellDate = [ArcosUtils addHours:1 date:self.startTimeCellDate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.title = self.myTitle;
    self.weekDayLabel.text = [self.weekDayCellDict objectForKey:@"Title"];
    self.startTimeContentLabel.text = [ArcosUtils stringFromDate:self.startTimeCellDate format:[GlobalSharedClass shared].hourMinuteFormat];
    self.endTimeContentLabel.text = [ArcosUtils stringFromDate:self.endTimeCellDate format:[GlobalSharedClass shared].hourMinuteFormat];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    UITapGestureRecognizer* weekDaySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeekDaySingleTapGesture:)];
    [self.weekDayLabel addGestureRecognizer:weekDaySingleTap];
    [weekDaySingleTap release];
    UITapGestureRecognizer* startTimeSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleStartTimeSingleTapGesture:)];
    [self.startTimeContentLabel addGestureRecognizer:startTimeSingleTap];
    [startTimeSingleTap release];
    UITapGestureRecognizer* endTimeSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndTimeSingleTapGesture:)];
    [self.endTimeContentLabel addGestureRecognizer:endTimeSingleTap];
    [endTimeSingleTap release];
}

- (void)dealloc {
    self.weekDayLabel = nil;
    self.startTimeTitleLabel = nil;
    self.startTimeContentLabel = nil;
    self.endTimeTitleLabel = nil;
    self.endTimeContentLabel = nil;
    self.weekDayDictList = nil;
    self.widgetFactory = nil;
    self.thePopover = nil;
    self.myTitle = nil;
    self.currentSelectedLabel = nil;
    self.auxDefaultKey = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)savePressed:(id)sender {
    [self.actionDelegate accessTimesOperationDone:self.weekDayCellDict startTime:self.startTimeCellDate endTime:self.endTimeCellDate];
}

- (NSMutableDictionary*)createWeekDayDict:(NSString*)aTitle fieldValue:(NSNumber*)aFieldValue {
    NSMutableDictionary* auxWeekDayDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [auxWeekDayDict setObject:aTitle forKey:@"Title"];
    [auxWeekDayDict setObject:aFieldValue forKey:@"FieldValue"];
    [auxWeekDayDict setObject:[NSNumber numberWithBool:NO] forKey:self.auxDefaultKey];
    return auxWeekDayDict;
}

- (void)handleWeekDaySingleTapGesture:(id)sender {
    self.currentSelectedLabel = self.weekDayLabel;
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:self.weekDayDictList title:@"Day"];
    [self showPopoverProcessor];
}

- (void)handleStartTimeSingleTapGesture:(id)sender {
    self.currentSelectedLabel = self.startTimeContentLabel;
    self.thePopover = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteAccessTimesType datePickerValue:self.startTimeCellDate minDate:nil maxDate:self.endTimeCellDate];
    [self showPopoverProcessor];
}

- (void)handleEndTimeSingleTapGesture:(id)sender {
    self.currentSelectedLabel = self.endTimeContentLabel;
    self.thePopover = [self.widgetFactory createDateHourMinuteWidgetWithType:DatePickerHourMinuteAccessTimesType datePickerValue:self.endTimeCellDate minDate:self.startTimeCellDate maxDate:nil];
    [self showPopoverProcessor];
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    switch (self.currentSelectedLabel.tag) {
        case 1: {
            [self clearAllWeekDayDefaultFlag];
            [data setObject:[NSNumber numberWithBool:YES] forKey:self.auxDefaultKey];
            self.weekDayCellDict = data;
            self.weekDayLabel.text = [data objectForKey:@"Title"];
        }
            break;
            
        case 2: {
            self.startTimeCellDate = [self retrieveQuarterlyDate:data];
            self.startTimeContentLabel.text = [ArcosUtils stringFromDate:self.startTimeCellDate format:[GlobalSharedClass shared].hourMinuteFormat];
        }
            break;
            
        case 3: {
            self.endTimeCellDate = [self retrieveQuarterlyDate:data];
            self.endTimeContentLabel.text = [ArcosUtils stringFromDate:self.endTimeCellDate format:[GlobalSharedClass shared].hourMinuteFormat];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

- (NSMutableDictionary*)retrieveWeekDayDictWithDay:(int)aDay {
    NSMutableDictionary* auxResultWeekDayDict = nil;
    [self clearAllWeekDayDefaultFlag];
    for (NSMutableDictionary* aWeekDayDict in self.weekDayDictList) {
        if ([[aWeekDayDict objectForKey:@"FieldValue"] intValue] == aDay) {
            [aWeekDayDict setObject:[NSNumber numberWithBool:YES] forKey:self.auxDefaultKey];
            auxResultWeekDayDict = aWeekDayDict;
            break;
        }
    }
    return auxResultWeekDayDict;
}

- (void)showPopoverProcessor {
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.currentSelectedLabel.bounds inView:self.currentSelectedLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (NSDate*)retrieveQuarterlyDate:(NSDate*)aDate {
    int auxMinutes = [ArcosUtils convertNSIntegerToInt:[ArcosUtils minuteWithDate:aDate]];
    int myMinutes = auxMinutes / 15 * 15;
    return [ArcosUtils configDateWithMinute:myMinutes date:aDate];
}

- (void)clearAllWeekDayDefaultFlag {
    for (NSMutableDictionary* aWeekDayDict in self.weekDayDictList) {
        [aWeekDayDict setObject:[NSNumber numberWithBool:NO] forKey:self.auxDefaultKey];
    }
}

@end
