//
//  PresenterBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 19/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "PresenterBaseDataManager.h"

@implementation PresenterBaseDataManager
@synthesize CLController = _CLController;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.CLController = [[[CoreLocationController alloc] init] autorelease];
        self.CLController.delegate = self;
        self.latitude = [NSNumber numberWithInt:0];
        self.longitude = [NSNumber numberWithInt:0];
    }
    
    return self;
}

- (void)dealloc {
    self.CLController = nil;
    [super dealloc];
}

- (void)loadPtranWithDict:(NSMutableDictionary*)aPtranDict {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date = %@ and locationIUR = %@ and contactIUR = %@ and presenterIUR = %@", [aPtranDict objectForKey:@"date"], [aPtranDict objectForKey:@"locationIUR"], [aPtranDict objectForKey:@"contactIUR"], [aPtranDict objectForKey:@"presenterIUR"]];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"PTran" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        PTran* PTran = [objectsArray objectAtIndex:0];
//        NSLog(@"date: %@", PTran.date);
        PTran.duration = [NSNumber numberWithInt:[PTran.duration intValue] + [[aPtranDict objectForKey:@"duration"] intValue]];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        PTran* PTran = [NSEntityDescription
                            insertNewObjectForEntityForName:@"PTran"
                            inManagedObjectContext:context];
        PTran.date = [aPtranDict objectForKey:@"date"];
        PTran.locationIUR = [aPtranDict objectForKey:@"locationIUR"];
        PTran.contactIUR = [aPtranDict objectForKey:@"contactIUR"];
        PTran.presenterIUR = [aPtranDict objectForKey:@"presenterIUR"];
        PTran.duration = [aPtranDict objectForKey:@"duration"];
        PTran.dateTime = [NSDate date];
        PTran.latitude = [aPtranDict objectForKey:@"latitude"];
        PTran.longitude = [aPtranDict objectForKey:@"longitude"];
        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    }
}

- (NSMutableDictionary*)createPtranDictWithPresenterIUR:(NSNumber*)presenterIUR duration:(NSNumber*)duration {
    NSMutableDictionary* ptranDict = [NSMutableDictionary dictionaryWithCapacity:5];
//    [ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat];
    [ptranDict setObject:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat] format:[GlobalSharedClass shared].dateFormat] forKey:@"date"];
    [ptranDict setObject:[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedLocationIUR] forKey:@"locationIUR"];
    [ptranDict setObject:[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedContactIUR] forKey:@"contactIUR"];
    [ptranDict setObject:[ArcosUtils convertNilToZero:presenterIUR] forKey:@"presenterIUR"];
    [ptranDict setObject:duration forKey:@"duration"];
    [ptranDict setObject:self.latitude forKey:@"latitude"];
    [ptranDict setObject:self.longitude forKey:@"longitude"];
    
    return ptranDict;
}

- (void)recordLocationCoordinate {
    [self.CLController start];
}

#pragma mark CoreLocationControllerDelegate
- (void)locationUpdate:(CLLocation *)location {
//    NSLog(@"aaa: %f %f", location.coordinate.latitude, location.coordinate.longitude);
    self.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    [self.CLController stop];
    
}
- (void)locationError:(NSError *)error {
//    NSLog(@"location error base");
    [self.CLController stop];
}

@end
