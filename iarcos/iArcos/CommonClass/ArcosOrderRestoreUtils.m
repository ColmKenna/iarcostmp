//
//  ArcosOrderRestoreUtils.m
//  iArcos
//
//  Created by David Kilmartin on 24/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ArcosOrderRestoreUtils.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"
@interface ArcosOrderRestoreUtils ()

@end

@implementation ArcosOrderRestoreUtils
@synthesize orderRestoreDict = _orderRestoreDict;

- (void)dealloc {
    self.orderRestoreDict = nil;
    
    [super dealloc];
}

- (BOOL)orderRestorePlistExistent {
    if ([FileCommon fileExistAtPath:[FileCommon orderRestorePlistPath]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadOrderlineWithDict:(NSMutableDictionary*)anOrderline {
    if (![self orderRestorePlistExistent]) {
        [self loadDefaultOrderRestorePlist];
    } else {
        [self loadOrderRestorePlist];
    }
    [self.orderRestoreDict setObject:[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedLocationIUR] forKey:@"LocationIUR"];
    [self.orderRestoreDict setObject:[ArcosUtils convertNilToZero:[GlobalSharedClass shared].currentSelectedContactIUR] forKey:@"ContactIUR"];
    [self.orderRestoreDict setObject:[ArcosUtils convertNilToZero:[OrderSharedClass sharedOrderSharedClass].currentFormIUR] forKey:@"FormIUR"];
    NSMutableDictionary* dataDict = [self.orderRestoreDict objectForKey:@"data"];
    if (dataDict == nil) {
        dataDict = [NSMutableDictionary dictionary];
        [self.orderRestoreDict setObject:dataDict forKey:@"data"];
    }
    NSNumber* productIUR = [anOrderline objectForKey:@"ProductIUR"];
    NSString* productIURSTR = [ArcosUtils convertNumberToIntString:productIUR];
    
    if ([dataDict objectForKey:productIURSTR] == nil) {
        NSMutableDictionary* tmpOrderRestoreDict = [NSMutableDictionary dictionaryWithCapacity:7];
        [tmpOrderRestoreDict setObject:productIUR forKey:@"ProductIUR"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"Qty"] forKey:@"Qty"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"Bonus"] forKey:@"Bonus"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"DiscountPercent"] forKey:@"DiscountPercent"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"InStock"] forKey:@"InStock"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"FOC"] forKey:@"FOC"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"Testers"] forKey:@"Testers"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"LineValue"] forKey:@"LineValue"];
        [tmpOrderRestoreDict setObject:[ArcosUtils convertNilToZero:[anOrderline objectForKey:@"PriceFlag"]] forKey:@"PriceFlag"];
        [tmpOrderRestoreDict setObject:[anOrderline objectForKey:@"UnitPrice"] forKey:@"UnitPrice"];
        [tmpOrderRestoreDict setObject:[ArcosUtils convertNilToZero:[anOrderline objectForKey:@"RRIUR"]] forKey:@"RRIUR"];
        [tmpOrderRestoreDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[anOrderline objectForKey:@"ProductColour"]]] forKey:@"ProductColour"];
        
        [dataDict setObject:tmpOrderRestoreDict forKey:productIURSTR];
        [self saveOrderRestorePlist];
    }
}

- (void)loadOrderRestorePlist {
    self.orderRestoreDict = [NSMutableDictionary dictionaryWithContentsOfFile:[FileCommon orderRestorePlistPath]];
}

- (void)loadDefaultOrderRestorePlist {
    self.orderRestoreDict = [NSMutableDictionary dictionary];
    [self.orderRestoreDict writeToFile:[FileCommon orderRestorePlistPath] atomically:YES];
}

- (BOOL)saveOrderRestorePlist {
    return [self.orderRestoreDict writeToFile:[FileCommon orderRestorePlistPath] atomically:YES];
}

