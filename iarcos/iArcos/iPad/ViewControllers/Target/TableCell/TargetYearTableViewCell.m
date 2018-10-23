//
//  TargetYearTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetYearTableViewCell.h"

@implementation TargetYearTableViewCell
@synthesize barChartView = _barChartView;
@synthesize yearSymbolTextAnnotation = _yearSymbolTextAnnotation;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.barChartView = nil;
    self.yearSymbolTextAnnotation = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.actualBarIdentifier = @"ActualBarPlotId";
    self.targetBarIdentifier = @"TargetBarPlotId";
    [super configCellWithData:aDataDict];
}

- (void)constructLeftBarChartWithData:(NSMutableDictionary*)aDataDict {
    [self constructYearBarChartWithData:aDataDict];
}

- (void)constructYearBarChartWithData:(NSMutableDictionary*)aDataDict {
    NSMutableArray* dataList = [aDataDict objectForKey:@"DataList"];
    float maxOfBarAxis = 0;
    for (int i = 0; i < [dataList count]; i++) {
        NSMutableDictionary* auxDataDict = [dataList objectAtIndex:i];
        NSNumber* auxActual = [auxDataDict objectForKey:@"Actual"];
        NSNumber* auxTarget = [auxDataDict objectForKey:@"Target"];
        if ([auxActual floatValue] > maxOfBarAxis) {
            maxOfBarAxis = [auxActual floatValue];
        }
        if ([auxTarget floatValue] > maxOfBarAxis) {
            maxOfBarAxis = [auxTarget floatValue];
        }
    }
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.barChartView.bounds];
    [graph applyTheme:[self createDefaultTheme]];
    self.barChartView.hostedGraph = graph;
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
//    graph.plotAreaFrame.borderLineStyle = nil;
    [self setDefaultPadding:graph];
    
    graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop        = 5.0;
    graph.plotAreaFrame.paddingRight    = 10.0;
    graph.plotAreaFrame.paddingBottom    = 27.0;
    graph.plotAreaFrame.paddingLeft        = 10.0;
    
    // Create axes
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    xAxisFormatter.maximumFractionDigits = 0;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength          = [NSNumber numberWithInt:1];
    x.minorTicksPerInterval          = 0;
    x.orthogonalPosition = [NSNumber numberWithInt:0];
    x.labelFormatter              = xAxisFormatter;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
    lineCap.lineStyle     = x.axisLineStyle;
    lineCap.lineCapType     = CPTLineCapTypeOpenArrow;
    lineCap.size         = CGSizeMake(12.0, 12.0);
    x.axisLineCapMax = lineCap;
    //    [lineCap release];
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;    
    NSMutableArray* customTickLocations = [NSMutableArray arrayWithCapacity:12];
    for (int i = 1; i < 12; i++) {
        [customTickLocations addObject:[NSNumber numberWithInt:i]];
    }
    
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[dataList count]];
    
    for (int i = 0; i < [dataList count]; i++) {
        NSMutableDictionary* tmpDict = [dataList objectAtIndex:i];
        NSString* monthString = [tmpDict objectForKey:@"Month"];
        CPTAxisLabel* newLabel = [[CPTAxisLabel alloc] initWithText:monthString textStyle:x.labelTextStyle];
        newLabel.tickLocation = [NSNumber numberWithInt:(i+1)];
        newLabel.offset = x.labelOffset + x.majorTickLength;
        newLabel.alignment = CPTAlignmentRight;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    x.majorTickLocations = [NSSet setWithArray:customTickLocations];
    x.axisLabels = [NSSet setWithArray:customLabels];
    
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    yAxisFormatter.maximumFractionDigits = 0;
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.majorIntervalLength = [NSNumber numberWithInt:(int)(maxOfBarAxis / 2)];
//    y.majorIntervalLength = [NSNumber numberWithFloat:15.0];
    y.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    y.labelOffset                  = 0.0;
    y.labelFormatter = yAxisFormatter;
    y.axisLineCapMax = lineCap;
    [lineCap release];
    
    // Create a bar line style
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor clearColor];
    
    // Create bar plot
    CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:CPTFloat(0.0) green:CPTFloat(128.0/255.0) blue:CPTFloat(0.0) alpha:CPTFloat(1.0)]];
    barPlot.lineStyle          = barLineStyle;
