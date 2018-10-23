//
//  SavedIarcosOrderDetailBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailBaseDataManager.h"

@implementation SavedIarcosOrderDetailBaseDataManager
@synthesize orderHeader = _orderHeader;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize titleKey = _titleKey;
@synthesize contactSectionTitle = _contactSectionTitle;
@synthesize orderSectionTitle = _orderSectionTitle;
@synthesize memoSectionTitle = _memoSectionTitle;
@synthesize printSectionTitle = _printSectionTitle;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.titleKey = @"Title";
        self.contactSectionTitle = @"Contact";
        self.orderSectionTitle = @"Order Details";
        self.memoSectionTitle = @"Memo";
        self.printSectionTitle = @"Print";
    }
    return self;
}

- (void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    if (self.titleKey != nil) { self.titleKey = nil; }
    self.contactSectionTitle = nil;
    self.orderSectionTitle = nil;
    self.memoSectionTitle = nil;
    self.printSectionTitle = nil;
    
    [super dealloc];
}

- (void)createContactSectionData {
    NSString* sectionTitle = self.contactSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"contact"]];
    [contactDict setObject:[self.orderHeader objectForKey:@"contactText"] forKey:self.titleKey];
    NSMutableDictionary* contactCellDict = [self createWriteCellDataWithCellKey:@"contact" fieldNameLabel:@"Contact" writeType:[NSNumber numberWithInt:7] fieldData:contactDict];
    [contactCellDict setObject:[self.orderHeader objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    
    [contactDisplayList addObject:contactCellDict];
    [contactDisplayList addObject:[self createDateLabelCellDataWithCellKey:@"orderDate" fieldNameLabel:@"Date" writeType:[NSNumber numberWithInt:1]]];
    NSMutableDictionary* callTypeDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"callType"]];
    [callTypeDict setObject:[self.orderHeader objectForKey:@"callTypeText"] forKey:self.titleKey];
    [contactDisplayList addObject:[self createWriteCellDataWithCellKey:@"callType" fieldNameLabel:@"Call Type" writeType:[NSNumber numberWithInt:6] fieldData:callTypeDict]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"EmployeeIUR" fieldNameLabel:@"Employee" fieldData:[self employeeName:[self.orderHeader objectForKey:@"EmployeeIUR"]]]];
    
    [self.groupedDataDict setObject:contactDisplayList forKey:sectionTitle];
}
- (void)createOrderDetailsSectionData {
    NSString* sectionTitle = self.orderSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* orderDetailDisplayList = [NSMutableArray arrayWithCapacity:6];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"OrderNumber" fieldNameLabel:@"Number" fieldData:[ArcosUtils convertNumberToIntString:[self.orderHeader objectForKey:@"OrderNumber"]]]];
    [orderDetailDisplayList addObject:[self createDateLabelCellDataWithCellKey:@"deliveryDate" fieldNameLabel:@"Delivery" writeType:[NSNumber numberWithInt:0]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showDeliveryInstructionsFlag]) {
        [orderDetailDisplayList addObject:[self createDeliveryInstructions1TextFieldCellDataWithCellKey:@"DeliveryInstructions1" fieldNameLabel:@"Instructions" fieldData:[self.orderHeader objectForKey:@"DeliveryInstructions1"]]];
    }
    NSMutableDictionary* wholesalerDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"wholesaler"]];
    [wholesalerDict setObject:[self.orderHeader objectForKey:@"wholesalerText"] forKey:self.titleKey];
    [orderDetailDisplayList addObject:[self createWriteCellDataWithCellKey:@"wholesaler" fieldNameLabel:@"Wholesaler" writeType:[NSNumber numberWithInt:4] fieldData:wholesalerDict]];
    NSMutableDictionary* orderStatusDict = [self addTitleToDict:@"status" titleKey:@"statusText"];
    [orderDetailDisplayList addObject:[self createWriteCellDataWithCellKey:@"status" fieldNameLabel:@"Status" writeType:[NSNumber numberWithInt:3] fieldData:orderStatusDict]];
    NSMutableDictionary* orderTypeDict = [self addTitleToDict:@"type" titleKey:@"orderTypeText"];
    [orderDetailDisplayList addObject:[self createWriteCellDataWithCellKey:@"type" fieldNameLabel:@"Type" writeType:[NSNumber numberWithInt:5] fieldData:orderTypeDict]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"totalGoodsText" fieldNameLabel:@"Value" fieldData:[self.orderHeader objectForKey:@"totalGoodsText"]]];
    
    [self.groupedDataDict setObject:orderDetailDisplayList forKey:sectionTitle];
}
- (void)createOrderMemoSectionData {
    NSString* sectionTitle = self.memoSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:3];
    [memoDisplayList addObject:[self createTextFieldCellDataWithCellKey:@"custRef" fieldNameLabel:@"Customer Ref" fieldData:[self.orderHeader objectForKey:@"custRef"]]];
    
    NSMutableDictionary* acctNoDict = [self.orderHeader objectForKey:@"acctNo"];
    [acctNoDict setObject:[self.orderHeader objectForKey:@"acctNoText"] forKey:self.titleKey];
    NSMutableDictionary* acctNoCellDict = [self createWriteCellDataWithCellKey:@"acctNo" fieldNameLabel:@"Account No." writeType:[NSNumber numberWithInt:7] fieldData:acctNoDict];
    [acctNoCellDict setObject:[self.orderHeader objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    [acctNoCellDict setObject:[self.orderHeader objectForKey:@"FromLocationIUR"] forKey:@"FromLocationIUR"];
    [memoDisplayList addObject:acctNoCellDict];
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    
    [self.groupedDataDict setObject:memoDisplayList forKey:sectionTitle];
}
- (void)createCallMemoSectionData {
    NSString* sectionTitle = self.memoSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:2];
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    
    [self.groupedDataDict setObject:memoDisplayList forKey:sectionTitle];
}
- (void)createRemoteContactSectionData {
    NSString* sectionTitle = self.contactSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray arrayWithCapacity:4];
    
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Contact" fieldNameLabel:@"Contact" fieldData:[self.orderHeader objectForKey:@"contactText"]]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"orderDate" fieldNameLabel:@"Date" fieldData:[self.orderHeader objectForKey:@"orderDateText"]]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"callType" fieldNameLabel:@"Call Type" fieldData:[self.orderHeader objectForKey:@"callTypeText"]]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Employee" fieldNameLabel:@"Employee" fieldData:[self.orderHeader objectForKey:@"Employee"]]];
    
    [self.groupedDataDict setObject:contactDisplayList forKey:sectionTitle];
}
- (void)createRemoteOrderDetailsSectionData {
    NSString* sectionTitle = self.orderSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* orderDetailDisplayList = [NSMutableArray arrayWithCapacity:6];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"OrderNumber" fieldNameLabel:@"Number" fieldData:[ArcosUtils convertNumberToIntString:[self.orderHeader objectForKey:@"OrderNumber"]]]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"deliveryDate" fieldNameLabel:@"Delivery" fieldData:[self.orderHeader objectForKey:@"deliveryDateText"]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showDeliveryInstructionsFlag]) {
        [orderDetailDisplayList addObject:[self createDeliveryInstructions1TextFieldCellDataWithCellKey:@"DeliveryInstructions1" fieldNameLabel:@"Instructions" fieldData:[self.orderHeader objectForKey:@"DeliveryInstructions1"]]];
    }
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"wholesaler" fieldNameLabel:@"Wholesaler" fieldData:[self.orderHeader objectForKey:@"wholesalerText"]]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"status" fieldNameLabel:@"Status" fieldData:[self.orderHeader objectForKey:@"statusText"]]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"type" fieldNameLabel:@"Type" fieldData:[self.orderHeader objectForKey:@"orderTypeText"]]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"totalGoodsText" fieldNameLabel:@"Value" fieldData:[self.orderHeader objectForKey:@"totalGoodsText"]]];
    
    [self.groupedDataDict setObject:orderDetailDisplayList forKey:sectionTitle];
}
- (void)createRemoteOrderMemoSectionData {
    NSString* sectionTitle = self.memoSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:3];
    [memoDisplayList addObject:[self createTextFieldCellDataWithCellKey:@"custRef" fieldNameLabel:@"Customer Ref" fieldData:[self.orderHeader objectForKey:@"custRef"]]];
    [memoDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"acctNo" fieldNameLabel:@"Account No." fieldData:[self.orderHeader objectForKey:@"acctNoText"]]];
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    [self.groupedDataDict setObject:memoDisplayList forKey:sectionTitle];
}
- (void)createRemoteCallMemoSectionData {
    NSString* sectionTitle = self.memoSectionTitle;
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:1];
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    [self.groupedDataDict setObject:memoDisplayList forKey:sectionTitle];
}
- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType {
    [self.sectionTitleList addObject:aSectionTitle];
    NSMutableArray* detailList = [NSMutableArray arrayWithCapacity:1];
    [detailList addObject:[self createDrillDownCellDataWithFieldNameLabel:aSectionTitle orderHeaderType:anOrderHeaderType]];
    [self.groupedDataDict setObject:detailList forKey:aSectionTitle];
}

