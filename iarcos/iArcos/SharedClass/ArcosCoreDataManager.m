//
//  ArcosCoreDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 20/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosCoreDataManager.h"

@implementation ArcosCoreDataManager

-(Product*)populateProductWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject product:(Product*)Product {
    Product.ProductIUR = [ArcosUtils convertStringToNumber:anObject.Field1];
    Product.ProductCode    =    [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field2]]];
    
    if (anObject.Field3==nil||[anObject.Field3 isEqualToString:@""]) {
        anObject.Field3=@"Unknown product description";
    }
    
    Product.Description    =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field3]];    
    Product.L1Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field4]];
    Product.L2Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field5]];
    Product.L3Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field6]];
    Product.L4Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field7]];
    Product.L5Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field8]];
    Product.UnitTradePrice =    [NSDecimalNumber decimalNumberWithString:anObject.Field9];
//    NSLog(@"ArcosCoreDataManager Product.UnitTradePrice is: %@",Product.UnitTradePrice);
    Product.Active          = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field10]];
    Product.Productsize = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field11]];
    Product.UnitsPerPack = [ArcosUtils convertStringToNumber:anObject.Field12];
    
    Product.FOrDetailing = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field13]];
    Product.SamplesAvailable = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:anObject.Field14]]];
    //[NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field14]];
    Product.ForSampling = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field15]];
    Product.Scoreprocedure = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field16]];
    @try {
        NSString* bonusBy = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:anObject.Field17]];
        if (bonusBy.length > 0) {
            char firstLetter = [bonusBy characterAtIndex:0];
            Product.Bonusby = [NSNumber numberWithInt:(int)firstLetter];
        }        
    }
    @catch (NSException *exception) {
        Product.Bonusby = [NSNumber numberWithInt:0];
    }    
    Product.StockAvailable = [ArcosUtils convertStringToNumber:anObject.Field18];
    Product.OrderPadDetails = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field19]];
    Product.ImageIUR = [ArcosUtils convertStringToNumber:anObject.Field20];
    Product.BonusGiven = [ArcosUtils convertStringToNumber:anObject.Field21];
    Product.BonusRequired = [ArcosUtils convertStringToNumber:anObject.Field22];
    if ([ArcosValidator isInteger:anObject.Field23]) {
        Product.SellBy = [ArcosUtils convertStringToNumber:anObject.Field23];
    } else {
        Product.SellBy = [NSNumber numberWithInt:0];
    }
    if ([Product.BonusGiven intValue] != 0 && [Product.BonusRequired intValue] != 0) {
        Product.Description    =    [NSString stringWithFormat:@"%@ [%@ for %@]",[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field3]], Product.BonusGiven, Product.BonusRequired];
    }
    NSString* tmpDesc = nil;
    if ([Product.Description length] <= 10) {
        tmpDesc = Product.Description;
    } else if ([Product.Description length] > 10){
        tmpDesc = [Product.Description substringToIndex:10];
    }
    Product.ColumnDescription = [NSString stringWithFormat:@"%d%@",[Product.Active intValue], tmpDesc];
    Product.BonusMinimum = [ArcosUtils convertStringToNumber:anObject.Field24];
    Product.EAN = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field25]];
    Product.FlagIUR = [ArcosUtils convertStringToNumber:anObject.Field26];
    Product.MinimumUnitPrice = [ArcosUtils convertStringToNumber:anObject.Field27];
    Product.PackEAN = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field28]];
    float unitRRPFloatValue = [[ArcosUtils convertStringToFloatNumber:anObject.Field29] floatValue];
    int unitRRPIntValue = (int)(unitRRPFloatValue * 100);    
    Product.UnitRRP = [NSNumber numberWithInt:unitRRPIntValue];
    float unitManufacturePriceFloatValue = [[ArcosUtils convertStringToFloatNumber:anObject.Field30] floatValue];
    int unitManufacturePriceIntValue = (int)(unitManufacturePriceFloatValue * 100);
    Product.UnitManufacturePrice = [NSNumber numberWithInt:unitManufacturePriceIntValue];
    float unitRevenueAmountFloatValue = [[ArcosUtils convertStringToFloatNumber:anObject.Field31] floatValue];
    int unitRevenueAmountIntValue = (int)(unitRevenueAmountFloatValue * 100);
    Product.UnitRevenueAmount = [NSNumber numberWithInt:unitRevenueAmountIntValue];
    Product.AdvertFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field32]];
    Product.DetailingFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field33]];
    Product.PackFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field34]];
    Product.POSFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field35]];
    Product.RadioFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field36]];
    Product.VCIUR = [ArcosUtils convertStringToNumber:anObject.Field37];
    Product.ProductColour = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field38]];
    
    return Product;
}
-(Product*)populateProductWithFieldList:(NSArray*)aFieldList product:(Product*)Product {
    Product.ProductIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Product.ProductCode    =    [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:1]]]];
    NSString* description = [aFieldList objectAtIndex:2];
    if (description==nil||[description isEqualToString:@""]) {
        description=@"Unknown product description";
    }
    
    Product.Description    =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:description]];
    Product.L1Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:3]]];
    Product.L2Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:4]]];
    Product.L3Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:5]]];
    Product.L4Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:6]]];
    Product.L5Code         =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:7]]];
    Product.UnitTradePrice =    [NSDecimalNumber decimalNumberWithString:[aFieldList objectAtIndex:8]];
    //    NSLog(@"ArcosCoreDataManager Product.UnitTradePrice is: %@",Product.UnitTradePrice);
    Product.Active          = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:9]]];
    Product.Productsize = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:10]]];
    Product.UnitsPerPack = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:11]];
    
    Product.FOrDetailing = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:12]]];
    Product.SamplesAvailable = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:13]];
    Product.ForSampling = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:14]]];
    Product.Scoreprocedure = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:15]]];
    @try {
        NSString* bonusBy = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:16]]];
        if (bonusBy.length > 0) {
            char firstLetter = [bonusBy characterAtIndex:0];
            Product.Bonusby = [NSNumber numberWithInt:(int)firstLetter];
        }
    }
    @catch (NSException *exception) {
        Product.Bonusby = [NSNumber numberWithInt:0];
    }
    Product.StockAvailable = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:17]];
    Product.OrderPadDetails = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:18]]];
    Product.ImageIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:19]];
    Product.BonusGiven = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:20]];
    Product.BonusRequired = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:21]];
    if ([ArcosValidator isInteger:[aFieldList objectAtIndex:22]]) {
        Product.SellBy = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:22]];
    } else {
        Product.SellBy = [NSNumber numberWithInt:0];
    }
    if ([Product.BonusGiven intValue] != 0 && [Product.BonusRequired intValue] != 0) {
        Product.Description    =    [NSString stringWithFormat:@"%@ [%@ for %@]",[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:description]], Product.BonusGiven, Product.BonusRequired];
    }
    NSString* tmpDesc = nil;
    if ([Product.Description length] <= 10) {
        tmpDesc = Product.Description;
    } else if ([Product.Description length] > 10){
        tmpDesc = [Product.Description substringToIndex:10];
    }
    Product.ColumnDescription = [NSString stringWithFormat:@"%d%@",[Product.Active intValue], tmpDesc];
    Product.BonusMinimum = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:23]];
    Product.EAN = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:24]]];
    Product.FlagIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:25]];
    Product.MinimumUnitPrice = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:26]];
    Product.PackEAN = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:27]]];
    float unitRRPFloatValue = [[ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:28]] floatValue];
    int unitRRPIntValue = (int)(unitRRPFloatValue * 100);    
    Product.UnitRRP = [NSNumber numberWithInt:unitRRPIntValue];
    float unitManufacturePriceFloatValue = [[ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:29]] floatValue];
    int unitManufacturePriceIntValue = (int)(unitManufacturePriceFloatValue * 100);
    Product.UnitManufacturePrice = [NSNumber numberWithInt:unitManufacturePriceIntValue];
    float unitRevenueAmountFloatValue = [[ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:30]] floatValue];
    int unitRevenueAmountIntValue = (int)(unitRevenueAmountFloatValue * 100);
    Product.UnitRevenueAmount = [NSNumber numberWithInt:unitRevenueAmountIntValue];
    Product.AdvertFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:31]]];
    Product.DetailingFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:32]]];
    Product.PackFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:33]]];
    Product.POSFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:34]]];
    Product.RadioFiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:35]]];
    Product.VCIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:36]];
    Product.ProductColour = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:37]]];
    
    return Product;
}
-(LocationProductMAT*)populateLocationProductMATWithFieldList:(NSArray*)aFieldList locationProductMAT:(LocationProductMAT*)anLocationProductMAT levelIUR:(NSNumber*)aLevelIUR {
    anLocationProductMAT.locationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    anLocationProductMAT.productIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]];

    anLocationProductMAT.qty01 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:2]];
    anLocationProductMAT.qty02 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:3]];
    anLocationProductMAT.qty03 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:4]];
    anLocationProductMAT.qty04 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:5]];
    anLocationProductMAT.qty05 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:6]];
    anLocationProductMAT.qty06 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:7]];
    anLocationProductMAT.qty07 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:8]];
    anLocationProductMAT.qty08 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:9]];
    anLocationProductMAT.qty09 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:10]];
    anLocationProductMAT.qty10 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:11]];
    anLocationProductMAT.qty11 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:12]];
    anLocationProductMAT.qty12 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:13]];
    anLocationProductMAT.qty13 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:14]];
    anLocationProductMAT.qty14 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:15]];
    anLocationProductMAT.qty15 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:16]];
    anLocationProductMAT.qty16 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:17]];
    anLocationProductMAT.qty17 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:18]];
    anLocationProductMAT.qty18 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:19]];
    anLocationProductMAT.qty19 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:20]];
    anLocationProductMAT.qty20 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:21]];
    anLocationProductMAT.qty21 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:22]];
    anLocationProductMAT.qty22 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:23]];
    anLocationProductMAT.qty23 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:24]];
    anLocationProductMAT.qty24 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:25]];
    anLocationProductMAT.qty25 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:26]];

    anLocationProductMAT.bonus01 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:27]];
    anLocationProductMAT.bonus02 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:28]];
    anLocationProductMAT.bonus03 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:29]];
    anLocationProductMAT.bonus04 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:30]];
    anLocationProductMAT.bonus05 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:31]];
    anLocationProductMAT.bonus06 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:32]];
    anLocationProductMAT.bonus07 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:33]];
    anLocationProductMAT.bonus08 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:34]];
    anLocationProductMAT.bonus09 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:35]];
    anLocationProductMAT.bonus10 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:36]];
    anLocationProductMAT.bonus11 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:37]];
    anLocationProductMAT.bonus12 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:38]];
    anLocationProductMAT.bonus13 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:39]];
    anLocationProductMAT.bonus14 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:40]];
    anLocationProductMAT.bonus15 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:41]];
    anLocationProductMAT.bonus16 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:42]];
    anLocationProductMAT.bonus17 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:43]];
    anLocationProductMAT.bonus18 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:44]];
    anLocationProductMAT.bonus19 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:45]];
    anLocationProductMAT.bonus20 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:46]];
    anLocationProductMAT.bonus21 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:47]];
    anLocationProductMAT.bonus22 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:48]];
    anLocationProductMAT.bonus23 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:49]];
    anLocationProductMAT.bonus24 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:50]];
    anLocationProductMAT.bonus25 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:51]];
    

    anLocationProductMAT.sales01 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:52]]];
    anLocationProductMAT.sales02 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:53]]];
    anLocationProductMAT.sales03 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:54]]];
    anLocationProductMAT.sales04 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:55]]];
    anLocationProductMAT.sales05 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:56]]];
    anLocationProductMAT.sales06 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:57]]];
    anLocationProductMAT.sales07 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:58]]];
    anLocationProductMAT.sales08 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:59]]];
    anLocationProductMAT.sales09 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:60]]];
    anLocationProductMAT.sales10 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:61]]];
    anLocationProductMAT.sales11 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:62]]];
    anLocationProductMAT.sales12 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:63]]];
    anLocationProductMAT.sales13 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:64]]];
    anLocationProductMAT.sales14 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:65]]];
    anLocationProductMAT.sales15 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:66]]];
    anLocationProductMAT.sales16 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:67]]];
    anLocationProductMAT.sales17 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:68]]];
    anLocationProductMAT.sales18 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:69]]];
    anLocationProductMAT.sales19 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:70]]];
    anLocationProductMAT.sales20 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:71]]];
    anLocationProductMAT.sales21 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:72]]];
    anLocationProductMAT.sales22 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:73]]];
    anLocationProductMAT.sales23 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:74]]];
    anLocationProductMAT.sales24 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:75]]];
    anLocationProductMAT.sales25 = [NSDecimalNumber decimalNumberWithString:[ArcosUtils convertBlankToZero:[aFieldList objectAtIndex:76]]];
    
    anLocationProductMAT.inStock = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:77]];
    NSString* dateLastModifiedStr = [aFieldList objectAtIndex:78];
    anLocationProductMAT.dateLastModified = [ArcosUtils addHours:1 date:[ArcosUtils dateFromString:dateLastModifiedStr format:[GlobalSharedClass shared].dateFormat]];
    anLocationProductMAT.levelIUR = aLevelIUR;
    
    return anLocationProductMAT;
}

