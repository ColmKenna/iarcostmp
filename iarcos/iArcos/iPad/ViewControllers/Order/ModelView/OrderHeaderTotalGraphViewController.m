//
//  OrderHeaderTotalGraphViewController.m
//  Arcos
//
//  Created by David Kilmartin on 30/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "OrderHeaderTotalGraphViewController.h"

@implementation OrderHeaderTotalGraphViewController
@synthesize delegate = _delegate;
@synthesize presentDelegate = _presentDelegate;
@synthesize allChartView;
@synthesize weekLineChartView;
@synthesize monthPieChartView;
@synthesize yearBarChartView;
@synthesize allTableView;
@synthesize weekTableChartView;
@synthesize monthTableChartView;
@synthesize yearTableChartView;
@synthesize weekLineChart;
@synthesize monthPieChart;
@synthesize yearBarChart;
@synthesize theData = _theData;
@synthesize weekTableScrollView;
@synthesize monthTableScrollView;
@synthesize yearTableScrollView;
@synthesize weekTarget;
@synthesize monthTarget;
@synthesize yearTarget;
@synthesize weekActual;
@synthesize monthActual;
@synthesize yearActual;
@synthesize weekDiff;
@synthesize monthDiff;
@synthesize yearDiff;
@synthesize weekAchieved;
@synthesize monthAchieved;
@synthesize yearAchieved;
@synthesize weekDayLeft;
@synthesize monthDayLeft;
@synthesize yearDayLeft;
@synthesize weekRequired;
@synthesize monthRequired;
@synthesize yearRequired;

@synthesize weekTargetTitleLabel;
@synthesize monthTargetTitleLabel;
@synthesize yearTargetTitleLabel;
@synthesize weekActualTitleLabel;
@synthesize monthActualTitleLabel;
@synthesize yearActualTitleLabel;
@synthesize weekDiffTitleLabel;
@synthesize monthDiffTitleLabel;
@synthesize yearDiffTitleLabel;
@synthesize weekAchievedTitleLabel;
@synthesize monthAchievedTitleLabel;
@synthesize yearAchievedTitleLabel;
@synthesize weekDayLeftTitleLabel;
@synthesize monthDayLeftTitleLabel;
@synthesize yearDayLeftTitleLabel;
@synthesize weekRequiredTitleLabel;
@synthesize monthRequiredTitleLabel;
@synthesize yearRequiredTitleLabel;

