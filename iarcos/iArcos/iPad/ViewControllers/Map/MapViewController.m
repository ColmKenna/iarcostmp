//
//  MapViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "MapViewController.h"
#import "ArcosCoreData.h"
#import "WebServiceSharedClass.h"
#import "UpdateCenter.h"

@interface MapViewController (Private)
    
-(void)dropOrderPins;
-(void)stampLocation;
@end

@implementation MapViewController
@synthesize myMapView;
@synthesize annotationPopoverController;
@synthesize locTrackString;
@synthesize annotations;
@synthesize orders;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize indicator;
@synthesize orderEndDate;
@synthesize orderStartDate;
@synthesize stockistPopoverController = _stockistPopoverController;
@synthesize stockistParentTableViewController = _stockistParentTableViewController;
@synthesize CLController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [self.myMapView.userLocation removeObserver:self forKeyPath:@"location"];
    [self.myMapView removeFromSuperview]; // release crashes app
    [myCustomerInfoViewController release];
    [annotationPopoverController release];
    [currentPopoverView release];
    [annotations release];
    
    [locTrackString release];
    self.myMapView = nil;
    
    [connectivityCheck release];
    [callGenericServices release];
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; } 
    if (self.rootView != nil) { self.rootView = nil; }
    [arcosCustomiseAnimation release];
    [orders release];
    self.orders=nil;
//    [arcosCustomiseAnimation release];
    [datePickerPopover release];
    [orderStartDate release];
    [orderEndDate release];
    if (self.stockistPopoverController != nil) { self.stockistPopoverController = nil; }
    if (self.stockistParentTableViewController != nil) { self.stockistParentTableViewController = nil; }
    self.CLController = nil;
    
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
    isMyLocationCentered=NO;
    annotations=[[NSMutableArray alloc]init];
    //for testing
    locTrackString=[[NSString alloc]initWithString:@""];
    
    //title view buttons
    NSArray *statusItems = [NSArray arrayWithObjects:@"Clear Pins",@"Orders",nil];
    UISegmentedControl* segmentBut = [[[UISegmentedControl alloc] initWithItems:statusItems]autorelease];

	[segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentBut.frame = CGRectMake(0, 0, 200, 30);
//	segmentBut.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentBut.momentary = YES;
	
	self.navigationItem.titleView = segmentBut;
    
    // Do any additional setup after loading the view from its nib.
    myMapView.showsUserLocation = YES;
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Type"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(changeMapType:)];

    self.navigationItem.leftBarButtonItem = typeButton;
    [typeButton release];
    
    //add Gesture Recognizer
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for 2 seconds
    [self.myMapView addGestureRecognizer:lpgr];
    [lpgr release];
    
    UIGestureRecognizer *mpgr = [[UIPanGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleMapMove:)];
    
    [self.myMapView addGestureRecognizer:mpgr];
    [mpgr release];
    
    //UILongPressGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMapTap:)];
    
    //[self.myMapView addGestureRecognizer:tpgr];
    //[tpgr release];
    
    
    [self.myMapView.userLocation addObserver:self  
                                forKeyPath:@"location"  
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
                                   context:NULL];
    
    //set the default location 53.344123,-6.276112
    CLLocationCoordinate2D coord = {.latitude =  53.344123, .longitude =  -6.276112};
    MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
    MKCoordinateRegion region = {coord, span};
    [self.myMapView setRegion:region];

    //set the popover view
    currentPopoverView= [[MapPopoverViewController alloc] init];
    currentPopoverView.delegate=self;
    
    annotationPopoverController=[[UIPopoverController alloc]initWithContentViewController:currentPopoverView];

    
    //init a connectivity check
    connectivityCheck = [[ConnectivityCheck alloc]init];
    connectivityCheck.delegate=self;
    //set the notification
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    
    //initialize order dates
    self.orderEndDate=[NSDate date]; 
    self.orderStartDate=[NSDate date];
    
    //animation
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    self.rootView=self.parentViewController.parentViewController;
    
    //generic service
    //UIDeviceOrientation orien=[[UIDevice currentDevice] orientation];
    
    //determent the view frame by orientation
    //if (UIDeviceOrientationIsLandscape(orien)) {
        self.view.frame=CGRectMake(0, 0, 1024 , 748);
    //}else{
        //self.view.frame=CGRectMake(0, 0, 748, 1024);
    //}
    /*
    callGenericServices = [[CallGenericServices alloc] initWithView:self.view];
    callGenericServices.delegate = self;
    */
    self.CLController = [[[CoreLocationController alloc] init] autorelease];
    self.CLController.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self stampLocation];
    if (callGenericServices == nil) {
        callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
        callGenericServices.delegate = self;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
	return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //dissmiss the popover when rotation begin
    [annotationPopoverController dismissPopoverAnimated:NO];
    if (self.stockistPopoverController != nil && [self.stockistPopoverController isPopoverVisible]) {
        [self.stockistPopoverController dismissPopoverAnimated:YES];
    }    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //repositioning the popover when rotation finished
//    if (annotationPopoverController!=nil&&currentPopoverView!=nil&&popoverAnnotationView!=nil) {
//        if (annotationPopoverController.popoverVisible) {
//            [annotationPopoverController presentPopoverFromRect:popoverAnnotationView.bounds inView:popoverAnnotationView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        }
//
//    }
    [self dissmissThePopoverView];
}


