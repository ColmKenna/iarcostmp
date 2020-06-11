//
//  UtilitiesAnimatedViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesAnimatedViewController.h"

@implementation UtilitiesAnimatedViewController
@synthesize delegate = _delegate;
@synthesize presentViewDelegate = _presentViewDelegate;
@synthesize animateDelegate = _animateDelegate;
@synthesize weekLineChartView;
@synthesize yearBarChartView;
@synthesize currentRunChartView = _currentRunChartView;
@synthesize previousRunChartView = _previousRunChartView;
@synthesize tylyBarChartView = _tylyBarChartView;
@synthesize tylyTableChartView = _tylyTableChartView;
@synthesize tylyTableScrollView = _tylyTableScrollView;
@synthesize dataManager = _dataManager;
@synthesize monthPieChartView;
@synthesize monthTableChartView;
@synthesize monthTableView;
@synthesize monthTableHeaderView;
@synthesize chartViewList = _chartViewList;
@synthesize symbolTextAnnotation = _symbolTextAnnotation;
@synthesize yearSymbolTextAnnotation = _yearSymbolTextAnnotation;
@synthesize landscapeSeqPosList = _landscapeSeqPosList;
@synthesize portraitSeqPosList = _portraitSeqPosList;
@synthesize weekLineChartAxisSet = _weekLineChartAxisSet;
@synthesize weekLineChartTitle = _weekLineChartTitle;
@synthesize monthPieChartTitle = _monthPieChartTitle;
@synthesize monthPieChartLegend = _monthPieChartLegend;
@synthesize monthTableChartTitle = _monthTableChartTitle;
@synthesize yearBarChartAxisSet = _yearBarChartAxisSet;
@synthesize yearBarChartTitle = _yearBarChartTitle;
@synthesize callGenericServices = _callGenericService;
@synthesize locationIUR = _locationIUR;
@synthesize animatedDataManager = _animatedDataManager;
@synthesize animatedTrManager = _animatedTrManager;
@synthesize yearBarImageView = _yearBarImageView;
@synthesize monthPieImageView = _monthPieImageView;
@synthesize monthTableImageView = _monthTableImageView;
@synthesize imageViewList = _imageViewList;
@synthesize weekLineImageView = _weekLineImageView;
@synthesize currentRunImageView = _currentRunImageView;
@synthesize previousRunImageView = _previousRunImageView;
@synthesize allChartViewList = _allChartViewList;
@synthesize customerName = _customerName;
@synthesize weekLineNavTitle = _weekLineNavTitle;
@synthesize monthPieNavTitle = _monthPieNavTitle;
@synthesize monthTableNavTitle = _monthTableNavTitle;
@synthesize yearBarNavTitle = _yearBarNavTitle;

static const CGFloat constantColorLookupTable[20][3] =
{
	{
		1.0, 0.0, 0.0
	},{
		0.0, 1.0, 0.0
	},{
		0.0, 0.0, 1.0
	},{
		1.0, 1.0, 0.0
	},{
		0.25, 0.5, 0.25
	},{
		1.0, 0.0, 1.0
	},{
		0.5, 0.5, 0.5
	},{
		0.25, 0.5, 0.0
	},{
		0.25, 0.25, 0.25
	},{
		0.0, 1.0, 1.0
	},{
		1.0, 0.5, 0.0
	},{
		1.0, 0.0, 0.5
	},{
		1.0, 1.0, 0.5
	},{
		0.5, 0.75, 1.0
	},{
		1.0, 0.75, 1.0
	},{
		1.0, 0.5, 0.5
	},{
		0.75, 1.0, 0.5
	},{
		0.5, 0.25, 1.0
	},{
		1.0, 0.75, 0.75
	},{
		0.75, 1.0, 1.0
	}
};

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
//    if (self.presentViewDelegate != nil) { self.presentViewDelegate = nil; }    
    if (self.weekLineChartView != nil) { self.weekLineChartView = nil; }
    if (self.yearBarChartView != nil) { self.yearBarChartView = nil; }
    if (self.currentRunChartView != nil) { self.currentRunChartView = nil; }
    if (self.previousRunChartView != nil) { self.previousRunChartView = nil; }
    if (self.tylyBarChartView != nil) { self.tylyBarChartView = nil; }
    if (self.tylyTableChartView != nil) { self.tylyTableChartView = nil; }
    if (self.tylyTableScrollView != nil) { self.tylyTableScrollView = nil; }
    
    if (self.dataManager != nil) { self.dataManager = nil; }
    if (self.monthPieChartView != nil) { self.monthPieChartView = nil; }
    if (self.monthTableChartView != nil) { self.monthTableChartView = nil; }
    if (self.monthTableView != nil) { self.monthTableView = nil; }
    if (self.monthTableHeaderView != nil) {
        self.monthTableHeaderView = nil;
    }
    if (self.chartViewList != nil) { self.chartViewList = nil; }
    if (self.symbolTextAnnotation != nil) { self.symbolTextAnnotation = nil; }
    if (self.yearSymbolTextAnnotation != nil) { self.yearSymbolTextAnnotation = nil; }       
    if (self.landscapeSeqPosList != nil) { self.landscapeSeqPosList = nil; }
    if (self.portraitSeqPosList != nil) { self.portraitSeqPosList = nil; }
    if (self.weekLineChartAxisSet != nil) { self.weekLineChartAxisSet = nil; }        
    if (self.weekLineChartTitle != nil) { self.weekLineChartTitle = nil; }            
    if (self.monthPieChartTitle != nil) { self.monthPieChartTitle = nil; }
    if (self.monthPieChartLegend != nil) { self.monthPieChartLegend = nil; }    
    if (self.monthTableChartTitle != nil) { self.monthTableChartTitle = nil; }                
    if (self.yearBarChartAxisSet != nil) { self.yearBarChartAxisSet = nil; }        
    if (self.yearBarChartTitle != nil) { self.yearBarChartTitle = nil; }            
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.animatedDataManager != nil) { self.animatedDataManager = nil; }
    if (self.animatedTrManager != nil) { self.animatedTrManager = nil; }
    if (self.yearBarImageView != nil) { self.yearBarImageView = nil; }
    if (self.monthPieImageView != nil) { self.monthPieImageView = nil; }
    if (self.monthTableImageView != nil) { self.monthTableImageView = nil; }
    if (self.imageViewList != nil) { self.imageViewList = nil; }
    if (self.weekLineImageView != nil) { self.weekLineImageView = nil; }    
    if (self.currentRunImageView != nil) { self.currentRunImageView = nil; }
    if (self.previousRunImageView != nil) { self.previousRunImageView = nil; }
    if (self.allChartViewList != nil) { self.allChartViewList = nil; }
    if (self.customerName != nil) { self.customerName = nil; }
    if (self.weekLineNavTitle != nil) { self.weekLineNavTitle = nil; }
    if (self.monthPieNavTitle != nil) { self.monthPieNavTitle = nil; }
    if (self.monthTableNavTitle != nil) { self.monthTableNavTitle = nil; }
    if (self.yearBarNavTitle != nil) { self.yearBarNavTitle = nil; }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"low memory encountered.");
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.                    
    self.weekLineNavTitle = [NSString stringWithFormat:@"Actual -v- Target for %@", self.customerName];
    self.monthPieNavTitle = [NSString stringWithFormat:@"Brand Distribution for %@", self.customerName];
    self.monthTableNavTitle = [NSString stringWithFormat:@"MAT for %@", self.customerName];
    self.yearBarNavTitle = [NSString stringWithFormat:@"Sales LY -v- TY by Month for %@", self.customerName];
    self.title = self.weekLineNavTitle;
    self.weekLineImageView.isInMiniMode = NO;
    self.monthPieImageView.isInMiniMode = YES;
    self.monthTableImageView.isInMiniMode = YES;
    self.yearBarImageView.isInMiniMode = YES;
    globalZoomInCGAffineTransform = CGAffineTransformMakeScale(0.10,0.10);