@synthesize targetPopoverController = _targetPopoverController;
@synthesize ohtstvc = _ohtstvc;
@synthesize setTargetButton = _setTargetButton;
@synthesize settingManager = _settingManager;
@synthesize dataManager = _dataManager;
@synthesize extendedSettingManager = _extendedSettingManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.allChartView != nil) { self.allChartView = nil;}            
    if (self.weekLineChartView != nil) { self.weekLineChartView = nil; }
    if (self.monthPieChartView != nil) { self.monthPieChartView = nil; }
    if (self.yearBarChartView != nil) { self.yearBarChartView = nil; }
    if (self.allTableView != nil) { self.allTableView = nil; }
    if (self.weekTableChartView != nil) { self.weekTableChartView = nil; }
    if (self.monthTableChartView != nil) { self.monthTableChartView = nil; }
    if (self.yearTableChartView != nil) { self.yearTableChartView = nil; }
    if (self.weekLineChart != nil) { self.weekLineChart = nil; }
    if (self.monthPieChart != nil) { self.monthPieChart = nil; }
    if (self.yearBarChart != nil) { self.yearBarChart = nil; }    
    if (self.theData != nil) { self.theData = nil; }
    if (self.weekTableScrollView != nil) { self.weekTableScrollView = nil; }
    if (self.monthTableScrollView != nil) { self.monthTableScrollView = nil; }
    if (self.yearTableScrollView != nil) { self.yearTableScrollView = nil; }    
    if (self.weekTarget != nil) { self.weekTarget = nil; }
    if (self.monthTarget != nil) { self.monthTarget = nil; }
    if (self.yearTarget != nil) { self.yearTarget = nil; }    
    if (self.weekActual != nil) { self.weekActual = nil; }
    if (self.monthActual != nil) { self.monthActual = nil; }
    if (self.yearActual != nil) { self.yearActual = nil; }
    if (self.weekDiff != nil) { self.weekDiff = nil; }
    if (self.monthDiff != nil) { self.monthDiff = nil; }
    if (self.yearDiff != nil) { self.yearDiff = nil; }
    if (self.weekAchieved != nil) { self.weekAchieved = nil; }
    if (self.monthAchieved != nil) { self.monthAchieved = nil; }
    if (self.yearAchieved != nil) { self.yearAchieved = nil; }    
    if (self.weekDayLeft != nil) { self.weekDayLeft = nil; }    
    if (self.monthDayLeft != nil) { self.monthDayLeft = nil; }    
    if (self.yearDayLeft != nil) { self.yearDayLeft = nil; }
    if (self.weekRequired != nil) { self.weekRequired = nil; }
    if (self.monthRequired != nil) { self.monthRequired = nil; }
    if (self.yearRequired != nil) { self.yearRequired = nil; }
    
    if (self.weekTargetTitleLabel != nil) { self.weekTargetTitleLabel = nil; }
    if (self.monthTargetTitleLabel != nil) { self.monthTargetTitleLabel = nil; }
    if (self.yearTargetTitleLabel != nil) { self.yearTargetTitleLabel = nil; }    
    if (self.weekActualTitleLabel != nil) { self.weekActualTitleLabel = nil; }
    if (self.monthActualTitleLabel != nil) { self.monthActualTitleLabel = nil; }
    if (self.yearActualTitleLabel != nil) { self.yearActualTitleLabel = nil; }
    if (self.weekDiffTitleLabel != nil) { self.weekDiffTitleLabel = nil; }
    if (self.monthDiffTitleLabel != nil) { self.monthDiffTitleLabel = nil; }
    if (self.yearDiffTitleLabel != nil) { self.yearDiffTitleLabel = nil; }
    if (self.weekAchievedTitleLabel != nil) { self.weekAchievedTitleLabel = nil; }
    if (self.monthAchievedTitleLabel != nil) { self.monthAchievedTitleLabel = nil; }
    if (self.yearAchievedTitleLabel != nil) { self.yearAchievedTitleLabel = nil; }    
    if (self.weekDayLeftTitleLabel != nil) { self.weekDayLeftTitleLabel = nil; }    
    if (self.monthDayLeftTitleLabel != nil) { self.monthDayLeftTitleLabel = nil; }    
    if (self.yearDayLeftTitleLabel != nil) { self.yearDayLeftTitleLabel = nil; }
    if (self.weekRequiredTitleLabel != nil) { self.weekRequiredTitleLabel = nil; }
    if (self.monthRequiredTitleLabel != nil) { self.monthRequiredTitleLabel = nil; }
    if (self.yearRequiredTitleLabel != nil) { self.yearRequiredTitleLabel = nil; }
    
    if (symbolTextAnnotation != nil) {
        [symbolTextAnnotation release];
        symbolTextAnnotation = nil;
    }
    if (yearlySymbolTextAnnotation != nil) {
        [yearlySymbolTextAnnotation release];
        yearlySymbolTextAnnotation = nil;
    }
    if (self.ohtstvc != nil) { self.ohtstvc = nil; }
    if (self.targetPopoverController != nil) { self.targetPopoverController = nil; }             
    
        
    if (self.setTargetButton != nil) { self.setTargetButton = nil; }
    if (self.settingManager != nil) { self.settingManager = nil; }      
    if (self.dataManager != nil) { self.dataManager = nil; }
    if (self.extendedSettingManager != nil) { self.extendedSettingManager = nil; }    
        
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
    [self createDataManagerCorrespondingly];    
    [self.dataManager createBasicLineChartData];
    [self.dataManager createBasicPieChartData];
    [self.dataManager createBasicBarChartData];
    self.weekLineChart = [[[CPTScatterPlot alloc] init] autorelease];
    self.monthPieChart = [[[CPTPieChart alloc] init] autorelease];
    self.yearBarChart = [[[CPTBarPlot alloc] init] autorelease];    
    
    self.setTargetButton = [[[UIBarButtonItem alloc] initWithTitle:@"SetTarget" style:UIBarButtonItemStylePlain target:self action:@selector(setTargetPressed:)] autorelease];
    [self.navigationItem setRightBarButtonItem:self.setTargetButton];
    self.ohtstvc = [[[OrderHeaderTotalSetTargetViewController alloc] initWithNibName:@"OrderHeaderTotalSetTargetViewController" bundle:nil] autorelease];
    self.ohtstvc.delegate = self;

    self.targetPopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.ohtstvc] autorelease];
    self.targetPopoverController.popoverContentSize = CGSizeMake(700.0f, 360.0f);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];

    NSInteger month = [ArcosUtils monthDayWithDate:[NSDate date]];
    [self constructOHLCLineChart:self.weekLineChartView lineChart:self.weekLineChart identifier:@"IdWeekLineChart" title:[NSString stringWithFormat:@"Week Ending %@", [ArcosUtils stringFromDate:self.dataManager.currentWeekendDate format:@"dd/MM/yyyy"]]];
    
    [self constructPieChart:self.monthPieChartView pieChart:self.monthPieChart identifier:@"IdMonthPieChart" title:[NSString stringWithFormat:@"Month: %@", [self.dataManager.monthMapDict objectForKey:[NSNumber numberWithInteger:month]]]];

    [self constructBarChart:self.yearBarChartView barChart:self.yearBarChart identifier:@"IdYearBarChart" title:[NSString stringWithFormat:@"Year: %d", [ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:[NSDate date]]]]];
    [self constructTableChartWithType:self.weekTableChartView title:[NSString stringWithFormat:@"Week Ending %@", [ArcosUtils stringFromDate:self.dataManager.currentWeekendDate format:@"dd/MM/yyyy"]]];
    [self constructTableChartWithType:self.monthTableChartView title:[NSString stringWithFormat:@"Month: %@", [self.dataManager.monthMapDict objectForKey:[NSNumber numberWithInteger:month]]]];
    [self constructTableChartWithType:self.yearTableChartView title:[NSString stringWithFormat:@"Year: %d", [ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:[NSDate date]]]]];
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.allChartView != nil) { self.allChartView = nil;}            
    if (self.weekLineChartView != nil) { self.weekLineChartView = nil; }
    if (self.monthPieChartView != nil) { self.monthPieChartView = nil; }
    if (self.yearBarChartView != nil) { self.yearBarChartView = nil; }
    if (self.allTableView != nil) { self.allTableView = nil; }
    if (self.weekTableChartView != nil) { self.weekTableChartView = nil; }
    if (self.monthTableChartView != nil) { self.monthTableChartView = nil; }
    if (self.yearTableChartView != nil) { self.yearTableChartView = nil; }
    
    if (self.weekTableScrollView != nil) { self.weekTableScrollView = nil; }
    if (self.monthTableScrollView != nil) { self.monthTableScrollView = nil; }
    if (self.yearTableScrollView != nil) { self.yearTableScrollView = nil; }    
    if (self.weekTarget != nil) { self.weekTarget = nil; }
    if (self.monthTarget != nil) { self.monthTarget = nil; }
    if (self.yearTarget != nil) { self.yearTarget = nil; }    
    if (self.weekActual != nil) { self.weekActual = nil; }
    if (self.monthActual != nil) { self.monthActual = nil; }
    if (self.yearActual != nil) { self.yearActual = nil; }
    if (self.weekDiff != nil) { self.weekDiff = nil; }
    if (self.monthDiff != nil) { self.monthDiff = nil; }
    if (self.yearDiff != nil) { self.yearDiff = nil; }
    if (self.weekAchieved != nil) { self.weekAchieved = nil; }
    if (self.monthAchieved != nil) { self.monthAchieved = nil; }
    if (self.yearAchieved != nil) { self.yearAchieved = nil; }    
    if (self.weekDayLeft != nil) { self.weekDayLeft = nil; }    
    if (self.monthDayLeft != nil) { self.monthDayLeft = nil; }    
    if (self.yearDayLeft != nil) { self.yearDayLeft = nil; }
    if (self.weekRequired != nil) { self.weekRequired = nil; }
    if (self.monthRequired != nil) { self.monthRequired = nil; }
    if (self.yearRequired != nil) { self.yearRequired = nil; }
    
    if (self.weekTargetTitleLabel != nil) { self.weekTargetTitleLabel = nil; }
    if (self.monthTargetTitleLabel != nil) { self.monthTargetTitleLabel = nil; }
    if (self.yearTargetTitleLabel != nil) { self.yearTargetTitleLabel = nil; }    
    if (self.weekActualTitleLabel != nil) { self.weekActualTitleLabel = nil; }
    if (self.monthActualTitleLabel != nil) { self.monthActualTitleLabel = nil; }
    if (self.yearActualTitleLabel != nil) { self.yearActualTitleLabel = nil; }
    if (self.weekDiffTitleLabel != nil) { self.weekDiffTitleLabel = nil; }
    if (self.monthDiffTitleLabel != nil) { self.monthDiffTitleLabel = nil; }
    if (self.yearDiffTitleLabel != nil) { self.yearDiffTitleLabel = nil; }
    if (self.weekAchievedTitleLabel != nil) { self.weekAchievedTitleLabel = nil; }
    if (self.monthAchievedTitleLabel != nil) { self.monthAchievedTitleLabel = nil; }
    if (self.yearAchievedTitleLabel != nil) { self.yearAchievedTitleLabel = nil; }    
    if (self.weekDayLeftTitleLabel != nil) { self.weekDayLeftTitleLabel = nil; }    
    if (self.monthDayLeftTitleLabel != nil) { self.monthDayLeftTitleLabel = nil; }    
    if (self.yearDayLeftTitleLabel != nil) { self.yearDayLeftTitleLabel = nil; }
    if (self.weekRequiredTitleLabel != nil) { self.weekRequiredTitleLabel = nil; }
    if (self.monthRequiredTitleLabel != nil) { self.monthRequiredTitleLabel = nil; }
    if (self.yearRequiredTitleLabel != nil) { self.yearRequiredTitleLabel = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self resetDisplayLayout:orientation];    
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];

    [self drawInitialTableChart:self.weekTableChartView scrollView:self.weekTableScrollView];
    [self drawInitialTableChart:self.monthTableChartView scrollView:self.monthTableScrollView];
    [self drawInitialTableChart:self.yearTableChartView scrollView:self.yearTableScrollView];