#pragma mark - Map delegate
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views { 
    MKAnnotationView *aV; 
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
        if (![aV.annotation isKindOfClass:[AddressAnnotation class]]) {
            aV.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    AddressAnnotation* tempAnno=view.annotation;
    CLLocationCoordinate2D aLocation=tempAnno.coordinate;
    NSLog(@"Pin drag to %f %f",aLocation.latitude,aLocation.longitude);
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{  
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"myAnno"];
    if(!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnno"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[(UIButton *)annotationView.rightCalloutAccessoryView addTarget:self action:@selector(openSpot:) forControlEvents:UIControlEventTouchUpInside];
        
        //annotationView.draggable=YES;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(7,-15);
        annotationView.calloutOffset = CGPointMake(-8,0);
        
        //only drop pin is draggable
        AddressAnnotation* anno=(AddressAnnotation*)annotation;
        if (anno.type==TouchDropAddressAnnotation) {
            annotationView.draggable=YES;
        }
    }
    
    // Setup annotation pin color depend on the annotation type
    if ([annotation isKindOfClass:[AddressAnnotation class]]) {
        
        AddressAnnotation* anno=(AddressAnnotation*)annotation;
        if (anno.type==CustomerAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinPurple.png"];
            
        }
        if (anno.type==TouchDropAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinRed.png"];
        }
        if (anno.type==OrderAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinGreen.png"];
        }
        if (anno.type==CallAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinOrange.png"];
        }
        if (anno.type==OtherAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinGray.png"];
        }
        if (anno.type == StockistAddressAnnotation) {
            annotationView.image = [UIImage imageNamed:@"pinYellow.png"];
        }
    }


    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
        
    [mapView deselectAnnotation:view.annotation animated:YES];
    currentPopoverView.annotaion=view.annotation;
    
    
    
    //NSArray *passThroughViews=[NSArray arrayWithObject:self.myMapView];
    //poc.passthroughViews=passThroughViews;
    //hold ref to popover in an ivar
    popoverAnnotationView=view;
    
    //set size depend on annotation type
    if ([view.annotation isKindOfClass:[AddressAnnotation class]]) {
       AddressAnnotation* anno=(AddressAnnotation*)view.annotation;
        if (anno.type!=TouchDropAddressAnnotation) {
            annotationPopoverController.popoverContentSize = CGSizeMake(170, 274);
        }else{
            annotationPopoverController.popoverContentSize = CGSizeMake(170, 224);//180
        }
    }else{
       annotationPopoverController.popoverContentSize = CGSizeMake(170, 164);//120
    }
    
    
    //show the popover next to the annotation view (pin)
    [annotationPopoverController presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                                     
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //NSLog(@"map move");
}

#pragma mark - Other delegate
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMapView];   
    CLLocationCoordinate2D touchMapCoordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];
