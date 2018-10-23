//
//  CustomerTyvLyDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 25/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "CustomerTyvLyDataManager.h"
@interface CustomerTyvLyDataManager ()
- (NSString*)fieldNameWithPrefix:(NSString*)aPrefix index:(int)anIndex;
- (NSMutableDictionary*)processQtyBonusValueWithData:(NSMutableDictionary*)matDict beginIndex:(int)beginIndex endIndex:(int)endIndex;

@end

@implementation CustomerTyvLyDataManager
@synthesize displayList = _displayList;

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (void)processTyvLyWithLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@", aLocationIUR];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] == 0) {
        self.displayList = [NSMutableArray array];
        return;
    }
    NSDictionary* firstLocationProductMATDict = [objectsArray objectAtIndex:0];
    NSDate* dateLastModified = [firstLocationProductMATDict objectForKey:@"dateLastModified"];
    int monthNum = [ArcosUtils convertNSIntegerToInt:[ArcosUtils monthDayWithDate:dateLastModified]];
    NSMutableArray* auxLocationProductMATList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (NSDictionary* aLocationProductMat in objectsArray) {
        [productIURList addObject:[aLocationProductMat objectForKey:@"productIUR"]];
    }
    NSMutableArray* productsList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
    NSMutableDictionary* productHashMap = [NSMutableDictionary dictionaryWithCapacity:[productsList count]];
    for (NSDictionary* aProductDict in productsList) {
        NSNumber* productIURKey = [aProductDict objectForKey:@"ProductIUR"];
        [productHashMap setObject:aProductDict forKey:productIURKey];
    }
    for (NSDictionary* aLocationProductMat in objectsArray) {
        NSMutableDictionary* tmpLocationProductMatDict = [NSMutableDictionary dictionaryWithDictionary:aLocationProductMat];
        NSNumber* productIUR = [tmpLocationProductMatDict objectForKey:@"productIUR"];
        NSDictionary* productDict = [productHashMap objectForKey:productIUR];
        if (productDict != nil) {
            [ProductFormRowConverter addProductInfoToDictionary:tmpLocationProductMatDict productDict:productDict];
        } else {
            [ProductFormRowConverter addBlankProductInfoToDictionary:tmpLocationProductMatDict];
        }
        [auxLocationProductMATList addObject:tmpLocationProductMatDict];
    }
    NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"OrderPadDetails" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Details" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [auxLocationProductMATList sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, detailsDescriptor, nil]];
    self.displayList = [NSMutableArray arrayWithCapacity:[auxLocationProductMATList count]];
    for (NSMutableDictionary* auxLocationProductMatDict in auxLocationProductMATList) {
        ArcosGenericClass* arcosGenericClass = [[[ArcosGenericClass alloc] init] autorelease];
        arcosGenericClass.Field2 = [auxLocationProductMatDict objectForKey:@"Details"];
        arcosGenericClass.Field16 = [auxLocationProductMatDict objectForKey:@"OrderPadDetails"];
        arcosGenericClass.Field17 = [auxLocationProductMatDict objectForKey:@"ProductCode"];
        arcosGenericClass.Field18 = [auxLocationProductMatDict objectForKey:@"ProductSize"];
        //TY-YTD
        int tyTDBeginIndex = 26 - monthNum;
        int tyTDEndIndex = 25;
        NSMutableDictionary* tyTDDataDict = [self processQtyBonusValueWithData:auxLocationProductMatDict beginIndex:tyTDBeginIndex endIndex:tyTDEndIndex];
        int tyTDQtyValue = [[tyTDDataDict objectForKey:@"Qty"] intValue];
        arcosGenericClass.Field3 = [NSString stringWithFormat:@"%d", tyTDQtyValue];
        arcosGenericClass.Field4 = [NSString stringWithFormat:@"%d", [[tyTDDataDict objectForKey:@"Bonus"] intValue]];
        arcosGenericClass.Field5 = [NSString stringWithFormat:@"%d", [[tyTDDataDict objectForKey:@"Sales"] intValue]];
        int lyTDBeginIndex = 14 - monthNum;
        int lyTDEndIndex = 13;
        NSMutableDictionary* lyTDDataDict = [self processQtyBonusValueWithData:auxLocationProductMatDict beginIndex:lyTDBeginIndex endIndex:lyTDEndIndex];
        int lyTDQtyValue = [[lyTDDataDict objectForKey:@"Qty"] intValue];
        arcosGenericClass.Field9 = [NSString stringWithFormat:@"%d", lyTDQtyValue];
        arcosGenericClass.Field10 = [NSString stringWithFormat:@"%d", [[lyTDDataDict objectForKey:@"Bonus"] intValue]];
        arcosGenericClass.Field11 = [NSString stringWithFormat:@"%d", [[lyTDDataDict objectForKey:@"Sales"] intValue]];
        int allLYBeginIndex = 14 - monthNum;
        int allLYEndIndex = 14 - monthNum + 11;
        NSMutableDictionary* allLYDataDict = [self processQtyBonusValueWithData:auxLocationProductMatDict beginIndex:allLYBeginIndex endIndex:allLYEndIndex];
        arcosGenericClass.Field12 = [NSString stringWithFormat:@"%d", [[allLYDataDict objectForKey:@"Qty"] intValue]];
        arcosGenericClass.Field13 = [NSString stringWithFormat:@"%d", [[allLYDataDict objectForKey:@"Bonus"] intValue]];
        arcosGenericClass.Field14 = [NSString stringWithFormat:@"%d", [[allLYDataDict objectForKey:@"Sales"] intValue]];
        float qtyPercentage = 0;
        if (tyTDQtyValue == 0 && lyTDQtyValue == 0) {
            qtyPercentage = 100;
        } else if (tyTDQtyValue == 0) {
            qtyPercentage = -100;
        } else if (lyTDQtyValue == 0) {
            qtyPercentage = 100;
        } else {
            qtyPercentage = ((tyTDQtyValue * 1.0 / lyTDQtyValue) - 1.0) * 100.0;
        }
        arcosGenericClass.Field15 = [NSString stringWithFormat:@"%d", (int)qtyPercentage];
        
        [self.displayList addObject:arcosGenericClass];
    }
}

