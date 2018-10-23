//
//  DatePickerWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "ArcosConfigDataManager.h"
typedef enum {
    DatePickerDeliveryDateType = 0,
    DatePickerOrderDateType = 1,
    DatePickerNormalDateType = 2
} DatePickerWidgetType;

typedef enum {
    DatePickerFormatDate = 0,
    DatePickerFormatDateTime = 1,
    DatePickerFormatForceDateTime = 2
} DatePickerFormatType;

@interface DatePickerWidgetViewController : WidgetViewController {
    DatePickerWidgetType type;
    IBOutlet UIDatePicker* picker;
    NSDate* _defaultPickerDate;
    DatePickerFormatType _pickerFormatType;
    UIButton* _bottomButton;
    UIBarButtonItem* _myBarButtonItem;
    UINavigationItem* _myNavigationItem;
    UINavigationBar* _myNavigationBar;
}
@property(nonatomic,assign) DatePickerWidgetType type;
@property(nonatomic,retain) IBOutlet  UIDatePicker* picker;
@property(nonatomic,retain) NSDate* defaultPickerDate;
@property(nonatomic,assign) DatePickerFormatType pickerFormatType;
@property(nonatomic,retain) IBOutlet UIButton* bottomButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem* myBarButtonItem;
@property(nonatomic,retain) IBOutlet UINavigationItem* myNavigationItem;
@property(nonatomic,retain) IBOutlet UINavigationBar* myNavigationBar;

-(id)initWithType:(DatePickerWidgetType)aType;
-(id)initWithType:(DatePickerWidgetType)aType defaultPickerDate:(NSDate*)aDefaultPickerDate;
-(id)initWithType:(DatePickerWidgetType)aType pickerFormatType:(DatePickerFormatType)aPickerFormatType;
-(id)initWithType:(DatePickerWidgetType)aType pickerFormatType:(DatePickerFormatType)aPickerFormatType defaultPickerDate:(NSDate*)aDefaultPickerDate;
@end
