//
//  PackageDataManager.m
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "PackageDataManager.h"

@implementation PackageDataManager
@synthesize displayList = _displayList;
@synthesize wholesalerIurImageIurHashMap = _wholesalerIurImageIurHashMap;
@synthesize pGiurDetailHashMap = _pGiurDetailHashMap;

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.wholesalerIurImageIurHashMap = nil;
    self.pGiurDetailHashMap = nil;
    
    [super dealloc];
}

- (void)retrievePackageDataWithLocationIUR:(NSNumber*)aLocationIUR {
    
    self.wholesalerIurImageIurHashMap = [NSMutableDictionary dictionary];
    self.pGiurDetailHashMap = [NSMutableDictionary dictionary];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and active = 1", aLocationIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"accountCode", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Package" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    self.displayList = [NSMutableArray arrayWithCapacity:[objectArray count]];
    
    NSMutableDictionary* tmpWholesalerIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[self.displayList count]];
    NSMutableDictionary* tmpPGiurHashMap = [NSMutableDictionary dictionaryWithCapacity:[self.displayList count]];
    NSMutableDictionary* defaultPackageDict = [[GlobalSharedClass shared] retrieveCurrentSelectedPackage];
    int defaultPackageIUR = [[defaultPackageDict objectForKey:@"iUR"] intValue];
    for (int i = 0; i < [objectArray count]; i++) {
        NSDictionary* tmpPackageDict = [objectArray objectAtIndex:i];
        NSMutableDictionary* resPackageDict = [NSMutableDictionary dictionaryWithDictionary:tmpPackageDict];
        [resPackageDict setObject:[NSNumber numberWithBool:NO] forKey:@"selectedFlag"];
        if (defaultPackageIUR != 0 && defaultPackageIUR == [[resPackageDict objectForKey:@"iUR"] intValue]) {
            [resPackageDict setObject:[NSNumber numberWithBool:YES] forKey:@"selectedFlag"];
        }
        [self.displayList addObject:resPackageDict];
        NSNumber* tmpWholesalerIUR = [tmpPackageDict objectForKey:@"wholesalerIUR"];
        NSNumber* tmpPGiur = [tmpPackageDict objectForKey:@"pGiur"];
        NSNumber* resWholesalerIUR = [ArcosUtils convertNilToZero:tmpWholesalerIUR];
        [tmpWholesalerIURHashMap setObject:resWholesalerIUR forKey:resWholesalerIUR];
        NSNumber* resPGiur = [ArcosUtils convertNilToZero:tmpPGiur];
        [tmpPGiurHashMap setObject:resPGiur forKey:resPGiur];
    }
//    NSLog(@"tmpWholesalerIURHashMap: %@", tmpWholesalerIURHashMap);
//    NSLog(@"tmpPGiurHashMap: %@", tmpPGiurHashMap);
    if ([tmpWholesalerIURHashMap count] > 0) {
        NSMutableArray* tmpLocationDictList = [[ArcosCoreData sharedArcosCoreData] locationsWithIURList:[NSMutableArray arrayWithArray:[tmpWholesalerIURHashMap allValues]]];
        for (int i = 0; i < [tmpLocationDictList count]; i++) {
            NSDictionary* tmpLocationDict = [tmpLocationDictList objectAtIndex:i];
            NSNumber* resWholesalerIUR = [ArcosUtils convertNilToZero:[tmpLocationDict objectForKey:@"LocationIUR"]];
            NSNumber* resLocationImageIur = [ArcosUtils convertNilToZero:[tmpLocationDict objectForKey:@"ImageIUR"]];
            [self.wholesalerIurImageIurHashMap setObject:resLocationImageIur forKey:resWholesalerIUR];
        }
    }
    if ([tmpPGiurHashMap count] > 0) {
        NSMutableArray* tmpDescrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:[NSMutableArray arrayWithArray:[tmpPGiurHashMap allValues]]];
        for (int i = 0; i < [tmpDescrDetailDictList count]; i++) {
            NSDictionary* tmpDescrDetailDict = [tmpDescrDetailDictList objectAtIndex:i];
            NSNumber* tmpDescrDetailIUR = [tmpDescrDetailDict objectForKey:@"DescrDetailIUR"];
            NSString* resDetail = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"Detail"]];
            [self.pGiurDetailHashMap setObject:resDetail forKey:tmpDescrDetailIUR];
        }
    }
}

- (void)resetSelectedFlagOnList {
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpPackageDict = [self.displayList objectAtIndex:i];
        [tmpPackageDict setObject:[NSNumber numberWithBool:NO] forKey:@"selectedFlag"];
    }
}

- (void)configSelectedFlagWithIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpPackageDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpPackageDict setObject:[NSNumber numberWithBool:YES] forKey:@"selectedFlag"];
}

- (void)saveButtonPressedProcessor {
    NSMutableDictionary* selectedPackageDict = nil;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpPackageDict = [self.displayList objectAtIndex:i];
        NSNumber* tmpSelectedFlag = [tmpPackageDict objectForKey:@"selectedFlag"];
        if ([tmpSelectedFlag boolValue]) {
            selectedPackageDict = tmpPackageDict;
            break;
        }
    }
    if (selectedPackageDict != nil) {
        [GlobalSharedClass shared].currentSelectedPackage = [NSMutableDictionary dictionaryWithDictionary:selectedPackageDict];
    }
}

@end
