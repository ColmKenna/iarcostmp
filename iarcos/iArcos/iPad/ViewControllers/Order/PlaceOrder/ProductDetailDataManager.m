//
//  ProductDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailDataManager.h"

@implementation ProductDetailDataManager
@synthesize displayList = _displayList;
@synthesize levelDisplayList = _levelDisplayList;
@synthesize stockDisplayList = _stockDisplayList;
@synthesize priceDisplayList = _priceDisplayList;
@synthesize codeDisplayList = _codeDisplayList;
@synthesize productCode = _productCode;
@synthesize productIUR = _productIUR;
@synthesize productDescription = _productDescription;
@synthesize bonusTitle = _bonusTitle;
@synthesize miscTitle = _miscTitle;
@synthesize detailsTitle = _detailsTitle;
@synthesize productImageIUR = _productImageIUR;
@synthesize useLocalImageFlag = _useLocalImageFlag;
@synthesize formRowDict = _formRowDict;

- (id)init {
    self = [super init];
    if (self) {
        self.bonusTitle = @"BONUS";
        self.miscTitle = @"MISC";
        self.detailsTitle = @"DETAILS";
        self.productImageIUR = [NSNumber numberWithInt:0];
        self.useLocalImageFlag = NO;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.levelDisplayList != nil) { self.levelDisplayList = nil; }
    if (self.stockDisplayList != nil) { self.stockDisplayList = nil; }
    if (self.priceDisplayList != nil) { self.priceDisplayList = nil; }
    if (self.codeDisplayList != nil) { self.codeDisplayList = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    self.productIUR = nil;
    self.productDescription = nil;
    self.bonusTitle = nil;
    self.miscTitle = nil;
    self.detailsTitle = nil;
    self.productImageIUR = nil;
    self.formRowDict = nil;
    
    [super dealloc];
}

- (void)processRawData:(ArcosGenericClass*)arcosGenericClass {
    self.levelDisplayList = [NSMutableArray arrayWithCapacity:3];
    self.stockDisplayList = [NSMutableArray arrayWithCapacity:4];
    self.priceDisplayList = [NSMutableArray arrayWithCapacity:6];
    self.codeDisplayList = [NSMutableArray arrayWithCapacity:8];
    
    NSMutableArray* productList = [[ArcosCoreData sharedArcosCoreData] productWithIUR:self.productIUR withResultType:NSDictionaryResultType];
    if ([productList count] == 1) {
        NSDictionary* productDict = [productList objectAtIndex:0];
        self.productImageIUR = [productDict objectForKey:@"ImageIUR"];
        [self.stockDisplayList addObject:[self cellDataDict:@"Minimum Qty:" value:[ArcosUtils convertNumberToIntString:[productDict objectForKey:@"BonusMinimum"]]]];
        [self.stockDisplayList addObject:[self cellDataDict:@"Qty Required:" value:[ArcosUtils convertNumberToIntString:[productDict objectForKey:@"BonusRequired"]]]];
        [self.stockDisplayList addObject:[self cellDataDict:@"Bonus Given:" value:[ArcosUtils convertNumberToIntString:[productDict objectForKey:@"BonusGiven"]]]];
        [self.stockDisplayList addObject:[self cellDataDict:@"Rule:" value:@""]];
    }
    
    
    [self.priceDisplayList addObject:[self cellDataDict:@"RRP:" value:[NSString stringWithFormat:@"%.2f", [[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field9]]] floatValue]]]];
    [self.priceDisplayList addObject:[self cellDataDict:@"Unit Price:" value:[NSString stringWithFormat:@"%.2f", [[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field10]]] floatValue]]]];
    if ([[self.formRowDict objectForKey:@"PriceFlag"] intValue] == 1) {
        NSNumber* auxCustomerPrice = [self.formRowDict objectForKey:@"UnitPrice"];
        [self.priceDisplayList addObject:[self cellDataDict:@"Customer Price:" value:[NSString stringWithFormat:@"%.2f", [auxCustomerPrice floatValue]]]];
    }    
    [self.priceDisplayList addObject:[self cellDataDict:@"Packs Per Case:" value:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field11]]]]];
    [self.priceDisplayList addObject:[self cellDataDict:@"Units Per Pack:" value:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field16]]]]];
    
    [self.priceDisplayList addObject:[self cellDataDict:@"In Stock:" value:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field6]]]]];
    [self.priceDisplayList addObject:[self cellDataDict:@"Stock On Order:" value:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field7]]]]];
    NSDate* updateDate = [ArcosUtils dateFromString:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field8]] format:@"yyyy-MM-dd HH:mm:ss"];
    
    [self.priceDisplayList addObject:[self cellDataDict:@"Due Date:" value:[ArcosUtils convertNilToEmpty:[ArcosUtils stringFromDate:updateDate format:@"dd/MM/yyyy"]]]];
    
    
    NSDictionary* l1codeDescrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"L1"];
    NSDictionary* l2codeDescrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"L2"];
    NSDictionary* l3codeDescrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"L3"];
    NSDictionary* l4codeDescrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"L4"];
    NSDictionary* l5codeDescrTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"L5"];
    
    [self.levelDisplayList addObject:[self cellDataDict:[ArcosUtils convertNilToEmpty:[l1codeDescrTypeDict objectForKey:@"Details"]] value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field1]]]];
    [self.levelDisplayList addObject:[self cellDataDict:[ArcosUtils convertNilToEmpty:[l2codeDescrTypeDict objectForKey:@"Details"]] value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field2]]]];
    [self.levelDisplayList addObject:[self cellDataDict:[ArcosUtils convertNilToEmpty:[l3codeDescrTypeDict objectForKey:@"Details"]] value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field3]]]];
    [self.levelDisplayList addObject:[self cellDataDict:[ArcosUtils convertNilToEmpty:[l4codeDescrTypeDict objectForKey:@"Details"]] value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field4]]]];
    [self.levelDisplayList addObject:[self cellDataDict:[ArcosUtils convertNilToEmpty:[l5codeDescrTypeDict objectForKey:@"Details"]] value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field5]]]];
    
    [self.levelDisplayList addObject:[self cellDataDict:@"Product Code:" value:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field12]]]]];
    [self.levelDisplayList addObject:[self cellDataDict:@"Catalog Code:" value:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field13]]]]];
    [self.levelDisplayList addObject:[self cellDataDict:@"EAN:" value:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field14]]]];
    self.productDescription = [ArcosUtils convertNilToEmpty:[arcosGenericClass Field15]];
}

