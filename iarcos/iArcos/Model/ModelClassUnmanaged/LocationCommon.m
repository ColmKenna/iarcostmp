//
//  LocationCommon .m
//  Arcos
//
//  Created by David Kilmartin on 29/06/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "LocationCommon.h"


@implementation LocationCommon
@synthesize Latitude;
@synthesize Longitude;
@synthesize LocationName;
@synthesize LocationAddress;

-(id)initWithLatitude:(NSNumber*)lat withLongitude:(NSNumber*)lon{
    self=[super init];
    if (self!=nil) {
        self.Latitude=lat;
        self.Longitude=lon;
    }
    return self;
}
-(CLLocationCoordinate2D)coordination{
    CLLocationCoordinate2D coord=CLLocationCoordinate2DMake([self.Latitude floatValue], [self.Longitude floatValue]);
    return  coord;
}
-(void)dealloc{
    [super dealloc];

}
@end