//    [self makeScrollViewScrollable:self.weekTableScrollView];
//    [self makeScrollViewScrollable:self.monthTableScrollView];
//    [self makeScrollViewScrollable:self.yearTableScrollView];    
    [self createBasicAnalysisData];    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)backPressed:(id)sender {
    if ([self.targetPopoverController isPopoverVisible]) {        
        [self.targetPopoverController dismissPopoverAnimated:YES];        
    }
//    [self.delegate didDismissModalView];
    [self.presentDelegate didDismissPresentView];
}

- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView pieChart:(CPTPieChart*)aPieChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	aGraphHostingView.hostedGraph = graph;
	graph.plotAreaFrame.masksToBorder = NO;
    
    CGFloat boundsPadding = 10.0f;
	graph.paddingLeft = boundsPadding;
	graph.paddingTop = boundsPadding;
	graph.paddingRight = boundsPadding;
	graph.paddingBottom = boundsPadding;
    
	graph.axisSet = nil;
    
	// Prepare a radial overlay gradient for shading/gloss
	CPTGradient* overlayGradient = [[[CPTGradient alloc] init] autorelease];
	overlayGradient.gradientType = CPTGradientTypeRadial;
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.7] atPosition:1.0];
    
	// Add pie chart
    
	aPieChart.dataSource = self;
    aPieChart.delegate = self;
	aPieChart.pieRadius = 80.0;
	aPieChart.identifier = anIdentifier;
	aPieChart.startAngle = M_PI_4;
	aPieChart.sliceDirection	= CPTPieDirectionCounterClockwise;
	aPieChart.borderLineStyle = [CPTLineStyle lineStyle];
	aPieChart.labelOffset = 5.0;
	aPieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
	[graph addPlot:aPieChart];
    
    // Add legend
	CPTLegend* theLegend = [CPTLegend legendWithGraph:graph];
	theLegend.numberOfColumns = 1;
    NSArray* columnWidthArray = [NSArray arrayWithObject:[NSNumber numberWithInt:36]];
    theLegend.columnWidths = columnWidthArray;
	theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	theLegend.borderLineStyle = [CPTLineStyle lineStyle];    
	theLegend.cornerRadius = 5.0; 
	graph.legend = theLegend;
	graph.legendAnchor = CPTRectAnchorRight;
    graph.legendDisplacement = CGPointMake(-12.0, 0.0);
    
    //Add title
//    CPTMutableTextStyle* whiteText = [CPTMutableTextStyle textStyle];
//    whiteText.color = [CPTColor whiteColor];
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].titleDisplacement;
    
//    [pieChart release];
    [graph release];
}

#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot isKindOfClass:[CPTPieChart class]] ) {
        return [self.dataManager.monthDisplayList count];
	} else if ([plot isKindOfClass:[CPTScatterPlot class]]) {
        return [self.dataManager.weekDisplayList count];
    } else if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        if ([(NSString*)plot.identifier isEqualToString:self.dataManager.weekBarChartIdentifier]) {
            return [self.dataManager.weekDisplayList count];
        }
        if ([(NSString*)plot.identifier isEqualToString:self.dataManager.targetMonthBarChartIdentifier] || [(NSString*)plot.identifier isEqualToString:self.dataManager.actualMonthBarChartIdentifier]) {
            return [self.dataManager.yearDisplayList count];
        }
	}
	return 0;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber* num = nil;
    if ([plot isKindOfClass:[CPTPieChart class]]) {        
		if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            if ([(NSString*)plot.identifier isEqualToString:@"IdMonthPieChart"]) {
                num = [self.dataManager.monthDisplayList objectAtIndex:index];
            }		
        } else {
            return [NSNumber numberWithUnsignedInteger:index];
        }
    } else if ([plot isKindOfClass:[CPTScatterPlot class]]) {        
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX: {
                if ( [(NSString*)plot.identifier isEqualToString:@"Data Source Plot"] ) {
                    num = [[self.dataManager.weekDisplayList objectAtIndex:index] objectForKey:@"x"];
                } else if ([(NSString*)plot.identifier isEqualToString:@"Target Line"]) {
                    num = [[self.dataManager.weekDisplayList objectAtIndex:index] objectForKey:@"x"];
                }
            }                
                break;
                
            case CPTScatterPlotFieldY: {
                if ( [(NSString*)plot.identifier isEqualToString:@"Data Source Plot"] ) {
                    num = [[self.dataManager.weekDisplayList objectAtIndex:index] objectForKey:@"y"];
                } else if ([(NSString*)plot.identifier isEqualToString:@"Target Line"]) {
                    num = [NSNumber numberWithInt:[[[self.dataManager latestPersonalTarget] objectForKey:@"weekTarget"] intValue]];
                }                    
            }                
                break;
                
            default:
                break;
        }
         
	} else if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch ( fieldEnum ) {
			case CPTBarPlotFieldBarLocation:
				num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
				break;
                
			case CPTBarPlotFieldBarTip:{
                if ([(NSString*)plot.identifier isEqualToString:self.dataManager.weekBarChartIdentifier]) {
                    num = [[self.dataManager.weekDisplayList objectAtIndex:index] objectForKey:self.dataManager.barTotalValueDayKey];
                }
                if ([(NSString*)plot.identifier isEqualToString:self.dataManager.actualMonthBarChartIdentifier]) {
                    num = [[self.dataManager.yearDisplayList objectAtIndex:index] objectForKey:self.dataManager.barTotalValueMonthKey];
                }
                if ([(NSString*)plot.identifier isEqualToString:self.dataManager.targetMonthBarChartIdentifier]) {//@"Bar Plot 2"
                    num = [NSNumber numberWithInt:[[[self.dataManager latestPersonalTarget] objectForKey:@"monthTarget"] intValue]];               
                }
            }
				break;
            default:
                break;
		}         
    } else {
        num = [NSNumber numberWithInt:0];
    }	
	return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    static CPTMutableTextStyle *whiteText = nil;
    
	if ( !whiteText ) {
		whiteText		= [[CPTMutableTextStyle alloc] init];
		whiteText.color = [CPTColor whiteColor];
	}
    if ([plot.identifier isEqual:@"IdMonthPieChart"]) {
        return [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.0f%%", [[self.dataManager.monthDisplayList objectAtIndex:index] floatValue]] style:whiteText] autorelease];
    }
    if ([(NSString*)plot.identifier isEqualToString:self.dataManager.weekBarChartIdentifier]) {
        return [[[CPTTextLayer alloc] initWithText:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%.0f", [[[self.dataManager.weekDisplayList objectAtIndex:index] objectForKey:self.dataManager.barTotalValueDayKey] floatValue]]] style:whiteText] autorelease];
    }
    return nil;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
	return [self.dataManager.legendList objectAtIndex:index];
}

- (void)constructTableChartWithType:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aCPTGraphHostingView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;    
	graph.paddingLeft = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingBottom = 10.0;    
	graph.axisSet = nil;
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	aCPTGraphHostingView.hostedGraph = graph;
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].titleDisplacement;
	[graph release];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self resetDisplayLayout:toInterfaceOrientation];
}

