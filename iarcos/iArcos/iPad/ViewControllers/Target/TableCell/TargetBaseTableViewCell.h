//
//  TargetBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTGraphHostingViewWithTouchEvent.h"

@interface TargetBaseTableViewCell : UITableViewCell <CPTPieChartDelegate, CPTPlotDataSource> {
    UIImageView* _bgImageView;
    NSMutableDictionary* _cellDataDict;
    NSString* _pieChartIdentifier;
    NSString* _actualBarIdentifier;
    NSString* _targetBarIdentifier;
    UILabel* _titleLabel;
    UILabel* _dateRangeLabel;
    CPTGraphHostingViewWithTouchEvent* _pieChartView;
    NSMutableArray* _plotDataList;
    BOOL _actualOverTargetFlag;
    BOOL _actualEqualToZeroFlag;
}

@property(nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic, retain) NSMutableDictionary* cellDataDict;
@property(nonatomic, retain) NSString* pieChartIdentifier;
@property(nonatomic, retain) NSString* actualBarIdentifier;
@property(nonatomic, retain) NSString* targetBarIdentifier;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateRangeLabel;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* pieChartView;
@property(nonatomic, retain) NSMutableArray* plotDataList;
@property(nonatomic, assign) BOOL actualOverTargetFlag;
@property(nonatomic, assign) BOOL actualEqualToZeroFlag;


- (CPTTheme*)createDefaultTheme;
- (void)setDefaultPadding:(CPTXYGraph*)aGraph;
- (void)configCellWithData:(NSMutableDictionary*)aDataDict;
- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize fontColor:(CPTColor*)aFontColor;
- (void)constructLeftBarChartWithData:(NSMutableDictionary*)aDataDict;
- (void)constructPieChartWithData:(NSMutableDictionary*)aDataDict;


@end
