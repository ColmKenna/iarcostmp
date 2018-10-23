//
//  OrderHeaderTotalGraphValueDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 21/05/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderHeaderTotalGraphValueDataManager.h"


@implementation OrderHeaderTotalGraphValueDataManager

- (id)init{
    self = [super init];
    if (self != nil) {        
        NSMutableArray* weekOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginOfDay:self.dateOfBeginOfWeek] withEndDate:[ArcosUtils endOfDay:self.currentWeekendDate]];
        self.weekTotalValue = [weekOrderList valueForKeyPath:@"@sum.TotalGoods"];
        
        NSMutableArray* monthOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginDayOfMonth:currentMonth withDate:[NSDate date]] withEndDate:[ArcosUtils endDayOfMonth:currentMonth withDate:[NSDate date]]];
        self.monthTotalValue = [monthOrderList valueForKeyPath:@"@sum.TotalGoods"];
        
        NSMutableArray* yearOrderList = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginDayOfMonth:1 withDate:[NSDate date]] withEndDate:[ArcosUtils endDayOfMonth:12 withDate:[NSDate date]]];
        self.yearTotalValue = [yearOrderList valueForKeyPath:@"@sum.TotalGoods"];
    }
    return self;
}

- (void)createBasicLineChartData {
    NSMutableDictionary* targetDict = [self latestPersonalTarget];
    self.maxOfWeekYAxis = [targetDict objectForKey:@"weekTarget"];    
    NSMutableArray* lineContentArray = [NSMutableArray array];
    self.weekAccumulativeValue = 0.0f;
    for ( NSUInteger i = 0; i < 7; i++ ) {
        NSTimeInterval x = i;
        NSDate* aDate = [ArcosUtils dateWithBeginOfWeek:self.dateOfBeginOfWeek interval:i];
        NSMutableArray* allOrders = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginOfDay:aDate]  withEndDate:[ArcosUtils endOfDay:aDate]];
        NSNumber* totalOrderValueDate = [allOrders valueForKeyPath:@"@sum.TotalGoods"];
        self.weekAccumulativeValue = self.weekAccumulativeValue + [totalOrderValueDate floatValue];
        
        [lineContentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber numberWithDouble:x], @"x", [NSNumber numberWithFloat:self.weekAccumulativeValue], @"y", nil]];
    }
    
    if (self.weekAccumulativeValue > [[targetDict objectForKey:@"weekTarget"] floatValue]) {
        self.maxOfWeekYAxis = [NSNumber numberWithFloat:(self.weekAccumulativeValue + self.weekAccumulativeValue / 10)];
    }    
    self.weekDisplayList = lineContentArray;
}

- (void)createBasicPieChartData {
    NSMutableDictionary* targetDict = [self latestPersonalTarget];
    float monthPercentage = [self.monthTotalValue floatValue] / [[targetDict objectForKey:@"monthTarget"] floatValue] * 100;
    
    monthPercentage = [self validateThePercentage:monthPercentage pieChart:YES];    
    float monthRemainPercentage = 100 - monthPercentage;
    monthRemainPercentage = [self convertMinusPercentage:monthRemainPercentage];
    
    self.monthDisplayList = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:monthPercentage], [NSNumber numberWithFloat:monthRemainPercentage], nil];
    self.monthNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[self.monthDisplayList count]];
    self.monthLabelDisplayList = [NSMutableArray arrayWithArray:self.monthDisplayList];
    for (int i = 0; i < [self.monthDisplayList count]; i++) {
        [self.monthNullLabelDisplayList addObject:[NSNull null]];
    }
}

- (void)createBasicBarChartData {
    NSMutableDictionary* targetDict = [self latestPersonalTarget];
    NSMutableArray* barContentArray = [NSMutableArray arrayWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        NSMutableArray* allOrders = [[ArcosCoreData sharedArcosCoreData] ordersWithDataRangeStart:[ArcosUtils beginDayOfMonth:i withDate:[NSDate date]]  withEndDate:[ArcosUtils endDayOfMonth:i withDate:[NSDate date]]];
        NSNumber* totalOrderValueMonth = [allOrders valueForKeyPath:@"@sum.TotalGoods"];
        NSMutableDictionary* orderDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [orderDict setObject:totalOrderValueMonth forKey:self.barTotalValueMonthKey];
        [barContentArray addObject:orderDict];
    }
    self.yearDisplayList = barContentArray;
    
    self.maxOfYearYAxis = [self.yearDisplayList valueForKeyPath:[NSString stringWithFormat:@"@max.%@", self.barTotalValueMonthKey]];
    if ([self.maxOfYearYAxis floatValue] < [[targetDict objectForKey:@"monthTarget"] floatValue]) {
        self.maxOfYearYAxis = [targetDict objectForKey:@"monthTarget"];
    }
}

@end
