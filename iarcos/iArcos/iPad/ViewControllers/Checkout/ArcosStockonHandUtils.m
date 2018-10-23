//
//  ArcosStockonHandUtils.m
//  iArcos
//
//  Created by David Kilmartin on 18/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "ArcosStockonHandUtils.h"
#import "ArcosCoreData.h"

@implementation ArcosStockonHandUtils

- (void)dealloc {    
    
    [super dealloc];
}

/*
 * 0: add 1: delete line
 */
- (void)updateStockonHandWithOrderLines:(NSArray*)anOrderLineList actionType:(int)anActionType {
    NSMutableDictionary* productManagedObjectHashMap = [self retrieveProductManagedObjectHashMap:anOrderLineList];
    for (NSMutableDictionary* anOrderLine in anOrderLineList) {
        NSNumber* productIUR = [anOrderLine objectForKey:@"ProductIUR"];
        NSNumber* qty = [anOrderLine objectForKey:@"Qty"];
        Product* auxProduct = [productManagedObjectHashMap objectForKey:productIUR];
        switch (anActionType) {
            case 0: {
                auxProduct.StockonHand = [NSNumber numberWithInt:([auxProduct.StockonHand intValue] - [qty intValue])];
//                NSLog(@"add product");
            }                
                break;
            case 1: {
                auxProduct.StockonHand = [NSNumber numberWithInt:([auxProduct.StockonHand intValue] + [qty intValue])];
//                NSLog(@"delete product %@", auxProduct.StockonHand);
            }                
                break;
                
            default:
                break;
        }
        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (void)updateStockonHandWithOrderLine:(NSMutableDictionary*)anOrderLine priorOrderLineQty:(NSNumber*)aPriorOrderLineQty {
    NSArray* anOrderLineList = [NSArray arrayWithObject:anOrderLine];
    NSMutableDictionary* productManagedObjectHashMap = [self retrieveProductManagedObjectHashMap:anOrderLineList];
    for (NSMutableDictionary* anOrderLine in anOrderLineList) {
        NSNumber* productIUR = [anOrderLine objectForKey:@"ProductIUR"];
        NSNumber* qty = [anOrderLine objectForKey:@"Qty"];
//        NSNumber* priorQty = [aPriorOrderLine objectForKey:@"Qty"];
        Product* auxProduct = [productManagedObjectHashMap objectForKey:productIUR];
        auxProduct.StockonHand = [NSNumber numberWithInt:([auxProduct.StockonHand intValue] - [qty intValue] + [aPriorOrderLineQty intValue])];
//        NSLog(@"edit product");
        
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (NSMutableDictionary*)retrieveProductManagedObjectHashMap:(NSArray*)anOrderLineList {
    NSMutableDictionary* productManagedObjectHashMap = [NSMutableDictionary dictionaryWithCapacity:[anOrderLineList count]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[anOrderLineList count]];
    for (NSMutableDictionary* anOrderLine in anOrderLineList) {
        NSNumber* productIUR = [anOrderLine objectForKey:@"ProductIUR"];
        [productIURList addObject:productIUR];
    }
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] productWithIURList:productIURList withResultType:NSManagedObjectResultType];
    for (Product* aProduct in objectList) {
        [productManagedObjectHashMap setObject:aProduct forKey:aProduct.ProductIUR];
    }
    return productManagedObjectHashMap;
}

@end
