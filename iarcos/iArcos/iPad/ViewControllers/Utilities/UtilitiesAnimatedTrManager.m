//
//  UtilitiesAnimatedTrManager.m
//  Arcos
//
//  Created by David Kilmartin on 30/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesAnimatedTrManager.h"

@implementation UtilitiesAnimatedTrManager
@synthesize yearBarChartAxisSet = _yearBarChartAxisSet;
@synthesize yearBarChartTitle = _yearBarChartTitle;
@synthesize monthTableChartTitle = _monthTableChartTitle;
@synthesize monthPieChartAxisSet = _monthPieChartAxisSet;
@synthesize monthPieChartTitle = _monthPieChartTitle;
@synthesize monthPieChartLegend = _monthPieChartLegend;
@synthesize weekLineChartAxisSet = _weekLineChartAxisSet;
@synthesize weekLineChartTitle = _weekLineChartTitle;
@synthesize weekLineChartLegend = _weekLineChartLegend;

- (id)init{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    if (self.yearBarChartAxisSet != nil) { self.yearBarChartAxisSet = nil; }
    if (self.yearBarChartTitle != nil) { self.yearBarChartTitle = nil; }
    if (self.monthTableChartTitle != nil) { self.monthTableChartTitle = nil; }
    self.monthPieChartAxisSet = nil;
    if (self.monthPieChartTitle != nil) { self.monthPieChartTitle = nil; }
    if (self.monthPieChartLegend != nil) { self.monthPieChartLegend = nil; }
    if (self.weekLineChartAxisSet != nil) { self.weekLineChartAxisSet = nil; }   
    if (self.weekLineChartTitle != nil) { self.weekLineChartTitle = nil; }    
    if (self.weekLineChartLegend != nil) { self.weekLineChartLegend = nil; }
                
    [super dealloc];
}

- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	[graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
	aGraphHostingView.hostedGraph = graph;
    [self setDefaultPadding:graph];
    
	graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop		= 50.0;
	graph.plotAreaFrame.paddingRight	= 10.0;
	graph.plotAreaFrame.paddingBottom	= 30.0;
	graph.plotAreaFrame.paddingLeft		= 50.0;
        
	// Create grid line styles
    /**
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 1.0;
	majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 1.0;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];
    */
    
	// Create axes
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	xAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.majorIntervalLength		  = [NSNumber numberWithInt:1];
    x.minorTicksPerInterval		  = 0;
    x.orthogonalPosition = [NSNumber numberWithInt:0];
    x.labelFormatter			  = xAxisFormatter;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
	lineCap.lineStyle	 = x.axisLineStyle;
	lineCap.lineCapType	 = CPTLineCapTypeOpenArrow;
	lineCap.size		 = CGSizeMake(12.0, 12.0);
	x.axisLineCapMax = lineCap;
//	[lineCap release];
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;    
    NSMutableArray* customTickLocations = [NSMutableArray arrayWithCapacity:12];
    for (int i = 0; i < 12; i++) {
        [customTickLocations addObject:[NSNumber numberWithInt:i]];
    }
    
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[anAnimatedDataManager.tylyBarDisplayList count]];
    
    for (int i = 0; i < [anAnimatedDataManager.tylyBarDisplayList count]; i++) {
        NSMutableDictionary* tmpDict = [anAnimatedDataManager.tylyBarDisplayList objectAtIndex:i];
        NSNumber* monthNumber = [tmpDict objectForKey:@"monthNumber"];
        CPTAxisLabel* newLabel = [[CPTAxisLabel alloc] initWithText:[anAnimatedDataManager.monthMapDict objectForKey:monthNumber] textStyle:x.labelTextStyle];
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
	y.majorIntervalLength = [NSNumber numberWithFloat:([anAnimatedDataManager.maxOfBarAxis floatValue] / 10)];
    y.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    y.labelOffset				  = 0.0;
    y.labelFormatter = yAxisFormatter;
    y.axisLineCapMax = lineCap;
    [lineCap release];
              
	// Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor clearColor];
    
	// Create bar plot
//    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
	barPlot.lineStyle		  = barLineStyle;
	barPlot.barWidth		  = [NSNumber numberWithFloat:0.25f];
//    barPlot.barOffset = CPTDecimalFromFloat(0.50f);
    barPlot.barOffset = [NSNumber numberWithFloat:0.375f];
//    barPlot.barCornerRadius      = 4.0;
	barPlot.barsAreHorizontal = NO;
	barPlot.dataSource		  = aTarget;
	barPlot.identifier		  = anAnimatedDataManager.lyBarIdentifier;
    barPlot.delegate = aTarget;
    [graph addPlot:barPlot];
    [barPlot release];
    // Second bar plot
//    CPTBarPlot *barPlot2 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    CPTBarPlot *barPlot2 = [[CPTBarPlot alloc] init];
    barPlot2.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0]];
    barPlot2.lineStyle = barLineStyle;
	barPlot2.dataSource = aTarget;
    barPlot2.barWidth = [NSNumber numberWithFloat:0.25f];
