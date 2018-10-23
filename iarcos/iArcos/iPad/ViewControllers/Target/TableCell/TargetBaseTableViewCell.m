//
//  TargetBaseTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetBaseTableViewCell.h"

@implementation TargetBaseTableViewCell
@synthesize bgImageView = _bgImageView;
@synthesize cellDataDict = _cellDataDict;
@synthesize pieChartIdentifier = _pieChartIdentifier;
@synthesize actualBarIdentifier = _actualBarIdentifier;
@synthesize targetBarIdentifier = _targetBarIdentifier;
@synthesize titleLabel = _titleLabel;
@synthesize dateRangeLabel = _dateRangeLabel;
@synthesize pieChartView = _pieChartView;
@synthesize plotDataList = _plotDataList;
@synthesize actualOverTargetFlag = _actualOverTargetFlag;
@synthesize actualEqualToZeroFlag = _actualEqualToZeroFlag;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {
    self.bgImageView = nil;
    self.cellDataDict = nil;
    self.pieChartIdentifier = nil;
    self.actualBarIdentifier = nil;
    self.targetBarIdentifier = nil;
    self.titleLabel = nil;
    self.dateRangeLabel = nil;
    self.pieChartView = nil;
    self.plotDataList = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    self.cellDataDict = aDataDict;
    self.titleLabel.text = [self.cellDataDict objectForKey:@"Title"];
    self.dateRangeLabel.text = [self.cellDataDict objectForKey:@"Description"];
    [self constructLeftBarChartWithData:aDataDict];
    [self constructPieChartWithData:aDataDict];
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize fontColor:(CPTColor*)aFontColor {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color    = aFontColor;
    textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:17.0].fontName;
    return textStyle;
}

- (void)constructLeftBarChartWithData:(NSMutableDictionary*)aDataDict {
    
}

- (CPTTheme*)createDefaultTheme {
    return [CPTTheme themeNamed:kCPTPlainWhiteTheme];
}

- (void)setDefaultPadding:(CPTXYGraph*)aGraph {
    CGFloat boundsPadding = 0.0f;
    aGraph.paddingLeft = boundsPadding;
    aGraph.paddingTop = boundsPadding;
    aGraph.paddingRight = boundsPadding;
    aGraph.paddingBottom = boundsPadding;
}

- (void)constructPieChartWithData:(NSMutableDictionary*)aDataDict {
    self.pieChartIdentifier = @"PieChartId";
    float ytdActualValue = fabsf([[aDataDict objectForKey:@"YtdActual"] floatValue]);
    float ytdTargetValue = fabsf([[aDataDict objectForKey:@"YtdTarget"] floatValue]);
    
    float unfinishedYtdTargetFloatValue = ytdTargetValue - ytdActualValue;
    self.actualOverTargetFlag = NO;
    if (unfinishedYtdTargetFloatValue <= 0) {
        unfinishedYtdTargetFloatValue = 0.001;
        self.actualOverTargetFlag = YES;
    }
    
    self.actualEqualToZeroFlag = NO;
    if (ytdActualValue == 0) {
        ytdActualValue = 0.001;
        self.actualEqualToZeroFlag = YES;
    }
    NSNumber* ytdActualNumber = [NSNumber numberWithFloat:ytdActualValue];
    NSNumber* unfinishedYtdTargetNumber = [NSNumber numberWithFloat:unfinishedYtdTargetFloatValue];
    self.plotDataList = [NSMutableArray arrayWithObjects:ytdActualNumber, unfinishedYtdTargetNumber, nil];
    
    //    NSLog(@"cc: %@", self.plotDataList);
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.pieChartView.bounds];
    [graph applyTheme:[self createDefaultTheme]];
    graph.plotAreaFrame.cornerRadius = CPTFloat(5.0);
    self.pieChartView.hostedGraph = graph;
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.masksToBorder = NO;
    
    [self setDefaultPadding:graph];
    graph.axisSet = nil;
    
    
    // Add pie chart
    CPTPieChart *aPieChart = [[CPTPieChart alloc] init];
    aPieChart.dataSource = self;
    aPieChart.delegate = self;
    aPieChart.pieRadius = 70.0;
    aPieChart.identifier = self.pieChartIdentifier;
    aPieChart.startAngle = M_PI_4;
    aPieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    CPTMutableLineStyle* pieBorderLineStyle = [CPTMutableLineStyle lineStyle];
    pieBorderLineStyle.lineColor = [CPTColor whiteColor];
    pieBorderLineStyle.lineWidth = 2.0;
    aPieChart.borderLineStyle = pieBorderLineStyle;
    aPieChart.labelOffset = -50.0;
    [graph addPlot:aPieChart];
    [aPieChart release];
    graph.titleTextStyle = [self textStyleWithFontSize:15.0f];
    graph.title = @"YTD";
    graph.titleDisplacement = CGPointMake(60.0, 2.0);;
    [graph release];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        return [self.plotDataList count];
    }
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
        return [dataList count];
    }
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSNumber* num = nil;
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            num = self.plotDataList[index];
        }
        else {
            num = [NSNumber numberWithUnsignedInteger:index];
        }
    } else if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
                break;
                
            case CPTBarPlotFieldBarTip:{
                if ([(NSString*)plot.identifier isEqualToString:self.actualBarIdentifier]) {
                    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
                    NSMutableDictionary* tmpDict = [dataList objectAtIndex:index];
                    num = [tmpDict objectForKey:@"Actual"];
                }
                if ([(NSString*)plot.identifier isEqualToString:self.targetBarIdentifier]) {
                    NSMutableArray* dataList = [self.cellDataDict objectForKey:@"DataList"];
                    NSMutableDictionary* tmpDict = [dataList objectAtIndex:index];
                    num = [tmpDict objectForKey:@"Target"];
                }
            }
                break;
            default:
                break;
        }
    }
    
    
    return num;
}

#pragma mark CPTPieChartDelegate Methods
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    
    if (index == 0) {
        return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:CPTFloat(0.0) green:CPTFloat(128.0/255.0) blue:CPTFloat(0.0) alpha:CPTFloat(1.0)]];
    }
    if (index == 1) {
        CPTColor* aColor = [CPTColor colorWithComponentRed:CPTFloat(1.0) green:CPTFloat(0.0) blue:CPTFloat(0.0) alpha:CPTFloat(1.0)];
        return [CPTFill fillWithColor:aColor];
    }
    return nil;
}

-(void)Plot:(nonnull CPTPlot *)plot dataLabelWasSelectedAtRecordIndex:(NSUInteger)index
{
    //    NSLog(@"Data label for '%@' was selected at index %d.", plot.identifier, (int)index);
}

-(void)pieChart:(nonnull CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
    //    NSLog(@"Slice was selected at index %d. Value = %f", (int)index, [[self.plotDataList objectAtIndex:index] doubleValue]);
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle* blackText = [self textStyleWithFontSize:14.0 fontColor:[CPTColor blackColor]];
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        id tmpLabelObj = [self.plotDataList objectAtIndex:index];
        if ([tmpLabelObj isKindOfClass:[NSNull class]]) {
            return nil;
        }
        if (self.actualOverTargetFlag && index == 1) {
            return nil;
        }
        if (self.actualEqualToZeroFlag && index == 0) {
            return nil;
        }
        
        return [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.0f", [[self.plotDataList objectAtIndex:index] floatValue]] style:blackText] autorelease];
    }
    return nil;
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color    = [CPTColor blackColor];
    textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:17.0].fontName;
    return textStyle;
}

@end