//    NSLog(@"begin globalZoomInCGAffineTransform: %@", NSStringFromCGAffineTransform(globalZoomInCGAffineTransform));
    globalZoomOutCGAffineTransform = CGAffineTransformMakeScale(1.0, 1.0);    
    
    landscapeBigViewSize = CGRectMake(10.0f, 10.0f, 904.0f, 684.0f);
    landscapeSmallViewSize = CGRectMake(914.0f, 10.0f, 110.0f, 684.0f);
    globalLandscapeBigViewCenter = [self getCenterFromRect:landscapeBigViewSize];
    globalLandscapeSmallViewCenter = [self getCenterFromRect:landscapeSmallViewSize];
//    NSLog(@"globalLandscapeSmallViewCenter is: %@ ", NSStringFromCGPoint(globalLandscapeSmallViewCenter));
    landscapeFirstViewSize = CGRectMake(20.0f, 44.0f, 120.0f, 120.0f);
    landscapeSecondViewSize = CGRectMake(landscapeFirstViewSize.origin.x, landscapeFirstViewSize.origin.y + landscapeFirstViewSize.size.height * 2, landscapeFirstViewSize.size.width, landscapeFirstViewSize.size.height);
    landscapeThirdViewSize = CGRectMake(landscapeFirstViewSize.origin.x, landscapeSecondViewSize.origin.y + landscapeSecondViewSize.size.height * 2, landscapeFirstViewSize.size.width, landscapeFirstViewSize.size.height);
    self.landscapeSeqPosList = [NSMutableArray arrayWithCapacity:3];
    [self.landscapeSeqPosList addObject:[NSValue valueWithCGRect:landscapeFirstViewSize]];
    [self.landscapeSeqPosList addObject:[NSValue valueWithCGRect:landscapeSecondViewSize]];
    [self.landscapeSeqPosList addObject:[NSValue valueWithCGRect:landscapeThirdViewSize]];
    
    
    portraitBigViewSize = CGRectMake(10.0f, 10.0f, 748.0f, 850.0f);
    portraitSmallViewSize = CGRectMake(10.0f, 860.0f, 748.0f, 100.0f);
    globalPortraitBigViewCenter = [self getCenterFromRect:portraitBigViewSize];
    globalPortraitSmallViewCenter = [self getCenterFromRect:portraitSmallViewSize];
    portraitFirstViewSize = CGRectMake(74.0f, 20.0f, 120.0f, 120.0f);
    portraitSecondViewSize = CGRectMake(portraitFirstViewSize.origin.x + portraitFirstViewSize.size.width * 2, portraitFirstViewSize.origin.y, portraitFirstViewSize.size.width, portraitFirstViewSize.size.height);
    portraitThirdViewSize = CGRectMake(portraitSecondViewSize.origin.x + portraitFirstViewSize.size.width * 2, portraitFirstViewSize.origin.y, portraitFirstViewSize.size.width, portraitFirstViewSize.size.height);
    self.portraitSeqPosList = [NSMutableArray arrayWithCapacity:3];
    [self.portraitSeqPosList addObject:[NSValue valueWithCGRect:portraitFirstViewSize]];
    [self.portraitSeqPosList addObject:[NSValue valueWithCGRect:portraitSecondViewSize]];
    [self.portraitSeqPosList addObject:[NSValue valueWithCGRect:portraitThirdViewSize]];
        
    centerDiff = 240.0f;
    // 0: top; 1: middle; 2: bottom
    self.chartViewList = [NSMutableArray arrayWithCapacity:3];
    [self.chartViewList addObject:self.monthPieChartView];
    [self.chartViewList addObject:self.monthTableChartView];
    [self.chartViewList addObject:self.yearBarChartView];
    
    self.allChartViewList = [NSMutableArray arrayWithCapacity:4];
    [self.allChartViewList addObject:self.weekLineChartView];
    [self.allChartViewList addObject:self.monthPieChartView];
    [self.allChartViewList addObject:self.monthTableChartView];
    [self.allChartViewList addObject:self.yearBarChartView];
    
    self.imageViewList = [NSMutableArray arrayWithCapacity:3];
    [self.imageViewList addObject:self.monthPieImageView];
    [self.imageViewList addObject:self.monthTableImageView];
    [self.imageViewList addObject:self.yearBarImageView];
    middleIndex = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.imageViewList count]] / 2;

    
    self.animatedDataManager = [[[UtilitiesAnimatedDataManager alloc] init] autorelease];
    self.animatedTrManager = [[[UtilitiesAnimatedTrManager alloc] init] autorelease];    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    
//    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearPressed:)];
//    [self.navigationItem setRightBarButtonItem:clearButton];
//    [clearButton release];
    
    UITapGestureRecognizer* pieImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animatePieImageTap)];
    [self.monthPieImageView addGestureRecognizer:pieImageTap];
    [pieImageTap release];
    
    UITapGestureRecognizer* tableImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateTableImageTap)];
    [self.monthTableImageView addGestureRecognizer:tableImageTap];
    [tableImageTap release];
    
    UITapGestureRecognizer* barImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateBarImageTap)];
    [self.yearBarImageView addGestureRecognizer:barImageTap];
    [barImageTap release];
    
    UITapGestureRecognizer* lineImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateLineImageTap)];
    [self.weekLineImageView addGestureRecognizer:lineImageTap];
    [lineImageTap release];
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{        
    [super viewWillAppear:animated];
    self.currentRunChartView = self.weekLineChartView;
    self.currentRunImageView = self.weekLineImageView;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self resetDisplayLayout:orientation];
}

- (void)viewDidAppear:(BOOL)animated
{        
    [super viewDidAppear:animated];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag]) {
        [self.animatedDataManager tableDataFromLocalWithLocationIUR:self.locationIUR];
        if ([self.animatedDataManager.monthTableDisplayList count] == 0) {
            [ArcosUtils showMsg:@"No data found" delegate:nil];
            return;
        }
        [self.animatedDataManager barDataFromLocalWithLocationIUR:self.locationIUR];
        if ([self.animatedDataManager.tylyBarDisplayList count] == 0) {
            [ArcosUtils showMsg:@"No data found" delegate:nil];
            return;
        }
        int localPieLevel = 5;
        @try {
            NSNumber* sMSTexting = [self.animatedDataManager.configDict objectForKey:@"SMSTexting"];
            if (sMSTexting != nil) {
                int resultPieLevel = [sMSTexting intValue] / 10;
                if (resultPieLevel > 0 && resultPieLevel < 10) {
                    localPieLevel = resultPieLevel;
                }
            }
        }
        @catch(NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
        [self.animatedDataManager pieDataFromLocalWithLocationIUR:self.locationIUR levelNumber:localPieLevel];
        if ([self.animatedDataManager.monthPieDisplayList count] == 0) {
            [ArcosUtils showMsg:@"No data found" delegate:nil];
            return;
        }
        [self setLineGetCustomerDataResult:nil];
    } else {
        
        self.callGenericServices.isNotRecursion = NO;
        int barLevel = 6;
        @try {
            NSNumber* sMSTexting = [self.animatedDataManager.configDict objectForKey:@"SMSTexting"];
            if (sMSTexting != nil) {
                int resultBarLevel = [sMSTexting intValue] % 10;
                if (resultBarLevel > 0 && resultBarLevel < 10) {
                    barLevel = resultBarLevel;
                }
            }
        }
        @catch(NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }        
        [self.callGenericServices genericGetCustomerData:[self.locationIUR intValue] startDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] endDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] type:@"TYLY" level:barLevel action:@selector(setBarGetCustomerDataResult:) target:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];   
    [self clearAllSnapshot];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)backPressed:(id)sender {
//    [self.delegate didDismissModalView];   
//    [self.presentViewDelegate didDismissPresentView];
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)clearPressed:(id)sender {
    [self clearAllSnapshot];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self didResetDisplayLayout:UIInterfaceOrientationLandscapeLeft];
    } else {
        [self didResetDisplayLayout:UIInterfaceOrientationPortrait];
    }
}
/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
        [self didResetDisplayLayout:UIInterfaceOrientationPortrait];
    } else {
        [self didResetDisplayLayout:UIInterfaceOrientationLandscapeLeft];        
    }
}
*/
- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation {    
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {  
        self.currentRunImageView.bounds = CGRectMake(0.0f, 0.0f, landscapeBigViewSize.size.width, landscapeBigViewSize.size.height);
        self.currentRunImageView.center = globalLandscapeBigViewCenter;
        self.currentRunImageView.hidden = YES;        
        
        for (int i = 0; i < [self.imageViewList count]; i++) {            
            UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
            tmpImageView.bounds = CGRectMake(0.0f, 0.0f, landscapeBigViewSize.size.width, landscapeBigViewSize.size.height);
            tmpImageView.center = globalLandscapeBigViewCenter;
        }         
        [self resizeAllChartViewListInLandscape];
    } else {
        self.currentRunImageView.bounds = CGRectMake(0.0f, 0.0f, portraitBigViewSize.size.width, portraitBigViewSize.size.height);
        self.currentRunImageView.center = globalPortraitBigViewCenter;
        self.currentRunImageView.hidden = YES;
        
        for (int i = 0; i < [self.imageViewList count]; i++) {            
            UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
            tmpImageView.bounds = CGRectMake(0.0f, 0.0f, portraitBigViewSize.size.width, portraitBigViewSize.size.height);
            tmpImageView.center = globalPortraitBigViewCenter;
        }        
        [self resizeAllChartViewListInPortrait];
    }
}

