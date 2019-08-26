//
//  OrderHeaderTotalGraphDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 15/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "ArcosCoreData.h"
#import "SettingManager.h"

@interface OrderHeaderTotalGraphDataManager : NSObject {
    NSMutableDictionary* _orderTotalValueDict;
    NSNumber* _dayOfWeekend;
    NSDate* _currentWeekendDate;
    NSDate* _dateOfBeginOfWeek;
    NSNumber* _weekOrderTotalValue;
    NSNumber* _monthOrderTotalValue;
    NSNumber* _yearOrderTotalValue;
    NSNumber* _weekTotalValue;
    NSNumber* _monthTotalValue;
    NSNumber* _yearTotalValue;
    NSInteger currentMonth;
    SettingManager* _settingManager;
    NSMutableArray* _weekDisplayList;
    NSString* _weekBarChartIdentifier;
    
    NSMutableArray* _monthNullLabelDisplayList;
    NSMutableArray* _monthLabelDisplayList;
    NSMutableArray* _monthDisplayList;
    NSMutableArray* _yearDisplayList;
    NSString* _targetMonthBarChartIdentifier;
    NSString* _actualMonthBarChartIdentifier;
    
    float weekAccumulativeOrderValue;
    float _weekAccumulativeValue;
    NSNumber* _maxOfWeekYAxis;
    NSNumber* _maxOfWeekXAxis;
    NSString* _barTotalValueDayKey;
    
    NSNumber* _maxOfYearYAxis;
    NSDictionary* _weekdayMapDict;
    NSDictionary* _monthMapDict;
    
    NSMutableArray* _legendList;
    NSString* _barTotalValueMonthKey;
}

@property(nonatomic, retain) NSMutableDictionary* orderTotalValueDict;
@property(nonatomic, retain) NSNumber* dayOfWeekend;
@property(nonatomic, retain) NSDate* currentWeekendDate;
@property(nonatomic, retain) NSDate* dateOfBeginOfWeek;
@property(nonatomic, retain) NSNumber* weekOrderTotalValue;
@property(nonatomic, retain) NSNumber* monthOrderTotalValue;
@property(nonatomic, retain) NSNumber* yearOrderTotalValue;
@property(nonatomic, retain) NSNumber* weekTotalValue;
@property(nonatomic, retain) NSNumber* monthTotalValue;
@property(nonatomic, retain) NSNumber* yearTotalValue;
@property(nonatomic, retain) SettingManager* settingManager;
@property(nonatomic, retain) NSMutableArray* weekDisplayList;
@property(nonatomic, retain) NSString* weekBarChartIdentifier;

@property(nonatomic, retain) NSMutableArray* monthNullLabelDisplayList;
@property(nonatomic, retain) NSMutableArray* monthLabelDisplayList;
@property(nonatomic, retain) NSMutableArray* monthDisplayList;
@property(nonatomic, retain) NSMutableArray* yearDisplayList;
@property(nonatomic, retain) NSString* targetMonthBarChartIdentifier;
@property(nonatomic, retain) NSString* actualMonthBarChartIdentifier;

@property(nonatomic, assign) float weekAccumulativeValue;
@property(nonatomic, retain) NSNumber* maxOfWeekYAxis;
@property(nonatomic, retain) NSNumber* maxOfWeekXAxis;
@property(nonatomic, retain) NSString* barTotalValueDayKey;

@property(nonatomic, retain) NSNumber* maxOfYearYAxis;
@property(nonatomic, retain) NSDictionary* weekdayMapDict;
@property(nonatomic, retain) NSDictionary* monthMapDict;
@property(nonatomic, retain) NSMutableArray* legendList;
@property(nonatomic, retain) NSString* barTotalValueMonthKey;

- (NSMutableDictionary*)latestPersonalTarget;
- (void)createBasicPieChartData;
- (float)validateThePercentage:(float)aValue pieChart:(BOOL)aFlag;
- (float)convertMinusPercentage:(float)aValue;
- (void)createBasicLineChartData;
- (void)createBasicBarChartData;

@end