-(DescrDetail*)populateDescrDetailWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject descrDetail:(DescrDetail*)DescrDetail {
    DescrDetail.DescrDetailIUR  = [ArcosUtils convertStringToNumber:anObject.Field1];
    DescrDetail.DescrTypeCode   = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field2]]; 
    DescrDetail.Detail          = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field3]];
    DescrDetail.DescrDetailCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field4]];
    DescrDetail.ImageIUR        = [ArcosUtils convertStringToNumber:anObject.Field5];
    DescrDetail.ForDetailing = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field6]];
    DescrDetail.ProfileOrder = [ArcosUtils convertStringToNumber:anObject.Field7];
    DescrDetail.Active = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:anObject.Field8]];
    DescrDetail.ParentCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field9]];
    DescrDetail.DetailingFiles = [ArcosUtils convertNilToEmpty:anObject.Field10];
    DescrDetail.CodeType = [ArcosUtils convertStringToNumber:anObject.Field11];
    DescrDetail.Tooltip = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field12]];
    DescrDetail.Toggle1 = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field13]];
    float dec1FloatValue = [[ArcosUtils convertStringToFloatNumber:anObject.Field14] floatValue];
    int dec1IntValue = (int)(dec1FloatValue * 100);
    DescrDetail.Dec1 = [NSNumber numberWithInt:dec1IntValue];
    DescrDetail.Nominal = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field15]];
    return DescrDetail;
}

