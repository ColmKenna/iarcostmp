//
//  LocationStampMapView.m
//  Arcos
//
//  Created by David Kilmartin on 16/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "LocationStampMapView.h"
#import "ArcosCoreData.h"
@implementation LocationStampMapView
@synthesize animateDelegate = _animateDelegate;
@synthesize myMapView;
@synthesize locationIUR;
@synthesize currentLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    self.currentLocation=[[ArcosCoreData sharedArcosCoreData]locationMAWithIUR:self.locationIUR];
    
    if ([currentLocation.Latitude floatValue]==0||[currentLocation.Longitude floatValue]==0) {
        
    }else{
        
    }
     NSMutableDictionary* aLocation=[NSMutableDictionary dictionaryWithObjectsAndKeys:currentLocation.Name,@"Name",currentLocation.Address2,@"Address1",currentLocation.Address4,@"Address2",nil];
    //set the default location 53.344123,-6.276112
    CLLocationCoordinate2D coord = {.latitude =  [currentLocation.Latitude floatValue ], .longitude =  [currentLocation.Longitude floatValue]};
    MKCoordinateSpan span = {.latitudeDelta =  .2, .longitudeDelta =  .2};
    MKCoordinateRegion region = {coord, span};
    [self.myMapView setRegion:region];
    [self addAnnotationToLocation:coord withLocation:aLocation withAnnoType:CustomerAddressAnnotation withObject:nil];
    
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:1];
    UIBarButtonItem* directionsButton = [[[UIBarButtonItem alloc] initWithTitle:@"Directions" style:UIBarButtonItemStylePlain target:self action:@selector(directionsPressed:)] autorelease];
    [rightButtonList addObject:directionsButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
}

- (void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)directionsPressed:(id)sender {
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([self.currentLocation.Latitude floatValue], [self.currentLocation.Longitude floatValue]);
    MKPlacemark* endLocation = [[[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil] autorelease];
    MKMapItem* endingItem = [[[MKMapItem alloc] initWithPlacemark:endLocation] autorelease];
    
    NSMutableDictionary* launchOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
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
    [[ArcosCoreData sharedArcosCoreData]saveGeoLocationWithLocationIUR:self.locationIUR withLat:[NSNumber numberWithDouble: aLocation.latitude] withLon:[NSNumber numberWithDouble: aLocation.longitude]];
    
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
        
        annotationView.draggable=YES;
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
        
    }
    
    
    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //NSLog(@"map move");
}

#pragma mark add annocation pin
-(void)addAnnotationToLocation:(CLLocationCoordinate2D)coord withLocation:(NSMutableDictionary*)aLocation withAnnoType:(AddressAnnotationType)type withObject:(NSObject*)anObject{
    
    //NSLog(@"pin add to the location lat:%f  lon:%f",aLocation.latitude,aLocation.longitude);
    AddressAnnotation *annot =[[AddressAnnotation alloc]initWithCoordinate:coord withLocation:aLocation withType:type];
    annot.anObject=anObject;
        
    [self.myMapView addAnnotation:annot];
    [annot release];
    
}

-(void)dealloc{
    if (self.myMapView != nil) {
        self.myMapView=nil;
    }
    self.locationIUR = nil;
//    if (currentLocation!=nil) {
//        [currentLocation release];
//    }
    self.currentLocation = nil;
    
    [super dealloc];
}
@end
