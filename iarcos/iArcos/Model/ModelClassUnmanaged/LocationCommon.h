//
//  LocationCommon .h
//  Arcos
//
//  Created by David Kilmartin on 29/06/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationCommon: NSObject {
    NSNumber* Latitude;
    NSNumber* Longitude;
    NSString* LocationName;
    NSString* LocationAddress;
}
@property(nonatomic,retain)NSNumber* Latitude;
@property(nonatomic,retain)NSNumber* Longitude;
@property(nonatomic,retain)NSString* LocationName;
@property(nonatomic,retain)NSString* LocationAddress;

-(id)initWithLatitude:(NSNumber*)lat withLongitude:(NSNumber*)lon;
-(CLLocationCoordinate2D)coordination;
@end