- (NSMutableDictionary*)cellDataDict:(NSString*)aTitle value:(NSString*)aValue {
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dataDict setObject:aTitle forKey:@"Title"];
    [dataDict setObject:aValue forKey:@"Value"];
    return dataDict;
}

- (void)processProductLocationRawData:(NSMutableArray*)aDataList {
    self.codeDisplayList = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray* monthList = [NSMutableArray arrayWithCapacity:14];
    NSMutableArray* qtyList = [NSMutableArray arrayWithCapacity:14];
    NSMutableArray* bonusList = [NSMutableArray arrayWithCapacity:14];
    int count = [ArcosUtils convertNSUIntegerToUnsignedInt:[aDataList count]];
    [monthList addObject:@""];
    [qtyList addObject:@"Qty"];
    [bonusList addObject:@"Bon"];
    for (int i = count - 1; i >= 0; i--) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        @try {
            NSString* monthText = [arcosGenericClass.Field2 substringToIndex:3];
            [monthList addObject:monthText];
        }
        @catch (NSException *exception) {
            [monthList addObject:@""];
        }
        [qtyList addObject:arcosGenericClass.Field4];
        [bonusList addObject:arcosGenericClass.Field5];
    }
    [self.codeDisplayList addObject:monthList];
    [self.codeDisplayList addObject:qtyList];
    [self.codeDisplayList addObject:bonusList];
}

@end