//    barPlot.barWidth          = [NSNumber numberWithFloat:0.25f];
//    barPlot.barOffset = [NSNumber numberWithFloat:0.375f];
    barPlot.barWidth          = [NSNumber numberWithFloat:0.375f];
    barPlot.barOffset = [NSNumber numberWithFloat:0.3125f];
    barPlot.barsAreHorizontal = NO;
    barPlot.dataSource          = self;
    barPlot.identifier          = self.actualBarIdentifier;
    barPlot.delegate = self;
    [graph addPlot:barPlot];
    [barPlot release];
    // Second bar plot
    CPTBarPlot *barPlot2 = [[CPTBarPlot alloc] init];
    barPlot2.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:CPTFloat(1.0) green:CPTFloat(0.0) blue:CPTFloat(0.0) alpha:CPTFloat(1.0)]];
    barPlot2.lineStyle = barLineStyle;
    barPlot2.dataSource = self;
//    barPlot2.barWidth = [NSNumber numberWithFloat:0.25f];
//    barPlot2.barOffset = [NSNumber numberWithFloat:0.625f];
    barPlot2.barWidth = [NSNumber numberWithFloat:0.375f];
    barPlot2.barOffset = [NSNumber numberWithFloat:0.6875f];
    barPlot2.identifier = self.targetBarIdentifier;
    barPlot2.delegate = self;
    
    [graph addPlot:barPlot2];
    [barPlot2 release];
    
    // Add plot space for bar charts
    CPTXYPlotSpace* barPlotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:12.0f]];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:(maxOfBarAxis + maxOfBarAxis / 2 / 4)]];
    [graph addPlotSpace:barPlotSpace];
    
    //Add title
//    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
//    graph.title = aTitle;
//    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    [graph release];
}

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    CPTGraph* barGraph = self.barChartView.hostedGraph;
    
    if ( self.yearSymbolTextAnnotation != nil ) {
        [barGraph.plotAreaFrame.plotArea removeAllAnnotations];
        self.yearSymbolTextAnnotation = nil;
    }
    CPTMutableTextStyle* hitAnnotationTextStyle = [self textStyleWithFontSize:14.0 fontColor:[CPTColor blackColor]];
    
    // Determine point of symbol in plot coordinates
    
    NSNumber* x = [NSNumber numberWithUnsignedInteger:index];
    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
    NSMutableDictionary* auxDataDict = [dataList objectAtIndex:index];
    NSNumber* y = [auxDataDict objectForKey:@"Actual"];
    if ([(NSString*)plot.identifier isEqualToString:self.targetBarIdentifier]) {
        y = [auxDataDict objectForKey:@"Target"];               
    }
    NSArray* anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
    // Add annotation
    // First make a string for the y value
    
    NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    NSString* yString = [formatter stringFromNumber:y];    
    
    // Now add the annotation to the plot area
    CPTTextLayer* textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
    self.yearSymbolTextAnnotation = [[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:barGraph.defaultPlotSpace anchorPlotPoint:anchorPoint] autorelease];    
    self.yearSymbolTextAnnotation.contentLayer = textLayer;
    self.yearSymbolTextAnnotation.displacement = CGPointMake(20.0f, 6.0f);
    if ([(NSString*)plot.identifier isEqualToString:self.targetBarIdentifier]) {
        self.yearSymbolTextAnnotation.displacement = CGPointMake(36.0f, 6.0f);
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.yearSymbolTextAnnotation.displacement = CGPointMake(10.0f, 6.0f);
        if ([(NSString*)plot.identifier isEqualToString:self.targetBarIdentifier]) {
            self.yearSymbolTextAnnotation.displacement = CGPointMake(26.0f, 6.0f);
        }
    }
    [barGraph.plotAreaFrame.plotArea addAnnotation:self.yearSymbolTextAnnotation];
}

@end