/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
        [self resetDisplayLayout:UIInterfaceOrientationLandscapeLeft];
    } else {
        [self resetDisplayLayout:UIInterfaceOrientationPortrait];
    }
}
*/
- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation {
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        self.allChartView.frame = CGRectMake(0.0f, 0.0f, 1024.0f, 340.0f);
        self.weekLineChartView.frame = CGRectMake(10.0f, 10.0f, 330.0f, 330.0f);
        self.monthPieChartView.frame = CGRectMake(347.0f, 10.0f, 330.0f, 330.0f);
        self.yearBarChartView.frame = CGRectMake(684.0f, 10.0f, 330.0f, 330.0f);
        
        self.allTableView.frame = CGRectMake(0.0f, 340.0f, 1024.0f, 340.0f);
//        self.weekTableChartView.frame = CGRectMake(10.0f, 350.0f, 330.0f, 330.0f);
        self.weekTableChartView.frame = CGRectMake(10.0f, 10.0f, 330.0f, 330.0f);
        self.weekTableScrollView.frame = CGRectMake(60.0f, 60.0f, 210.0f, 210.0f);
//        self.monthTableChartView.frame = CGRectMake(347.0f, 350.0f, 330.0f, 330.0f);
        self.monthTableChartView.frame = CGRectMake(347.0f, 10.0f, 330.0f, 330.0f);
        self.monthTableScrollView.frame = CGRectMake(60.0f, 60.0f, 210.0f, 210.0f);
//        self.yearTableChartView.frame = CGRectMake(684.0f, 350.0f, 330.0f, 330.0f);
        self.yearTableChartView.frame = CGRectMake(684.0f, 10.0f, 330.0f, 330.0f);
        self.yearTableScrollView.frame = CGRectMake(60.0f, 60.0f, 210.0f, 210.0f);
        CPTPieChart* tmpMonthPieChart = (CPTPieChart*)[self.monthPieChartView.hostedGraph plotAtIndex:0];
        tmpMonthPieChart.pieRadius = 120.0f;
//        self.monthPieChart.pieRadius = 120.0f;
    } else {
        self.allChartView.frame = CGRectMake(0.0f, 0.0f, 440.0f, 1024.0f);
        self.weekLineChartView.frame = CGRectMake(10.0f, 10.0f, 430.0f, 310.0f);
        self.monthPieChartView.frame = CGRectMake(10.0f, 330.0f, 430.0f, 310.0f);
        self.yearBarChartView.frame = CGRectMake(10.0f, 650.0f, 430.0f, 310.0f);
        
        self.allTableView.frame = CGRectMake(448.0f, 0.0f, 310.0f, 960.0f);
//        self.weekTableChartView.frame = CGRectMake(448.0f, 10.0f, 310.0f, 310.0f);
        self.weekTableChartView.frame = CGRectMake(0.0f, 10.0f, 310.0f, 310.0f);
        self.weekTableScrollView.frame = CGRectMake(50.0f, 50.0f, 210.0f, 210.0f);
//        self.monthTableChartView.frame = CGRectMake(448.0f, 330.0f, 310.0f, 310.0f);
        self.monthTableChartView.frame = CGRectMake(0.0f, 330.0f, 310.0f, 310.0f);
        self.monthTableScrollView.frame = CGRectMake(50.0f, 50.0f, 210.0f, 210.0f);
//        self.yearTableChartView.frame = CGRectMake(448.0f, 650.0f, 310.0f, 310.0f);
        self.yearTableChartView.frame = CGRectMake(0.0f, 650.0f, 310.0f, 310.0f);
        self.yearTableScrollView.frame = CGRectMake(50.0f, 50.0f, 210.0f, 210.0f);
        CPTPieChart* tmpMonthPieChart = (CPTPieChart*)[self.monthPieChartView.hostedGraph plotAtIndex:0];
        tmpMonthPieChart.pieRadius = 120.0f;
//        self.monthPieChart.pieRadius = 120.0f;        
    }
    [self makeScrollViewScrollable:self.weekTableScrollView];
    [self makeScrollViewScrollable:self.monthTableScrollView];
    [self makeScrollViewScrollable:self.yearTableScrollView];    
}

#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
	// Impose a limit on how far user can scroll in x
	if ( coordinate == CPTCoordinateX ) {
		CPTPlotRange *maxRange			  = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-1.0f] length:[NSNumber numberWithFloat:6.0f]];
		CPTMutablePlotRange *changedRange = [[newRange mutableCopy] autorelease];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;
	}
    
	return newRange;
}

