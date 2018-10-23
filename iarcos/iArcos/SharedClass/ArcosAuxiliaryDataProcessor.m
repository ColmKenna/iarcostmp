//
//  ArcosAuxiliaryDataProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 30/11/2015.
//  Copyright © 2015 Strata IT Limited. All rights reserved.
//

#import "ArcosAuxiliaryDataProcessor.h"

@implementation ArcosAuxiliaryDataProcessor
SYNTHESIZE_SINGLETON_FOR_CLASS(ArcosAuxiliaryDataProcessor);

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString *)aDescrTypeCode activeOnly:(BOOL)activeFlag {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@", aDescrTypeCode];
    if (activeFlag) {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ AND Active = 1", aDescrTypeCode];
    }
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (void)runTransaction {
//    if (1 == 1) {
//        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
//        DescrDetail* descrDetail = [NSEntityDescription insertNewObjectForEntityForName:@"DescrDetail" inManagedObjectContext:context];
//        descrDetail.DescrTypeCode = @"PP";
//        descrDetail.DescrDetailIUR = [NSNumber numberWithInt:9];
//        descrDetail.Detail = @"main group";
//        [[ArcosCoreData sharedArcosCoreData] saveContext:context];
//    }
//    if (1 == 1) {
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR = 91095"];
//        NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//        if ([objectsArray count] > 0) {
//            for (DescrDetail* aDescrDetail in objectsArray) {
//                aDescrDetail.DescrDetailCode = @"21";
//                [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
//            }
//        }
//    }
    /*
    if (1==1) {//98033 --83997 imageiur for employee
        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Journey"];
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        Journey* journey = [NSEntityDescription insertNewObjectForEntityForName:@"Journey"
                                                         inManagedObjectContext:context];
        journey.IUR = [NSNumber numberWithInt:2567];
        journey.ContactIUR = [NSNumber numberWithInt:89846];
        journey.DayNumber = [NSNumber numberWithInt:1];
        journey.EmployeeIUR = [NSNumber numberWithInt:1];
        journey.LocationIUR = [NSNumber numberWithInt:2693];
        journey.WeekNumber = [NSNumber numberWithInt:1];
        [[ArcosCoreData sharedArcosCoreData] saveContext:context];
    }
    if (1==1) {//98033 --83997 imageiur for employee
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        Journey* journey = [NSEntityDescription insertNewObjectForEntityForName:@"Journey"
                                                         inManagedObjectContext:context];
        journey.IUR = [NSNumber numberWithInt:2569];
        journey.ContactIUR = [NSNumber numberWithInt:89846];
        journey.DayNumber = [NSNumber numberWithInt:2];
        journey.EmployeeIUR = [NSNumber numberWithInt:1];
        journey.LocationIUR = [NSNumber numberWithInt:2736];
        journey.WeekNumber = [NSNumber numberWithInt:1];
        [[ArcosCoreData sharedArcosCoreData] saveContext:context];
    }
    if (1==1) {//98033 --83997 imageiur for employee
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        Journey* journey = [NSEntityDescription insertNewObjectForEntityForName:@"Journey"
                                                         inManagedObjectContext:context];
        journey.IUR = [NSNumber numberWithInt:2568];
        journey.ContactIUR = [NSNumber numberWithInt:89846];
        journey.DayNumber = [NSNumber numberWithInt:1];
        journey.EmployeeIUR = [NSNumber numberWithInt:1];
        journey.LocationIUR = [NSNumber numberWithInt:2560];
        journey.WeekNumber = [NSNumber numberWithInt:1];
        [[ArcosCoreData sharedArcosCoreData] saveContext:context];
    }
    if (1==1) {//98033 --83997 imageiur for employee
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        Journey* journey = [NSEntityDescription insertNewObjectForEntityForName:@"Journey"
                                                         inManagedObjectContext:context];
        journey.IUR = [NSNumber numberWithInt:2570];
        journey.ContactIUR = [NSNumber numberWithInt:89846];
        journey.DayNumber = [NSNumber numberWithInt:1];
        journey.EmployeeIUR = [NSNumber numberWithInt:1];
        journey.LocationIUR = [NSNumber numberWithInt:3262];
        journey.WeekNumber = [NSNumber numberWithInt:2];
        [[ArcosCoreData sharedArcosCoreData] saveContext:context];
    }
    */
    if (1 == 1) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = 1"];
        NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Employee" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        if ([objectsArray count] > 0) {
            for (Employee* anEmployee in objectsArray) {
                anEmployee.JourneyStartDate = [ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat] format:[GlobalSharedClass shared].dateFormat];
                [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
            }
        }
    }

}

@end
