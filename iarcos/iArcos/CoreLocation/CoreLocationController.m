//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController

@synthesize locMgr, delegate;

- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease];
		self.locMgr.delegate = self;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locMgr.distanceFilter = 10.0;
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        if (newLocation.horizontalAccuracy < 0) return;
        [self.delegate locationUpdate:newLocation];
//        if (newLocation.horizontalAccuracy<=locMgr.desiredAccuracy) {
//            [self.delegate locationUpdate:newLocation];
//        }
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

-(void)start{
    if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locMgr requestWhenInUseAuthorization];
    }
    [self.locMgr startUpdatingLocation];
}
-(void)stop{
    [self.locMgr stopUpdatingLocation];
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

@end