-(DescrDetail*)populateDescrDetailWithFieldList:(NSArray*)aFieldList descrDetail:(DescrDetail*)DescrDetail {
    DescrDetail.DescrDetailIUR  = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    DescrDetail.DescrTypeCode   = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:1]]];
    DescrDetail.Detail          = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:2]]];
    DescrDetail.DescrDetailCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:3]]];
    DescrDetail.ImageIUR        = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:4]];
    DescrDetail.ForDetailing = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:5]]];
    DescrDetail.ProfileOrder = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:6]];
    DescrDetail.Active = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:[aFieldList objectAtIndex:7]]];
    DescrDetail.ParentCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:8]]];
    DescrDetail.DetailingFiles = [ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:9]];
    DescrDetail.CodeType = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:10]];
    DescrDetail.Tooltip = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:11]]];
    DescrDetail.Toggle1 = [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:12]]];
    float dec1FloatValue = [[ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:13]] floatValue];
    int dec1IntValue = (int)(dec1FloatValue * 100);
    DescrDetail.Dec1 = [NSNumber numberWithInt:dec1IntValue];
    DescrDetail.Nominal = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:14]]];
    return DescrDetail;
}

-(Package*)populatePackageWithFieldList:(NSArray*)aFieldList package:(Package*)Package {
    Package.iUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Package.locationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]];
    Package.wholesalerIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:2]];
    Package.pGiur = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:3]];
    Package.accountCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:4]]];
    Package.xxIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:5]];
    Package.yyIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:6]];
    Package.xxString = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:7]]];
    Package.formIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:8]];
    Package.active = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:[aFieldList objectAtIndex:9]]];
    Package.allowBonus = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:[aFieldList objectAtIndex:10]]];
    Package.defaultPackage = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:[aFieldList objectAtIndex:11]]];
    return Package;
}