//    NSLog(@"touchMapCoordinate: %f, %f", touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    NSMutableDictionary* aLocation=[NSMutableDictionary dictionary];
    [aLocation setObject:[NSNumber numberWithFloat:touchMapCoordinate.latitude] forKey:@"Latitude"];
    [aLocation setObject:[NSNumber numberWithFloat:touchMapCoordinate.longitude] forKey:@"Longitude"];
    [aLocation setObject:@"dropped pin" forKey:@"Name"];

        
    [self addAnnotationToLocation:touchMapCoordinate withLocation:aLocation withAnnoType:TouchDropAddressAnnotation withObject:nil];
}
-(void)handleMapMove:(UIGestureRecognizer*)gestureRecognizer{
    NSLog(@"map is moving");
    
    if (annotationPopoverController!=nil) {
        [annotationPopoverController presentPopoverFromRect:popoverAnnotationView.bounds inView:popoverAnnotationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
        
    }
    
}
//map popover delegate
-(void)handleMapTap:(UIGestureRecognizer*)gestureRecognizer{
    
    NSLog(@"map is tapping");
    //[self dissmissThePopoverView];
}
- (void)searchRadius:(NSInteger)radius AroundMe:(AddressAnnotation*)anno{
//    NSLog(@"around me touched in delegate with radius %d",radius);
    [self findLocationsAroundAnnotation:anno withRadius:radius];
    //show all locations 
    //[self findLocationsAroundAnnotation:anno withRadius:10000000];
}
-(void)detailTouched:(AddressAnnotation*)anno{
    if (anno.type==CustomerAddressAnnotation || anno.type==StockistAddressAnnotation) {//push the customer detail view        
        CustomerInfoTableViewController* tmpCustomerInfoTableViewController
        = [[CustomerInfoTableViewController alloc] initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
        tmpCustomerInfoTableViewController.title = @"Customer Information Page";
        tmpCustomerInfoTableViewController.custIUR = [anno.location objectForKey:@"LocationIUR"];
//        [tmpCustomerInfoTableViewController resetContentWithDict: anno.location];
        [self.navigationController pushViewController:tmpCustomerInfoTableViewController animated:YES];
        [tmpCustomerInfoTableViewController release];
    }else if(anno.type==OrderAddressAnnotation){//push the order detail
        NSLog(@"handleSingleTapGesture");
        NSString* orderDetailsNibName = @"CustomerOrderDetailsModalViewController";
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            orderDetailsNibName = @"CustomerOrderDetailsGoodsVatModalViewController";
        }
        CustomerOrderDetailsModalViewController* codmvc=[[CustomerOrderDetailsModalViewController alloc]initWithNibName:orderDetailsNibName bundle:nil];
        codmvc.title = @"ORDER DETAILS";    
        codmvc.animateDelegate=self;
        if (anno.anObject!=nil) {
            codmvc.orderIUR = (NSString*) anno.anObject;
        }
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:codmvc] autorelease];
        [codmvc release];
        
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        
    }else if(anno.type==CallAddressAnnotation){
        CustomerCallDetailViewController* ccdmvc=[[CustomerCallDetailViewController alloc]initWithNibName:@"CustomerCallDetailViewController" bundle:nil];
        ccdmvc.title = @"CALL DETAILS";
        ccdmvc.animateDelegate=self;
        if (anno.anObject!=nil) {
            ccdmvc.IUR = (NSString*) anno.anObject;
        }
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccdmvc] autorelease];
        [ccdmvc release];
        
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    }
    
    [self dissmissThePopoverView];
}
-(void)removePin:(AddressAnnotation *)anno{
    [self removePinOnMap:anno];
    
}
- (void)stockistPressed:(AddressAnnotation*)anno {
    self.stockistParentTableViewController = [[[StockistParentTableViewController alloc] initWithNibName:@"StockistParentTableViewController" bundle:nil] autorelease];
    self.stockistParentTableViewController.childDelegate = self;
    UINavigationController* stockistNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.stockistParentTableViewController] autorelease];
    
    self.stockistPopoverController = [[[UIPopoverController alloc] initWithContentViewController:stockistNavigationController] autorelease];
    [self.stockistPopoverController presentPopoverFromRect:popoverAnnotationView.bounds inView:popoverAnnotationView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark StockistChildTableViewDelegate
- (void)didSelectStockistChildWithCellData:(NSDictionary *)aCellData {
    [self.stockistPopoverController dismissPopoverAnimated:YES];
    [annotationPopoverController dismissPopoverAnimated:YES];
    int level = 0;
    NSString* descrTypeCode = [aCellData objectForKey:@"DescrTypeCode"];
    NSString* descrDetailCode = [aCellData objectForKey:@"DescrDetailCode"];
    if ([descrTypeCode length] == 2) {
        NSString* lastChar = [descrTypeCode substringFromIndex:1];
        NSNumber* lastCharNumber = [ArcosUtils convertStringToNumber:lastChar];
        level = [lastCharNumber intValue];
    }
    int employeeIUR = [[SettingManager employeeIUR] intValue];
    //[ArcosUtils dateFromString:@"30/04/2012" format:[GlobalSharedClass shared].dateFormat]
    [callGenericServices genericGetStockistWithEmployeeiur:employeeIUR longtitude:currentPopoverView.annotaion.coordinate.longitude latitude:currentPopoverView.annotaion.coordinate.latitude distance:currentPopoverView.radiusSlider.value areacode:@"" areaiur:0 level:level levelcode:descrDetailCode AsOfDate:[NSDate date] action:@selector(setGetStockistDataResult:) target:self];
}

- (void)setGetStockistDataResult:(ArcosGenericReturnObject*)result {
    result = [callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code < 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    } else if(result.ErrorModel.Code == 0) {
        [ArcosUtils showMsg:@"No data available" delegate:nil];
    } else if(result.ErrorModel.Code > 0) {
        NSMutableArray* dataList = result.ArrayOfData;
        for (int i = 0; i < [dataList count]; i++) {
            ArcosGenericClass* arcosGenericClass = [dataList objectAtIndex:i];
            NSString* latitude = [ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[ArcosUtils trim:[arcosGenericClass Field6]]]];
            NSString* longitude = [ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[ArcosUtils trim:[arcosGenericClass Field5]]]];
            NSNumber* latitudeNumber = [ArcosUtils convertStringToFloatNumber:latitude];
            NSNumber* longitudeNumber = [ArcosUtils convertStringToFloatNumber:longitude];
//            NSLog(@"server:%@ %f %f", [arcosGenericClass Field3],[latitudeNumber floatValue], [longitudeNumber floatValue]);
            CLLocationCoordinate2D theLocation=CLLocationCoordinate2DMake([latitudeNumber floatValue], [longitudeNumber floatValue]);
            NSMutableDictionary* aLocation=[NSMutableDictionary dictionary];
            [aLocation setObject:latitudeNumber forKey:@"Latitude"];
            [aLocation setObject:longitudeNumber forKey:@"Longitude"];
            [aLocation setObject:[NSString stringWithFormat:@"%@", [ArcosUtils convertNilToEmpty:[arcosGenericClass Field2]]] forKey:@"Name"];
            [aLocation setObject:[NSString stringWithFormat:@"%@", [ArcosUtils convertNilToEmpty:[arcosGenericClass Field3]]] forKey:@"Address1"];
            [aLocation setObject:[ArcosUtils convertStringToNumber:[NSString stringWithFormat:@"%@", [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[arcosGenericClass Field1]]]]] forKey:@"LocationIUR"];
            [self addAnnotationToLocation:theLocation withLocation:aLocation withAnnoType:StockistAddressAnnotation withObject:nil];
        }
    }
} 

