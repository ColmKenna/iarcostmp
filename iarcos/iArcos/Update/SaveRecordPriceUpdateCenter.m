//
//  SaveRecordPriceUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 31/07/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "SaveRecordPriceUpdateCenter.h"
@interface SaveRecordPriceUpdateCenter ()
- (void)retrieveExistingPriceDict:(NSArray*)aRecordList;

@end

@implementation SaveRecordPriceUpdateCenter
@synthesize existingPromotionDict = _existingPromotionDict;

- (id)initWithRecordList:(NSArray*)aRecordList {
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 12;
        [self retrieveExistingPriceDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    self.existingPromotionDict = nil;
    [super dealloc];
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData] LoadPriceWithFieldList:aFieldList existingPriceDict:self.existingObjectDict existingPromotionDict:self.existingPromotionDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingPriceDict:(NSArray*)aRecordList {
    NSMutableArray* priceIURList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* priceIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [priceIURList addObject:priceIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR in %@", priceIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Price" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (Price* aPrice in objectArray) {
        [self.existingObjectDict setObject:aPrice forKey:aPrice.IUR];
    }
    
    NSPredicate* promotionPredicate = [NSPredicate predicateWithFormat:@"IUR in %@", priceIURList];
    NSMutableArray* promotionObjectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Promotion" withPropertiesToFetch:nil withPredicate:promotionPredicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingPromotionDict = [NSMutableDictionary dictionaryWithCapacity:[promotionObjectArray count]];
    for (Promotion* aPromotion in promotionObjectArray) {
        [self.existingPromotionDict setObject:aPromotion forKey:aPromotion.IUR];
    }
}


@end
