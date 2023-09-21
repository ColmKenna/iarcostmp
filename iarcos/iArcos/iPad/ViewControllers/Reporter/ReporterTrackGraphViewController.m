//
//  ReporterTrackGraphViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterTrackGraphViewController.h"
#import "ArcosMemoryUtils.h"

@implementation ReporterTrackGraphViewController
@synthesize trackChartView = _trackChartView;
@synthesize reporterTrackGraphDataManager = _reporterTrackGraphDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize reportIUR = _reportIUR;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize isGraphHavingData = _isGraphHavingData;
@synthesize tableName = _tableName;
@synthesize selectedIUR = _selectedIUR;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.trackChartView != nil) { self.trackChartView = nil; }
    if (self.reporterTrackGraphDataManager != nil) { self.reporterTrackGraphDataManager = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.reportIUR != nil) { self.reportIUR = nil; }
    if (self.startDate != nil) { self.startDate = nil; }
    if (self.endDate != nil) { self.endDate = nil; }
    if (self.tableName != nil) { self.tableName = nil; }
    if (self.selectedIUR != nil) { self.selectedIUR = nil; }
                
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    self.reporterTrackGraphDataManager = [[[ReporterTrackGraphDataManager alloc] init] autorelease];
    if (self.callGenericServices == nil) {        
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    }
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.trackChartView != nil) { self.trackChartView = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isGraphHavingData) {
        [self constructStackedBarChart];
    }
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    
    [self.callGenericServices genericGetReportMainWithEmployeeiur:[self.reporterTrackGraphDataManager.employeeIUR intValue] reportiur:[self.reportIUR intValue] startDate:self.startDate endDate:self.endDate type:[self.reporterTrackGraphDataManager.configDict objectForKey:@"DefaultDataSource"] tablename:self.tableName iur:[self.selectedIUR intValue]  action:@selector(setGetReportMainResult:) target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.isGraphHavingData) {
        if (self.trackChartView.hostedGraph != nil) {
            self.trackChartView.hostedGraph = nil;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

- (void)constructStackedBarChart {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.trackChartView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    if (self.trackChartView.hostedGraph != nil) {
        self.trackChartView.hostedGraph = nil;
    }
	self.trackChartView.hostedGraph = graph;
    float boundsPadding = 10.0f;
    graph.paddingLeft = boundsPadding;
	graph.paddingTop = boundsPadding;
	graph.paddingRight = boundsPadding;
	graph.paddingBottom = boundsPadding;
    
	graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop		= 10.0;
	graph.plotAreaFrame.paddingRight	= 10.0;
	graph.plotAreaFrame.paddingBottom	= 150.0;
	graph.plotAreaFrame.paddingLeft		= 35.0;
    
    
    
    //Grid line styles
    
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.75;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth            = 0.5;
    minorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1],[NSDecimalNumber numberWithInt:5], nil];
	minorGridLineStyle.lineWidth            = 0.25;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.5];
    
    //Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:0]
                                                                   length:[NSNumber numberWithInt:([self.reporterTrackGraphDataManager.maxOfBarAxis intValue] + [self.reporterTrackGraphDataManager.maxOfBarAxis intValue] / 20)]];
    int xInitialRangeValue = 1;
    int xRangeDBValue = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.reporterTrackGraphDataManager.displayList count]] + 1;
    
    if (xRangeDBValue > xInitialRangeValue) {
        xInitialRangeValue = xRangeDBValue;
    }
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:-1]
                                                                   length:[NSNumber numberWithInt:xInitialRangeValue]];
    
    //Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalPosition   = [NSNumber numberWithInt:0];
	x.majorIntervalLength           = [NSNumber numberWithInt:1];
	x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    x.majorGridLineStyle            = majorGridLineStyle;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //X labels
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *xLabel in self.reporterTrackGraphDataManager.xLabelList) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:xLabel textStyle:x.labelTextStyle];
        newLabel.tickLocation   = [NSNumber numberWithInt:labelLocations];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        newLabel.rotation       = M_PI / 7;
        [customXLabels addObject:newLabel];
        labelLocations++;
        [newLabel release];
    }
    x.axisLabels                    = [NSSet setWithArray:customXLabels];
    
    //Y axis
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	yAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxis *y            = axisSet.yAxis;
    CPTLineCap* lineCap = [[CPTLineCap alloc] init];
	lineCap.lineStyle	 = y.axisLineStyle;
	lineCap.lineCapType	 = CPTLineCapTypeOpenArrow;
	lineCap.size		 = CGSizeMake(12.0, 12.0);
