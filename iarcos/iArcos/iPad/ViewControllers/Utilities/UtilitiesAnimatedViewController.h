//
//  UtilitiesAnimatedViewController.h
//  Arcos
//
//  Created by David Kilmartin on 16/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CorePlot-CocoaTouch.h"
#import "OrderHeaderTotalGraphDataManager.h"
#import "CPTGraphHostingViewWithTouchEvent.h"
#import "CallGenericServices.h"
#import "UtilitiesAnimatedDataManager.h"
#import "UtilitiesAnimatedMonthTableCell.h"
#import "UtilitiesAnimatedTrManager.h"
#import "ArcosXMLParser.h"
#import "GlobalSharedClass.h"
#import "UIImageViewWithControlFlag.h"
#import "PresentViewControllerDelegate.h"
#import "UIImage+Resize.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosConfigDataManager.h"
#import "LeftRightInsetUILabel.h"
#import "UtilitiesAnimatedMonthTableHeaderView.h"

@interface UtilitiesAnimatedViewController : UIViewController<CPTPlotSpaceDelegate,CPTPlotDataSource,CPTScatterPlotDelegate,CPTBarPlotDelegate,UITableViewDelegate, UITableViewDataSource> {
    id<ModelViewDelegate> _delegate;
    id<PresentViewControllerDelegate> _presentViewDelegate;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;

    CPTGraphHostingViewWithTouchEvent* weekLineChartView;
    CPTGraphHostingViewWithTouchEvent* yearBarChartView;
    CPTGraphHostingViewWithTouchEvent* _currentRunChartView;
    CPTGraphHostingViewWithTouchEvent* _previousRunChartView;
    CPTGraphHostingViewWithTouchEvent* _tylyBarChartView;
    CPTGraphHostingViewWithTouchEvent* _tylyTableChartView;
    UIScrollView* _tylyTableScrollView;
    
    OrderHeaderTotalGraphDataManager* _dataManager;
    CGAffineTransform globalZoomInCGAffineTransform;
    CGAffineTransform globalZoomOutCGAffineTransform;    

    CPTGraphHostingViewWithTouchEvent* monthPieChartView;    
    CPTGraphHostingViewWithTouchEvent* monthTableChartView;
    UITableView* monthTableView;
    UtilitiesAnimatedMonthTableHeaderView* _monthTableHeaderView;
    
    BOOL isYearViewInMiniMode;
    CGRect landscapeBigViewSize;
    CGRect landscapeSmallViewSize;
    CGPoint globalLandscapeBigViewCenter;
    CGPoint globalLandscapeSmallViewCenter;
    CGRect landscapeFirstViewSize;
    
    CGRect portraitBigViewSize;
    CGRect portraitSmallViewSize;
    CGPoint globalPortraitBigViewCenter;
    CGPoint globalPortraitSmallViewCenter;
    CGRect portraitFirstViewSize;
    NSMutableArray* _chartViewList;
    CGFloat centerDiff;
    int middleIndex;
    
    CPTPlotSpaceAnnotation* _symbolTextAnnotation;
    CPTPlotSpaceAnnotation* _yearSymbolTextAnnotation;

    CGRect landscapeSecondViewSize;
    CGRect landscapeThirdViewSize;
    CGRect portraitSecondViewSize;
    CGRect portraitThirdViewSize;
    NSMutableArray* _landscapeSeqPosList;
    NSMutableArray* _portraitSeqPosList;
    
    CPTXYAxisSet* _weekLineChartAxisSet;
    NSString* _weekLineChartTitle;
    NSString* _monthPieChartTitle;
    CPTLegend* _monthPieChartLegend;
    NSString* _monthTableChartTitle;
    CPTXYAxisSet* _yearBarChartAxisSet;
    NSString* _yearBarChartTitle;
    
    CallGenericServices* _callGenericService;
    NSNumber* _locationIUR;
    UtilitiesAnimatedDataManager* _animatedDataManager;
    UtilitiesAnimatedTrManager* _animatedTrManager;
    UIImageViewWithControlFlag* _yearBarImageView;
    UIImageViewWithControlFlag* _monthPieImageView;
    UIImageViewWithControlFlag* _monthTableImageView;
    UIImageViewWithControlFlag* _weekLineImageView;
    UIImageViewWithControlFlag* _currentRunImageView;
    NSMutableArray* _imageViewList;
    UIImageViewWithControlFlag* _previousRunImageView;
    NSMutableArray* _allChartViewList;
    NSString* _customerName;
    NSString* _weekLineNavTitle;
    NSString* _monthPieNavTitle;
    NSString* _monthTableNavTitle;
    NSString* _yearBarNavTitle;
}

@property(nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic, assign) id<PresentViewControllerDelegate> presentViewDelegate;
@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;