-(Location*)populateLocationWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject location:(Location*)Location {
    Location.LocationIUR        =    [ArcosUtils convertStringToNumber:anObject.Field1];    
    Location.LocationCode		=    [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field2]]];
    
    if (anObject.Field3 == nil || [anObject.Field3 isEqualToString:@""]) {
        anObject.Field3 = [NSString stringWithFormat: @"Noname Shop -- %d", [Location.LocationIUR intValue]];
    }
    
    Location.Name				=    [ArcosUtils convertToString:anObject.Field3];
    Location.SortKey            =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field4]];
    Location.Address1			=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field5]];
    Location.Address2			=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field6]];
    Location.Address3			=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field7]];
    Location.Address4			=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field8]];

    Location.PhoneNumber		=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field9]];
    Location.FaxNumber          =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field10]];
    Location.CCiur				=    [ArcosUtils convertStringToNumber:anObject.Field11];
    Location.TCiur				=    [ArcosUtils convertStringToNumber:anObject.Field12];
    Location.CSiur				=    [ArcosUtils convertStringToNumber:anObject.Field13];
    Location.LTiur				=    [ArcosUtils convertStringToNumber:anObject.Field14];
    Location.lsiur				=    [ArcosUtils convertStringToNumber:anObject.Field15];
    Location.lP01				=    [ArcosUtils convertStringToNumber:anObject.Field16];
    Location.Latitude           =    [ArcosUtils convertStringToFloatNumber:anObject.Field17];
    Location.Longitude          =    [ArcosUtils convertStringToFloatNumber:anObject.Field18];
    Location.Active             =    [NSNumber numberWithBool: [ArcosUtils convertStringToBool:anObject.Field19]];
    Location.MasterLocationIUR  =    [ArcosUtils convertStringToNumber:anObject.Field20];  
    Location.ImageIUR           =    [ArcosUtils convertStringToNumber:anObject.Field21];
    Location.Email				=    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field22]];
    Location.Password           =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field23]];
    Location.RouteNumber        =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field24]];
    Location.OustandingBalance = [ArcosUtils convertStringToFloatNumber:anObject.Field25];
    Location.AgedAmount1 = [ArcosUtils convertStringToFloatNumber:anObject.Field26];
    Location.AgedAmount2 = [ArcosUtils convertStringToFloatNumber:anObject.Field27];
    Location.AgedAmount3 = [ArcosUtils convertStringToFloatNumber:anObject.Field28];
    Location.AgedAmount4 = [ArcosUtils convertStringToFloatNumber:anObject.Field29];
    Location.lP02				=    [ArcosUtils convertStringToNumber:anObject.Field30];
    Location.lP03				=    [ArcosUtils convertStringToNumber:anObject.Field31];
    Location.lP04				=    [ArcosUtils convertStringToNumber:anObject.Field32];
    Location.lP05				=    [ArcosUtils convertStringToNumber:anObject.Field33];
    Location.lP06				=    [ArcosUtils convertStringToNumber:anObject.Field34];
    Location.lP07				=    [ArcosUtils convertStringToNumber:anObject.Field35];
    Location.lP08				=    [ArcosUtils convertStringToNumber:anObject.Field36];
    Location.lP09				=    [ArcosUtils convertStringToNumber:anObject.Field37];
    Location.lP10				=    [ArcosUtils convertStringToNumber:anObject.Field38];
    Location.accessTimes = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field39]];
    Location.PGiur = [ArcosUtils convertStringToNumber:anObject.Field40];
    float priceOverrideFloatValue = [[ArcosUtils convertStringToFloatNumber:anObject.Field41] floatValue];
    int priceOverrideIntValue = (int)(priceOverrideFloatValue * 100);    
    Location.PriceOverride = [NSNumber numberWithInt:priceOverrideIntValue];
    Location.CUiur = [ArcosUtils convertStringToNumber:anObject.Field42];
    Location.DialupNumber = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field43]];
    Location.Address5            =    [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field44]];
    Location.Competitor3 = [ArcosUtils convertStringToNumber:anObject.Field45];
    Location.lP20                =    [ArcosUtils convertStringToNumber:anObject.Field46];
    Location.lP19                =    [ArcosUtils convertStringToNumber:anObject.Field47];
    
    return Location;
}

