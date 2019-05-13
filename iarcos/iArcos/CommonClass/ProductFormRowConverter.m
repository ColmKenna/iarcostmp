//
//  ProductFormRowConverter.m
//  Arcos
//
//  Created by David Kilmartin on 09/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ProductFormRowConverter.h"

@implementation ProductFormRowConverter


/*
 Standard Product Specification
 change restore as well
 InStock == Qty SplitPack
 FOC == Bonus SplitPack
 OrderPadDetails == Brands
 PS:connecting to MAT
 BonusGiven
 BonusRequired
 SellBy
 BonusMinimum
 Active
 StockonHand
 PriceFlag added for Price at 07/09/2017 0:default 1: set 2:priceoverride
 MinimumUnitPrice used as weight at 29/01/2017
 RRIUR added for Price Change at 17/08/2018 0:default -1:price change
 UnitRRP at 26/09/2018
 VCIUR at 04/01/2019
 BonusDeal at 08/04/2019
 */
+ (NSMutableDictionary*)createFormRowWithProduct:(NSMutableDictionary*) product {
    NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
    NSString* combinationKey = [NSString stringWithFormat:@"%@->%d",[product objectForKey:@"Description"], [[product objectForKey:@"ProductIUR"]intValue]];
    
    [formRow setObject:combinationKey forKey:@"CombinationKey"];
    [formRow setObject:[product objectForKey:@"ProductIUR"] forKey:@"ProductIUR"];
    [formRow setObject:[product objectForKey:@"UnitTradePrice"] forKey:@"UnitPrice"];
    [formRow setObject:[product objectForKey:@"Description"] forKey:@"Details"];
    [formRow setObject:[product objectForKey:@"UnitsPerPack"] forKey:@"UnitsPerPack"];
    [formRow setObject:[product objectForKey:@"Bonusby"] forKey:@"Bonusby"];
    [formRow setObject:[product objectForKey:@"StockAvailable"] forKey:@"StockAvailable"];
    [formRow setObject:[product objectForKey:@"StockonHand"] forKey:@"StockonHand"];
    //add OrderPadDetails ProductCode ProductSize  at 06-09-2013
    [formRow setObject:[ArcosUtils convertNilToEmpty:[product objectForKey:@"OrderPadDetails"]] forKey:@"OrderPadDetails"];
    [formRow setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils trim:[product objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
    [formRow setObject:[ArcosUtils convertNilToEmpty:[product objectForKey:@"Productsize"]] forKey:@"ProductSize"];
    [formRow setObject:[product objectForKey:@"ImageIUR"] forKey:@"ImageIUR"];
    //add BonusGiven BonusRequired SellBy at 07/01/2015
    [formRow setObject:[product objectForKey:@"BonusGiven"] forKey:@"BonusGiven"];
    [formRow setObject:[product objectForKey:@"BonusRequired"] forKey:@"BonusRequired"];
    [formRow setObject:[product objectForKey:@"SellBy"] forKey:@"SellBy"];
    [formRow setObject:[product objectForKey:@"BonusMinimum"] forKey:@"BonusMinimum"];
    [formRow setObject:[product objectForKey:@"Active"] forKey:@"Active"];
    [formRow setObject:[ArcosUtils convertNilToZero:[product objectForKey:@"PriceFlag"]] forKey:@"PriceFlag"];
    [formRow setObject:[product objectForKey:@"MinimumUnitPrice"] forKey:@"MinimumUnitPrice"];
    [formRow setObject:[ArcosUtils convertNilToZero:[product objectForKey:@"RRIUR"]] forKey:@"RRIUR"];
    [formRow setObject:[product objectForKey:@"UnitRRP"] forKey:@"UnitRRP"];
    [formRow setObject:[product objectForKey:@"VCIUR"] forKey:@"VCIUR"];
    [formRow setObject:[ArcosUtils convertNilToEmpty:[product objectForKey:@"BonusDeal"]] forKey:@"BonusDeal"];
    
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
    [formRow setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
    [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"LineValue"];
    
    if ([[ArcosUtils convertNilToZero:[product objectForKey:@"PriceFlag"]] intValue] == 1 && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountFromPriceFlag]) {
        NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
        SettingManager* sm = [SettingManager setting];
        NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
        NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
        NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
        if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag]) {
            [formRow setObject:[ArcosUtils convertNilToZero:[product objectForKey:@"DiscountPercent"]]  forKey:@"DiscountPercent"];
        } else {
            [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"DiscountPercent"];
        }
    } else {
        [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"DiscountPercent"];
    }
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
    [formRow setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    
    return formRow;
}

/*
 Standard Form Row Spec
 FormIUR
 SequenceDivicer
 SequenceNumber
 DefaultQty
 DefaultPercent
 */
+ (NSMutableDictionary*)createOrderPadFormRowWrapper:(NSMutableDictionary*)aStdFormRowDict formRow:(NSDictionary*)aRawFormRowDict {
    NSMutableDictionary* orderPadFormRow = [NSMutableDictionary dictionaryWithDictionary:aStdFormRowDict];
    [orderPadFormRow setObject:[aRawFormRowDict objectForKey:@"FormIUR"] forKey:@"FormIUR"];
    [orderPadFormRow setObject:[aRawFormRowDict objectForKey:@"SequenceDivider"] forKey:@"SequenceDivider"];
    [orderPadFormRow setObject:[aRawFormRowDict objectForKey:@"SequenceNumber"] forKey:@"SequenceNumber"];
    
    [orderPadFormRow setObject:[aRawFormRowDict objectForKey:@"DefaultQty"] forKey:@"DefaultQty"];
    [orderPadFormRow setObject:[aRawFormRowDict objectForKey:@"TradePrice"] forKey:@"DefaultPercent"];
    
    return orderPadFormRow;
}

+ (NSMutableDictionary*)createFormRowWithOrderLine:(NSMutableDictionary*)anOrderLine {
    NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
    NSString* combinationKey = [NSString stringWithFormat:@"%@->%d",[anOrderLine objectForKey:@"Description"], [[anOrderLine objectForKey:@"ProductIUR"]intValue]];
    
    [formRow setObject:combinationKey forKey:@"CombinationKey"];
    [formRow setObject:[anOrderLine objectForKey:@"ProductIUR"] forKey:@"ProductIUR"];
    [formRow setObject:[anOrderLine objectForKey:@"UnitPrice"] forKey:@"UnitPrice"];
    [formRow setObject:[anOrderLine objectForKey:@"Description"] forKey:@"Details"];
    [formRow setObject:[anOrderLine objectForKey:@"UnitsPerPack"] forKey:@"UnitsPerPack"];
    [formRow setObject:[anOrderLine objectForKey:@"Bonusby"] forKey:@"Bonusby"];
    [formRow setObject:[anOrderLine objectForKey:@"StockAvailable"] forKey:@"StockAvailable"];
    [formRow setObject:[anOrderLine objectForKey:@"StockonHand"] forKey:@"StockonHand"];
    [formRow setObject:[anOrderLine objectForKey:@"ImageIUR"] forKey:@"ImageIUR"];
    
    [formRow setObject:[anOrderLine objectForKey:@"Bonus"] forKey:@"Bonus"];
    [formRow setObject:[anOrderLine objectForKey:@"Qty"] forKey:@"Qty"];
    [formRow setObject:[anOrderLine objectForKey:@"LineValue"]  forKey:@"LineValue"];
    [formRow setObject:[anOrderLine objectForKey:@"DiscountPercent"]  forKey:@"DiscountPercent"];
    [formRow setObject:[anOrderLine objectForKey:@"InStock"] forKey:@"InStock"];
    [formRow setObject:[anOrderLine objectForKey:@"FOC"] forKey:@"FOC"];
    //add OrderPadDetails ProductCode ProductSize BonusGiven BonusRequired SellBy 08/01/2015
    [formRow setObject:[anOrderLine objectForKey:@"OrderPadDetails"] forKey:@"OrderPadDetails"];
    [formRow setObject:[anOrderLine objectForKey:@"ProductCode"] forKey:@"ProductCode"];
    [formRow setObject:[anOrderLine objectForKey:@"ProductSize"]  forKey:@"ProductSize"];
    [formRow setObject:[anOrderLine objectForKey:@"BonusGiven"]  forKey:@"BonusGiven"];
    [formRow setObject:[anOrderLine objectForKey:@"BonusRequired"] forKey:@"BonusRequired"];
    [formRow setObject:[anOrderLine objectForKey:@"SellBy"] forKey:@"SellBy"];
    [formRow setObject:[anOrderLine objectForKey:@"BonusMinimum"] forKey:@"BonusMinimum"];
    [formRow setObject:[ArcosUtils convertNilToZero:[anOrderLine objectForKey:@"Active"]] forKey:@"Active"];
    [formRow setObject:[ArcosUtils convertNilToZero:[anOrderLine objectForKey:@"PriceFlag"]] forKey:@"PriceFlag"];
    [formRow setObject:[anOrderLine objectForKey:@"MinimumUnitPrice"] forKey:@"MinimumUnitPrice"];
    [formRow setObject:[ArcosUtils convertNilToZero:[anOrderLine objectForKey:@"RRIUR"]] forKey:@"RRIUR"];
    [formRow setObject:[anOrderLine objectForKey:@"UnitRRP"] forKey:@"UnitRRP"];
    [formRow setObject:[anOrderLine objectForKey:@"VCIUR"] forKey:@"VCIUR"];
    [formRow setObject:[ArcosUtils convertNilToEmpty:[anOrderLine objectForKey:@"BonusDeal"]] forKey:@"BonusDeal"];
    return formRow;
}

+ (NSMutableDictionary*)createBlankFormRowWithProductIUR:(NSNumber*)aProductIUR {
    NSString* description = @"Product not found";
    NSString* blankString = @"";
    NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
    NSString* combinationKey = [NSString stringWithFormat:@"%@->%d", description, [aProductIUR intValue]];
    
    [formRow setObject:combinationKey forKey:@"CombinationKey"];
    [formRow setObject:aProductIUR forKey:@"ProductIUR"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"UnitPrice"];
    [formRow setObject:description forKey:@"Details"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"UnitsPerPack"];
    [formRow setObject:[NSNumber numberWithInt:78] forKey:@"Bonusby"];
    [formRow setObject:[NSNumber numberWithInt:9999] forKey:@"StockAvailable"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"StockonHand"];
    //add OrderPadDetails ProductCode ProductSize  at 06-09-2013
    [formRow setObject:blankString forKey:@"OrderPadDetails"];
    [formRow setObject:blankString forKey:@"ProductCode"];
    [formRow setObject:blankString forKey:@"ProductSize"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"ImageIUR"];
    //add BonusGiven BonusRequired SellBy at 07/01/2015
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"BonusGiven"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"BonusRequired"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"SellBy"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"BonusMinimum"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"Active"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"PriceFlag"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"MinimumUnitPrice"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"RRIUR"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"UnitRRP"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"VCIUR"];
    [formRow setObject:@"" forKey:@"BonusDeal"];
    
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
    [formRow setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
    [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"LineValue"];
    [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"DiscountPercent"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
    [formRow setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    
    return formRow;
}

+ (BOOL)showSeparatorWithFormIUR:(NSNumber*)aFormIUR {
    NSDictionary* formDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:aFormIUR];
    if (formDetailDict != nil) {
        NSNumber* showSeparator = [formDetailDict objectForKey:@"ShowSeperators"];
        return [showSeparator boolValue];
    }
    return NO;
}

+ (BOOL)isSelectedWithFormRowDict:(NSMutableDictionary*)aFormRowDict {    
    NSNumber* qty = [aFormRowDict objectForKey:@"Qty"];
    NSNumber* bonus = [aFormRowDict objectForKey:@"Bonus"];
    NSNumber* inStock = [aFormRowDict objectForKey:@"InStock"];
    NSNumber* foc = [aFormRowDict objectForKey:@"FOC"];
    if (([qty intValue] <= 0 || qty == nil) && ([bonus intValue] <= 0 || bonus==nil) 
        && ([inStock intValue] <= 0 || inStock == nil) && ([foc intValue] <= 0 || foc == nil)){
        return NO;
    }
    return YES;
}

+ (NSMutableDictionary*)convertToOrderProductDict:(NSMutableDictionary*)aDict {
    [aDict setObject: [aDict objectForKey:@"Details"]  forKey:@"Description"];
    return aDict;
}

+ (BOOL)showSeparatorWithFormType:(NSString*)aFormType {
    NSDictionary* formDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormType:aFormType];
    if (formDetailDict != nil) {
        NSNumber* showSeparator = [formDetailDict objectForKey:@"ShowSeperators"];
        return [showSeparator boolValue];
    }
    return NO;
}

+ (NSNumber*)calculateLineValue:(NSMutableDictionary*)aProductDetailDict {
    NSNumber* total = [NSNumber numberWithFloat:[[aProductDetailDict objectForKey:@"Qty"] intValue] * [[aProductDetailDict objectForKey:@"UnitPrice"] floatValue]];
    
    NSNumber* unitsPerPack = [aProductDetailDict objectForKey:@"UnitsPerPack"];
    int tmpSpQty = [[aProductDetailDict objectForKey:@"InStock"] intValue];
    if (tmpSpQty != 0 && [unitsPerPack intValue] != 0 && ![[ArcosConfigDataManager sharedArcosConfigDataManager] recordInStockRBFlag]) {
        float splitPackValue = [[aProductDetailDict objectForKey:@"UnitPrice"] floatValue] / [unitsPerPack intValue] * tmpSpQty;
        total = [NSNumber numberWithFloat:[total floatValue]+splitPackValue];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useWeightToCalculatePriceFlag]) {
        int minUnitPrice = [[aProductDetailDict objectForKey:@"MinimumUnitPrice"] intValue];
        if (minUnitPrice != 0) {
            total = [NSNumber numberWithFloat:([total floatValue] * minUnitPrice / 100)];
        }
    }
    total = [NSNumber numberWithFloat:[ArcosUtils roundFloatTwoDecimal:[total floatValue] * (1.0 - ([[aProductDetailDict objectForKey:@"DiscountPercent"] floatValue] / 100))]];
    return total;
}