//	barPlot2.barOffset = CPTDecimalFromFloat(0.75f);
    barPlot2.barOffset = [NSNumber numberWithFloat:0.625f];
//    barPlot2.barCornerRadius = 2.0f;
	barPlot2.identifier = anAnimatedDataManager.tyBarIdentifier;
	barPlot2.delegate = aTarget;
    
	[graph addPlot:barPlot2];
    [barPlot2 release];
    // Add plot space for bar charts
	CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:12.0f]];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:([anAnimatedDataManager.maxOfBarAxis floatValue] + [anAnimatedDataManager.maxOfBarAxis floatValue] / 10 / 2)]];
	[graph addPlotSpace:barPlotSpace];
    
    //Add title
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    [graph release];
    self.yearBarChartAxisSet = (id)aGraphHostingView.hostedGraph.axisSet;
//    aGraphHostingView.hostedGraph.axisSet = nil;
    self.yearBarChartTitle = aGraphHostingView.hostedGraph.title;
//    aGraphHostingView.hostedGraph.title = nil;
}

- (CPTTheme*)createDefaultTheme {
    // --kCPTDarkGradientTheme
    return [CPTTheme themeNamed:kCPTPlainWhiteTheme];
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color	= [CPTColor blackColor];
	textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:17.0].fontName;
    return textStyle;
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize fontColor:(CPTColor*)aFontColor {
    CPTMutableTextStyle* textStyle = [self textStyleWithFontSize:aFontSize];
    textStyle.color = aFontColor;
    return textStyle;
}

- (void)setDefaultPadding:(CPTXYGraph*)aGraph {
    CGFloat boundsPadding = 10.0f;
	aGraph.paddingLeft = boundsPadding;
	aGraph.paddingTop = boundsPadding;
	aGraph.paddingRight = boundsPadding;
	aGraph.paddingBottom = boundsPadding;
}

- (void)constructTableChart:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aCPTGraphHostingView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;    
	[self setDefaultPadding:graph]; 
	graph.axisSet = nil;
	[graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
	aCPTGraphHostingView.hostedGraph = graph;
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
	[graph release];
    self.monthTableChartTitle = aCPTGraphHostingView.hostedGraph.title;
    aCPTGraphHostingView.hostedGraph.title = nil;
}

- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)aDataManager target:(id)aTarget {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	[graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
	aGraphHostingView.hostedGraph = graph;
    aGraphHostingView.allowPinchScaling = NO;
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
    x.orthogonalPosition = [NSNumber numberWithFloat:-aDataManager.monthPieNormalBarCount - 1];
    x.labelFormatter = xAxisFormatter;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
    lineCap.lineCapType     = CPTLineCapTypeOpenArrow;
    lineCap.size         = CGSizeMake(12.0, 12.0);
    x.axisLineCapMax = lineCap;
    x.hidden = YES;
    
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
    y.hidden = YES;
    
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
    barPlot.dataSource          = aTarget;
    barPlot.identifier          = aDataManager.monthPieIdentifier;
    barPlot.delegate = aTarget;
    [graph addPlot:barPlot];
    [barPlot release];
    // Add plot space for bar charts
    CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//    barPlotSpace.allowsUserInteraction = YES;
    barPlotSpace.delegate = self;
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:150.0f]];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:-11.0]];
    [graph addPlotSpace:barPlotSpace];
    
    //Add title
    graph.titleTextStyle = [self textStyleWithFontSize:20.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    [graph release];
    self.monthPieChartTitle = aGraphHostingView.hostedGraph.title;
    self.monthPieChartAxisSet = (id)aGraphHostingView.hostedGraph.axisSet;
}