- (void)didResetDisplayLayout:(UIInterfaceOrientation)fromOrientation {            
    if ((fromOrientation == UIInterfaceOrientationLandscapeLeft) || (fromOrientation == UIInterfaceOrientationLandscapeRight)) {
        [self resizeAllChartViewListInPortrait];
        if (self.currentRunChartView.tag == 4) {// tyly  
            [self populateTylyTableChartView:UIInterfaceOrientationPortrait];
        }
        self.currentRunImageView.bounds = CGRectMake(0.0f, 0.0f, portraitBigViewSize.size.width, portraitBigViewSize.size.height);
        self.currentRunImageView.center = globalPortraitBigViewCenter;
        
        for (int i = 0; i < [self.imageViewList count]; i++) {
            UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];            
            CGRect tmpPosViewSize = [[self.portraitSeqPosList objectAtIndex:i] CGRectValue];
            tmpImageView.center = CGPointMake(portraitSmallViewSize.origin.x + tmpPosViewSize.origin.x + tmpPosViewSize.size.width/2, globalPortraitSmallViewCenter.y);            
        }        
    } else {
        [self resizeAllChartViewListInLandscape];
        if (self.currentRunChartView.tag == 4) {// tyly
            [self populateTylyTableChartView:UIInterfaceOrientationLandscapeLeft];
        }
        self.currentRunImageView.bounds = CGRectMake(0.0f, 0.0f, landscapeBigViewSize.size.width, landscapeBigViewSize.size.height);
        self.currentRunImageView.center = globalLandscapeBigViewCenter;        

        for (int i = 0; i < [self.imageViewList count]; i++) {
            UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
            CGRect tmpPosViewSize = [[self.landscapeSeqPosList objectAtIndex:i] CGRectValue];
            tmpImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, landscapeSmallViewSize.origin.y + tmpPosViewSize.origin.y + tmpPosViewSize.size.height/2);
        }
    }
    [self makeScrollViewScrollable:self.tylyTableScrollView];
//    for (int i = 0; i < [self.imageViewList count]; i++) {
//        UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
//        NSLog(@"imageViewList index frame %@", NSStringFromCGRect(tmpImageView.frame));
//    }    
}

#pragma mark animation begin


