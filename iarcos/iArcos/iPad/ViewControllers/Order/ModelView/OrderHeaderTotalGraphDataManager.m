//
//  OrderHeaderTotalGraphDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "OrderHeaderTotalGraphDataManager.h"

@implementation OrderHeaderTotalGraphDataManager
@synthesize orderTotalValueDict = _orderTotalValueDict;
@synthesize dayOfWeekend = _dayOfWeekend;
@synthesize currentWeekendDate = _currentWeekendDate;
@synthesize dateOfBeginOfWeek = _dateOfBeginOfWeek;
@synthesize weekOrderTotalValue = _weekOrderTotalValue;
@synthesize monthOrderTotalValue = _monthOrderTotalValue;
@synthesize yearOrderTotalValue = _yearOrderTotalValue;
@synthesize weekTotalValue = _weekTotalValue;
@synthesize monthTotalValue = _monthTotalValue;
@synthesize yearTotalValue = _yearTotalValue;
@synthesize settingManager = _settingManager;
@synthesize weekDisplayList = _weekDisplayList;
@synthesize weekBarChartIdentifier = _weekBarChartIdentifier;

@synthesize monthNullLabelDisplayList = _monthNullLabelDisplayList;
@synthesize monthLabelDisplayList = _monthLabelDisplayList;
@synthesize monthDisplayList = _monthDisplayList;
@synthesize yearDisplayList = _yearDisplayList;
@synthesize targetMonthBarChartIdentifier = _targetMonthBarChartIdentifier;
@synthesize actualMonthBarChartIdentifier = _actualMonthBarChartIdentifier;
@synthesize weekAccumulativeValue = _weekAccumulativeValue;
@synthesize maxOfWeekYAxis = _maxOfWeekYAxis;
@synthesize maxOfWeekXAxis = _maxOfWeekXAxis;
@synthesize barTotalValueDayKey = _barTotalValueDayKey;
@synthesize maxOfYearYAxis = _maxOfYearYAxis;
@synthesize weekdayMapDict = _weekdayMapDict;
@synthesize monthMapDict = _monthMapDict;
@synthesize legendList = _legendList;
@synthesize barTotalValueMonthKey = _barTotalValueMonthKey;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.dayOfWeekend = [ArcosUtils getDayOfWeekend];
        self.currentWeekendDate = [ArcosUtils weekendOfWeek:[NSDate date] config:[self.dayOfWeekend integerValue]];
        self.dateOfBeginOfWeek = [ArcosUtils beginOfWeek:self.currentWeekendDate];
        currentMonth = [ArcosUtils monthDayWithDate:[NSDate date]];
        self.weekBarChartIdentifier = @"Week Bar Plot";
        self.barTotalValueDayKey = @"totalValueDay";
        NSMutableArray* weekOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginOfDay:self.dateOfBeginOfWeek] withEndDate:[ArcosUtils endOfDay:self.currentWeekendDate]];
        self.weekOrderTotalValue = [weekOrderList valueForKeyPath:@"@sum.TotalGoods"];
        
        NSMutableArray* monthOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginDayOfMonth:currentMonth withDate:[NSDate date]] withEndDate:[ArcosUtils endDayOfMonth:currentMonth withDate:[NSDate date]]];
        self.monthOrderTotalValue = [monthOrderList valueForKeyPath:@"@sum.TotalGoods"];
        
        NSMutableArray* yearOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginDayOfMonth:1 withDate:[NSDate date]] withEndDate:[ArcosUtils endDayOfMonth:12 withDate:[NSDate date]]];
        self.yearOrderTotalValue = [yearOrderList valueForKeyPath:@"@sum.TotalGoods"];
        
        NSMutableArray* weekdayMapValueList = [NSMutableArray arrayWithObjects:@"S", @"M", @"T", @"W", @"T", @"F", @"S", nil];
        NSMutableArray* weekdayMapKeyList = [NSMutableArray arrayWithCapacity:8];
        for (int i = 1; i < 8; i++) {
            [weekdayMapKeyList addObject:[NSNumber numberWithInt:i]];
        }        
        self.weekdayMapDict = [NSDictionary dictionaryWithObjects:weekdayMapValueList forKeys:weekdayMapKeyList];
        
        NSMutableArray* monthMapValueList = [NSMutableArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May",@"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
        NSMutableArray* monthMapKeyList = [NSMutableArray arrayWithCapacity:8];
        for (int i = 1; i <= 12; i++) {
            [monthMapKeyList addObject:[NSNumber numberWithInt:i]];
        }    
        self.monthMapDict = [NSDictionary dictionaryWithObjects:monthMapValueList forKeys:monthMapKeyList];
        self.legendList = [NSMutableArray arrayWithObjects:@"Actual", @"Target", nil];
        self.barTotalValueMonthKey = @"totalValueMonth";
        self.targetMonthBarChartIdentifier = @"Target Bar Plot";
        self.actualMonthBarChartIdentifier = @"Actual Bar Plot";
    }
    return self;
}

