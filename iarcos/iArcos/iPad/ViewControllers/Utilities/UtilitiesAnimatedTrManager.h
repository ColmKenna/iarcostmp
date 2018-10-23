//
//  UtilitiesAnimatedTrManager.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilitiesAnimatedDataManager.h"
#import "CorePlot-CocoaTouch.h"
#import "OrderHeaderTotalGraphDataManager.h"

@interface UtilitiesAnimatedTrManager : NSObject <CPTPlotSpaceDelegate> {
    CPTXYAxisSet* _yearBarChartAxisSet;
    NSString* _yearBarChartTitle;
    NSString* _monthTableChartTitle;
    CPTXYAxisSet* _monthPieChartAxisSet;
    NSString* _monthPieChartTitle;
    CPTLegend* _monthPieChartLegend;
    CPTXYAxisSet* _weekLineChartAxisSet;
    NSString* _weekLineChartTitle;
    CPTLegend* _weekLineChartLegend;
}

@property(nonatomic, retain) CPTXYAxisSet* yearBarChartAxisSet;
@property(nonatomic, retain) NSString* yearBarChartTitle;
@property(nonatomic, retain) NSString* monthTableChartTitle;
@property(nonatomic, retain) CPTXYAxisSet* monthPieChartAxisSet;
@property(nonatomic, retain) NSString* monthPieChartTitle;
@property(nonatomic, retain) CPTLegend* monthPieChartLegend;
@property(nonatomic, retain) CPTXYAxisSet* weekLineChartAxisSet;
@property(nonatomic, retain) NSString* weekLineChartTitle;
@property(nonatomic, retain) CPTLegend* weekLineChartLegend;

- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (CPTTheme*)createDefaultTheme;
- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize;
- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize fontColor:(CPTColor*)aFontColor;
- (void)setDefaultPadding:(CPTXYGraph*)aGraph;
- (void)constructTableChart:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)aDataManager target:(id)aTarget;
- (void)constructLineChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (void)removeAllSubViews:(UIView*)aView;
- (void)clearAllSubViews:(UIView*)aView;
- (void)captureSnapshot:(UIView*)aView;

@end
