//
//  CustomerListingMapViewController.m
//  iArcos
//
//  Created by Richard on 07/01/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerListingMapViewController.h"

@interface CustomerListingMapViewController ()

@end

@implementation CustomerListingMapViewController
@synthesize presentDelegate = _presentDelegate;
@synthesize myMapView = _myMapView;
@synthesize customerListingMapDataManager = _customerListingMapDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.customerListingMapDataManager = [[[CustomerListingMapDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].backButtonText style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    BOOL regionSetFlag = NO;
    for (int i = 0; i < [self.customerListingMapDataManager.displayList count]; i++) {
        NSMutableDictionary* tmpLocationDict = [self.customerListingMapDataManager.displayList objectAtIndex:i];
        if ([[tmpLocationDict objectForKey:@"Latitude"] floatValue] == 0 || [[tmpLocationDict objectForKey:@"Longitude"] floatValue] == 0) {
            continue;
        }
        NSLog(@"-- %@", [tmpLocationDict objectForKey:@"Name"]);
        NSMutableDictionary* aLocation = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ArcosUtils convertNilToEmpty:[tmpLocationDict objectForKey:@"Name"]], @"Name", [ArcosUtils convertNilToEmpty:[tmpLocationDict objectForKey:@"Address2"]], @"Address1", [ArcosUtils convertNilToEmpty:[tmpLocationDict objectForKey:@"Address4"]], @"Address2", nil];
        //set the default location 53.344123,-6.276112
        CLLocationCoordinate2D coord = {.latitude = [[tmpLocationDict objectForKey:@"Latitude"] floatValue], .longitude = [[tmpLocationDict objectForKey:@"Longitude"] floatValue]};
        if (!regionSetFlag) {
            regionSetFlag = YES;
            MKCoordinateSpan span = {.latitudeDelta =  .2, .longitudeDelta =  .2};
            MKCoordinateRegion region = {coord, span};
            [self.myMapView setRegion:region];
        }
       
        [self addAnnotationToLocation:coord withLocation:aLocation withAnnoType:CustomerAddressAnnotation withObject:nil];
    }
}

- (void)dealloc {
    self.myMapView = nil;
    self.customerListingMapDataManager = nil;
    
    [super dealloc];
}

- (void)backPressed:(id)sender {
    [self.presentDelegate didDismissBuiltInPresentView];
}

#pragma mark - MKMapViewDelegate
- (void)addAnnotationToLocation:(CLLocationCoordinate2D)aCoord withLocation:(NSMutableDictionary*)aLocation withAnnoType:(AddressAnnotationType)aType withObject:(NSObject*)anObject {
    //NSLog(@"pin add to the location lat:%f  lon:%f",aLocation.latitude,aLocation.longitude);
    AddressAnnotation* annot = [[AddressAnnotation alloc] initWithCoordinate:aCoord withLocation:aLocation withType:aType];
    annot.anObject = anObject;
        
    [self.myMapView addAnnotation:annot];
    [annot release];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKAnnotationView* annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"myAnno"];
    if(!annotationView) {
    
        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnno"] autorelease];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        annotationView.draggable = NO;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(7, -15);
        annotationView.calloutOffset = CGPointMake(-8, 0);
    }
    
    // Setup annotation pin color depend on the annotation type
    if ([annotation isKindOfClass:[AddressAnnotation class]]) {
        annotationView.image = [UIImage imageNamed:@"pinPurple.png"];
    }
    
    return annotationView;
    
}

@end