- (void)dealloc {
    if (self.orderTotalValueDict != nil) { self.orderTotalValueDict = nil; }
    if (self.dayOfWeekend != nil) { self.dayOfWeekend = nil; }
    if (self.currentWeekendDate != nil) { self.currentWeekendDate = nil; }
    if (self.dateOfBeginOfWeek != nil) { self.dateOfBeginOfWeek = nil; }
    self.weekBarChartIdentifier = nil;
    if (self.weekOrderTotalValue != nil) { self.weekOrderTotalValue = nil; }
    if (self.monthOrderTotalValue != nil) { self.monthOrderTotalValue = nil; }
    if (self.yearOrderTotalValue != nil) { self.yearOrderTotalValue = nil; }
    if (self.weekTotalValue != nil) { self.weekTotalValue = nil; }
    if (self.monthTotalValue != nil) { self.monthTotalValue = nil; }
    if (self.yearTotalValue != nil) { self.yearTotalValue = nil; }
    if (self.settingManager != nil) { self.settingManager = nil; }
    if (self.weekDisplayList != nil) { self.weekDisplayList = nil; }
    if (self.monthNullLabelDisplayList != nil) { self.monthNullLabelDisplayList = nil; }
    if (self.monthLabelDisplayList != nil) { self.monthLabelDisplayList = nil; }            
    if (self.monthDisplayList != nil) { self.monthDisplayList = nil; }
    if (self.yearDisplayList != nil) { self.yearDisplayList = nil; }
    self.targetMonthBarChartIdentifier = nil;
    self.actualMonthBarChartIdentifier = nil;
    if (self.maxOfWeekYAxis != nil) { self.maxOfWeekYAxis = nil; }
    self.maxOfWeekXAxis = nil;
    self.barTotalValueDayKey = nil;
    if (self.maxOfYearYAxis != nil) { self.maxOfYearYAxis = nil; }
    if (self.weekdayMapDict != nil) { self.weekdayMapDict = nil; }
    if (self.monthMapDict != nil) { self.monthMapDict = nil; }
    if (self.legendList != nil) { self.legendList = nil; }
    if (self.barTotalValueMonthKey != nil) { self.barTotalValueMonthKey = nil; }    
    
    [super dealloc];
}

- (NSMutableDictionary*)latestPersonalTarget {
    self.settingManager = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"PersonalSetting.%@",@"Personal"];
    NSNumber* weekTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:1] objectForKey:@"Value"];
    NSNumber* monthTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:2] objectForKey:@"Value"];
    NSNumber* yearTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:3] objectForKey:@"Value"];
    NSMutableDictionary* targetDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [targetDict setObject:weekTargetNum forKey:@"weekTarget"];
    [targetDict setObject:monthTargetNum forKey:@"monthTarget"];
    [targetDict setObject:yearTargetNum forKey:@"yearTarget"];  
    return targetDict;
}

- (float)validateThePercentage:(float)aValue pieChart:(BOOL)aFlag {    
    if (isnan(aValue)) {
        return 100.0f;
    } else if (isinf(aValue)) {
        return 100.0f;
    } else if (aValue > 100.0f && aFlag) {
        return 100.0f;
    }    
    return aValue;
}

- (float)convertMinusPercentage:(float)aValue {
    return aValue < 0 ? 0.0f : aValue;
}

- (void)createBasicLineChartData {

}

- (void)createBasicPieChartData {

}

- (void)createBasicBarChartData {

}

@end