- (NSString*)fieldNameWithPrefix:(NSString*)aPrefix index:(int)anIndex {
    return anIndex < 10 ? [NSString stringWithFormat:@"%@0%d", aPrefix, anIndex] : [NSString stringWithFormat:@"%@%d", aPrefix, anIndex];
}

- (NSMutableDictionary*)processQtyBonusValueWithData:(NSMutableDictionary*)matDict beginIndex:(int)beginIndex endIndex:(int)endIndex {
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    int qtySum = 0;
    int bonusSum = 0;
    float salesSum = 0.0;
    for (int i = beginIndex; i <= endIndex ; i++) {
        NSString* qtyField = [self fieldNameWithPrefix:@"qty" index:i];
        NSString* methodField = @"objectForKey:";
        SEL valueMethod = NSSelectorFromString(methodField);
        NSNumber* qtyNumber = [matDict performSelector:valueMethod withObject:qtyField];
        qtySum += [qtyNumber intValue];
        NSString* bonusField = [self fieldNameWithPrefix:@"bonus" index:i];
        NSNumber* bonusNumber = [matDict performSelector:valueMethod withObject:bonusField];
        bonusSum += [bonusNumber intValue];
        NSString* salesField = [self fieldNameWithPrefix:@"sales" index:i];
        NSNumber* salesNumber = [matDict performSelector:valueMethod withObject:salesField];
        salesSum += [salesNumber floatValue];
    }
    [dataDict setObject:[NSNumber numberWithInt:qtySum] forKey:@"Qty"];
    [dataDict setObject:[NSNumber numberWithInt:bonusSum] forKey:@"Bonus"];
    [dataDict setObject:[NSNumber numberWithFloat:salesSum] forKey:@"Sales"];
    return dataDict;
}

//- (void)addProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict productDict:(NSDictionary*)aProductDict {
//    [aLocationProductMatDict setObject:[aProductDict objectForKey:@"Description"] forKey:@"Details"];
//    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[aProductDict objectForKey:@"OrderPadDetails"]] forKey:@"OrderPadDetails"];
//    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils trim:[aProductDict objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
//    [aLocationProductMatDict setObject:[ArcosUtils convertNilToEmpty:[aProductDict objectForKey:@"Productsize"]] forKey:@"ProductSize"];
//}
//
//- (void)addBlankProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict {
//    [aLocationProductMatDict setObject:@"Product not found" forKey:@"Details"];
//    [aLocationProductMatDict setObject:@"" forKey:@"OrderPadDetails"];
//    [aLocationProductMatDict setObject:@"" forKey:@"ProductCode"];
//    [aLocationProductMatDict setObject:@"" forKey:@"ProductSize"];
//}

@end
