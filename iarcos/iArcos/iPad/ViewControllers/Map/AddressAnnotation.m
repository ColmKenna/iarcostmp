//
//  AddressAnnotaion.m
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "AddressAnnotation.h"
#import "ArcosCoreData.h"



@implementation AddressAnnotation

@synthesize coordinate;
@synthesize mTitle;
@synthesize mSubTitle;
@synthesize location;
@synthesize type;
@synthesize anObject;

- (NSString *)subtitle{
    return self.mSubTitle;
}

- (NSString *)title{
    return self.mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord withLocation:(NSMutableDictionary*) aLocation withType:(AddressAnnotationType)annoType{
    self.coordinate=coord;
    self.location=aLocation;
    self.mTitle=[aLocation objectForKey:@"Name"];
    self.mSubTitle=[[self fullAddressWith:aLocation]retain];
    self.type=annoType;
    //NSLog(@"%f,%f",c.latitude,c.longitude);
//    NSLog(@"new annotation name %@  title %@",self.mTitle,self.mSubTitle);
    return self;
}

-(void)dealloc{
    [location release];
    [super dealloc];    
}

-(NSString*)fullAddressWith:(NSMutableDictionary*)aLocation{
    NSString* LocationAddress=@"";
    if (![[aLocation objectForKey:@"Address1"] isEqualToString:@""]&&[aLocation objectForKey:@"Address1"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address1"]];
    }
    if (![[aLocation objectForKey:@"Address2"] isEqualToString:@""]&&[aLocation objectForKey:@"Address2"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address2"]];
    }
    if (![[aLocation objectForKey:@"Address3"] isEqualToString:@""]&&[aLocation objectForKey:@"Address3"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address3"]];
    }
    if (![[aLocation objectForKey:@"Address4"] isEqualToString:@""]&&[aLocation objectForKey:@"Address4"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address4"]];
    }
    if (![[aLocation objectForKey:@"Address5"] isEqualToString:@""]&&[aLocation objectForKey:@"Address5"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address5"]];
    }
    return LocationAddress;
    
}
@end