#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
//    if ( [plot isKindOfClass:[CPTPieChart class]] ) {
//        return [self.animatedDataManager.monthPieDisplayList count];
//    } else if ([plot isKindOfClass:[CPTScatterPlot class]]) {
//        return [self.animatedDataManager.lineDetailList count];
//    } else if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
//        return [self.animatedDataManager.tylyBarDisplayList count];
//    }
    if ([plot isKindOfClass:[CPTScatterPlot class]]) {
        return [self.animatedDataManager.lineDetailList count];
    }
    if ([(NSString*)plot.identifier isEqualToString:self.animatedDataManager.monthPieIdentifier]) {
        return [self.animatedDataManager.monthPieDisplayList count];
    }
    if ([(NSString*)plot.identifier isEqualToString:self.animatedDataManager.tyBarIdentifier] || [(NSString*)plot.identifier isEqualToString:self.animatedDataManager.lyBarIdentifier]) {
        return [self.animatedDataManager.tylyBarDisplayList count];
    }
	return 0;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber* num = nil;
    if ([plot isKindOfClass:[CPTPieChart class]]) {        
		if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            if ([(NSString*)plot.identifier isEqualToString:@"IdMonthPieChart"]) {
                num = [self.animatedDataManager.monthPieDisplayList objectAtIndex:index];
            }		
        } else {
            return [NSNumber numberWithUnsignedInteger:index];
        }
    } else if ([plot isKindOfClass:[CPTScatterPlot class]]) {        
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX: {                
                num = [[self.animatedDataManager.lineTargetList objectAtIndex:index] objectForKey:@"x"];
            }                
                break;
                
            case CPTScatterPlotFieldY: {
                if ( [(NSString*)plot.identifier isEqualToString:@"Data Source Plot"] ) {
                    num = [[self.animatedDataManager.lineActualList objectAtIndex:index] objectForKey:@"y"];
                } else if ([(NSString*)plot.identifier isEqualToString:@"Target Line"]) {
                    num = [[self.animatedDataManager.lineTargetList objectAtIndex:index] objectForKey:@"y"];
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
                if ([(NSString*)plot.identifier isEqualToString:self.animatedDataManager.tyBarIdentifier]) {
                    NSMutableDictionary* tmpDict = [self.animatedDataManager.tylyBarDisplayList objectAtIndex:index];
                    num = [tmpDict objectForKey:@"TY"];
                }                
                if ([(NSString*)plot.identifier isEqualToString:self.animatedDataManager.lyBarIdentifier]) {
                    NSMutableDictionary* tmpDict = [self.animatedDataManager.tylyBarDisplayList objectAtIndex:index];
                    num = [tmpDict objectForKey:@"LY"];
                }
                if ([(NSString*)plot.identifier isEqualToString:self.animatedDataManager.monthPieIdentifier]) {
                    num = [self.animatedDataManager.monthPieDisplayList objectAtIndex:index];
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
    CPTMutableTextStyle* blackTextStyle = [self.animatedTrManager textStyleWithFontSize:14.0f fontColor:[CPTColor blackColor]];
    if ([plot.identifier isEqual:self.animatedDataManager.monthPieIdentifier]) {
        id tmpLabelObj = [self.animatedDataManager.monthPieLabelDisplayList objectAtIndex:index];
        if ([tmpLabelObj isKindOfClass:[NSNull class]]) {
            return nil;
        }
        return [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n%.0f%%", [self.animatedDataManager.monthPieLegendList objectAtIndex:index], [[self.animatedDataManager.monthPieLabelDisplayList objectAtIndex:index] floatValue]] style:blackTextStyle] autorelease];
    }
    
    return nil;
}

- (void)constructLineChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    [self.animatedTrManager constructLineChart:aGraphHostingView identifier:anIdentifier title:aTitle dataManager:anAnimatedDataManager target:aTarget];
}

- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize {
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color	= [CPTColor whiteColor];
	textStyle.fontSize = aFontSize;
    textStyle.fontName = [UIFont systemFontOfSize:12.0f].fontName;
    return textStyle;
}

- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)aDataManager target:(id)aTarget {
    [self.animatedTrManager constructPieChart:aGraphHostingView identifier:anIdentifier title:aTitle dataManager:aDataManager target:aTarget];
}

- (void)constructTableChart:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    [self.animatedTrManager constructTableChart:aCPTGraphHostingView title:aTitle dataManager:anAnimatedDataManager target:self];
}

- (void)drawInitialTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView {
    [aGraphHostingView bringSubviewToFront:aScrollView];
    aScrollView.hidden = NO;
    aScrollView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
}

- (void)sendSubViewBackTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView {
    [aGraphHostingView sendSubviewToBack:aScrollView];
    aScrollView.hidden = YES;
}

- (void)bringSubViewFrontTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView {
    [aGraphHostingView bringSubviewToFront:aScrollView];
    aScrollView.hidden = NO;
}

- (void)makeScrollViewScrollable:(UIScrollView*)aScrollView {
    aScrollView.contentSize = CGSizeMake(aScrollView.frame.size.width, aScrollView.frame.size.height + 1.0f);
}

- (CPTTheme*)createDefaultTheme {
    return [CPTTheme themeNamed:kCPTDarkGradientTheme];
}

#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{    
    CPTGraph* lineGraph = self.weekLineChartView.hostedGraph;
    
	if ( self.symbolTextAnnotation ) {
		[lineGraph.plotAreaFrame.plotArea removeAnnotation:self.symbolTextAnnotation];
		self.symbolTextAnnotation = nil;
	}
    
	// Setup a style for the annotation
	CPTMutableTextStyle* hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
	hitAnnotationTextStyle.color	= [CPTColor blackColor];
	hitAnnotationTextStyle.fontSize = 14.0f;
    hitAnnotationTextStyle.fontName = [UIFont systemFontOfSize:12.0f].fontName;
    
	// Determine point of symbol in plot coordinates
	NSNumber* x = [[self.animatedDataManager.lineTargetList objectAtIndex:index] valueForKey:@"x"];
//    NSLog(@"plot.identifier is %@", plot.identifier);
	NSNumber* y = [[self.animatedDataManager.lineActualList objectAtIndex:index] valueForKey:@"y"];
    if ([(NSString*)plot.identifier isEqualToString:@"Target Line"]) {
        y = [[self.animatedDataManager.lineTargetList objectAtIndex:index] valueForKey:@"y"];
    }
	NSArray* anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
	// Add annotation
	// First make a string for the y value
    
	NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setMaximumFractionDigits:2];
	NSString* yString = [formatter stringFromNumber:y];
    
	// Now add the annotation to the plot area
	CPTTextLayer* textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
	self.symbolTextAnnotation = [[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:lineGraph.defaultPlotSpace anchorPlotPoint:anchorPoint] autorelease];
	self.symbolTextAnnotation.contentLayer = textLayer;
	self.symbolTextAnnotation.displacement = CGPointMake(0.0f, 12.0f);
	[lineGraph.plotAreaFrame.plotArea addAnnotation:self.symbolTextAnnotation];
}

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    if ([plot.identifier isEqual:self.animatedDataManager.monthPieIdentifier]) return;
    CPTGraph* lineGraph = self.tylyBarChartView.hostedGraph;
    
	if ( self.yearSymbolTextAnnotation ) {
		[lineGraph.plotAreaFrame.plotArea removeAnnotation:self.yearSymbolTextAnnotation];
		self.yearSymbolTextAnnotation = nil;
	}
    
	// Setup a style for the annotation
	CPTMutableTextStyle* hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
	hitAnnotationTextStyle.color	= [CPTColor blackColor];
	hitAnnotationTextStyle.fontSize = 14.0f;
	hitAnnotationTextStyle.fontName = [UIFont systemFontOfSize:12.0].fontName;
    
    
	// Determine point of symbol in plot coordinates
    
	NSNumber* x = [NSNumber numberWithUnsignedInteger:index];
	NSNumber* y = [[self.animatedDataManager.tylyBarDisplayList objectAtIndex:index] objectForKey:@"TY"];
    if ([(NSString*)plot.identifier isEqualToString:@"Bar Plot 2"]) {
        y = [[self.animatedDataManager.tylyBarDisplayList objectAtIndex:index] objectForKey:@"LY"];               
    }
	NSArray* anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    
	// Add annotation
	// First make a string for the y value
    
	NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setMaximumFractionDigits:2];
	NSString* yString = [formatter stringFromNumber:y];
    
    
	// Now add the annotation to the plot area
	CPTTextLayer* textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
	self.yearSymbolTextAnnotation = [[[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:lineGraph.defaultPlotSpace anchorPlotPoint:anchorPoint] autorelease];
	self.yearSymbolTextAnnotation.contentLayer = textLayer;
	self.yearSymbolTextAnnotation.displacement = CGPointMake(30.0f, 12.0f);
    if ([(NSString*)plot.identifier isEqualToString:@"Bar Plot 2"]) {
        self.yearSymbolTextAnnotation.displacement = CGPointMake(46.0f, 12.0f);
    }
	[lineGraph.plotAreaFrame.plotArea addAnnotation:self.yearSymbolTextAnnotation];
}

- (CGPoint)getCenterFromRect:(CGRect)aRect {
    return CGPointMake(aRect.origin.x + aRect.size.width/2, aRect.origin.y + aRect.size.height/2);
}

/**
- (void)resetChartViewListSize {
    for (int i = 0; i < [self.chartViewList count]; i++) {
        CPTGraphHostingViewWithTouchEvent* tmpChartView = [self.chartViewList objectAtIndex:i];
        tmpChartView.bounds = CGRectMake(0.0, 0.0, landscapeFirstViewSize.size.width, landscapeFirstViewSize.size.height);
    }
}
*/
- (void)hideAxis:(CPTGraphHostingViewWithTouchEvent*)aCurrentRunChartView {
    switch (aCurrentRunChartView.tag) {
        case 1: {
            self.weekLineChartView.hostedGraph.axisSet = nil;
            self.weekLineChartView.hostedGraph.title = nil;
            self.weekLineChartView.hostedGraph.legend = nil;
            /**
            CPTGraph* lineGraph = self.weekLineChartView.hostedGraph;            
            if ( self.symbolTextAnnotation ) {
                [lineGraph.plotAreaFrame.plotArea removeAnnotation:self.symbolTextAnnotation];
                self.symbolTextAnnotation = nil;
            }
            */
//            self.weekLineChartView.hidden = YES;
        }            
            break;
        case 2: {
            self.monthPieChartView.hostedGraph.axisSet = nil;
            self.monthPieChartView.hostedGraph.title = nil;
            self.animatedDataManager.monthPieLabelDisplayList = self.animatedDataManager.monthPieNullLabelDisplayList;
//            [self.monthPieChartView.hostedGraph reloadData];
//            self.monthPieChartView.hidden = YES;
        }
            break;
        case 3: {
            self.monthTableChartView.hostedGraph.title = nil;
            self.animatedDataManager.monthTableDisplayList = nil;
            self.animatedDataManager.monthTableFieldNames = nil;
            [self.monthTableView reloadData];
//            self.monthTableChartView.hidden = YES;
        }
            break;
        case 4: {
            self.tylyBarChartView.hostedGraph.axisSet = nil;
            self.tylyBarChartView.hostedGraph.title = nil;
             /**
            CPTGraph* lineGraph = self.tylyBarChartView.hostedGraph;           
            if ( self.yearSymbolTextAnnotation ) {
                [lineGraph.plotAreaFrame.plotArea removeAnnotation:self.yearSymbolTextAnnotation];
                self.yearSymbolTextAnnotation = nil;
            }
             */
//            self.yearBarChartView.hidden = YES;
        }            
            break;            
            
        default:
            break;
    }
}