#pragma mark - Addtional functions
- (void) changeMapType: (id)sender
{
    if (myMapView.mapType == MKMapTypeStandard)
        myMapView.mapType = MKMapTypeSatellite;
    else
        myMapView.mapType = MKMapTypeStandard;
} 
//segment buttons action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self clearPins];
            break;
        case 1:
        {
            //chcek security level
            NSNumber* employeeIUR= [SettingManager employeeIUR];
            NSDictionary* employee=[[ArcosCoreData sharedArcosCoreData]employeeWithIUR:employeeIUR];
            if (employee==nil) {
                break;
            }else{
                NSNumber* securityLevel=[employee objectForKey:@"SecurityLevel"];
                NSLog(@"security level is %d",[securityLevel intValue]);
                if ([securityLevel intValue]<95) {
                    break;
                }
            }
            
            
            [self dissmissThePopoverView];
            if (datePickerPopover==nil) {
                OrderDateRangePicker* ODRP=[[OrderDateRangePicker alloc]initWithNibName:@"OrderDateRangePicker" bundle:nil];
                ODRP.delegate=self;
                datePickerPopover=[[UIPopoverController alloc]initWithContentViewController:ODRP];
                [ODRP release];
                datePickerPopover.popoverContentSize=CGSizeMake(328, 500);
                [datePickerPopover presentPopoverFromRect:segment.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }else{
                [datePickerPopover presentPopoverFromRect:segment.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
            [self orderOption];
            
        }
            break;
            
        default:
            break;
    }
//    NSLog(@"segment %d touched!!",segment.selectedSegmentIndex);

}
-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
    
    if ([self.myMapView isUserLocationVisible]&&!isMyLocationCentered) {  
        [self centerUserLocation];
        isMyLocationCentered=YES;
        // and of course you can use here old and new location values
    }
}
-(void)centerUserLocation{
    
    MKCoordinateRegion region;
    region.center = self.myMapView.userLocation.coordinate;  
    
    MKCoordinateSpan span; 
    span.latitudeDelta  = 1; // Change these values to change the zoom
    span.longitudeDelta = 1; 
    region.span = span;
    
    [self.myMapView setRegion:region animated:YES];
    
}
-(void)addAnnotationToLocation:(CLLocationCoordinate2D)coord withLocation:(NSMutableDictionary*)aLocation withAnnoType:(AddressAnnotationType)type withObject:(NSObject*)anObject{
//    NSLog(@"aLocation: %@", aLocation);
    //NSLog(@"pin add to the location lat:%f  lon:%f",aLocation.latitude,aLocation.longitude);
    AddressAnnotation *annot =[[AddressAnnotation alloc]initWithCoordinate:coord withLocation:aLocation withType:type];
    annot.anObject=anObject;
    
    [annotations addObject:annot];
    
    [self.myMapView addAnnotation:annot];
    [annot release];
    
}
-(void)removePinOnMap:(AddressAnnotation*)anno{
    [myMapView removeAnnotation:anno];
    [annotations removeObject:anno];
    [annotationPopoverController dismissPopoverAnimated:YES];
}
-(void)clearPins{
    for (AddressAnnotation* anno in self.annotations) {
        [myMapView removeAnnotation:anno];
    }
    [annotations removeAllObjects];
}
-(void)orderOption{

    
}
-(void)dissmissThePopoverView{
    if (currentPopoverView!=nil) {
        [annotationPopoverController dismissPopoverAnimated:NO];
        [datePickerPopover dismissPopoverAnimated:NO];
        //[currentPopoverView release];
    }
}
-(void)findLocationsAroundAnnotation:(AddressAnnotation*)anno withRadius:(NSInteger)radius{
    
    NSLog(@"reference location is %f---%f",anno.coordinate.latitude,anno.coordinate.longitude);
    
    //CLRegion* region=[[CLRegion alloc]initCircularRegionWithCenter:anno.coordinate radius:radius identifier:@""];
    
    
//    for (LocationCommon* aLocation in locations) {
//        CLLocationCoordinate2D custCoordinate;
//        custCoordinate.latitude=[aLocation.Latitude floatValue];
//        custCoordinate.longitude=[aLocation.Longitude floatValue];
//        
//        NSLog(@"customer location is %f---%f",custCoordinate.latitude,custCoordinate.longitude);
//        
//        if ([region containsCoordinate:custCoordinate]) {
//            [self addAnnotationToLocation:custCoordinate withLocation:aLocation withAnnoType:CustomerAddressAnnotation];
//        }
//    }
    CGRect aRect=[[GlobalSharedClass shared]boundRectFromStartPoint:anno.coordinate withDistance:radius];
    NSMutableArray* locationsAroundPoint=[[ArcosCoreData sharedArcosCoreData]locationFromGeoBoundBox:aRect];
    
    for (NSMutableDictionary* aLocation in locationsAroundPoint) {
        CLLocationCoordinate2D theLocation=CLLocationCoordinate2DMake([[aLocation objectForKey:@"Latitude"]floatValue], [[aLocation objectForKey:@"Longitude"]floatValue]);
        
        [self addAnnotationToLocation:theLocation withLocation:aLocation withAnnoType:CustomerAddressAnnotation withObject:nil];
    }
    
//    CLLocationCoordinate2D a=CLLocationCoordinate2DMake(aRect.origin.x, aRect.origin.y);
//    CLLocationCoordinate2D b=CLLocationCoordinate2DMake(aRect.origin.x, aRect.origin.y+aRect.size.width);
//    CLLocationCoordinate2D c=CLLocationCoordinate2DMake(aRect.origin.x+aRect.size.height, aRect.origin.y);
//    CLLocationCoordinate2D d=CLLocationCoordinate2DMake(aRect.origin.x+aRect.size.height,aRect.origin.y+aRect.size.width);
    
//    [self addAnnotationToLocation:a withLocation:nil withAnnoType:OtherAddressAnnotation];
//    [self addAnnotationToLocation:b withLocation:nil withAnnoType:OtherAddressAnnotation];
//    [self addAnnotationToLocation:c withLocation:nil withAnnoType:OtherAddressAnnotation];
//    [self addAnnotationToLocation:d withLocation:nil withAnnoType:OtherAddressAnnotation];

}