//	y.title                 = @"Value";
//	y.titleOffset           = 50.0f;
//    y.majorIntervalLength = CPTDecimalFromFloat([self.reporterTrackGraphDataManager.maxOfBarAxis floatValue] / 10);
//    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.labelOffset				  = 0.0;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle    = majorGridLineStyle;
    y.minorGridLineStyle    = minorGridLineStyle;
    y.labelFormatter = yAxisFormatter;
    y.axisLineCapMax = lineCap;
    [lineCap release];
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    
    
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth              = 0.5;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color                = [CPTColor whiteColor];
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *barSet in [[self.reporterTrackGraphDataManager.barSets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot* plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[self.reporterTrackGraphDataManager.barSets objectForKey:barSet]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
            plot.barCornerRadius = 4.0;
        }
        plot.barWidth           = [NSNumber numberWithFloat:0.8f];
        plot.barsAreHorizontal  = NO;
        plot.dataSource         = self;
        plot.delegate = self;
        plot.identifier         = barSet;
        
        [graph addPlot:plot toPlotSpace:plotSpace];
        
        
//        [graph addPlot:plot];
    }
    
    
    
    
    graph.legend				 = [CPTLegend legendWithPlots:graph.allPlots];
	graph.legend.textStyle		 = x.titleTextStyle;
	graph.legend.borderLineStyle = nil;
	graph.legend.cornerRadius	 = 5.0;
	graph.legend.numberOfRows	 = 1;
	graph.legend.swatchSize		 = CGSizeMake(15.0, 15.0);
	graph.legendAnchor			 = CPTRectAnchorBottom;
	graph.legendDisplacement	 = CGPointMake(0.0, 10.0);
    
    [graph release];
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
//    return self.reporterTrackGraphDataManager.dates.count;
    return [self.reporterTrackGraphDataManager.displayList count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    }
    
    else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *barSet in [[self.reporterTrackGraphDataManager.barSets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:barSet]) {
                    break;
                }
                offset += [[[self.reporterTrackGraphDataManager.barDataDict objectForKey:[self.reporterTrackGraphDataManager.xLabelList objectAtIndex:index]] objectForKey:barSet] doubleValue];
            }
        }
        
        //Y Value
        if (fieldEnum == 1) {
            num = [[[self.reporterTrackGraphDataManager.barDataDict objectForKey:[self.reporterTrackGraphDataManager.xLabelList objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
        }
        
        //Offset for stacked bar
        else {
            num = offset;
        }
    }
    
    //NSLog(@"%@ - %d - %d - %f", plot.identifier, index, fieldEnum, num);
    
    return num;
}
/*
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    NSLog(@"%d, %@",index, plot.identifier);    
    BOOL buyFlag = YES;
    if (![self.reporterTrackGraphDataManager.buyKey isEqualToString:(NSString*)plot.identifier]) {
        buyFlag = NO;
    }
    NSMutableDictionary* dataDict = [self.reporterTrackGraphDataManager.displayList objectAtIndex:index];
    NSNumber* levelIUR = [dataDict objectForKey:@"IUR"];
    
    ReporterTrackDetailViewController* RTDVC = [[ReporterTrackDetailViewController alloc] initWithNibName:@"ReporterTrackDetailViewController" bundle:nil];
    if (buyFlag) {
        RTDVC.title = [NSString stringWithFormat:@"%@ customers bought %@", [dataDict objectForKey:self.reporterTrackGraphDataManager.buyKey], [dataDict objectForKey:@"Details"]];
    } else {
        RTDVC.title = [NSString stringWithFormat:@"%@ customers did not buy %@", [dataDict objectForKey:self.reporterTrackGraphDataManager.notBuyKey], [dataDict objectForKey:@"Details"]];
    }
    RTDVC.reportIUR = self.reportIUR;
    RTDVC.startDate = self.startDate;
    RTDVC.endDate = self.endDate;
    //will come back
    RTDVC.buyFlag = YES;
    RTDVC.levelIUR = [NSNumber numberWithInt:1005509];
    RTDVC.employeeIUR = self.reporterTrackGraphDataManager.employeeIUR;
    [self.navigationController pushViewController:RTDVC animated:YES];
    [RTDVC release];
}
*/

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index withEvent:(CPTNativeEvent *)event {
    NSMutableDictionary* paramDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDataDict setObject:plot forKey:@"BarPlot"];
    [paramDataDict setObject:[NSNumber numberWithUnsignedInteger:index] forKey:@"BarIndex"];
    
    self.reporterTrackGraphDataManager.selectedBarRecordIndex = [ArcosUtils convertNSUIntegerToUnsignedInt:index];
    
    NSSet* touches = [event allTouches];
//    NSLog(@"touches count: %d", [touches count]);
    UITouch* touch = [touches anyObject];
//    NSLog(@"tapCount: %d", touch.tapCount);
    if (touch.tapCount == 2 && self.reporterTrackGraphDataManager.previousSelectedBarRecordIndex == self.reporterTrackGraphDataManager.selectedBarRecordIndex) {
        NSLog(@"enter double");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap:) object:paramDataDict];
        [self handleDoubleTap:paramDataDict];
    } else if (touch.tapCount == 1){
        [self performSelector:@selector(handleSingleTap:) withObject:paramDataDict afterDelay:0.3]; //delay of 0.3 seconds
    }
    if (self.reporterTrackGraphDataManager.previousSelectedBarRecordIndex != self.reporterTrackGraphDataManager.selectedBarRecordIndex) {
        self.reporterTrackGraphDataManager.previousSelectedBarRecordIndex = self.reporterTrackGraphDataManager.selectedBarRecordIndex;
    }
}

