//
//  ReporterTrackGraphViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "ReporterTrackGraphDataManager.h"
#import "CallGenericServices.h"
#import "ReporterTrackDetailViewController.h"
#import "ReporterFileManager.h"

@interface ReporterTrackGraphViewController : UIViewController<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTBarPlotDelegate> {
    CPTGraphHostingView* _trackChartView;
    ReporterTrackGraphDataManager* _reporterTrackGraphDataManager;
    CallGenericServices* _callGenericServices;
    NSNumber* _reportIUR;
    NSDate* _startDate;
    NSDate* _endDate;
    BOOL _isNotFirstLoaded;
    BOOL _isGraphHavingData;
    NSString* _tableName;
    NSNumber* _selectedIUR;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* trackChartView;
@property(nonatomic, retain) ReporterTrackGraphDataManager* reporterTrackGraphDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* reportIUR;
@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) BOOL isGraphHavingData;
@property(nonatomic, retain) NSString* tableName;
@property(nonatomic, retain) NSNumber* selectedIUR;

- (void)constructStackedBarChart;
- (void)handleDoubleTap:(NSMutableDictionary *)aParamDict;
- (void)tapProcessCenter:(NSMutableDictionary *)aParamDict reverse:(BOOL)aReverseFlag;

@end