-(Location*)populateLocationWithFieldList:(NSArray*)aFieldList location:(Location*)Location {
    Location.LocationIUR        =    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Location.LocationCode		=    [ArcosUtils trim:[ArcosUtils convertToString:[aFieldList objectAtIndex:1]]];
    NSString* myName = [aFieldList objectAtIndex:2];
    if (myName == nil || [myName isEqualToString:@""]) {
        myName = [NSString stringWithFormat: @"Noname Shop -- %d", [Location.LocationIUR intValue]];
    }
    
    Location.Name				=    [ArcosUtils convertToString:myName];
    Location.SortKey            =    [ArcosUtils convertToString:[aFieldList objectAtIndex:3]];
    Location.Address1			=    [ArcosUtils convertToString:[aFieldList objectAtIndex:4]];
    Location.Address2			=    [ArcosUtils convertToString:[aFieldList objectAtIndex:5]];
    Location.Address3			=    [ArcosUtils convertToString:[aFieldList objectAtIndex:6]];
    Location.Address4			=    [ArcosUtils convertToString:[aFieldList objectAtIndex:7]];
    
    Location.PhoneNumber		=    [ArcosUtils convertToString:[aFieldList objectAtIndex:8]];
    Location.FaxNumber          =    [ArcosUtils convertToString:[aFieldList objectAtIndex:9]];
    Location.CCiur				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:10]];
    Location.TCiur				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:11]];
    Location.CSiur				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:12]];
    Location.LTiur				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:13]];
    Location.lsiur				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:14]];
    Location.lP01				=    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:15]];
    Location.Latitude           =    [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:16]];
    Location.Longitude          =    [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:17]];
    Location.Active             =    [NSNumber numberWithBool: [ArcosUtils convertStringToBool:[aFieldList objectAtIndex:18]]];
    Location.MasterLocationIUR  =    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:19]];
    Location.ImageIUR           =    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:20]];
    Location.Email				=    [ArcosUtils convertToString:[aFieldList objectAtIndex:21]];
    Location.Password           =    [ArcosUtils convertToString:[aFieldList objectAtIndex:22]];
    Location.RouteNumber        =    [ArcosUtils convertToString:[aFieldList objectAtIndex:23]];
    Location.OustandingBalance = [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:24]];
    Location.AgedAmount1 = [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:25]];
    Location.AgedAmount2 = [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:26]];
    Location.AgedAmount3 = [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:27]];
    Location.AgedAmount4 = [ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:28]];
    Location.lP02 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:29]];
    Location.lP03 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:30]];
    Location.lP04 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:31]];
    Location.lP05 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:32]];
    Location.lP06 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:33]];
    Location.lP07 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:34]];
    Location.lP08 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:35]];
    Location.lP09 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:36]];
    Location.lP10 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:37]];
    Location.accessTimes = [ArcosUtils convertToString:[aFieldList objectAtIndex:38]];
    Location.PGiur = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:39]];
    float priceOverrideFloatValue = [[ArcosUtils convertStringToFloatNumber:[aFieldList objectAtIndex:40]] floatValue];
    int priceOverrideIntValue = (int)(priceOverrideFloatValue * 100);    
    Location.PriceOverride = [NSNumber numberWithInt:priceOverrideIntValue];
    Location.CUiur                =    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:41]];
    Location.DialupNumber = [ArcosUtils convertToString:[aFieldList objectAtIndex:42]];
    Location.Address5            =    [ArcosUtils convertToString:[aFieldList objectAtIndex:43]];
    Location.Competitor3         =    [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:44]];
    Location.lP20 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:45]];
    Location.lP19 = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:46]];
    
    return Location;
}

-(Price*)populatePriceWithFieldList:(NSArray*)aFieldList price:(Price*)Price {
    Price.IUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Price.LocationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]];
    Price.ProductIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:2]];    
    Price.PGIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:3]];
    Price.UnitTradePrice = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:8]];
    Price.MinimumUnitPrice = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:5]];
    Price.CurrencyIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:6]];
    Price.DiscountPercent = [ArcosUtils convertStringToDecimalNumber:[aFieldList objectAtIndex:7]];
    Price.RebatePercent = [ArcosUtils convertStringToDecimalNumber:[aFieldList objectAtIndex:4]];    
    Price.AllowFree = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:[aFieldList objectAtIndex:9]]];
    
    return Price;
}

-(Promotion*)populatePromotionWithFieldList:(NSArray*)aFieldList promotion:(Promotion*)aPromotion {
    aPromotion.IUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    aPromotion.MemoIUr = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]];
    aPromotion.ProductIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:2]];
    aPromotion.Advertfiles = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:10]]];
    
    return aPromotion;
}

-(Contact*)populateContactWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject contact:(Contact*)Contact {    
    Contact.IUR = [ArcosUtils convertStringToNumber:anObject.Field1];
    Contact.SecondIUR = [ArcosUtils convertStringToNumber:anObject.Field2];
    Contact.Forename = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field3]];
    Contact.Surname = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field4]];
    Contact.Email = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field5]];
    Contact.Initial = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field6]];
    Contact.InitialIUR = [ArcosUtils convertStringToNumber:anObject.Field7];
    Contact.MemoIUR = [ArcosUtils convertStringToNumber:anObject.Field8];
    Contact.MobileNumber = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field9]];
    Contact.PhoneNumber = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field10]];
    Contact.CLiur = [ArcosUtils convertStringToNumber:anObject.Field11];
    Contact.Active = [NSNumber numberWithBool:[ArcosUtils convertStringToBool:anObject.Field12]];
    Contact.COiur = [ArcosUtils convertStringToNumber:anObject.Field13];
    Contact.cP01 = [ArcosUtils convertStringToNumber:anObject.Field14];
    Contact.cP02 = [ArcosUtils convertStringToNumber:anObject.Field15];
    Contact.cP03 = [ArcosUtils convertStringToNumber:anObject.Field16];
    Contact.cP04 = [ArcosUtils convertStringToNumber:anObject.Field17];
    Contact.cP05 = [ArcosUtils convertStringToNumber:anObject.Field18];
    Contact.cP06 = [ArcosUtils convertStringToNumber:anObject.Field19];
    Contact.cP07 = [ArcosUtils convertStringToNumber:anObject.Field20];
    Contact.cP08 = [ArcosUtils convertStringToNumber:anObject.Field21];
    Contact.cP09 = [ArcosUtils convertStringToNumber:anObject.Field22];
    Contact.cP10 = [ArcosUtils convertStringToNumber:anObject.Field23];
    Contact.accessTimes = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field24]];
    Contact.linkedContactIUR = [ArcosUtils convertStringToNumber:anObject.Field25];
    return Contact;
}

-(ConLocLink*)populateConLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject conLocLink:(ConLocLink*)ConLocLink {
    ConLocLink.IUR = [ArcosUtils convertStringToNumber:anObject.Field1];
    ConLocLink.ContactIUR = [ArcosUtils convertStringToNumber:anObject.Field2];
    ConLocLink.LocationIUR = [ArcosUtils convertStringToNumber:anObject.Field3];
    ConLocLink.DefaultContact = [[NSNumber numberWithBool:[ArcosUtils convertStringToBool:anObject.Field4]] stringValue];
    ConLocLink.DefaultLocation = [[NSNumber numberWithBool:[ArcosUtils convertStringToBool:anObject.Field5]] stringValue];
    return ConLocLink;
}

