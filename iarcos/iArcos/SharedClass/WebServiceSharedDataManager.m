//
//  WebServiceSharedDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 04/07/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "WebServiceSharedDataManager.h"
#import "ArcosRootViewController.h"
#import "CustomerGroupViewController.h"

@implementation WebServiceSharedDataManager
@synthesize myRootViewController = _myRootViewController;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    }
    return self;
}

- (void)dealloc {
    self.myRootViewController = nil;
    
    [super dealloc];
}


- (NSMutableArray*)retrieveAllLocationIUR {
    NSMutableArray* locationIURList = [NSMutableArray array]; 
    NSArray* properties = [NSArray arrayWithObjects:@"LocationIUR", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:properties  withPredicate:nil withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    for (int i = 0; i < [objectArray count]; i++) {
        NSDictionary* tmpLocationDict = [objectArray objectAtIndex:i];
        [locationIURList addObject:[tmpLocationDict objectForKey:@"LocationIUR"]];
    }    
    return locationIURList;
}

- (void)removeAllSentOrderHeaderWithLocationIURList:(NSMutableArray*)aLocationIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT (LocationIUR IN %@) AND OrderHeaderIUR != 0", aLocationIURList];
    NSMutableArray* orderHeaderList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[orderHeaderList count]] - 1; i >= 0; i--) {
        OrderHeader* OH = [orderHeaderList objectAtIndex:i];
        
        for (OrderLine* OL in OH.orderlines) {
            [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:OL];
        }
        
        for (CallTran* CT in OH.calltrans) {
            [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:CT];
        }
        
        //delete call
        if (OH.call != nil) {
            [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:OH.call];
        }
        
        //delete memo
        if (OH.memo != nil) {
            [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:OH.memo];
        }
        
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:OH];        
        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext refreshObject:OH mergeChanges:NO];    
    }
}

- (void)resetLocationList {
    @try {
        int itemIndex = [self.myRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[[GlobalSharedClass shared] customerText]];
        NSMutableDictionary* topTabBarCellDict = [self.myRootViewController.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
        ArcosStackedViewController* myArcosStackedViewController = [topTabBarCellDict objectForKey:@"MyCustomController"];
        UINavigationController* locationNavigationController = (UINavigationController*)myArcosStackedViewController.myMasterViewController.masterViewController;
        CustomerGroupViewController* locationCustomerGroupViewController = (CustomerGroupViewController*)[locationNavigationController.viewControllers objectAtIndex:0];
        [locationCustomerGroupViewController resetButtonPressed:nil];
    } @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self.myRootViewController tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }    
}

- (void)removeLocationProductMATWithLocationIURList:(NSMutableArray*)aLocationIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT (locationIUR IN %@)", aLocationIURList];
    NSMutableArray* locationProductMATList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[locationProductMATList count]] - 1; i >= 0; i--) {
        LocationProductMAT* auxLocationProductMAT = [locationProductMATList objectAtIndex:i];        
        
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:auxLocationProductMAT];        
        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext refreshObject:auxLocationProductMAT mergeChanges:NO];    
    }
}

- (void)removeLocationProductMATWithLevelIUR:(NSNumber*)aLevelIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"levelIUR != %@", aLevelIUR];
    NSMutableArray* locationProductMATList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[locationProductMATList count]] - 1; i >= 0; i--) {        
        LocationProductMAT* auxLocationProductMAT = [locationProductMATList objectAtIndex:i];                
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:auxLocationProductMAT];        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];        
        [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext refreshObject:auxLocationProductMAT mergeChanges:NO];    
    }
}

@end