#pragma mark connectivty region
//connectivity notification back
-(void)connectivityChanged: (ConnectivityCheck* )check{    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss24"];//101 AS [MM/DD/YYYY]
        [formatter setDateFormat:@"dd/MM/yyyy"];//101 AS [MM/DD/YYYY]
        
        NSString* startDate = [NSString stringWithFormat:@"%@ 00:00:00", [formatter stringFromDate:self.orderStartDate]];
        
        NSString* endDate = [NSString stringWithFormat:@"%@ 23:59:59", [formatter stringFromDate:self.orderEndDate]];
        NSLog(@"enter into the check connection.");
//        NSString* sqlStatement = [NSString stringWithFormat:@"select * from ipadordersbyposition where entereddate between '%@' and '%@' ",startDate,endDate ];
         NSString* sqlStatement = [NSString stringWithFormat:@"select * from ipadcallsbyposition where calldate between convert(datetime, '%@', 103) and convert(datetime, '%@', 103)", startDate, endDate ];
        
        NSLog(@"%@", sqlStatement);
        [callGenericServices getData: sqlStatement];
        
        [formatter release];
    } else {
        [check stop];
        //        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}

#pragma mark generic servie delegate
-(void)setGetDataResult:(ArcosGenericReturnObject *)result{
    
    NSLog(@"set result happens in customer order");
    if (result == nil) {
        //        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.orders = result.ArrayOfData;
        [self dropOrderPins];
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
    }
}

#pragma mark drop order pins
-(void)dropOrderPins{
    if (self.orders!=nil) {
        if ([self.orders count]>0) {
            for (ArcosGenericClass* aClass in self.orders) {
//                NSLog(@"order data back for-----%@--- %@---%@ ",aClass.Field4,aClass.Field2,aClass.Field1);
                CLLocationCoordinate2D theLocation=CLLocationCoordinate2DMake([aClass.Field2 floatValue], [aClass.Field1 floatValue]);
               
                
                //check it is a call or order
                if (aClass.Field10!=nil&&aClass.Field13!=nil) {
                    int orderIUR=[aClass.Field13 intValue];
                    int callIUR=[aClass.Field12 intValue];
                    
                    if (orderIUR>0) {//check it is an order or not
                        NSMutableDictionary* aLocation=[NSMutableDictionary dictionaryWithObjectsAndKeys:aClass.Field4 ,@"Name",aClass.Field7,@"Address1",aClass.Field3 ,@"Address2",nil];
                       [self addAnnotationToLocation:theLocation withLocation:aLocation withAnnoType:OrderAddressAnnotation withObject:aClass.Field13]; 
                    }else if(callIUR>0){//check it is an call or not
                         NSMutableDictionary* aLocation=[NSMutableDictionary dictionaryWithObjectsAndKeys:aClass.Field4 ,@"Name",aClass.Field7,@"Address1",aClass.Field11 ,@"Address2",nil];
                        [self addAnnotationToLocation:theLocation withLocation:aLocation withAnnoType:CallAddressAnnotation withObject:aClass.Field12];
                    }
                }
                
                
            }
        }
    }
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

#pragma mark
-(void)dateSelectedForm:(NSDate *)start To:(NSDate *)end{
    self.orderEndDate=end;
    self.orderStartDate=start;
    
    [self clearPins];
    [datePickerPopover dismissPopoverAnimated:YES];
    [connectivityCheck asyncStart];
}

-(void)stampLocation {
    [self.CLController start];
}

//core location delegate
- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"location is coming back %@",[location description]);
    [self.CLController stop];
}
- (void)locationError:(NSError *)error {
    NSLog(@"location is coming back with error");
    [self.CLController stop];
    
}

@end