- (void)showAxis:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView {
    switch (aCPTGraphHostingView.tag) {
        case 1: {
            self.weekLineChartView.hostedGraph.axisSet = self.animatedTrManager.weekLineChartAxisSet;
            self.weekLineChartView.hostedGraph.title = self.animatedTrManager.weekLineChartTitle;
            self.weekLineChartView.hostedGraph.legend = self.animatedTrManager.weekLineChartLegend;
//            self.weekLineChartView.hidden = NO;
        }            
            break;
        case 2: {
            self.monthPieChartView.hostedGraph.axisSet = self.animatedTrManager.monthPieChartAxisSet;
            self.monthPieChartView.hostedGraph.title = self.animatedTrManager.monthPieChartTitle;
            self.animatedDataManager.monthPieLabelDisplayList = self.animatedDataManager.monthPieDisplayList;
//            [self.monthPieChartView.hostedGraph reloadData];
//            self.monthPieChartView.hidden = NO;
        }
            break;
        case 3: {
            self.monthTableChartView.hostedGraph.title = self.animatedTrManager.monthTableChartTitle;
            self.animatedDataManager.monthTableDisplayList = self.animatedDataManager.originalMonthTableDisplayList;
            self.animatedDataManager.monthTableFieldNames = self.animatedDataManager.originalMonthTableFieldNames;
            [self.monthTableView reloadData];
//            self.monthTableChartView.hidden = NO;
        }
            break;
        case 4: {
            self.tylyBarChartView.hostedGraph.axisSet = self.animatedTrManager.yearBarChartAxisSet;
            self.tylyBarChartView.hostedGraph.title = self.animatedTrManager.yearBarChartTitle;
//            self.yearBarChartView.hidden = NO;            
        }            
            break;
            
        default:
            break;
    }
}

/**
- (void)lockChartView:(BOOL)aLockFlag {
    self.weekLineChartView.isLocked = aLockFlag;
    self.monthPieChartView.isLocked = aLockFlag;
    self.monthTableChartView.isLocked = aLockFlag;
    self.yearBarChartView.isLocked = aLockFlag;
    self.tylyBarChartView.isLocked = aLockFlag;
    self.tylyTableChartView.isLocked = aLockFlag;    
}
 */

- (void)drawInitialTylyChartView {
    self.tylyBarChartView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
//    self.tylyTableChartView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
}
- (void)resetTylyChartView:(BOOL)aMiniFlag {
    self.tylyBarChartView.isInMiniMode = aMiniFlag;
    self.tylyTableChartView.isInMiniMode = aMiniFlag;
}

- (void)didResetTylyChartViewSize:(UIInterfaceOrientation)anFromOrientation {
    if (UIInterfaceOrientationIsPortrait(anFromOrientation)) {
        [self didResetTylyChartViewSizeWithRect:landscapeBigViewSize];    
    } else {
        [self didResetTylyChartViewSizeWithRect:portraitBigViewSize];
    }
}

- (void)didResetTylyChartViewSizeWithRect:(CGRect)aRect {
    float tmpTableSizeHeight = aRect.size.height * 1 / 3;
    float tmpBarSizeHeight = aRect.size.height * 2 / 3;
    
    self.tylyTableChartView.bounds = CGRectMake(0.0f, 0.0f, aRect.size.width, tmpTableSizeHeight);
    self.tylyTableChartView.center = CGPointMake(aRect.size.width/2, tmpTableSizeHeight/2);
    self.tylyTableScrollView.bounds = CGRectMake(0.0f, 0.0f, aRect.size.width, tmpTableSizeHeight);
    self.tylyTableScrollView.center = CGPointMake(aRect.size.width/2, tmpTableSizeHeight/2);
    self.tylyBarChartView.bounds = CGRectMake(0.0f, 0.0f, aRect.size.width, tmpBarSizeHeight);
    self.tylyBarChartView.center = CGPointMake(aRect.size.width/2, tmpTableSizeHeight + tmpBarSizeHeight / 2);
}

- (void)drawAllViews {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self constructLineChart:self.weekLineChartView identifier:@"IdWeekLineChart" title:[NSString stringWithFormat:@"Year: %d", [ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:[NSDate date]]]] dataManager:self.animatedDataManager target:self];
    
    [self constructPieChart:self.monthPieChartView identifier:@"IdMonthPieChart" title:[NSString stringWithFormat:@"MAT Sales up to: %@", [self.animatedDataManager.monthMapDict objectForKey:[NSNumber numberWithInteger:[ArcosUtils monthDayWithDate:[NSDate date]]]]] dataManager:self.animatedDataManager target:self];
    
    [self constructTableChart:self.monthTableChartView title:[NSString stringWithFormat:@"Month: %@", [self.animatedDataManager.monthMapDict objectForKey:[NSNumber numberWithInteger:[ArcosUtils monthDayWithDate:[NSDate date]]]]] dataManager:self.animatedDataManager target:self];
    [self bringSubViewFrontTableChart:self.monthTableChartView scrollView:self.monthTableView];
    [self.monthTableView reloadData];
    
    [self constructBarChart:self.tylyBarChartView  identifier:@"IdYearBarChart" title:[NSString stringWithFormat:@"Year: %d", [ArcosUtils convertNSIntegerToInt:[ArcosUtils yearDayWithDate:[NSDate date]]]] dataManager:self.animatedDataManager target:self];    
    
    [self constructTableChart:self.tylyTableChartView title:@"" dataManager:self.animatedDataManager target:self];
               
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.monthPieImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, landscapeSmallViewSize.origin.y + landscapeFirstViewSize.origin.y + landscapeFirstViewSize.size.height/2);
        
        self.monthTableImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, landscapeSmallViewSize.origin.y + landscapeSecondViewSize.origin.y + landscapeSecondViewSize.size.height/2);
        self.yearBarImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, landscapeSmallViewSize.origin.y + landscapeThirdViewSize.origin.y + landscapeThirdViewSize.size.height/2);
        [self populateTylyTableChartView:UIInterfaceOrientationLandscapeLeft];
    } else {        
        self.monthPieImageView.center = CGPointMake(portraitSmallViewSize.origin.x + portraitFirstViewSize.origin.x + portraitFirstViewSize.size.width/2, globalPortraitSmallViewCenter.y);
        self.monthTableImageView.center = CGPointMake(portraitSmallViewSize.origin.x + portraitSecondViewSize.origin.x + portraitSecondViewSize.size.width/2, globalPortraitSmallViewCenter.y);
        self.yearBarImageView.center = CGPointMake(portraitSmallViewSize.origin.x + portraitThirdViewSize.origin.x + portraitThirdViewSize.size.width/2, globalPortraitSmallViewCenter.y);
        [self populateTylyTableChartView:UIInterfaceOrientationPortrait];
    }
            
//    [self drawInitialTableChart:self.tylyTableChartView scrollView:self.tylyTableScrollView];
    [self resetTylyChartView:NO];
    
    self.tylyTableScrollView.hidden = NO;
    [self.tylyTableChartView bringSubviewToFront:self.tylyTableScrollView];
    [self drawInitialTylyChartView];
    [self makeScrollViewScrollable:self.tylyTableScrollView];
    
    self.monthTableView.allowsSelection = NO;
    self.monthTableView.scrollEnabled = YES;
    self.monthTableView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
    [self rightPressed:nil];
    for (int i = 0; i < [self.chartViewList count]; i++) {
        CPTGraphHostingViewWithTouchEvent* tmpChartView = [self.chartViewList objectAtIndex:i];
        tmpChartView.hidden = YES;
    }    
    [self clearChartViewList];
//    [self.monthPieChartView setTransform:globalZoomInCGAffineTransform];        
//    NSLog(@"NSStringFromCGAffineTransform : %@", NSStringFromCGAffineTransform(globalZoomInCGAffineTransform));    
//    [self.monthTableChartView setTransform:globalZoomInCGAffineTransform];    
//    [self.yearBarChartView setTransform:globalZoomInCGAffineTransform]; 
    
    for (int i = 0; i < [self.imageViewList count]; i++) {
        UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
        [tmpImageView setTransform:globalZoomInCGAffineTransform];    
    }
}