-(Image*)populateImageWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject image:(Image*)Image {
    Image.IUR   =   [ArcosUtils convertStringToNumber:anObject.Field1];
    Image.Title =   anObject.Field2;
    Image.Filename  =  anObject.Field3;
    Image.Thumbnail = anObject.Image;
    return Image;
}

-(FormRow*)populateFormRowWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject formRow:(FormRow*)FormRow {    
    FormRow.IUR =   [ArcosUtils convertStringToNumber:anObject.Field1];
    FormRow.FormIUR =   [ArcosUtils convertStringToNumber:anObject.Field2];
    FormRow.ProductIUR =   [ArcosUtils convertStringToNumber:anObject.Field3];
    FormRow.Details =   anObject.Field4;
    FormRow.SequenceNumber =   [ArcosUtils convertStringToNumber:anObject.Field5];
    FormRow.SequenceDivider =   [ArcosUtils convertStringToNumber:anObject.Field6];
    FormRow.UnitPrice = [ArcosUtils convertStringToDecimalNumber:anObject.Field7];
    FormRow.Level5IUR = [ArcosUtils convertStringToNumber:anObject.Field8];
    FormRow.DefaultQty = [ArcosUtils convertStringToNumber:anObject.Field9];
    FormRow.TradePrice = [ArcosUtils convertStringToDecimalNumber:anObject.Field10];
    return FormRow;
}

-(void)populateResponseWithDataDict:(NSMutableDictionary*)aQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR response:(Response*)aResponse {
    aResponse.IUR = [NSNumber numberWithInt:0];
    aResponse.Answer = [aQuestionDict objectForKey:@"Answer"];
    aResponse.ContactIUR = aContactIUR;
    aResponse.LocationIUR = aLocationIUR;
    aResponse.QuestionIUR = [aQuestionDict objectForKey:@"IUR"];
    aResponse.ResponseDate = [NSDate date];
    //[ArcosUtils todayWithFormat:@"yyyy-MM-dd"];
    //        aResponse.ResponseDate = [ArcosUtils dateFromString:@"2012-02-17" format:@"yyyy-MM-dd"];
    aResponse.SurveyIUR = [aQuestionDict objectForKey:@"SurveyIUR"];
    switch ([[aQuestionDict objectForKey:@"QuestionType"]intValue]) {
        case 2:
        case 8:
        case 10:
            aResponse.ResponseInt = [ArcosUtils convertIntToString:[[aQuestionDict objectForKey:@"QuestionType"] intValue]];
            break;
        default:
            break;
    }
    //ResponseDecimal type 9 response
}

-(void)populateResponseWithSoapOB:(ArcosResponseBO*)anObject response:(Response*)aResponse {
    aResponse.IUR = [NSNumber numberWithInt:anObject.Iur];
    aResponse.Answer = anObject.Answer;
    aResponse.LocationIUR = [NSNumber numberWithInt:anObject.Locationiur];
    aResponse.SurveyIUR = [NSNumber numberWithInt:anObject.Surveyiur];
    aResponse.ContactIUR = [NSNumber numberWithInt:anObject.Contactiur];
    aResponse.QuestionIUR = [NSNumber numberWithInt:anObject.Questioniur];
    aResponse.ResponseDate = anObject.ResponseDate;
    aResponse.ResponseInt = [ArcosUtils convertIntToString:anObject.Responseint];
}

-(void)populateLocLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject locLocLink:(LocLocLink*)aLocLocLink {
    aLocLocLink.IUR = [ArcosUtils convertStringToNumber:anObject.Field1];
    aLocLocLink.LocationIUR = [ArcosUtils convertStringToNumber:anObject.Field2];
    aLocLocLink.FromLocationIUR = [ArcosUtils convertStringToNumber:anObject.Field3];
    aLocLocLink.CustomerCode = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Field4]];
    aLocLocLink.LinkType = [ArcosUtils convertStringToNumber:anObject.Field5];
}

-(void)populateLocLocLinkWithFieldList:(NSArray*)aFieldList locLocLink:(LocLocLink*)anLocLocLink {
    anLocLocLink.IUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    anLocLocLink.LocationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]];
    anLocLocLink.FromLocationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:2]];
    anLocLocLink.CustomerCode = [ArcosUtils convertToString:[aFieldList objectAtIndex:3]];
    anLocLocLink.LinkType = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:4]];
}