+ (NSMutableDictionary*)createStandardOrderLine:(NSMutableDictionary*)tempDict product:(NSDictionary*)aProduct {
    if (aProduct!=nil) {        
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Description"]] forKey:@"Description"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"OrderPadDetails"]]] forKey:@"OrderPadDetails"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Productsize"]]] forKey:@"ProductSize"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Description"]] forKey:@"Details"];
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
//        [tempDict setObject:[aProduct objectForKey:@"UnitTradePrice"] forKey:@"UnitPrice"];
        [tempDict setObject:[ArcosUtils convertNilToZero:[aProduct objectForKey:@"PriceFlag"]] forKey:@"PriceFlag"];
        [tempDict setObject:[aProduct objectForKey:@"MinimumUnitPrice"] forKey:@"MinimumUnitPrice"];
//        [tempDict setObject:[ArcosUtils convertNilToZero:[aProduct objectForKey:@"RRIUR"]] forKey:@"RRIUR"];
        [tempDict setObject:[aProduct objectForKey:@"UnitRRP"] forKey:@"UnitRRP"];
        [tempDict setObject:[aProduct objectForKey:@"VCIUR"] forKey:@"VCIUR"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"BonusDeal"]] forKey:@"BonusDeal"];
        [tempDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"EAN"]] forKey:@"EAN"];
    }else{
        [tempDict setObject:@"Product unassigned" forKey:@"Description"];
        //use for display the name on input pad
        [tempDict setObject:@"Product unassigned" forKey:@"Details"];
        [tempDict setObject:@"" forKey:@"OrderPadDetails"];
        [tempDict setObject:@"" forKey:@"ProductCode"];
        [tempDict setObject:@"" forKey:@"ProductSize"];
        //            NSLog(@"aProduct.UnitsPerPack not: %@",aProduct.UnitsPerPack);
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
        [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"PriceFlag"];
        [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"MinimumUnitPrice"];
        [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"RRIUR"];
        [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitRRP"];
        [tempDict setObject:[NSNumber numberWithInt:0] forKey:@"VCIUR"];
        [tempDict setObject:@"" forKey:@"BonusDeal"];
        [tempDict setObject:@"" forKey:@"EAN"];
    }
    return tempDict;
}