- (void)populateTylyTableChartView:(UIInterfaceOrientation)anOrientation {
    [self removeAllSubViews:self.tylyTableScrollView];    
    float labelWidth = 69.0f;
    float labelHeight = 21.0f;
    float sepSpace = 0.0f;
    float beginSpace = 50.0f;
    float verBeginSpace = 20.0f;
    float verSepSpace = 20.0f;
    if (UIInterfaceOrientationIsPortrait(anOrientation)) {
        labelWidth = 56.0f;
    }
    
    int tagNumber = 1;
    for (int i = 0; i < [self.animatedDataManager.tylyTableKeyList count]; i++) {
        CGFloat yOrigin = verBeginSpace + i * labelHeight + i * verSepSpace;
        [self addLabel:self.tylyTableScrollView rect:CGRectMake(10.0f, yOrigin, 40.0f, labelHeight) value:[self.animatedDataManager.tylyTableHeadingList objectAtIndex:i] tag:999 textAlignment:NSTextAlignmentRight color:[UIColor blackColor]];
        for (int j = 0; j < [self.animatedDataManager.tylyBarDisplayList count]; j++) {
            NSMutableDictionary* tmpDict = [self.animatedDataManager.tylyBarDisplayList objectAtIndex:j];
            CGFloat xOrigin = beginSpace + j * labelWidth + sepSpace;
            UIColor* textColor = nil;
            switch (i) {
                case 0: {
                    textColor = [UIColor redColor];
                }                    
                    break;
                case 1: {
                    textColor = [UIColor greenColor];
                }                    
                    break;
                    
                default: {
                    textColor = [UIColor blackColor];
                }
                    break;
            }
            [self addLabel:self.tylyTableScrollView rect:CGRectMake(xOrigin, yOrigin, labelWidth, labelHeight) value:[ArcosUtils convertNumberToIntString:[tmpDict objectForKey:[self.animatedDataManager.tylyTableKeyList objectAtIndex:i]]] tag:tagNumber textAlignment:NSTextAlignmentRight color:textColor];
            tagNumber++;
        }
    }        
}

- (void)removeAllSubViews:(UIView*)aView {
    [self.animatedTrManager removeAllSubViews:aView];
}

- (void)clearAllSubViews:(UIView*)aView {
    [self.animatedTrManager clearAllSubViews:aView];
}

- (void)addLabel:(UIView*)aView rect:(CGRect)aRect value:(NSString*)aValue tag:(int)aTag textAlignment:(NSTextAlignment)anAlignment color:(UIColor*)aColor {
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:aRect];
    headerLabel.textAlignment = anAlignment;
    headerLabel.text = aValue;
    if ([aValue isEqualToString:@"0"]) {
        [headerLabel setHidden:YES];
    }
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setTextColor:aColor];
    [headerLabel setFont:[UIFont systemFontOfSize:14.0f]];
    headerLabel.tag = aTag;
    [aView addSubview:headerLabel];
    [headerLabel release];
}

- (void)setBarGetCustomerDataResult:(ArcosGenericReturnObject*) result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.animatedDataManager processRawData:result];
        [self.callGenericServices genericGetCustomerData:[self.locationIUR intValue] startDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] endDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] type:@"MATQTY" level:6 action:@selector(setTableGetCustomerDataResult:) target:self];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (void)setTableGetCustomerDataResult:(ArcosGenericReturnObject*) result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.animatedDataManager.originalMonthTableDisplayList = result.ArrayOfData;
        self.animatedDataManager.originalMonthTableFieldNames = result.FieldNames;
        self.animatedDataManager.monthTableDisplayList = result.ArrayOfData;
        self.animatedDataManager.monthTableFieldNames = result.FieldNames;
        int pieLevel = 5;
        @try {
            NSNumber* sMSTexting = [self.animatedDataManager.configDict objectForKey:@"SMSTexting"];
            if (sMSTexting != nil) {
                int resultPieLevel = [sMSTexting intValue] / 10;
                if (resultPieLevel > 0 && resultPieLevel < 10) {
                    pieLevel = resultPieLevel;
                }
            }
        }
        @catch(NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
        [self.callGenericServices genericGetCustomerData:[self.locationIUR intValue] startDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] endDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] type:@"MATQTY" level:pieLevel action:@selector(setPieGetCustomerDataResult:) target:self];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (void)setPieGetCustomerDataResult:(ArcosGenericReturnObject*) result {    
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.animatedDataManager processMonthPieRawData:result];
        [self setLineGetCustomerDataResult:nil];
//        [self.callGenericServices genericGetCustomerData:[self.locationIUR intValue] startDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] endDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] type:@"MATQTY" level:5 action:@selector(setLineGetCustomerDataResult:) target:self];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (void)setLineGetCustomerDataResult:(ArcosGenericReturnObject*) result {
    [self.callGenericServices.HUD hide:YES];
    result = [ArcosXMLParser doXMLParse:@"testxmldoc" deserializeTo:[[ArcosGenericReturnObject alloc] autorelease]];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.animatedDataManager processLineRawData:result];
        [self drawAllViews];
    } else if(result.ErrorModel.Code <= 0) {        
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    [self clearAllSubViews:self.monthTableHeaderView];
    if (self.animatedDataManager.monthTableFieldNames != nil) {
        UILabel* detailsLabel = (UILabel*)[self.monthTableHeaderView viewWithTag:2];
        detailsLabel.text = @"Details";
        for (int i = 3; i<= 15; i++) {
            NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
            SEL selector = NSSelectorFromString(fieldMethodName);
            NSString* fieldName = [self.animatedDataManager.monthTableFieldNames performSelector:selector];
            UILabel* headerCellLabel = (UILabel*)[self.monthTableHeaderView viewWithTag:i];
            @try {
                headerCellLabel.text = [fieldName substringToIndex:3];
            }
            @catch (NSException *exception) {
                [ArcosUtils showMsg:-1 message:[NSString stringWithFormat:@"%@%@", [exception name], [exception reason]] delegate:nil];
                break;
            }
        }
        UILabel* totalLabel = (UILabel*)[self.monthTableHeaderView viewWithTag:16];
        totalLabel.text = @"Total";        
    }    
    return self.monthTableHeaderView;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.animatedDataManager.monthTableDisplayList != nil) {
        return [self.animatedDataManager.monthTableDisplayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    NSString *CellIdentifier = @"IdLabelUtilitiesAnimatedMonthTableCell";
    
    UtilitiesAnimatedMonthTableCell *cell=(UtilitiesAnimatedMonthTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesAnimatedMonthTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesAnimatedMonthTableCell class]] && [[(UtilitiesAnimatedMonthTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (UtilitiesAnimatedMonthTableCell *) nibItem;                              
            }
        }
	}    
    // Configure the cell...
    
    ArcosGenericClass* cellData = [self.animatedDataManager.monthTableDisplayList objectAtIndex:indexPath.row];
    cell.orderPadDetails.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field20]]];
    cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
    } else {
        cell.productCode.text = @"";
    }    
//    if ([cell.orderPadDetails.text isEqualToString:@""]) {
//        cell.productCode.text = @"";
//        cell.productSize.text = @"";
//    } else {
//        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
//        cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
//    }
    cell.labelDetails.text = [cellData Field2];
    for (int i = 3; i <= 16; i++) {
        NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(fieldMethodName);
        NSString* fieldValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:(NSString*)[cellData performSelector:selector]]];
        NSString* valueFirstMethodName = [NSString stringWithFormat:@"setText:"];
        NSString* valueSecondMethod = [NSString stringWithFormat:@"label%d", i];
        SEL secondSelector = NSSelectorFromString(valueSecondMethod);
        SEL firstSelector = NSSelectorFromString(valueFirstMethodName); 
        if (![@"" isEqualToString:fieldValue]) {
            NSNumber* tmpFieldValueNumber = [ArcosUtils convertStringToFloatNumber:fieldValue];
            NSString* finalFieldValue = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", (int)roundf([tmpFieldValueNumber floatValue])]];
            [[cell performSelector:secondSelector] performSelector:firstSelector withObject:finalFieldValue];
        } else {
            [[cell performSelector:secondSelector] performSelector:firstSelector withObject:@""];
        }
    }
    return cell;
}

- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView identifier:(NSString*)anIdentifier title:(NSString*)aTitle dataManager:(UtilitiesAnimatedDataManager*)anAnimatedDataManager target:(id)aTarget {
    [self.animatedTrManager constructBarChart:aGraphHostingView identifier:anIdentifier title:aTitle dataManager:anAnimatedDataManager target:aTarget];
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
//    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(constantColorLookupTable[index % 20][0] + (CGFloat)(index / 20) * (CGFloat)0.1) green:(constantColorLookupTable[index % 20][1] + (CGFloat)(index / 20) * (CGFloat)0.1) blue:(constantColorLookupTable[index % 20][2] + (CGFloat)(index / 20) * (CGFloat)0.1) alpha:1.0]];
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(constantColorLookupTable[index % 20][0]) green:(constantColorLookupTable[index % 20][1]) blue:(constantColorLookupTable[index % 20][2]) alpha:1.0]];
}

- (UIImage*)captureSnapshot:(UIView*)aView fileName:(NSString*)aFileName {
    CGRect rect = [aView bounds];     
    CGSize captureSize;    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        NSLog(@"captureSnapshot landscape");
        captureSize = CGSizeMake(126.0f, 102.0f);        
    } else {
//        NSLog(@"captureSnapshot portrait");        
        captureSize = CGSizeMake(112.0f, 117.0f);
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [aView.layer renderInContext:context];
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[[aView subviews] count]] - 1; i >= 0; i--) {
        UIView* subView = [[aView subviews] objectAtIndex:i];      
        if (subView.tag == 5) {
            continue;
        } else {            
            [[subView layer] renderInContext:context];                
        }       
    }     
    
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* resizedCapturedImage = [capturedImage thumbnailWithSize:captureSize];
    UIGraphicsEndImageContext();
       
//    NSString* imagePngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png",aFileName]];
//    [UIImagePNGRepresentation(resizedCapturedImage) writeToFile:imagePngPath atomically:YES];
    return resizedCapturedImage;
}

-(void)rightPressed:(id)sender {
    self.weekLineImageView.image = [self captureSnapshot:self.weekLineChartView fileName:@"weekLineImage"];
    self.monthPieImageView.image = [self captureSnapshot:self.monthPieChartView fileName:@"monthPieImage"];
    self.monthTableImageView.image = [self captureSnapshot:self.monthTableChartView fileName:@"monthTableImage"];    
    self.yearBarImageView.image = [self captureSnapshot:self.yearBarChartView fileName:@"yearBarImage"];
    NSLog(@"capture done.");
}

- (void)clearChartViewList {
    for (int i = 0; i < [self.chartViewList count]; i++) {
        CPTGraphHostingViewWithTouchEvent* tmpChartView = [self.chartViewList objectAtIndex:i];
        [self hideAxis:tmpChartView];
    }
    [self removeAllSubViews:self.tylyTableScrollView];
}

#pragma animation action
- (void)animatePieImageTap {
    self.title = self.monthPieNavTitle;
    [self animateImageView:self.monthPieImageView chartView:self.monthPieChartView];
}
- (void)animateTableImageTap {
    self.title = self.monthTableNavTitle;
    [self animateImageView:self.monthTableImageView chartView:self.monthTableChartView];
}
- (void)animateBarImageTap {
    self.title = self.yearBarNavTitle;
    [self animateImageView:self.yearBarImageView chartView:self.yearBarChartView];
}
- (void)animateLineImageTap {
    self.title = self.weekLineNavTitle;
    [self animateImageView:self.weekLineImageView chartView:self.weekLineChartView];
}

- (void)animateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent *)aCPTGraphHostingView{
    if (!anImageView.isInMiniMode || anImageView.isLocked) {
        return;
    }
    [self lockImageView:YES];
    [self captureSnapshot:self.currentRunChartView];
    int positionOfChartView = 0;
    int posistionToInsert = 0;
    float tmpCenterDiff = 0.0f;
    for (int i = 0; i < [self.imageViewList count]; i++) {
        if (anImageView == [self.imageViewList objectAtIndex:i]) {
            positionOfChartView = i;
            break;
        }
    }
    
    switch (positionOfChartView) {
        case 2: {
            tmpCenterDiff = centerDiff;
            posistionToInsert = 0;
        }            
            break;
        case 1: {
            tmpCenterDiff = centerDiff;
            posistionToInsert = 1;
        }            
            break;
        case 0: {
            tmpCenterDiff = -centerDiff;
            posistionToInsert = 2;
        }            
            break;
            
        default:
            break;
    }    
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        [self landscapeAnimateImageView:anImageView chartView:aCPTGraphHostingView positionOfChartView:positionOfChartView positionInsertIndex:posistionToInsert centerDiff:tmpCenterDiff];
    } else {        
        [self portraitAnimateImageView:anImageView chartView:aCPTGraphHostingView positionOfChartView:positionOfChartView positionInsertIndex:posistionToInsert centerDiff:tmpCenterDiff];
    }
}

- (void)landscapeAnimateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView positionOfChartView:(int)aPositionOfChartView positionInsertIndex:(int)aPositionInsertIndex centerDiff:(float)aCenterDiff {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {//first level
        self.previousRunChartView = self.currentRunChartView;
        CGRect positionViewSize = [[self.landscapeSeqPosList objectAtIndex:aPositionInsertIndex] CGRectValue];
        self.currentRunChartView.hidden = YES;
        [self hideAxis:self.currentRunChartView];
        
        self.previousRunImageView = self.currentRunImageView;
        self.currentRunImageView.hidden = NO;
        self.currentRunImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, landscapeSmallViewSize.origin.y + positionViewSize.origin.y + positionViewSize.size.height/2);
        [self.currentRunImageView setTransform:globalZoomInCGAffineTransform];
        
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^ {//second level
            [anImageView setTransform:globalZoomOutCGAffineTransform];            
            anImageView.bounds = CGRectMake(0.0f, 0.0f, landscapeBigViewSize.size.width, landscapeBigViewSize.size.height);
            anImageView.center = globalLandscapeBigViewCenter;
            anImageView.alpha = 0.3;
            if (aPositionOfChartView == middleIndex) {
                UIImageView* firstTmpImageView = [self.imageViewList objectAtIndex:0];
                firstTmpImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, firstTmpImageView.center.y + aCenterDiff * 2);
                UIImageView* lastTmpImageView = [self.imageViewList lastObject];
                lastTmpImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, firstTmpImageView.center.y - aCenterDiff * 2);
                [self.imageViewList exchangeObjectAtIndex:0 withObjectAtIndex:[self.imageViewList count] - 1];
                return;
            }
            for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.imageViewList count]] - 1; i >= 0; i--) {
                if (i == aPositionOfChartView) continue;
                UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
                tmpImageView.center = CGPointMake(globalLandscapeSmallViewCenter.x, tmpImageView.center.y + aCenterDiff);
            }
        } completion:^ (BOOL finished) {//second level finished            
            [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ { //2.1 level
                if (aCPTGraphHostingView.tag == 4) {//bar
                    [self populateTylyTableChartView:UIInterfaceOrientationLandscapeLeft];                    
                }                
                [self showAxis:aCPTGraphHostingView];
                aCPTGraphHostingView.hidden = NO;
                anImageView.hidden = YES;
                anImageView.alpha = 1.0;
                self.currentRunImageView.isInMiniMode = YES;
                anImageView.isInMiniMode = NO;
                self.currentRunChartView = aCPTGraphHostingView;
                self.currentRunImageView = anImageView;
            } completion:^ (BOOL finished) {//2.1 finished
                [self.imageViewList removeObjectAtIndex:aPositionOfChartView];
                [self.imageViewList insertObject:self.previousRunImageView atIndex:aPositionInsertIndex];
                [self lockImageView:NO];
            }];
        }];        
    } completion:^(BOOL finished) {//first level finished        
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
            self.previousRunImageView.alpha = 1.0;
            //--Personalization            
            if (self.previousRunChartView.tag == 4) {
                [self removeAllSubViews:self.tylyTableScrollView];
            }            
        } completion:nil];
    }];
}