- (void)populateOrderWithSoapOB:(ArcosOrderHeaderBO*)anObject orderHeader:(OrderHeader*)OrderHeader {
    OrderHeader.OSiur = [NSNumber numberWithInt:anObject.OSIUR];
    OrderHeader.InvoiseRef = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.InvoiceRef]];
    if (OrderHeader.DeliveryInstructions1 == nil || [[ArcosUtils trim:OrderHeader.DeliveryInstructions1] isEqualToString:@""]) {
        OrderHeader.DeliveryInstructions1 = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.DeliveryInstructions1]];
    }
    if (OrderHeader.DeliveryInstructions2 == nil || [[ArcosUtils trim:OrderHeader.DeliveryInstructions2] isEqualToString:@""]) {
        OrderHeader.DeliveryInstructions2 = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.DeliveryInstructions2]];
    }
    NSMutableDictionary* orderlineMap = [NSMutableDictionary dictionaryWithCapacity:[OrderHeader.orderlines count]];
    for (OrderLine* tmpOrderLine in OrderHeader.orderlines) {
        NSString* tmpKey = [NSString stringWithFormat:@"%@->%@", tmpOrderLine.OrderNumber, tmpOrderLine.OrderLine];
        [orderlineMap setObject:tmpOrderLine forKey:tmpKey];
    }
    
    for (ArcosOrderLineBO* tmpArcosOrderLine in anObject.Lines) {
        NSString* tmpArcosKey = [NSString stringWithFormat:@"%d->%d", tmpArcosOrderLine.OrderNumber, tmpArcosOrderLine.OrderLine];
        OrderLine* auxOrderLine = [orderlineMap objectForKey:tmpArcosKey];
        if (auxOrderLine != nil) {
            auxOrderLine.Bonus = [NSNumber numberWithInt:tmpArcosOrderLine.Bonus];
            auxOrderLine.FOC = [NSNumber numberWithInt:tmpArcosOrderLine.FOC];
            auxOrderLine.InStock = [NSNumber numberWithInt:tmpArcosOrderLine.InStock];
            auxOrderLine.units = [NSNumber numberWithInt:tmpArcosOrderLine.Units];
            auxOrderLine.Qty = [NSNumber numberWithInt:tmpArcosOrderLine.Qty];
            auxOrderLine.Testers = [NSNumber numberWithInt:tmpArcosOrderLine.Testers];
        }
    }
}

- (NSMutableDictionary*)createOrderLineWithManagedOrderLine:(OrderLine*)anOrderLine {
    NSMutableDictionary* orderLineDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [orderLineDict setObject:[NSNumber numberWithInt:[anOrderLine.ProductIUR intValue]] forKey:@"ProductIUR"];
    [orderLineDict setObject:[NSNumber numberWithInt:[anOrderLine.Qty intValue]] forKey:@"Qty"];    
    return orderLineDict;
}

- (NSMutableArray*)processPriceProductList:(NSMutableArray*)aProductList priceHashMap:(NSMutableDictionary*)aPriceHashMap bonusDealHashMap:(NSMutableDictionary*)aBonusDealHashMap {
    NSMutableArray* resultProductList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (NSDictionary* auxProductDict in aProductList) {
        NSMutableDictionary* resultProductDict = [NSMutableDictionary dictionaryWithDictionary:auxProductDict];
        [resultProductDict setObject:[NSNumber numberWithBool:NO] forKey:@"PriceFlag"];
        NSNumber* auxProductIUR = [auxProductDict objectForKey:@"ProductIUR"];
        NSDictionary* auxPriceDict = [aPriceHashMap objectForKey:auxProductIUR];
//        NSDecimalNumber* auxUnitPriceFromPrice = [aPriceHashMap objectForKey:auxProductIUR];
        if (auxPriceDict != nil) {
            NSDecimalNumber* auxUnitPriceFromPrice = [auxPriceDict objectForKey:@"RebatePercent"];
            NSDecimalNumber* auxDiscountPercentFromPrice = [auxPriceDict objectForKey:@"DiscountPercent"];
            [resultProductDict setObject:[NSNumber numberWithBool:YES] forKey:@"PriceFlag"];
            [resultProductDict setObject:auxUnitPriceFromPrice forKey:@"UnitTradePrice"];
            [resultProductDict setObject:[NSNumber numberWithFloat:[auxDiscountPercentFromPrice floatValue]] forKey:@"DiscountPercent"];
            [resultProductDict setObject:@"" forKey:@"BonusDeal"];
            NSString* bonusDeal = [aBonusDealHashMap objectForKey:auxProductIUR];
            if (bonusDeal != nil) {
                [resultProductDict setObject:bonusDeal forKey:@"BonusDeal"];
            }
        }
        [resultProductList addObject:resultProductDict];
    }
    return resultProductList;
}

- (NSMutableArray*)processPriceProductList:(NSMutableArray*)aProductList priceHashMap:(NSMutableDictionary*)aPriceHashMap {
    NSMutableArray* resultProductList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (NSDictionary* auxProductDict in aProductList) {
        NSMutableDictionary* resultProductDict = [NSMutableDictionary dictionaryWithDictionary:auxProductDict];
        [resultProductDict setObject:[NSNumber numberWithBool:NO] forKey:@"PriceFlag"];
        NSNumber* auxProductIUR = [auxProductDict objectForKey:@"ProductIUR"];
        NSDictionary* auxPriceDict = [aPriceHashMap objectForKey:auxProductIUR];
        if (auxPriceDict != nil) {
            [resultProductDict setObject:[NSNumber numberWithBool:YES] forKey:@"PriceFlag"];
            NSDecimalNumber* auxDiscountPercentFromPrice = [auxPriceDict objectForKey:@"DiscountPercent"];
            [resultProductDict setObject:[NSNumber numberWithFloat:[auxDiscountPercentFromPrice floatValue]] forKey:@"DiscountPercent"];
        }
        [resultProductList addObject:resultProductDict];
    }
    return resultProductList;
}

