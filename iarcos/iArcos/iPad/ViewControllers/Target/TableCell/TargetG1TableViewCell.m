//
//  TargetG1TableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 21/02/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "TargetG1TableViewCell.h"

@implementation TargetG1TableViewCell
@synthesize g1ChartView = _g1ChartView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.g1ChartView = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.cellDataDict = aDataDict;
    [self constructG1BarChart];
}

- (void)constructG1BarChart {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.g1ChartView.bounds];
    [graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
    self.g1ChartView.hostedGraph = graph;
    self.g1ChartView.allowPinchScaling = NO;
    graph.plotAreaFrame.masksToBorder = NO;
    
    [self setDefaultPadding:graph];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop        = 50.0;
    graph.plotAreaFrame.paddingRight    = 30.0;
    graph.plotAreaFrame.paddingBottom    = 30.0;
    graph.plotAreaFrame.paddingLeft        = 150.0;
    
    
    
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    xAxisFormatter.maximumFractionDigits = 0;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    CPTMutableLineStyle* majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
    x.majorGridLineStyle = majorGridLineStyle;
    x.majorIntervalLength   = [NSNumber numberWithFloat:25.0f];
    x.minorTicksPerInterval = 0;
    x.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    x.labelFormatter = xAxisFormatter;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
    lineCap.lineCapType     = CPTLineCapTypeOpenArrow;
    lineCap.size         = CGSizeMake(12.0, 12.0);
    x.axisLineCapMax = lineCap;
    
    NSMutableArray* customXTickLocations = [NSMutableArray arrayWithCapacity:12];
    for (int i = 1; i < 5; i++) {
        [customXTickLocations addObject:[NSNumber numberWithInt:i * [x.majorIntervalLength intValue]]];
    }
    x.majorTickLocations = [NSSet setWithArray:customXTickLocations];
    NSMutableArray* customXLabels = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1; i < 5; i++) {
        CPTAxisLabel* axisLabel = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@%%",[[customXTickLocations objectAtIndex:i-1] stringValue]] textStyle:x.labelTextStyle];
        axisLabel.tickLocation = [NSNumber numberWithFloat:(i*[x.majorIntervalLength floatValue])];
//        NSLog(@"aac %f %f", x.labelOffset, x.majorTickLength);
        axisLabel.offset = x.labelOffset + x.majorTickLength;
        axisLabel.alignment = CPTAlignmentMiddle;
        [customXLabels addObject:axisLabel];
        [axisLabel release];
    }
    
    x.axisLabels = [NSSet setWithArray:customXLabels];
    
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
    
    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[dataList count]];
    CPTMutableTextStyle* yBlackTextStyle = [self textStyleWithFontSize:10.0f fontColor:[CPTColor blackColor]];
    //x.labelTextStyle
    for (int i = 0; i < [dataList count]; i++) {
        NSMutableDictionary* tmpDict = [dataList objectAtIndex:i];
        NSString* narrativeString = [tmpDict objectForKey:@"Narrative"];
        CPTAxisLabel* axisLabel = [[CPTAxisLabel alloc] initWithText:narrativeString textStyle:yBlackTextStyle];
        axisLabel.tickLocation = [NSNumber numberWithFloat:(i+0.5)];
        axisLabel.offset = y.labelOffset + y.majorTickLength;
        axisLabel.alignment = CPTAlignmentMiddle;
        [customLabels addObject:axisLabel];
        [axisLabel release];
    }
    y.axisLabels = [NSSet setWithArray:customLabels];
    
    // Create a bar line style
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    // Create bar plot
    CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0]];
    barPlot.lineStyle          = barLineStyle;
    barPlot.barWidth          = [NSNumber numberWithFloat:0.75f];
    barPlot.barOffset = [NSNumber numberWithFloat:0.5f];
    //    barPlot.barCornerRadius      = 4.0;
    barPlot.barsAreHorizontal = YES;
    barPlot.dataSource          = self;
    barPlot.identifier          = @"";
    barPlot.delegate = self;
    [graph addPlot:barPlot];
    [barPlot release];
    // Add plot space for bar charts
    CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    barPlotSpace.allowsUserInteraction = YES;
    barPlotSpace.delegate = self;
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:120.0f]];
    int yLength = [ArcosUtils convertNSUIntegerToUnsignedInt:[dataList count]];
    if (yLength > 15) {
        yLength = 15;
    }
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:yLength]];
    [graph addPlotSpace:barPlotSpace];
    
    //Add title
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f fontColor:[CPTColor blackColor]];
    graph.title = [self.cellDataDict objectForKey:@"Title"];
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    [graph release];
}

- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
    return [dataList count];
}

- (NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSNumber* num = nil;
    switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
            break;
            
        case CPTBarPlotFieldBarTip:{
            
            NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
            NSMutableDictionary* tmpDict = [dataList objectAtIndex:index];
            num = [tmpDict objectForKey:@"Value"];
        }
            break;
        default:
            break;
    }
    return num;
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle* blackTextStyle = [self textStyleWithFontSize:14.0f fontColor:[CPTColor blackColor]];
    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
    NSMutableDictionary* tmpDict = [dataList objectAtIndex:index];
    return [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.0f%%", [[tmpDict objectForKey:@"Value"] floatValue]] style:blackTextStyle] autorelease];
}

#pragma mark CPTPlotSpaceDelegate
- (CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement {
    return CGPointMake(0, displacement.y);
}

@end