- (void)portraitAnimateImageView:(UIImageViewWithControlFlag*)anImageView chartView:(CPTGraphHostingViewWithTouchEvent*)aCPTGraphHostingView positionOfChartView:(int)aPositionOfChartView positionInsertIndex:(int)aPositionInsertIndex centerDiff:(float)aCenterDiff {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {//first level
        self.previousRunChartView = self.currentRunChartView;
        CGRect positionViewSize = [[self.portraitSeqPosList objectAtIndex:aPositionInsertIndex] CGRectValue];
        self.currentRunChartView.hidden = YES;
        [self hideAxis:self.currentRunChartView];
        
        self.previousRunImageView = self.currentRunImageView;
        self.currentRunImageView.hidden = NO;
        self.currentRunImageView.center = CGPointMake(portraitSmallViewSize.origin.x + positionViewSize.origin.x + positionViewSize.size.width/2, globalPortraitSmallViewCenter.y); 
        [self.currentRunImageView setTransform:globalZoomInCGAffineTransform];
        
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^ {//second level
            [anImageView setTransform:globalZoomOutCGAffineTransform];            
            anImageView.bounds = CGRectMake(0.0f, 0.0f, portraitBigViewSize.size.width, portraitBigViewSize.size.height);
            anImageView.center = globalPortraitBigViewCenter;
            anImageView.alpha = 0.3;
            if (aPositionOfChartView == middleIndex) {
                UIImageView* firstTmpImageView = [self.imageViewList objectAtIndex:0];
                firstTmpImageView.center = CGPointMake(firstTmpImageView.center.x + aCenterDiff * 2, globalPortraitSmallViewCenter.y);
                UIImageView* lastTmpImageView = [self.imageViewList lastObject];
                lastTmpImageView.center = CGPointMake(firstTmpImageView.center.x - aCenterDiff * 2, globalPortraitSmallViewCenter.y);
                [self.imageViewList exchangeObjectAtIndex:0 withObjectAtIndex:[self.imageViewList count] - 1];                                
                return;
            }
            for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.imageViewList count]] - 1; i >= 0; i--) {
                if (i == aPositionOfChartView) continue;
                UIImageView* tmpImageView = [self.imageViewList objectAtIndex:i];
                tmpImageView.center = CGPointMake(tmpImageView.center.x + aCenterDiff, globalPortraitSmallViewCenter.y);
            }
        } completion:^ (BOOL finished) {//second level finished            
            [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ { //2.1 level
                if (aCPTGraphHostingView.tag == 4) {//bar
                    [self populateTylyTableChartView:UIInterfaceOrientationPortrait];                    
                }
                [self showAxis:aCPTGraphHostingView];
                aCPTGraphHostingView.hidden = NO;
                anImageView.hidden = YES;
                anImageView.alpha = 1.0;
                self.currentRunImageView.isInMiniMode = YES;
                anImageView.isInMiniMode = NO;
                self.currentRunChartView = aCPTGraphHostingView;
                self.currentRunImageView = anImageView;
            } completion:^ (BOOL finished) {//2.1 finished
                [self.imageViewList removeObjectAtIndex:aPositionOfChartView];
                [self.imageViewList insertObject:self.previousRunImageView atIndex:aPositionInsertIndex];
                [self lockImageView:NO];
            }];
        }];        
    } completion:^(BOOL finished) {//first level finished        
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
            self.previousRunImageView.alpha = 1.0;
            //--Personalization            
            if (self.previousRunChartView.tag == 4) {
                [self removeAllSubViews:self.tylyTableScrollView];
            }            
        } completion:nil];
    }];
}

- (void)captureSnapshot:(UIView*)aView {
    switch (aView.tag) {
        case 1: {
            if (self.weekLineImageView.image != nil) { self.weekLineImageView.image = nil; }            
            self.weekLineImageView.image = [self captureSnapshot:self.weekLineChartView fileName:@"weekLineImage"];
        }
            break;
        case 2: {
            if (self.monthPieImageView.image != nil) { self.monthPieImageView.image = nil; }            
            self.monthPieImageView.image = [self captureSnapshot:self.monthPieChartView fileName:@"monthPieImage"];
        }
            break;
        case 3: {
            if (self.monthTableImageView.image != nil) { self.monthTableImageView.image = nil; }            
            self.monthTableImageView.image = [self captureSnapshot:self.monthTableChartView fileName:@"monthTableImage"];
        }
            break;
        case 4: {
            if (self.yearBarImageView.image != nil) { self.yearBarImageView.image = nil; }            
            self.yearBarImageView.image = [self captureSnapshot:self.yearBarChartView fileName:@"yearBarImage"];
        }
            break;
            
        default:
            break;
    }
}

- (void)lockImageView:(BOOL)aLockFlag {
    self.weekLineImageView.isLocked = aLockFlag;
    self.monthPieImageView.isLocked = aLockFlag;
    self.monthTableImageView.isLocked = aLockFlag;
    self.yearBarImageView.isLocked = aLockFlag;    
}

- (void)resizeAllChartViewListInLandscape {
    for (int i = 0; i < [self.allChartViewList count]; i++) {
        CPTGraphHostingViewWithTouchEvent* hostingView = [self.allChartViewList objectAtIndex:i];
        hostingView.bounds = CGRectMake(0.0f, 0.0f, landscapeBigViewSize.size.width, landscapeBigViewSize.size.height);
        hostingView.center = globalLandscapeBigViewCenter;
    }
    
    [self didResetTylyChartViewSizeWithRect:landscapeBigViewSize];
}
- (void)resizeAllChartViewListInPortrait {
    for (int i = 0; i < [self.allChartViewList count]; i++) {
        CPTGraphHostingViewWithTouchEvent* hostingView = [self.allChartViewList objectAtIndex:i];
        hostingView.bounds = CGRectMake(0.0f, 0.0f, portraitBigViewSize.size.width, portraitBigViewSize.size.height);
        hostingView.center = globalPortraitBigViewCenter;
    }
    [self didResetTylyChartViewSizeWithRect:portraitBigViewSize];
}

- (void)clearAllSnapshot {
    if (self.weekLineImageView.image != nil) { self.weekLineImageView.image = nil; }
    if (self.monthPieImageView.image != nil) { self.monthPieImageView.image = nil; }
    if (self.monthTableImageView.image != nil) { self.monthTableImageView.image = nil; }
    if (self.yearBarImageView.image != nil) { self.yearBarImageView.image = nil; }
    if (self.currentRunImageView.image != nil) { self.currentRunImageView.image = nil; }
    if (self.previousRunImageView.image != nil) { self.previousRunImageView.image = nil; }
        
    /*
    if (self.monthTableHeaderView != nil) { self.monthTableHeaderView = nil; }
    if (self.monthTableView != nil) { self.monthTableView = nil; }    
    if (self.monthTableChartView != nil) { self.monthTableChartView = nil; }
    if (self.monthPieChartView != nil) { self.monthPieChartView = nil; }
    if (self.tylyTableScrollView != nil) { self.tylyTableScrollView = nil;}
    if (self.tylyTableChartView != nil) { self.tylyTableChartView = nil; }
    if (self.tylyBarChartView != nil) { self.tylyBarChartView = nil; }
    if (self.yearBarChartView != nil) { self.yearBarChartView = nil; }
    if (self.weekLineChartView != nil) { self.weekLineChartView = nil; }
    if (self.currentRunChartView != nil) { self.currentRunChartView = nil; }
    if (self.previousRunChartView != nil) { self.previousRunChartView = nil; }
    */
}

@end