- (NSMutableArray*)processMasterPriceProductList:(NSMutableArray*)aProductList masterPriceHashMap:(NSMutableDictionary*)aMasterPriceHashMap  masterBonusDealHashMap:(NSMutableDictionary*)aMasterBonusDealHashMap {
    NSMutableArray* resultProductList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (NSDictionary* auxProductDict in aProductList) {
        NSMutableDictionary* resultProductDict = [NSMutableDictionary dictionaryWithDictionary:auxProductDict];
        NSNumber* auxProductIUR = [auxProductDict objectForKey:@"ProductIUR"];
        NSDictionary* auxPriceDict = [aMasterPriceHashMap objectForKey:auxProductIUR];
//        NSDecimalNumber* auxUnitPriceFromPrice = [aMasterPriceHashMap objectForKey:auxProductIUR];
        if (auxPriceDict != nil) {
            NSDecimalNumber* auxUnitPriceFromPrice = [auxPriceDict objectForKey:@"RebatePercent"];
            NSDecimalNumber* auxDiscountPercentFromPrice = [auxPriceDict objectForKey:@"DiscountPercent"];
            NSNumber* tmpPriceFlag = [resultProductDict objectForKey:@"PriceFlag"];
            if (![tmpPriceFlag boolValue]) {
                [resultProductDict setObject:[NSNumber numberWithBool:YES] forKey:@"PriceFlag"];
                [resultProductDict setObject:auxUnitPriceFromPrice forKey:@"UnitTradePrice"];
                [resultProductDict setObject:[NSNumber numberWithFloat:[auxDiscountPercentFromPrice floatValue]] forKey:@"DiscountPercent"];
                NSString* bonusDeal = [aMasterBonusDealHashMap objectForKey:auxProductIUR];
                if (bonusDeal != nil) {
                    [resultProductDict setObject:bonusDeal forKey:@"BonusDeal"];
                }
            }            
        }
        [resultProductList addObject:resultProductDict];
    }
    return resultProductList;
}

- (NSMutableArray*)processPriceOverrideWithProductList:(NSMutableArray*)aProductList priceOverride:(int)aPriceOverride {
    NSMutableArray* resultProductList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (int i = 0; i < [aProductList count]; i++) {
        NSMutableDictionary* auxProductDict = [aProductList objectAtIndex:i];
        NSMutableDictionary* resultProductDict = [NSMutableDictionary dictionaryWithDictionary:auxProductDict];
        [resultProductList addObject:resultProductDict];
        NSNumber* tmpPriceFlag = [resultProductDict objectForKey:@"PriceFlag"];
        if ([tmpPriceFlag intValue] == 1) continue;
        NSDecimalNumber* tmpUnitPrice = [resultProductDict objectForKey:@"UnitTradePrice"];
        float updatedUnitPriceFloatValue = [tmpUnitPrice floatValue] * (1 - aPriceOverride * 1.0 / 100 / 100);
        NSString* updatedUnitPriceStringValue = [NSString stringWithFormat:@"%.2f", updatedUnitPriceFloatValue];
        NSDecimalNumber* updatedUnitPrice = [ArcosUtils convertStringToDecimalNumber:updatedUnitPriceStringValue];
        [resultProductDict setObject:updatedUnitPrice forKey:@"UnitTradePrice"];
        [resultProductDict setObject:[NSNumber numberWithInt:2] forKey:@"PriceFlag"];        
    }
    return resultProductList;
}

- (NSMutableArray*)processCUiurWithProductList:(NSMutableArray*)aProductList {
    NSMutableArray* resultProductList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (int i = 0; i < [aProductList count]; i++) {
        NSMutableDictionary* auxProductDict = [aProductList objectAtIndex:i];
        NSMutableDictionary* resultProductDict = [NSMutableDictionary dictionaryWithDictionary:auxProductDict];
        [resultProductList addObject:resultProductDict];
        NSNumber* tmpUnitManufacturePrice = [auxProductDict objectForKey:@"UnitManufacturePrice"];
        NSNumber* auxUnitManufacturePrice = [NSNumber numberWithFloat:[tmpUnitManufacturePrice floatValue] / 100];
        NSNumber* unitRevenueAmount = [auxProductDict objectForKey:@"UnitRevenueAmount"];
        [resultProductDict setObject:[NSDecimalNumber decimalNumberWithDecimal:[auxUnitManufacturePrice decimalValue]] forKey:@"UnitTradePrice"];
        [resultProductDict setObject:[NSNumber numberWithInt:[unitRevenueAmount intValue]] forKey:@"UnitRRP"];
    }
    return resultProductList;
}

- (NSMutableArray*)processBonusDealProductList:(NSMutableArray*)aProductList bonusDealHashMap:(NSMutableDictionary*)aBonusDealHashMap {
    return nil;
}

- (NSMutableArray*)processMasterBonusDealProductList:(NSMutableArray*)aProductList masterBonusDealHashMap:(NSMutableDictionary*)aMasterBonusDealHashMap {
    return nil;
}

- (NSPredicate*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode {
    NSPredicate* predicate = nil;
    if (aParentCode != nil) {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and ParentCode = %@ and Active = 1", aDescrCodeType, aParentCode];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and Active = 1", aDescrCodeType];
    }
    return predicate;
}

- (NSPredicate*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode checkActive:(BOOL)aCheckFlag {
    NSPredicate* predicate = nil;
    if (aParentCode != nil) {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and ParentCode = %@ and Active = 1", aDescrCodeType, aParentCode];
        if (!aCheckFlag) {
            predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and ParentCode = %@", aDescrCodeType, aParentCode];
        }
    } else {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and Active = 1", aDescrCodeType];
        if (!aCheckFlag) {
            predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@", aDescrCodeType];
        }
    }
    return predicate;
}

- (NSMutableArray*)convertDescrDetailDictList:(NSMutableArray*)aDescrDetailDictList {
    NSMutableArray* newObjectsArray = [NSMutableArray array];
    
    for (NSDictionary* aDict in aDescrDetailDictList) {
        NSMutableDictionary* myDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        if ([aDict objectForKey:@"Detail"]==nil) {
            [myDict setObject:@"Not Defined" forKey:@"Title"];
        } else{
            [myDict setObject:[ArcosUtils trim:[aDict objectForKey:@"Detail"]] forKey:@"Title"];
        }
        [newObjectsArray addObject:myDict];
    }
    return newObjectsArray;
}

@end