#pragma mark -
#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{    
    CPTGraph* lineGraph = self.weekLineChartView.hostedGraph;
    
	if ( symbolTextAnnotation ) {
		[lineGraph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
		[symbolTextAnnotation release];
		symbolTextAnnotation = nil;
	}
    
	// Setup a style for the annotation
	CPTMutableTextStyle* hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
	hitAnnotationTextStyle.color	= [CPTColor whiteColor];
	hitAnnotationTextStyle.fontSize = 12.0f;
    hitAnnotationTextStyle.fontName = [UIFont systemFontOfSize:12.0f].fontName;
    
	// Determine point of symbol in plot coordinates
	NSNumber* x = [[self.dataManager.weekDisplayList objectAtIndex:index] valueForKey:@"x"];
	NSNumber* y = [[self.dataManager.weekDisplayList objectAtIndex:index] valueForKey:@"y"];
	NSArray* anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
	// Add annotation
	// First make a string for the y value
   
	NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setMaximumFractionDigits:2];
	NSString* yString = [formatter stringFromNumber:y];
 
	// Now add the annotation to the plot area
	CPTTextLayer* textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
	symbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:lineGraph.defaultPlotSpace anchorPlotPoint:anchorPoint];
	symbolTextAnnotation.contentLayer = textLayer;
	symbolTextAnnotation.displacement = CGPointMake(0.0f, 12.0f);
	[lineGraph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];
}

- (void)constructOHLCLineChart:(CPTGraphHostingView*)aGraphHostingView lineChart:(CPTScatterPlot*)aLineChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle{
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	CPTTheme* theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	aGraphHostingView.hostedGraph = graph;
    CGFloat boundsPadding = 10.0f;
	graph.paddingLeft = boundsPadding;
	graph.paddingTop = boundsPadding;
	graph.paddingRight = boundsPadding;
	graph.paddingBottom = boundsPadding;
    
	graph.plotAreaFrame.masksToBorder = NO;        
    graph.plotAreaFrame.paddingTop		= 10.0;
	graph.plotAreaFrame.paddingRight	= 10.0;
	graph.plotAreaFrame.paddingBottom	= 30.0;
	graph.plotAreaFrame.paddingLeft		= 35.0;
    
    
	// Setup scatter plot space    
    
	// Grid line styles
	CPTMutableLineStyle* majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 0.75;
	majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 0.25;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
//    CPTMutableLineStyle *redLineStyle = [CPTMutableLineStyle lineStyle];
//    redLineStyle.lineWidth = 10.0;
//    redLineStyle.lineColor = [[CPTColor redColor] colorWithAlphaComponent:0.5];
    // Axes
    
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	yAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxisSet *xyAxisSet = (id)graph.axisSet;
	CPTXYAxis *yAxis		= xyAxisSet.yAxis;
	yAxis.majorIntervalLength	= [NSNumber numberWithInt:1];
	yAxis.minorTicksPerInterval = 0;
    yAxis.orthogonalPosition = [NSNumber numberWithInt:0];
    yAxis.labelFormatter = yAxisFormatter;
    
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
    lineCap.lineStyle     = yAxis.axisLineStyle;
    lineCap.lineCapType     = CPTLineCapTypeOpenArrow;
    lineCap.size         = CGSizeMake(12.0, 12.0);
    yAxis.axisLineCapMax = lineCap;
    
    
    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSMutableArray* customTickLocations = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray* yAxisLabels = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        [customTickLocations addObject:[NSNumber numberWithInt:i]];
        NSDate* tmpDate = [ArcosUtils dateWithBeginOfWeek:self.dataManager.dateOfBeginOfWeek interval:i];
        NSInteger tmpWeekday = [ArcosUtils weekDayWithDate:tmpDate];
        [yAxisLabels addObject: [self.dataManager.weekdayMapDict objectForKey:[NSNumber numberWithInteger:tmpWeekday]]];
    }
    NSUInteger labelLocation	 = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[yAxisLabels count]];
    for ( NSNumber* tickLocation in customTickLocations ) {
        CPTAxisLabel* newLabel = [[CPTAxisLabel alloc] initWithText:[yAxisLabels objectAtIndex:labelLocation++] textStyle:yAxis.labelTextStyle];
        newLabel.tickLocation = tickLocation;
        newLabel.offset = yAxis.labelOffset + yAxis.majorTickLength;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    yAxis.axisLabels = [NSSet setWithArray:customLabels];
    
	
    
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	yAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxis *xAxis = xyAxisSet.xAxis;
    if ([self.dataManager.maxOfWeekXAxis floatValue] > 0) {
        self.dataManager.maxOfWeekXAxis = [NSNumber numberWithFloat:[self.dataManager.maxOfWeekXAxis floatValue] * 1.25];
        xAxis.axisLineCapMax = lineCap;
    }
    [lineCap release];
	xAxis.orthogonalPosition = [NSNumber numberWithFloat:0.0];
    float xAxisIntervalLine = [self.dataManager.maxOfWeekXAxis floatValue] / 5;
    xAxis.majorIntervalLength = [NSNumber numberWithFloat:xAxisIntervalLine];
    if (xAxisIntervalLine < 1.0) {
        xAxisFormatter.maximumFractionDigits = 1;
    }
    xAxis.labelFormatter = xAxisFormatter;
//    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
	/*
    //Target plot
    CPTScatterPlot *targetLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	targetLinePlot.identifier = @"Target Line";
    
	CPTMutableLineStyle *targetLineStyle = [CPTMutableLineStyle lineStyle];
	targetLineStyle.lineWidth = 3.0;
	targetLineStyle.lineColor = [CPTColor greenColor];
	targetLinePlot.dataLineStyle = targetLineStyle;
    
	targetLinePlot.dataSource = self;
	[graph addPlot:targetLinePlot];
    
    // Line plot with gradient fill
	CPTScatterPlot *dataSourceLinePlot = [[(CPTScatterPlot *)[CPTScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
	dataSourceLinePlot.identifier	 = @"Data Source Plot";
	dataSourceLinePlot.title		 = @"Close Values";
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth = 3.0;
	lineStyle.lineColor = [CPTColor redColor];
	dataSourceLinePlot.dataLineStyle = lineStyle;
	dataSourceLinePlot.dataSource	 = self;
	[graph addPlot:dataSourceLinePlot];
    
    
	CPTColor *areaColor = [CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.6];
	CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
	areaGradient.angle = -90.0f;
	CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
	dataSourceLinePlot.areaFill		 = areaGradientFill;
	dataSourceLinePlot.areaBaseValue = [NSNumber numberWithFloat:0.0];
    
	areaColor = [CPTColor colorWithComponentRed:0.0 green:1.0 blue:0.0 alpha:0.6];
	areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor clearColor] endingColor:areaColor];
	areaGradient.angle = -90.0f;
	areaGradientFill = [CPTFill fillWithGradient:areaGradient];
	dataSourceLinePlot.areaFill2	  = areaGradientFill;
	dataSourceLinePlot.areaBaseValue2 = [NSNumber numberWithFloat:0.0];
     */
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
    barPlot.identifier          = self.dataManager.weekBarChartIdentifier;
    barPlot.delegate = self;
    [graph addPlot:barPlot];
    [barPlot release];
    // Add plot space for bar charts
//    CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//    barPlotSpace.allowsUserInteraction = YES;
//    barPlotSpace.delegate = self;
//    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:150.0f]];
//    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:10.0]];
//    [graph addPlotSpace:barPlotSpace];
    
	// Set plot ranges
    
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//    plotSpace.allowsUserInteraction = YES;
//    plotSpace.delegate = self;
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:[NSNumber numberWithFloat:7.0f]];
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:0.0f] length:self.dataManager.maxOfWeekXAxis];
    [graph addPlotSpace:plotSpace];
    // Add plot symbols
