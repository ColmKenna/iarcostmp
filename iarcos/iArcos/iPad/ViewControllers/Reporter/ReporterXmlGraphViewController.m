//
//  ReporterXmlGraphViewController.m
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlGraphViewController.h"

@interface ReporterXmlGraphViewController ()

@end

@implementation ReporterXmlGraphViewController
@synthesize reporterXmlGraphDataManager = _reporterXmlGraphDataManager;
@synthesize chartView = _chartView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.reporterXmlGraphDataManager = [[[ReporterXmlGraphDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self constructBarGraph];
}

- (void)dealloc {
    self.reporterXmlGraphDataManager = nil;
    self.chartView = nil;
    
    [super dealloc];
}

- (void)constructBarGraph {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.chartView.bounds];
    [graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
    self.chartView.hostedGraph = graph;
    self.chartView.allowPinchScaling = NO;
    graph.plotAreaFrame.masksToBorder = NO;
    
    [self setDefaultPadding:graph];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop        = 50.0;
    graph.plotAreaFrame.paddingRight    = 30.0;
    graph.plotAreaFrame.paddingBottom    = 30.0;
    graph.plotAreaFrame.paddingLeft        = 30.0;

    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    xAxisFormatter.maximumFractionDigits = 0;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength   = @10.0;
    x.minorTicksPerInterval = 0;
    x.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    x.labelFormatter = xAxisFormatter;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
    lineCap.lineCapType     = CPTLineCapTypeOpenArrow;
    lineCap.size         = CGSizeMake(12.0, 12.0);
    x.axisLineCapMax = lineCap;
    
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    yAxisFormatter.maximumFractionDigits = 0;
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = [NSNumber numberWithFloat:1.0f];
    y.minorTicksPerInterval = 0;
    y.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    y.labelOffset                  = 0.0;
    y.labelFormatter = yAxisFormatter;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.axisLineCapMax = lineCap;
    [lineCap release];
    
    // Create a bar line style
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    // Create bar plot
    CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0]];
    barPlot.lineStyle          = barLineStyle;
    barPlot.barWidth          = [NSNumber numberWithFloat:0.5f];
    barPlot.barOffset = [NSNumber numberWithFloat:0.5f];
    //    barPlot.barCornerRadius      = 4.0;
    barPlot.barsAreHorizontal = YES;
    barPlot.dataSource          = self;
    barPlot.identifier          = self.reporterXmlGraphDataManager.identifier;
    barPlot.delegate = self;
    [graph addPlot:barPlot];
    [barPlot release];
    // Add plot space for bar charts
    CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    barPlotSpace.allowsUserInteraction = YES;
    barPlotSpace.delegate = self;
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:150.0f]];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:10.0]];
    [graph addPlotSpace:barPlotSpace];
    
    //Add title
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = @"";
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    [graph release];
}

- (CPTTheme*)createDefaultTheme {
    return [CPTTheme themeNamed:kCPTPlainWhiteTheme];
}

- (void)setDefaultPadding:(CPTXYGraph*)aGraph {
    CGFloat boundsPadding = 10.0f;
    aGraph.paddingLeft = boundsPadding;
    aGraph.paddingTop = boundsPadding;
    aGraph.paddingRight = boundsPadding;
    aGraph.paddingBottom = boundsPadding;
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color    = [CPTColor whiteColor];
    textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:12.0f].fontName;
    return textStyle;
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize fontColor:(CPTColor*)aFontColor {
    CPTMutableTextStyle* textStyle = [self textStyleWithFontSize:aFontSize];
    textStyle.color = aFontColor;
    return textStyle;
}

- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.reporterXmlGraphDataManager.displayList count];
}

- (NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSNumber* num = nil;
    switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
            break;
            
        case CPTBarPlotFieldBarTip:{
            
            
            NSMutableDictionary* tmpDict = [self.reporterXmlGraphDataManager.displayList objectAtIndex:index];
            num = [tmpDict objectForKey:@"Percentage"];
        }
            break;
        default:
            break;
    }
    return num;
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle* blackTextStyle = [self textStyleWithFontSize:14.0f fontColor:[CPTColor blackColor]];
    NSMutableDictionary* tmpDict = [self.reporterXmlGraphDataManager.displayList objectAtIndex:index];
    
    return [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n%.0f%%", [tmpDict objectForKey:@"Details"], [[tmpDict objectForKey:@"Percentage"] floatValue]] style:blackTextStyle] autorelease];
}

#pragma mark CPTPlotSpaceDelegate
- (CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement {
    return CGPointMake(0, displacement.y);
}

@end