#pragma mark CPTPlotSpaceDelegate
- (CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement {
    return CGPointMake(0, displacement.y);
}

- (void)constructLineChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	[graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
	aGraphHostingView.hostedGraph = graph;
    [self setDefaultPadding:graph];
    
	graph.plotAreaFrame.masksToBorder = NO;        
    graph.plotAreaFrame.paddingTop		= 50.0;
	graph.plotAreaFrame.paddingRight	= 10.0;
	graph.plotAreaFrame.paddingBottom	= 30.0;
	graph.plotAreaFrame.paddingLeft		= 50.0;
        
	// Setup scatter plot space	
    // Axes
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	xAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxisSet *xyAxisSet = (id)graph.axisSet;
	CPTXYAxis *xAxis		= xyAxisSet.xAxis;
	xAxis.majorIntervalLength	= [NSNumber numberWithInt:1];
//	xAxis.minorTicksPerInterval = 0;
    xAxis.orthogonalPosition = [NSNumber numberWithInt:0];
    xAxis.labelFormatter = xAxisFormatter;
    
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
//    xAxis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    
    NSUInteger lineLength = [anAnimatedDataManager.lineDetailList count];
    NSMutableArray* customTickLocations = [NSMutableArray arrayWithCapacity:lineLength];
    NSMutableArray* xAxisLabels = [NSMutableArray arrayWithCapacity:lineLength];
    for (int i = 0; i < lineLength; i++) {        
        [customTickLocations addObject:[NSNumber numberWithInt:i]];        
        @try {
            NSString* tickName = [anAnimatedDataManager.lineDetailList objectAtIndex:i];
            [xAxisLabels addObject:[tickName substringToIndex:3]];
        }
        @catch (NSException *exception) {
            [ArcosUtils showMsg:-1 message:[NSString stringWithFormat:@"%@%@", [exception name], [exception reason]] delegate:nil];
            break;
        }        
    }
    xAxis.majorTickLocations = [NSSet setWithArray:customTickLocations];
    NSUInteger labelLocation	 = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber* tickLocation in customTickLocations ) {
        CPTAxisLabel* newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:xAxis.labelTextStyle];
        newLabel.tickLocation = tickLocation;
        newLabel.offset = xAxis.labelOffset + xAxis.majorTickLength;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    xAxis.axisLabels = [NSSet setWithArray:customLabels];
    
	CPTLineCap *lineCap = [[CPTLineCap alloc] init];
	lineCap.lineStyle	 = xAxis.axisLineStyle;
	lineCap.lineCapType	 = CPTLineCapTypeOpenArrow;
	lineCap.size		 = CGSizeMake(12.0, 12.0);
	xAxis.axisLineCapMax = lineCap;
	
    
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	yAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxis *yAxis = xyAxisSet.yAxis;
	yAxis.orthogonalPosition = [NSNumber numberWithFloat:-0.5];
    yAxis.majorIntervalLength = [NSNumber numberWithFloat:([anAnimatedDataManager.maxOfLineYAxis floatValue] / 10)];
    yAxis.labelFormatter = yAxisFormatter;
    yAxis.axisLineCapMax = lineCap;
    [lineCap release];
    	
    //Target plot
    CPTScatterPlot *targetLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	targetLinePlot.identifier = @"Target Line";
    targetLinePlot.title = @"Target";
    
	CPTMutableLineStyle *targetLineStyle = [CPTMutableLineStyle lineStyle];
	targetLineStyle.lineWidth = 3.0;
	targetLineStyle.lineColor = [CPTColor greenColor];
	targetLinePlot.dataLineStyle = targetLineStyle;
    
	targetLinePlot.dataSource = aTarget;
	[graph addPlot:targetLinePlot];
    
    // Line plot with gradient fill
	CPTScatterPlot *dataSourceLinePlot = [[(CPTScatterPlot *)[CPTScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
	dataSourceLinePlot.identifier	 = @"Data Source Plot";
    dataSourceLinePlot.title = @"Actual";
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth = 3.0;
	lineStyle.lineColor = [CPTColor redColor];
	dataSourceLinePlot.dataLineStyle = lineStyle;
	dataSourceLinePlot.dataSource	 = aTarget;
	[graph addPlot:dataSourceLinePlot];
    
	CPTColor *areaColor = [CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.6];
	CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
	areaGradient.angle = -90.0f;
	CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
//	dataSourceLinePlot.areaFill		 = areaGradientFill;
//	dataSourceLinePlot.areaBaseValue = CPTDecimalFromDouble(0.0);
    
	areaColor = [CPTColor colorWithComponentRed:0.0 green:1.0 blue:0.0 alpha:0.6];
	areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor clearColor] endingColor:areaColor];
	areaGradient.angle = -90.0f;
	areaGradientFill = [CPTFill fillWithGradient:areaGradient];
//	dataSourceLinePlot.areaFill2	  = areaGradientFill;
//	dataSourceLinePlot.areaBaseValue2 = CPTDecimalFromDouble(5.0);
            
	// Set plot ranges
    
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    //    plotSpace.allowsUserInteraction = YES;
    //    plotSpace.delegate = self;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(-0.5f)] length:[NSNumber numberWithUnsignedInteger:lineLength]];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:0] length:[NSNumber numberWithFloat:([anAnimatedDataManager.maxOfLineYAxis floatValue] + [anAnimatedDataManager.maxOfLineYAxis floatValue] / 10 / 2)]];
    
    // Add plot symbols
	CPTMutableLineStyle* symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
	CPTPlotSymbol* plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:CPTFloat(135.0/255.0) green:CPTFloat(206.0/255.0) blue:CPTFloat(250.0/255.0) alpha:1.0]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size = CGSizeMake(10.0, 10.0);
	dataSourceLinePlot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle* symbolTargetLineStyle = [CPTMutableLineStyle lineStyle];
	symbolTargetLineStyle.lineColor = [CPTColor blackColor];
	CPTPlotSymbol* targetPlotSymbol = [CPTPlotSymbol hexagonPlotSymbol];
    targetPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor cyanColor]];
	targetPlotSymbol.lineStyle = symbolTargetLineStyle;
	targetPlotSymbol.size = CGSizeMake(10.0, 10.0);
    targetLinePlot.plotSymbol = targetPlotSymbol;
    
	// Set plot delegate, to know when symbols have been touched
	// We will display an annotation when a symbol is touched
	dataSourceLinePlot.delegate = aTarget;
	dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
    targetLinePlot.delegate = aTarget;
    targetLinePlot.plotSymbolMarginForHitDetection = 5.0f;
    
    //Add title    
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].analysisTitleDisplacement;
    //legend
    graph.legend				 = [CPTLegend legendWithPlots:[NSArray arrayWithObjects:dataSourceLinePlot, targetLinePlot, nil]];
	graph.legend.textStyle		 = xAxis.titleTextStyle;
	graph.legend.borderLineStyle = xAxis.axisLineStyle;
	graph.legend.cornerRadius	 = 5.0;
	graph.legend.numberOfRows	 = 1;
    graph.legend.numberOfColumns = 2;
    NSArray* columnWithArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:40], [NSNumber numberWithInt:40], nil];
    graph.legend.columnWidths = columnWithArray;
	graph.legend.swatchSize		 = CGSizeMake(25.0, 25.0);
	graph.legendAnchor			 = CPTRectAnchorTop;
	graph.legendDisplacement	 = CGPointMake(0.0, -70.0);
    
    [graph release];
    self.weekLineChartAxisSet = (id)aGraphHostingView.hostedGraph.axisSet; 
    self.weekLineChartTitle = aGraphHostingView.hostedGraph.title;
    self.weekLineChartLegend = aGraphHostingView.hostedGraph.legend;
}

- (void)removeAllSubViews:(UIView*)aView {
    NSUInteger length = [[aView subviews] count];
    for (int i = 0; i < length; i++) {
        UILabel* tmpLabel = [[aView subviews] lastObject];
        [tmpLabel removeFromSuperview];
    }
}

- (void)clearAllSubViews:(UIView*)aView {
    NSUInteger length = [[aView subviews] count];
    for (int i = 0; i < length; i++) {
        UILabel* tmpLabel = [[aView subviews] objectAtIndex:i];
        tmpLabel.text = nil;
    }
}

- (void)captureSnapshot:(UIView*)aView {
    CGRect rect = [aView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:context];   
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/capturedImage.jpg"]];
    NSString  *imagePngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/capturedImage.png"]];
    [UIImageJPEGRepresentation(capturedImage, 1.0) writeToFile:imagePath atomically:YES];
    [UIImagePNGRepresentation(capturedImage) writeToFile:imagePngPath atomically:YES];
}

@end