@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* weekLineChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* yearBarChartView;
@property(nonatomic, retain) CPTGraphHostingViewWithTouchEvent* currentRunChartView;
@property(nonatomic, retain) CPTGraphHostingViewWithTouchEvent* previousRunChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* tylyBarChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* tylyTableChartView;
@property(nonatomic, retain) IBOutlet UIScrollView* tylyTableScrollView;
@property(nonatomic, retain) OrderHeaderTotalGraphDataManager* dataManager;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* monthPieChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* monthTableChartView;
@property(nonatomic, retain) IBOutlet UITableView* monthTableView;
@property(nonatomic, retain) IBOutlet UtilitiesAnimatedMonthTableHeaderView* monthTableHeaderView;
@property(nonatomic, retain) NSMutableArray* chartViewList;
@property(nonatomic, retain) CPTPlotSpaceAnnotation* symbolTextAnnotation;
@property(nonatomic, retain) CPTPlotSpaceAnnotation* yearSymbolTextAnnotation;
@property(nonatomic, retain) NSMutableArray* landscapeSeqPosList;
@property(nonatomic, retain) NSMutableArray* portraitSeqPosList;
@property(nonatomic, retain) CPTXYAxisSet* weekLineChartAxisSet;
@property(nonatomic, retain) NSString* weekLineChartTitle;
@property(nonatomic, retain) NSString* monthPieChartTitle;
@property(nonatomic, retain) CPTLegend* monthPieChartLegend;
@property(nonatomic, retain) NSString* monthTableChartTitle;
@property(nonatomic, retain) CPTXYAxisSet* yearBarChartAxisSet;
@property(nonatomic, retain) NSString* yearBarChartTitle;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) UtilitiesAnimatedDataManager* animatedDataManager;
@property(nonatomic, retain) UtilitiesAnimatedTrManager* animatedTrManager;
@property(nonatomic, retain) IBOutlet UIImageViewWithControlFlag* yearBarImageView;
@property(nonatomic, retain) IBOutlet UIImageViewWithControlFlag* monthPieImageView;
@property(nonatomic, retain) IBOutlet UIImageViewWithControlFlag* monthTableImageView;
@property(nonatomic, retain) IBOutlet UIImageViewWithControlFlag* weekLineImageView;
@property(nonatomic, retain) UIImageViewWithControlFlag* currentRunImageView;
@property(nonatomic, retain) NSMutableArray* imageViewList;
@property(nonatomic, retain) UIImageViewWithControlFlag* previousRunImageView;
@property(nonatomic, retain) NSMutableArray* allChartViewList;
@property(nonatomic, retain) NSString* customerName;
@property(nonatomic, retain) NSString* weekLineNavTitle;
@property(nonatomic, retain) NSString* monthPieNavTitle;
@property(nonatomic, retain) NSString* monthTableNavTitle;
@property(nonatomic, retain) NSString* yearBarNavTitle;

- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation;
- (void)didResetDisplayLayout:(UIInterfaceOrientation)fromOrientation;
- (void)constructLineChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize;
- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)aDataManager target:(id)aTarget;
- (void)constructTableChart:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget;
- (void)drawInitialTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView;
- (void)sendSubViewBackTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView;
- (void)bringSubViewFrontTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView;
- (void)makeScrollViewScrollable:(UIScrollView*)aScrollView;
- (CPTTheme*)createDefaultTheme;
- (CGPoint)getCenterFromRect:(CGRect)aRect;
//- (void)resetChartViewListSize;
- (void)hideAxis:(CPTGraphHostingViewWithTouchEvent*)aCurrentRunChartView;
- (void)showAxis:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView;
//- (void)lockChartView:(BOOL)aLockFlag;
- (void)drawInitialTylyChartView;
- (void)resetTylyChartView:(BOOL)aMiniFlag;
- (void)didResetTylyChartViewSize:(UIInterfaceOrientation)anFromOrientation;
- (void)didResetTylyChartViewSizeWithRect:(CGRect)aRect;
- (void)drawAllViews;
- (void)populateTylyTableChartView:(UIInterfaceOrientation)anOrientation;
- (void)addLabel:(UIView*)aView rect:(CGRect)aRect value:(NSString*)aValue tag:(int)aTag textAlignment:(NSTextAlignment)anAlignment color:(UIColor*)aColor;
- (void)removeAllSubViews:(UIView*)aView;
- (void)clearAllSubViews:(UIView*)aView;
- (UIImage*)captureSnapshot:(UIView*)aView fileName:(NSString*)aFileName;
-(void)rightPressed:(id)sender;
- (void)clearChartViewList;
- (void)animateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView;
- (void)landscapeAnimateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView positionOfChartView:(int)aPositionOfChartView positionInsertIndex:(int)aPositionInsertIndex centerDiff:(float)aCenterDiff;
- (void)portraitAnimateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView positionOfChartView:(int)aPositionOfChartView positionInsertIndex:(int)aPositionInsertIndex centerDiff:(float)aCenterDiff;
- (void)captureSnapshot:(UIView*)aCPTGraphHostingView;
- (void)lockImageView:(BOOL)aLockFlag;
- (void)resizeAllChartViewListInLandscape;
- (void)resizeAllChartViewListInPortrait;
- (void)clearAllSnapshot;

@end