//    CPTMutableLineStyle* symbolLineStyle = [CPTMutableLineStyle lineStyle];
//    symbolLineStyle.lineColor = [CPTColor blackColor];
//    CPTPlotSymbol* plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
//    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
//    plotSymbol.lineStyle = symbolLineStyle;
//    plotSymbol.size = CGSizeMake(10.0, 10.0);
//    dataSourceLinePlot.plotSymbol = plotSymbol;
    
	// Set plot delegate, to know when symbols have been touched
	// We will display an annotation when a symbol is touched
//    dataSourceLinePlot.delegate = self;
//    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
    
    //Add title    
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].titleDisplacement;
    [graph release];
}

- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView barChart:(CPTBarPlot*)aBarChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle {
    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:aGraphHostingView.bounds];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	aGraphHostingView.hostedGraph = graph;    
    CGFloat boundsPadding = 10.0f;
	graph.paddingLeft = boundsPadding;
	graph.paddingTop = boundsPadding;
	graph.paddingRight = boundsPadding;
	graph.paddingBottom = boundsPadding;
    
	graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.paddingTop		= 10.0;
	graph.plotAreaFrame.paddingRight	= 10.0;
	graph.plotAreaFrame.paddingBottom	= 30.0;
	graph.plotAreaFrame.paddingLeft		= 35.0;
                	
    
	// Create grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 1.0;
	majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 1.0;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];
    
	// Create axes
    NSNumberFormatter* xAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	xAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.majorIntervalLength		  = [NSNumber numberWithInt:1];
    x.minorTicksPerInterval		  = 0;
    x.orthogonalPosition = [NSNumber numberWithInt:0];
//    x.axisLineStyle				  = nil;
//    x.majorTickLineStyle		  = nil;
//    x.minorTickLineStyle		  = nil;
    x.labelFormatter			  = xAxisFormatter;
    CPTLineCap *lineCap = [[CPTLineCap alloc] init];
	lineCap.lineStyle	 = x.axisLineStyle;
	lineCap.lineCapType	 = CPTLineCapTypeOpenArrow;
	lineCap.size		 = CGSizeMake(12.0, 12.0);
	x.axisLineCapMax = lineCap;
	[lineCap release];
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;    
    NSMutableArray* customTickLocations = [NSMutableArray arrayWithCapacity:12];
    for (int i = 0; i < 12; i++) {
        [customTickLocations addObject:[NSNumber numberWithInt:i]];
    }

    NSArray* xAxisLabels = [NSArray arrayWithObjects:@"J", @"F", @"M", @"A", @"M",@"J", @"J", @"A", @"S", @"O", @"N", @"D", nil];
    NSUInteger labelLocation	 = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber* tickLocation in customTickLocations ) {
        CPTAxisLabel* newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = tickLocation;
        newLabel.offset = x.labelOffset + x.majorTickLength;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    
    x.axisLabels = [NSSet setWithArray:customLabels];
    
    NSNumberFormatter* yAxisFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	yAxisFormatter.maximumFractionDigits = 0;
	CPTXYAxis *y = axisSet.yAxis;
    float yAxisIntervalBar = [self.dataManager.maxOfYearYAxis floatValue] / 10;
	y.majorIntervalLength = [NSNumber numberWithFloat:yAxisIntervalBar];
    y.orthogonalPosition = [NSNumber numberWithFloat:-0.5];
    y.labelOffset				  = 0.0;
    if (yAxisIntervalBar < 1.0) {
        yAxisFormatter.maximumFractionDigits = 1;
    }
    y.labelFormatter = yAxisFormatter;
    
	// Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor clearColor];
    
	// Create bar plot
	CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
	barPlot.lineStyle		  = barLineStyle;
	barPlot.barWidth		  = [NSNumber numberWithFloat:0.25f]; // bar is 75% of the available space
	barPlot.barCornerRadius	  = 4.0;
	barPlot.barsAreHorizontal = NO;
	barPlot.dataSource		  = self;
	barPlot.identifier		  = self.dataManager.actualMonthBarChartIdentifier;
    [graph addPlot:barPlot];
    
    // Second bar plot
	barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    barPlot.lineStyle = barLineStyle;
	barPlot.dataSource = self;
    barPlot.barWidth = [NSNumber numberWithFloat:0.25f]; // bar is 75% of the
	barPlot.barOffset = [NSNumber numberWithFloat:0.25f]; // 25% offset, 75% overlap
	barPlot.barCornerRadius = 2.0f;
	barPlot.identifier = self.dataManager.targetMonthBarChartIdentifier;
	barPlot.delegate = self;
        	    
	[graph addPlot:barPlot];
    
    // Add plot space for bar charts
	CPTXYPlotSpace *barPlotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-0.5f] length:[NSNumber numberWithFloat:12.0f]];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0f] length:self.dataManager.maxOfYearYAxis];
	[graph addPlotSpace:barPlotSpace];
            
    //Add title
    graph.titleTextStyle = [self textStyleWithFontSize:17.0f];
    graph.title = aTitle;
    graph.titleDisplacement = [GlobalSharedClass shared].titleDisplacement;
    [graph release];
}

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    if ([plot.identifier isEqual:self.dataManager.weekBarChartIdentifier]) return;
    CPTGraph* lineGraph = self.yearBarChartView.hostedGraph;
    
	if ( yearlySymbolTextAnnotation ) {
		[lineGraph.plotAreaFrame.plotArea removeAnnotation:yearlySymbolTextAnnotation];
		[yearlySymbolTextAnnotation release];
		yearlySymbolTextAnnotation = nil;
	}
    
	// Setup a style for the annotation
	CPTMutableTextStyle* hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
	hitAnnotationTextStyle.color	= [CPTColor whiteColor];
	hitAnnotationTextStyle.fontSize = 12.0f;
    hitAnnotationTextStyle.fontName = [UIFont systemFontOfSize:12.0].fontName;
	// Determine point of symbol in plot coordinates
	NSNumber* x = [NSNumber numberWithUnsignedInteger:index];
	NSNumber* y = [[self.dataManager.yearDisplayList objectAtIndex:index] objectForKey:self.dataManager.barTotalValueMonthKey];
	NSArray* anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
	// Add annotation
	// First make a string for the y value
    
	NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setMaximumFractionDigits:2];
	NSString* yString = [formatter stringFromNumber:y];

    
	// Now add the annotation to the plot area
	CPTTextLayer* textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
	yearlySymbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:lineGraph.defaultPlotSpace anchorPlotPoint:anchorPoint];
	yearlySymbolTextAnnotation.contentLayer = textLayer;
	yearlySymbolTextAnnotation.displacement = CGPointMake(0.0f, 12.0f);
	[lineGraph.plotAreaFrame.plotArea addAnnotation:yearlySymbolTextAnnotation];
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color	= [CPTColor whiteColor];
	textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:12.0].fontName;
    return textStyle;
}

