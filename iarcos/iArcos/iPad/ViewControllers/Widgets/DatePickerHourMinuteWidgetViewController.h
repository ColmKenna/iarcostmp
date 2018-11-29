//
//  DatePickerHourMinuteWidgetViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "WidgetViewController.h"
#import "ArcosUtils.h"

typedef enum {
    DatePickerHourMinuteAccessTimesType = 0,
    DatePickerHourMinuteNormalType
} DatePickerHourMinuteWidgetType;

@interface DatePickerHourMinuteWidgetViewController : WidgetViewController {
    UIDatePicker* _myDatePicker;
    UIBarButtonItem* _myBarButtonItem;
    UINavigationItem* _myNavigationItem;
    UINavigationBar* _myNavigationBar;
    NSDate* _defaultPickerDate;
    DatePickerHourMinuteWidgetType _widgetType;
    NSDate* _minDate;
    NSDate* _maxDate;
}

@property(nonatomic, retain) IBOutlet UIDatePicker* myDatePicker;
@property(nonatomic, retain) IBOutlet UIBarButtonItem* myBarButtonItem;
@property(nonatomic, retain) IBOutlet UINavigationItem* myNavigationItem;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) NSDate* defaultPickerDate;
@property(nonatomic, assign) DatePickerHourMinuteWidgetType widgetType;
@property(nonatomic, retain) NSDate* minDate;
@property(nonatomic, retain) NSDate* maxDate;

- (instancetype)initWithType:(DatePickerHourMinuteWidgetType)aWidgetType datePickerValue:(NSDate*)aDatePickerValue minDate:(NSDate*)aMinDate maxDate:(NSDate*)aMaxDate;

@end
