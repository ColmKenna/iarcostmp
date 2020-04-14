//
//  CustomerIarcosInvoiceDetailsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosInvoiceDetailsDataManager.h"

@implementation CustomerIarcosInvoiceDetailsDataManager
@synthesize invoiceIUR = _invoiceIUR;
@synthesize replyResult = _replyResult;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize invoiceDetailsTitle = _invoiceDetailsTitle;
@synthesize orderlineDictList = _orderlineDictList;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.invoiceDetailsTitle = @"Invoice Details";
    }
    return self;
}

- (void)dealloc {
    self.invoiceIUR = nil;
    self.replyResult = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.invoiceDetailsTitle = nil;
    self.orderlineDictList = nil;
    
    [super dealloc];
}

- (void)loadInvoiceDetailsData:(ArcosGenericClass*)aReplyResult {
    self.replyResult = aReplyResult;
    self.sectionTitleList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    [self createInvoiceDetailsSectionData];
    [self createDrillDownSectionDataWithSectionTitle:@"Invoice lines" orderHeaderType:[NSNumber numberWithInt:1]];
    [self createOrderlinesData];
}

- (void)createInvoiceDetailsSectionData {
    [self.sectionTitleList addObject:self.invoiceDetailsTitle];
    NSMutableArray* invoiceDetailDisplayList = [NSMutableArray arrayWithCapacity:8];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Date" fieldNameLabel:@"Date" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field17]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Reference" fieldNameLabel:@"Reference" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field18]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Type" fieldNameLabel:@"Type" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field12]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Delivery By" fieldNameLabel:@"Delivery By" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field14]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Status" fieldNameLabel:@"Status" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field15]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Cus.Ref." fieldNameLabel:@"Cus.Ref." fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field24]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Order No." fieldNameLabel:@"Order No." fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field16]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Employee" fieldNameLabel:@"Employee" fieldData:[ArcosUtils convertNilToEmpty:[self.replyResult Field10]]]];
    [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Value" fieldNameLabel:@"Value" fieldData:[ArcosUtils convertToFloatString:[ArcosUtils convertNilToEmpty:[self.replyResult Field21]]]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"TotalVAT" fieldNameLabel:@"VAT" fieldData:[ArcosUtils convertToFloatString:[ArcosUtils convertNilToEmpty:[self.replyResult Field22]]]]];
        NSNumber* valueFloatNumber = [ArcosUtils convertStringToFloatNumber:[ArcosUtils convertNilToEmpty:[self.replyResult Field21]]];
        NSNumber* vatFloatNumber = [ArcosUtils convertStringToFloatNumber:[ArcosUtils convertNilToEmpty:[self.replyResult Field22]]];
        float totalValue = [valueFloatNumber floatValue] + [vatFloatNumber floatValue];
        [invoiceDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Total" fieldNameLabel:@"Total" fieldData:[NSString stringWithFormat:@"%.2f", totalValue]]];
    }
    
    [self.groupedDataDict setObject:invoiceDetailDisplayList forKey:self.invoiceDetailsTitle];
}



- (NSMutableDictionary*)createReadLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType {
    [self.sectionTitleList addObject:aSectionTitle];
    NSMutableArray* detailList = [NSMutableArray arrayWithCapacity:1];
    [detailList addObject:[self createDrillDownCellDataWithFieldNameLabel:aSectionTitle orderHeaderType:anOrderHeaderType]];
    [self.groupedDataDict setObject:detailList forKey:aSectionTitle];
}

- (NSMutableDictionary*)createDrillDownCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel orderHeaderType:(NSNumber*)anOrderHeaderType {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:6] forKey:@"CellType"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:anOrderHeaderType forKey:@"OrderHeaderType"];
    return cellData;
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (void)createOrderlinesData {
    self.orderlineDictList = [NSMutableArray arrayWithCapacity:[self.replyResult.SubObjects count]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[self.replyResult.SubObjects count]];
    for (int i = 0; i < [self.replyResult.SubObjects count]; i++) {
        ArcosGenericClass* cellData = [self.replyResult.SubObjects objectAtIndex:i];
        [productIURList addObject:[ArcosUtils convertStringToNumber:cellData.Field8]];
    }
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    
    for (int i = 0; i < [self.replyResult.SubObjects count]; i++) {
        ArcosGenericClass* cellData = [self.replyResult.SubObjects objectAtIndex:i];
        NSMutableDictionary* orderlineDict = [NSMutableDictionary dictionaryWithCapacity:15];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:cellData.Field10] forKey:@"Qty"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:cellData.Field13] forKey:@"Bonus"];
        [orderlineDict setObject:[NSNumber numberWithInt:0] forKey:@"DiscountPercent"];
        [orderlineDict setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
        [orderlineDict setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
        [orderlineDict setObject:[NSNumber numberWithInt:0] forKey:@"Testers"];
        [orderlineDict setObject:[ArcosUtils convertStringToFloatNumber:[ArcosUtils convertNilToEmpty:cellData.Field11]] forKey:@"LineValue"];
        NSNumber* productIUR = [ArcosUtils convertStringToNumber:cellData.Field8];
        [orderlineDict setObject:productIUR forKey:@"ProductIUR"];
        NSDictionary* aProduct = [productDictHashMap objectForKey:productIUR];
        [self.orderlineDictList addObject:[ProductFormRowConverter createStandardOrderLine:orderlineDict product:aProduct]];
        /*
        if (aProduct!=nil) {
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Description"]] forKey:@"Description"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"OrderPadDetails"]] forKey:@"OrderPadDetails"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"ProductCode"]]] forKey:@"ProductCode"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Productsize"]]] forKey:@"ProductSize"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Description"]] forKey:@"Details"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"UnitsPerPack"]] forKey:@"UnitsPerPack"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"Bonusby"]] forKey:@"Bonusby"];
            [orderlineDict setObject:[ArcosUtils convertNilToEmpty:[aProduct objectForKey:@"StockAvailable"]] forKey:@"StockAvailable"];
            [self.orderlineDictList addObject:orderlineDict];
        }else{
            [orderlineDict setObject:@"Product unassigned" forKey:@"Description"];
            [orderlineDict setObject:@"Product unassigned" forKey:@"Details"];
            [orderlineDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitsPerPack"];
            [orderlineDict setObject:[NSNumber numberWithInt:78] forKey:@"Bonusby"];
            [orderlineDict setObject:[NSNumber numberWithInt:9999] forKey:@"StockAvailable"];
            [self.orderlineDictList addObject:orderlineDict];
        }
        */
    }
}

@end