- (void)drawInitialTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView {
    [aGraphHostingView bringSubviewToFront:aScrollView];
//    [aGraphHostingView addSubview:aScrollView];
    aScrollView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
}

- (void)makeScrollViewScrollable:(UIScrollView*)aScrollView {
    aScrollView.contentSize = CGSizeMake(aScrollView.frame.size.width, aScrollView.frame.size.height + 1.0f);
}

- (void)calculateDaysLeft:(NSDate*)aStartDate endDate:(NSDate*)anEndDate percentage:(float)aPercentage difference:(float)aDifference dayLeftLabel:(UILabel*)aDayLeftLabel requiredLabel:(UILabel*)aRequiredLabel {
    if (aPercentage >= 100) {
        aDayLeftLabel.text = @"";
        aRequiredLabel.text = @"";
        return;
    }
    aDifference = fabsf(aDifference);
    NSInteger numOfDays = [ArcosUtils numOfDaysBetweenDates:aStartDate endDate:anEndDate];
    int numOfActualDays = 0;
    for (int i = 1; i <= numOfDays; i++) {
        NSDate* tmpDate = [ArcosUtils dateWithBeginOfWeek:[NSDate date] interval:i];
        int tmpWeekDay = [ArcosUtils convertNSIntegerToInt:[ArcosUtils weekDayWithDate:tmpDate]];
        if (tmpWeekDay != 1 && tmpWeekDay != 7) {
            numOfActualDays++;
        }
    }
    aDayLeftLabel.text = [NSString stringWithFormat:@"%d", numOfActualDays]; 
    if (numOfActualDays == 0) {
        aRequiredLabel.text = [NSString stringWithFormat:@"%d", (int)roundf(aDifference)];
    } else {
        aRequiredLabel.text = [NSString stringWithFormat:@"%d", (int)roundf(aDifference / numOfActualDays)];
    }    
}

- (void)setDifferenceLabelColor:(UILabel*)aDiffLabel diffValue:(float)aDiffValue {
    if (aDiffValue < 0) {
        aDiffLabel.textColor = [UIColor redColor];
    } else {
        aDiffLabel.textColor = [UIColor greenColor];
    }
}

