//
//  LocationStampMapView.h
//  Arcos
//
//  Created by David Kilmartin on 16/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"
#import "Location.h"
#import "SlideAcrossViewAnimationDelegate.h"
@interface LocationStampMapView : UIViewController<MKMapViewDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet MKMapView *myMapView;
    NSNumber* locationIUR;
    Location* currentLocation;
 }
@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic, retain) Location* currentLocation;
-(void)addAnnotationToLocation:(CLLocationCoordinate2D)aLocation withLocation:(NSMutableDictionary*)aLocation withAnnoType:(AddressAnnotationType)type withObject:(NSObject*)anObject;
@end