- (void)loadExistingOrderline {
    [self loadOrderRestorePlist];
    NSMutableDictionary* dataDict = [self.orderRestoreDict objectForKey:@"data"];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [self.orderRestoreDict objectForKey:@"LocationIUR"];
    NSArray* keyList = [dataDict allKeys];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[keyList count]];
    for (int i = 0; i < [keyList count]; i++) {
        [productIURList addObject:[ArcosUtils convertStringToNumber:[keyList objectAtIndex:i]]];
    }
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
//    NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIURList:productIURList];
//    productDictList = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:productDictList priceHashMap:priceHashMap];
    productDictList = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:productDictList productIURList:productIURList locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    NSMutableDictionary* finalOrderlineDict = [NSMutableDictionary dictionaryWithCapacity:[keyList count]];
    for (int i = 0; i < [keyList count]; i++) {
        NSString* tmpKey = [keyList objectAtIndex:i];
        NSNumber* tmpProductIUR = [ArcosUtils convertStringToNumber:tmpKey];
        NSMutableDictionary* tempDict = [dataDict objectForKey:tmpKey];
        if (![ProductFormRowConverter isSelectedWithFormRowDict:tempDict]) {
            continue;
        }
//        if ([[tempDict objectForKey:@"Qty"] intValue] == 0 && [[tempDict objectForKey:@"Bonus"] intValue] == 0 && [[tempDict objectForKey:@"InStock"] intValue] == 0 && [[tempDict objectForKey:@"FOC"] intValue] == 0) {
//            // && [[tempDict objectForKey:@"DiscountPercent"] intValue] == 0
//            continue;
//        }
        NSDictionary* aProduct = [productDictHashMap objectForKey:tmpProductIUR];
        NSString* combinationKey = @"";
        if (aProduct != nil) {
            NSString* description = [ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Description"]];
            [tempDict setObject:description forKey:@"Description"];
            combinationKey = [NSString stringWithFormat:@"%@->%d", description, [tmpProductIUR intValue]];
            
            [tempDict setObject:combinationKey forKey:@"CombinationKey"];
            
            [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"OrderPadDetails"]]] forKey:@"OrderPadDetails"];
            [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
            [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Productsize"]]] forKey:@"ProductSize"];
            [tempDict setObject:description forKey:@"Details"];
//            [tempDict setObject:[aProduct objectForKey:@"UnitTradePrice"] forKey:@"UnitPrice"];
            [tempDict setObject:[aProduct objectForKey:@"UnitsPerPack"] forKey:@"UnitsPerPack"];
            [tempDict setObject:[aProduct objectForKey:@"Bonusby"] forKey:@"Bonusby"];
            [tempDict setObject:[aProduct objectForKey:@"StockAvailable"] forKey:@"StockAvailable"];
            [tempDict setObject:[aProduct objectForKey:@"StockonHand"] forKey:@"StockonHand"];
            //add ImageIUR BonusGiven BonusRequired SellBy 08/01/2015
            [tempDict setObject:[aProduct objectForKey:@"ImageIUR"] forKey:@"ImageIUR"];
            [tempDict setObject:[aProduct objectForKey:@"BonusGiven"] forKey:@"BonusGiven"];
            [tempDict setObject:[aProduct objectForKey:@"BonusRequired"] forKey:@"BonusRequired"];
            if ([aProduct objectForKey:@"SellBy"] == nil) {
                [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"SellBy"];
            } else {
                [tempDict setObject:[aProduct objectForKey:@"SellBy"] forKey:@"SellBy"];
            }
            [tempDict setObject:[aProduct objectForKey:@"BonusMinimum"] forKey:@"BonusMinimum"];
            [tempDict setObject:[aProduct objectForKey:@"Active"] forKey:@"Active"];
//            [tempDict setObject:[ArcosUtils convertNilToZero:[aProduct objectForKey:@"PriceFlag"]] forKey:@"PriceFlag"];
            [tempDict setObject:[aProduct objectForKey:@"MinimumUnitPrice"] forKey:@"MinimumUnitPrice"];
            [tempDict setObject:[aProduct objectForKey:@"UnitRRP"] forKey:@"UnitRRP"];
            [tempDict setObject:[aProduct objectForKey:@"VCIUR"] forKey:@"VCIUR"];
            [tempDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"BonusDeal"]] forKey:@"BonusDeal"];
            [tempDict setObject:[aProduct objectForKey:@"SamplesAvailable"] forKey:@"SamplesAvailable"];
        } else {
            NSString* description = @"Product unassigned";
            combinationKey = [NSString stringWithFormat:@"%@->%d", description, [tmpProductIUR intValue]];
            [tempDict setObject:description forKey:@"Description"];
            [tempDict setObject:combinationKey forKey:@"CombinationKey"];
            //use for display the name on input pad
            [tempDict setObject:description forKey:@"Details"];
            [tempDict setObject:@"" forKey:@"OrderPadDetails"];
            [tempDict setObject:@"" forKey:@"ProductCode"];
            [tempDict setObject:@"" forKey:@"ProductSize"];
            //            NSLog(@"aProduct.UnitsPerPack not: %@",aProduct.UnitsPerPack);
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitPrice"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitsPerPack"];
            //            NSLog(@"product not found for order line %@",aProduct.Description);
            [tempDict setObject:[NSNumber numberWithInt:78] forKey:@"Bonusby"];
            [tempDict setObject:[NSNumber numberWithInt:9999] forKey:@"StockAvailable"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"StockonHand"];
            //add ImageIUR BonusGiven BonusRequired SellBy 08/01/2015
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"ImageIUR"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"BonusGiven"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"BonusRequired"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"SellBy"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"BonusMinimum"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"Active"];
//            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"PriceFlag"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"MinimumUnitPrice"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitRRP"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"VCIUR"];
            [tempDict setObject:@"" forKey:@"BonusDeal"];
            [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"SamplesAvailable"];
        }
        [tempDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        [finalOrderlineDict setObject:tempDict forKey:combinationKey];
    }    
    [GlobalSharedClass shared].currentSelectedContactIUR = [self.orderRestoreDict objectForKey:@"ContactIUR"];
    [OrderSharedClass sharedOrderSharedClass].currentFormIUR = [self.orderRestoreDict objectForKey:@"FormIUR"];
    int lastOrderFormIUR = [[OrderSharedClass sharedOrderSharedClass].currentFormIUR intValue];
    if (lastOrderFormIUR != 0) {
        [GlobalSharedClass shared].lastOrderFormIUR = [NSNumber numberWithInt:lastOrderFormIUR];
    }
    [OrderSharedClass sharedOrderSharedClass].currentOrderCart = finalOrderlineDict;
}

- (CompositeErrorResult*)removeOrderRestorePlist {
    return [FileCommon removeFileAtPath:[FileCommon orderRestorePlistPath]];
}

@end
