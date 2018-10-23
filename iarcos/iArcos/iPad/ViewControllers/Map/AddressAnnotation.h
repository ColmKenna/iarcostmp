//
//  AddressAnnotaion.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocationCommon.h"

typedef enum {
    CustomerAddressAnnotation  = 0,
    PharmacyAddressAnnotation     = 1,
    TouchDropAddressAnnotation  = 2,
    OrderAddressAnnotation   = 3,
    CallAddressAnnotation   =4,
    OtherAddressAnnotation    = 5,
    StockistAddressAnnotation = 6
} AddressAnnotationType;

@interface AddressAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
    NSMutableDictionary* location;
    AddressAnnotationType type;
    NSObject* anObject;
}
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,assign) NSString *mTitle;
@property(nonatomic,assign) NSString *mSubTitle;
@property(nonatomic,retain) NSMutableDictionary* location;
@property(nonatomic,assign) AddressAnnotationType type;
@property(nonatomic,retain) NSObject* anObject;


-(id)initWithCoordinate:(CLLocationCoordinate2D)coord withLocation:(NSMutableDictionary*) aLocation withType:(AddressAnnotationType)annoType;

-(NSString*)fullAddressWith:(NSMutableDictionary*)aLocation;
@end
