//
//  TwoBarViewController.m
//  SciChartText
//
//  Created by David Kilmartin on 19/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TwoBarViewController.h"

@interface TwoBarViewController ()

@end

@implementation TwoBarViewController
//@synthesize sCIChartSurface = _sCIChartSurface;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    [self initializeSurfaceData];
    UIBarButtonItem* screenShotBtn = [[UIBarButtonItem alloc] initWithTitle:@"ScreenShot" style:UIBarButtonItemStylePlain target:self action:@selector(screenShotBtnPressed)];
    [self.navigationItem setRightBarButtonItem:screenShotBtn];
    [screenShotBtn release];
    
}

- (void)screenShotBtnPressed {
    /*
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString* documentsFilePath = [paths objectAtIndex:0];
    NSLog(@"documentsFilePath %@", documentsFilePath);
    NSString* filePath = [NSString stringWithFormat:@"%@/Image.png", documentsFilePath];
    UIImage* image = [self screenshotFromView:self.sCIChartSurface];
    BOOL FLAG = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
     */
}

-(UIImage*) screenshotFromView:(UIView*)view {
    CGSize size = CGSizeMake(view.frame.size.width, view.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen.scale);
    CGRect rec = CGRectMake(0, 0, view.frame.size.width,view.frame.size.height);
    [view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
//    self.sCIChartSurface = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeSurfaceData {
    /*
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis new] autorelease];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
//    xAxis.style.drawLabels = YES;
//    xAxis.autoTicks = NO;
//    xAxis.minorsPerMajor = 2;
//    xAxis.majorDelta = SCIGeneric(1);
//    xAxis.minorDelta = SCIGeneric(1);
//    xAxis.isLabelCullingEnabled = NO;
    SCITextFormattingStyle* textFormattingStyle = [[SCITextFormattingStyle alloc] initWithFontSize:17.0 andTextColor:0xFFFFFFFF];
    SCIAxisStyle* sCIAxisStyle = [[[SCIAxisStyle alloc] init] autorelease];
    sCIAxisStyle.labelStyle = textFormattingStyle;
    
    xAxis.style = sCIAxisStyle;
    [textFormattingStyle release];
    xAxis.visibleRange = [[[SCIDoubleRange alloc] initWithMin:SCIGeneric(1991.5) Max:SCIGeneric(2000.5)] autorelease];
//    xAxis.visibleRange = [[[SCIDoubleRange alloc] initWithMin:SCIGeneric(1991.5) Max:SCIGeneric(2000.5)] autorelease];
//    xAxis.minimalZoomConstrain = SCIGeneric(1991.5);
//    xAxis.maximalZoomConstrain = SCIGeneric(2000.5);
    xAxis.labelProvider = [[[ThousandsLabelProvider alloc] init] autorelease];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis new] autorelease];
    yAxis.style = sCIAxisStyle;
    yAxis.visibleRange = [[[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(30 + 30*0.1)] autorelease];
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    yAxis.flipCoordinates = YES;
    yAxis.growBy = [[[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)] autorelease];
    //
    double porkData[] = {10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11,12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10};
//    double vealData[] = {12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10};
    //
    double tomatoesData[] = {7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22,16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17};
//    double cucumberData[] = {16, 10};//, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17};
//    double pepperData[] = {7, 24};//, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16};
    
    SCIXyDataSeries * ds1 = [[[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double] autorelease];
    ds1.seriesName = @"Apple Series";    
//    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
//    ds2.seriesName = @"Veal Series";
    SCIXyDataSeries * ds3 = [[[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double] autorelease];
    ds3.seriesName = @"Tomato Series";
//    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
//    ds4.seriesName = @"Cucumber Series";
//    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
//    ds5.seriesName = @"Pepper Series";
    
    int data = 1992;
    NSString* myData = @"berocca";
//    const char* auxMyData = [myData UTF8String];
    int size = sizeof(porkData) / sizeof(porkData[0]);
    SCIAnnotationCollection *annotationCollection = [[SCIAnnotationCollection new] autorelease];
//    textAnnotation.style.textStyle = textFormatting;
    for (int i = 0; i < size; i++) {
        int xValue = data + i;
        [ds1 appendX:SCIGeneric(xValue) Y:SCIGeneric(porkData[i])];
//        [ds2 appendX:SCIGeneric(xValue) Y:SCIGeneric(vealData[i])];
        [ds3 appendX:SCIGeneric(xValue) Y:SCIGeneric(tomatoesData[i])];
//        [ds4 appendX:SCIGeneric(xValue) Y:SCIGeneric(cucumberData[i])];
//        [ds5 appendX:SCIGeneric(xValue) Y:SCIGeneric(pepperData[i])];
        SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
//        textAnnotation.coordinateMode = SCIAnnotationCoordinate_RelativeX;
//        textAnnotation.horizontalAnchorPoint = SCIVerticalAnchorPoint_Top;
        
        textAnnotation.x1 = SCIGeneric(xValue-1.0/2/2);
//        textAnnotation.x1 = SCIGeneric(xValue - 0.3);
        textAnnotation.y1 = SCIGeneric(porkData[i] + 0.1);
        textAnnotation.style.textStyle.fontSize = 17.0;
        textAnnotation.style.textColor = [UIColor whiteColor];
        textAnnotation.text = [NSString stringWithFormat:@"%.0f", porkData[i]];
//        [self.sCIChartSurface.annotations add:textAnnotation];
        [annotationCollection add:textAnnotation];
        [textAnnotation release];
        SCITextAnnotation * textAnnotation2 = [[SCITextAnnotation alloc] init];
        textAnnotation2.x1 = SCIGeneric(xValue);
        textAnnotation2.y1 = SCIGeneric(tomatoesData[i] + 0.1);
        textAnnotation2.style.textStyle.fontSize = 17.0;
        textAnnotation2.style.textColor = [UIColor whiteColor];
        textAnnotation2.text = [NSString stringWithFormat:@"%.0f", tomatoesData[i]];
//        [self.sCIChartSurface.annotations add:textAnnotation2];
        [annotationCollection add:textAnnotation2];
        [textAnnotation2 release];
    }
    self.sCIChartSurface.annotations = annotationCollection;
    
    SCIHorizontallyStackedColumnsCollection * horizontalColumnCollection = [[SCIHorizontallyStackedColumnsCollection new] autorelease];
    [horizontalColumnCollection add:[self getRenderableSeriesWithDataSeries:ds1 FillColor:0xff226fb7]];
    [horizontalColumnCollection add:[self getRenderableSeriesWithDataSeries:ds3 FillColor:0xffdc443f]];
//    [hotizontalColumnCollection add:[self getRenderableSeriesWithDataSeries:ds4 FillColor:0xff00ff00]];
//    [hotizontalColumnCollection add:[self getRenderableSeriesWithDataSeries:ds5 FillColor:0xffdc003f]];

    
    SCIWaveRenderableSeriesAnimation * animation = [[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut] autorelease];
    [animation startAfterDelay:0.3];
    animation.completionHandler = ^{
        NSLog(@"completionHandler called");
        
        
    };
    [horizontalColumnCollection addAnimation:animation];
//    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
//    xDragModifier.dragMode = SCIAxisDragMode_Scale;
//    xDragModifier.clipModeX = SCIClipMode_None;
//    
    
    
    [self.sCIChartSurface.xAxes add:xAxis];
    [self.sCIChartSurface.yAxes add:yAxis];
    [self.sCIChartSurface.renderableSeries add:horizontalColumnCollection];
    //SCIRolloverModifier
    SCIXAxisDragModifier * xDragModifier = [[SCIXAxisDragModifier new] autorelease];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    SCILegendModifier* sCILegendModifier = [[[SCILegendModifier alloc] initWithPosition:SCILegendPositionRight andOrientation:SCIOrientationVertical] autorelease];
    sCILegendModifier.showCheckBoxes = NO;
    SCICursorModifier* sCICursorModifier = [[SCICursorModifier new] autorelease];
    SCIZoomExtentsModifier* sCIZoomExtentsModifier = [[SCIZoomExtentsModifier new] autorelease];
    self.sCIChartSurface.chartModifiers = [[[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier,sCILegendModifier, sCICursorModifier,sCIZoomExtentsModifier]] autorelease];
    */
}


/*
- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries FillColor:(uint)fillColor {
    SCIStackedColumnRenderableSeries * renderableSeries = [[SCIStackedColumnRenderableSeries new] autorelease];
    renderableSeries.dataSeries = dataSeries;
//    renderableSeries.dataPointWidth = 1.0;
    NSLog(@"dataPointWidth: %f", renderableSeries.dataPointWidth);
    renderableSeries.fillBrushStyle = [[[SCISolidBrushStyle alloc] initWithColorCode:fillColor] autorelease];
    renderableSeries.strokeStyle = nil;
    
    return renderableSeries;
}
*/
@end