- (void)handleSingleTap:(NSMutableDictionary *)aParamDict {
    CPTBarPlot* tmpPlot = (CPTBarPlot*)[aParamDict objectForKey:@"BarPlot"];
    NSNumber* tmpRecordIndexNum = [aParamDict objectForKey:@"BarIndex"];
    NSLog(@"handleSingleTap: %@ %d", tmpPlot.identifier, [tmpRecordIndexNum intValue]);
    if ([tmpRecordIndexNum intValue] != self.reporterTrackGraphDataManager.selectedBarRecordIndex) {
        NSLog(@"cancel handleSingleTap");
        return;
    }
    [self tapProcessCenter:aParamDict reverse:NO];
}

- (void)handleDoubleTap:(NSMutableDictionary *)aParamDict {
    CPTBarPlot* tmpPlot = (CPTBarPlot*)[aParamDict objectForKey:@"BarPlot"];
    NSNumber* tmpRecordIndexNum = [aParamDict objectForKey:@"BarIndex"];
    NSLog(@"handleDoubleTap: %@ %d", tmpPlot.identifier, [tmpRecordIndexNum intValue]);
    [self tapProcessCenter:aParamDict reverse:YES];    
}

- (void)tapProcessCenter:(NSMutableDictionary *)aParamDict reverse:(BOOL)aReverseFlag{
    CPTBarPlot* tmpPlot = (CPTBarPlot*)[aParamDict objectForKey:@"BarPlot"];
    NSNumber* tmpRecordIndexNum = [aParamDict objectForKey:@"BarIndex"];
    BOOL buyFlag = YES;
    if (![self.reporterTrackGraphDataManager.buyKey isEqualToString:(NSString*)tmpPlot.identifier]) {
        buyFlag = NO;
    }
    if (aReverseFlag) {
        buyFlag = !buyFlag;
    }
    NSMutableDictionary* dataDict = [self.reporterTrackGraphDataManager.displayList objectAtIndex:[tmpRecordIndexNum intValue]];
//    NSNumber* levelIUR = [dataDict objectForKey:@"IUR"];
    
    ReporterTrackDetailViewController* RTDVC = [[ReporterTrackDetailViewController alloc] initWithNibName:@"ReporterTrackDetailViewController" bundle:nil];
    
    if (buyFlag) {
        RTDVC.title = [NSString stringWithFormat:@"%@ customers bought %@", [dataDict objectForKey:self.reporterTrackGraphDataManager.buyKey], [dataDict objectForKey:@"Details"]];
    } else {
        RTDVC.title = [NSString stringWithFormat:@"%@ customers did not buy %@", [dataDict objectForKey:self.reporterTrackGraphDataManager.notBuyKey], [dataDict objectForKey:@"Details"]];
    }
    
    RTDVC.reportIUR = self.reportIUR;
    RTDVC.startDate = self.startDate;
    RTDVC.endDate = self.endDate;
    //will come back
    RTDVC.buyFlag = YES;
    RTDVC.levelIUR = [NSNumber numberWithInt:1005509];
    RTDVC.employeeIUR = self.reporterTrackGraphDataManager.employeeIUR;
    RTDVC.configDict = self.reporterTrackGraphDataManager.configDict;
    RTDVC.tableName = self.tableName;
    RTDVC.selectedIUR = self.selectedIUR;
    [self.navigationController pushViewController:RTDVC animated:YES];
    [RTDVC release];
}

-(void)setGetReportMainResult:(ArcosGenericReturnObject*)result {
    [GlobalSharedClass shared].serviceTimeoutInterval = [GlobalSharedClass shared].defaultServiceTimeoutInterval;
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.isNotFirstLoaded = YES;
        self.isGraphHavingData = YES;
        [self.reporterTrackGraphDataManager processRawData:result.ArrayOfData];        
        [self constructStackedBarChart];
    } else if(result.ErrorModel.Code <= 0) {        
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:@"" target:self handler:nil];
    }    
}

/*
-(void)setGetReportSubResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        
    } else if(result.ErrorModel.Code <= 0) {        
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }    
}
*/


@end