- (void)setTargetPressed:(id)sender {
    if ([self.targetPopoverController isPopoverVisible]) {        
        [self.targetPopoverController dismissPopoverAnimated:YES];        
    } else {        
        [self.targetPopoverController presentPopoverFromBarButtonItem:self.setTargetButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    }
}

- (void)dismissPopoverController {
    if ([self.targetPopoverController isPopoverVisible]) {        
        [self.targetPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)refreshParentContent {
    [self createDataManagerCorrespondingly];
    [self createBasicAnalysisData];    
    [self.dataManager createBasicPieChartData]; 

    CPTGraph* pieGraph = self.monthPieChartView.hostedGraph;
    [pieGraph reloadData];
    
    [self.dataManager createBasicLineChartData];
    [self constructOHLCLineChart:self.weekLineChartView lineChart:self.weekLineChart identifier:@"IdWeekLineChart" title:[NSString stringWithFormat:@"Week Ending %@", [ArcosUtils stringFromDate:self.dataManager.currentWeekendDate format:@"dd/MM/yyyy"]]];
    [self.dataManager createBasicBarChartData];
    [self constructBarChart:self.yearBarChartView barChart:self.yearBarChart identifier:@"IdYearBarChart" title:[NSString stringWithFormat:@"Year: %d", [ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:[NSDate date]]]]];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self resetDisplayLayout:orientation];
}
/*
- (void)createBasicAnalysisData {
    self.settingManager = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"PersonalSetting.%@",@"Personal"];
    NSNumber* weekTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:1] objectForKey:@"Value"];
    NSNumber* monthTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:2] objectForKey:@"Value"];
    NSNumber* yearTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:3] objectForKey:@"Value"];
    
    self.weekTarget.text = [NSString stringWithFormat:@"%.2f", [weekTargetNum floatValue]];
    self.monthTarget.text = [NSString stringWithFormat:@"%.2f", [monthTargetNum floatValue]];
    self.yearTarget.text = [NSString stringWithFormat:@"%.2f", [yearTargetNum floatValue]];
        
    self.weekActual.text = [NSString stringWithFormat:@"%.2f",[self.dataManager.weekOrderTotalValue floatValue]];
    self.monthActual.text = [NSString stringWithFormat:@"%.2f",[self.dataManager.monthOrderTotalValue floatValue]];
    self.yearActual.text = [NSString stringWithFormat:@"%.2f",[self.dataManager.yearOrderTotalValue floatValue]];
    
    float weekDiffNum = [self.dataManager.weekOrderTotalValue floatValue] - [weekTargetNum floatValue];
    self.weekDiff.text = [NSString stringWithFormat:@"%.2f",weekDiffNum];
    [self setDifferenceLabelColor:self.weekDiff diffValue:weekDiffNum];
    float monthDiffNum = [self.dataManager.monthOrderTotalValue floatValue] - [monthTargetNum floatValue];
    self.monthDiff.text = [NSString stringWithFormat:@"%.2f", monthDiffNum];
    [self setDifferenceLabelColor:self.monthDiff diffValue:monthDiffNum];
    float yearDiffNum = [self.dataManager.yearOrderTotalValue floatValue] - [yearTargetNum floatValue];
    self.yearDiff.text = [NSString stringWithFormat:@"%.2f",yearDiffNum];
    [self setDifferenceLabelColor:self.yearDiff diffValue:yearDiffNum];
    
    float weekPercentage4Table = [self.dataManager.weekOrderTotalValue floatValue] / [weekTargetNum floatValue] * 100;
    weekPercentage4Table = [self.dataManager validateThePercentage:weekPercentage4Table pieChart:NO];
    self.weekAchieved.text = [NSString stringWithFormat:@"%.2f%%",weekPercentage4Table];
    
    float monthPercentage4Table = [self.dataManager.monthOrderTotalValue floatValue] / [monthTargetNum floatValue] * 100;
    monthPercentage4Table = [self.dataManager validateThePercentage:monthPercentage4Table pieChart:NO];
    self.monthAchieved.text = [NSString stringWithFormat:@"%.2f%%",monthPercentage4Table];
    
    float yearPercentage4Table = [self.dataManager.yearOrderTotalValue floatValue] / [yearTargetNum floatValue] * 100;
    yearPercentage4Table = [self.dataManager validateThePercentage:yearPercentage4Table pieChart:NO];
    self.yearAchieved.text = [NSString stringWithFormat:@"%.2f%%",yearPercentage4Table];
    
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:[ArcosUtils endOfDay:self.dataManager.currentWeekendDate] percentage:weekPercentage4Table difference:weekDiffNum dayLeftLabel:self.weekDayLeft requiredLabel:self.weekRequired];
    NSDate* endOfDayOfMonth = [ArcosUtils endDayOfMonth:[ArcosUtils monthDayWithDate:[NSDate date]] withDate:[NSDate date]];
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:endOfDayOfMonth percentage:monthPercentage4Table difference:monthDiffNum dayLeftLabel:self.monthDayLeft requiredLabel:self.monthRequired];
    NSDate* endOfDayOfYear = [ArcosUtils endDayOfYearWithDate:[NSDate date]];
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:endOfDayOfYear percentage:yearPercentage4Table difference:yearDiffNum dayLeftLabel:self.yearDayLeft requiredLabel:self.yearRequired];    
}
*/
- (void)createBasicAnalysisData {
    self.settingManager = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"PersonalSetting.%@",@"Personal"];
    NSNumber* weekTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:1] objectForKey:@"Value"];
    NSNumber* monthTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:2] objectForKey:@"Value"];
    NSNumber* yearTargetNum = [[self.settingManager getSettingForKeypath:keypath atIndex:3] objectForKey:@"Value"];
    
    self.weekTarget.text = [NSString stringWithFormat:@"%d", (int)roundf([weekTargetNum floatValue])];
    self.monthTarget.text = [NSString stringWithFormat:@"%d", (int)roundf([monthTargetNum floatValue])];
    self.yearTarget.text = [NSString stringWithFormat:@"%d", (int)roundf([yearTargetNum floatValue])];
    
    self.weekActual.text = [NSString stringWithFormat:@"%d",(int)roundf([self.dataManager.weekTotalValue floatValue])];
    self.monthActual.text = [NSString stringWithFormat:@"%d",(int)roundf([self.dataManager.monthTotalValue floatValue])];
    self.yearActual.text = [NSString stringWithFormat:@"%d",(int)roundf([self.dataManager.yearTotalValue floatValue])];
    
    float weekDiffNum = [self.dataManager.weekTotalValue floatValue] - [weekTargetNum floatValue];
    self.weekDiff.text = [NSString stringWithFormat:@"%d",(int)roundf(weekDiffNum)];
    [self setDifferenceLabelColor:self.weekDiff diffValue:weekDiffNum];
    float monthDiffNum = [self.dataManager.monthTotalValue floatValue] - [monthTargetNum floatValue];
    self.monthDiff.text = [NSString stringWithFormat:@"%d", (int)roundf(monthDiffNum)];
    [self setDifferenceLabelColor:self.monthDiff diffValue:monthDiffNum];
    float yearDiffNum = [self.dataManager.yearTotalValue floatValue] - [yearTargetNum floatValue];
    self.yearDiff.text = [NSString stringWithFormat:@"%d",(int)roundf(yearDiffNum)];
    [self setDifferenceLabelColor:self.yearDiff diffValue:yearDiffNum];
    
    float weekPercentage4Table = [self.dataManager.weekTotalValue floatValue] / [weekTargetNum floatValue] * 100;
    weekPercentage4Table = [self.dataManager validateThePercentage:weekPercentage4Table pieChart:NO];
    self.weekAchieved.text = [NSString stringWithFormat:@"%d%%",(int)roundf(weekPercentage4Table)];
    
    float monthPercentage4Table = [self.dataManager.monthTotalValue floatValue] / [monthTargetNum floatValue] * 100;
    monthPercentage4Table = [self.dataManager validateThePercentage:monthPercentage4Table pieChart:NO];
    self.monthAchieved.text = [NSString stringWithFormat:@"%d%%",(int)roundf(monthPercentage4Table)];
    
    float yearPercentage4Table = [self.dataManager.yearTotalValue floatValue] / [yearTargetNum floatValue] * 100;
    yearPercentage4Table = [self.dataManager validateThePercentage:yearPercentage4Table pieChart:NO];
    self.yearAchieved.text = [NSString stringWithFormat:@"%d%%",(int)roundf(yearPercentage4Table)];
    
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:[ArcosUtils endOfDay:self.dataManager.currentWeekendDate] percentage:weekPercentage4Table difference:weekDiffNum dayLeftLabel:self.weekDayLeft requiredLabel:self.weekRequired];
    NSDate* endOfDayOfMonth = [ArcosUtils endDayOfMonth:[ArcosUtils monthDayWithDate:[NSDate date]] withDate:[NSDate date]];
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:endOfDayOfMonth percentage:monthPercentage4Table difference:monthDiffNum dayLeftLabel:self.monthDayLeft requiredLabel:self.monthRequired];
    NSDate* endOfDayOfYear = [ArcosUtils endDayOfYearWithDate:[NSDate date]];
    [self calculateDaysLeft:[ArcosUtils beginOfDay:[NSDate date]] endDate:endOfDayOfYear percentage:yearPercentage4Table difference:yearDiffNum dayLeftLabel:self.yearDayLeft requiredLabel:self.yearRequired];    
}

- (void)createDataManagerCorrespondingly {
    self.extendedSettingManager = [[[ExtendedSettingManager alloc] init] autorelease];
    NSString* tmpKeypath = [NSString stringWithFormat:@"PersonalSetting.Personal"];
    NSMutableDictionary* configDataDict = [self.extendedSettingManager getSettingForKeypath:tmpKeypath atIndex:0];
//    NSLog(@"configDataDict %@", configDataDict);
    if ([[configDataDict objectForKey:@"Value"] boolValue]) {
        self.dataManager = [[[OrderHeaderTotalGraphValueDataManager alloc] init] autorelease];
    } else {
        self.dataManager = [[[OrderHeaderTotalGraphCountDataManager alloc] init] autorelease];
    }
}

@end