+ (NSMutableArray*)convertManagedCalltranSet:(NSSet*)calltranSet {
    NSMutableArray* calltranList = [NSMutableArray arrayWithCapacity:[calltranSet count]];
    for (CallTran* CT in calltranSet) {
        ArcosCallTran* aCalltran = [[ArcosCallTran alloc]init];
        
        aCalltran.ProductIUR = [CT.ProductIUR intValue];
        aCalltran.DetailIUR = [CT.DetailIUR intValue];
        aCalltran.Score = [CT.Score intValue];
        aCalltran.DetailLevel = CT.DetailLevelIUR;
        aCalltran.DTIUR = 0;
        aCalltran.Reference = CT.Reference;
        if ([aCalltran.DetailLevel isEqualToString:@"PS"]) {
            aCalltran.Reference = [ArcosUtils convertNumberToIntString:CT.Score];
        }
        
        [calltranList addObject:aCalltran];
        [aCalltran release];
    }
    return calltranList;
}

+ (void)addProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict productDict:(NSDictionary*)aProductDict {
    [aLocationProductMatDict setObject:[aProductDict objectForKey:@"Description"] forKey:@"Details"];
    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[aProductDict objectForKey:@"OrderPadDetails"]] forKey:@"OrderPadDetails"];
    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils trim:[aProductDict objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[aProductDict objectForKey:@"Productsize"]] forKey:@"ProductSize"];
}

+ (void)addBlankProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict {
    [aLocationProductMatDict setObject:@"Product not found" forKey:@"Details"];
    [aLocationProductMatDict setObject:@"" forKey:@"OrderPadDetails"];
    [aLocationProductMatDict setObject:@"" forKey:@"ProductCode"];
    [aLocationProductMatDict setObject:@"" forKey:@"ProductSize"];
}

+ (void)resetFormRowFigureWithFormRowDict:(NSMutableDictionary*)aFormRowDict {
    [aFormRowDict setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
    [aFormRowDict setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
    [aFormRowDict setObject:[NSNumber numberWithFloat:0]  forKey:@"LineValue"];
    [aFormRowDict setObject:[NSNumber numberWithFloat:0]  forKey:@"DiscountPercent"];
    [aFormRowDict setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
    [aFormRowDict setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
    [aFormRowDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
}

@end