- (void)createPrintSectionData {
    [self.sectionTitleList addObject:self.printSectionTitle];
    NSMutableArray* printDisplayList = [NSMutableArray arrayWithCapacity:1];
    [printDisplayList addObject:[self createPrintCellData]];
    
    [self.groupedDataDict setObject:printDisplayList forKey:self.printSectionTitle];
}

- (NSMutableDictionary*)createPrintCellData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:10] forKey:@"CellType"];
    [cellData setObject:@"Print - Email" forKey:@"FieldNameLabel"];
    return cellData;
}

- (NSMutableDictionary*)createDateLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aWriteType forKey:@"WriteType"];
    [cellData setObject:[self.orderHeader objectForKey:aCellKey] forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)createReadLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)createTextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)createDeliveryInstructions1TextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:11] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;    
}

- (NSMutableDictionary*)createTextViewCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:5] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)createWriteCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType fieldData:(NSMutableDictionary*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:5];
    [cellData setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aWriteType forKey:@"WriteType"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}



- (NSMutableDictionary*)createNumberTextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:7] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}



- (NSMutableDictionary*)createDrillDownCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel orderHeaderType:(NSNumber*)anOrderHeaderType {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:6] forKey:@"CellType"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:anOrderHeaderType forKey:@"OrderHeaderType"];
    return cellData;
}

- (NSMutableDictionary*)createDateHourMinLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:8] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aWriteType forKey:@"WriteType"];
    [cellData setObject:[self.orderHeader objectForKey:aCellKey] forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (NSString*)employeeName:(NSNumber*)anEmployeeIUR {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:anEmployeeIUR];
    return [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
}

- (NSMutableDictionary*)addTitleToDict:(NSString*)aCellKey titleKey:(NSString*)aTitleKey {
    NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:aCellKey]];
    [tmpDict setObject:[self.orderHeader objectForKey:aTitleKey] forKey:self.titleKey];
    return tmpDict;
}

- (void)createAllSectionData {

}

@end
