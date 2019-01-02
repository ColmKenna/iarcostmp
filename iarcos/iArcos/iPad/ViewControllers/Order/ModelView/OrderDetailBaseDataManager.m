//
//  OrderDetailBaseDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailBaseDataManager.h"

@implementation OrderDetailBaseDataManager
@synthesize orderHeader = _orderHeader;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize titleKey = _titleKey;
@synthesize contactSectionKey = _contactSectionKey;
@synthesize memoSectionKey = _memoSectionKey;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.titleKey = @"Title";
        self.contactSectionKey = @"Contact";
        self.memoSectionKey = @"Memo";
    }
    return self;
}

- (void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }                    
    if (self.titleKey != nil) { self.titleKey = nil; }
    self.contactSectionKey = nil;
    self.memoSectionKey = nil;
    [super dealloc];
}

/*
 *DataStructure Specification
 *CellType nsnumber 1:DateCell 2:readLabelCell 3:writeLabelCell 4:textFieldCell 5:TextViewCell 6:DrillDownCell 7:numberTextFieldCell 8:DateHourMinCell 9:Print 11:DeliveryInstructions1
 *CellKey nsstring key from orderheader
 *FieldNameLabel nsstring fieldName displayed
 *FieldData id NSDate or NSString or NSMutableDictionary
 * -DateCell NSDate
 * -readLabelCell textFieldCell TextViewCell NSString
 * -writeLabelCell NSMutableDictionary
 *WriteType NSNumber according to the value defined in WidgetDataSource 
 * -0:delivery date label 
 * -1:order date label
 * -4:wholesaler label
 * -3:status label
 * -5:type label
 * -7:contact label
 * -6:call type label
 */
- (void)createLocationSectionData {
    NSString* sectionTitle = @"Location";
    [self.sectionTitleList addObject:sectionTitle];
    [self createLocationSectionDataProcessor];
}

- (void)createLocationSectionDataProcessor {
    NSString* sectionTitle = @"Location";
    NSDictionary* customerDict = [self.orderHeader objectForKey:@"Customer"];
    //    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    //    NSNumber* showLocationCode = [configDict objectForKey:@"ShowlocationCode"];
    NSMutableArray* locationDisplayList = [NSMutableArray arrayWithCapacity:5];
    //    NSString* locationName = [self.orderHeader objectForKey:@"CustName"];
    //    if ([showLocationCode boolValue]) {
    //        locationName = [NSString stringWithFormat:@"%@ [%@]",[self.orderHeader objectForKey:@"CustName"], [ArcosUtils trim:[self.orderHeader objectForKey:@"LocationCode"]]];
    //    }
    
    //    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"CustName" fieldNameLabel:@"Location" fieldData:locationName]];
    //    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address1" fieldNameLabel:@"Address" fieldData:[self.orderHeader objectForKey:@"Address1"]]];
    if (customerDict == nil) {
        [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"CustName" fieldNameLabel:@"Location" fieldData:@""]];
        [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address1" fieldNameLabel:@"Address" fieldData:@""]];
    } else {
        [locationDisplayList addObject:[self createLocationCellDataWithCellKey:@"Customer" fieldNameLabel:@"Location" fieldData:customerDict]];
        [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address1" fieldNameLabel:@"Address" fieldData:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[customerDict objectForKey:@"Address1"]]]]];
        NSString* address2 = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[customerDict objectForKey:@"Address2"]]];
        if (![address2 isEqualToString:@""]) {
            [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address2" fieldNameLabel:@"" fieldData:address2]];
        }
        NSString* address3 = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[customerDict objectForKey:@"Address3"]]];
        if (![address3 isEqualToString:@""]) {
            [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address3" fieldNameLabel:@"" fieldData:address3]];
        }
        NSString* address4 = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[customerDict objectForKey:@"Address4"]]];;
        if (![address4 isEqualToString:@""]) {
            [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address4" fieldNameLabel:@"" fieldData:address4]];
        }
    }
    [self.groupedDataDict setObject:locationDisplayList forKey:sectionTitle];
}

- (void)createContactSectionData {
//    NSString* sectionTitle = @"Contact";
    [self.sectionTitleList addObject:self.contactSectionKey];
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
    
    [self.groupedDataDict setObject:contactDisplayList forKey:self.contactSectionKey];
}

- (void)createOrderDetailsSectionData {
    NSString* sectionTitle = @"Order Details";
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
    NSMutableDictionary* formTypeDict = [self.orderHeader objectForKey:@"formType"];
    if (formTypeDict != nil) {
        [orderDetailDisplayList addObject:[self createFormTypeCellDataWithCellKey:@"formType" fieldNameLabel:@"Form Type" fieldData:formTypeDict]];
    }
    NSMutableDictionary* orderStatusDict = [self addTitleToDict:@"status" titleKey:@"statusText"];
    [orderDetailDisplayList addObject:[self createWriteCellDataWithCellKey:@"status" fieldNameLabel:@"Status" writeType:[NSNumber numberWithInt:3] fieldData:orderStatusDict]];
    NSMutableDictionary* orderTypeDict = [self addTitleToDict:@"type" titleKey:@"orderTypeText"];
    [orderDetailDisplayList addObject:[self createWriteCellDataWithCellKey:@"type" fieldNameLabel:@"Type" writeType:[NSNumber numberWithInt:5] fieldData:orderTypeDict]];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"totalGoodsText" fieldNameLabel:@"Value" fieldData:[self.orderHeader objectForKey:@"totalGoodsText"]]];
    
    [self.groupedDataDict setObject:orderDetailDisplayList forKey:sectionTitle];
}

- (void)createOrderMemoSectionData {
//    NSString* sectionTitle = @"Memo";
    [self.sectionTitleList addObject:self.memoSectionKey];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:3];
    [memoDisplayList addObject:[self createTextFieldCellDataWithCellKey:@"custRef" fieldNameLabel:@"Customer Ref" fieldData:[self.orderHeader objectForKey:@"custRef"]]];
    
    NSMutableDictionary* acctNoDict = [self.orderHeader objectForKey:@"acctNo"];
    [acctNoDict setObject:[self.orderHeader objectForKey:@"acctNoText"] forKey:self.titleKey];
    NSMutableDictionary* acctNoCellDict = [self createWriteCellDataWithCellKey:@"acctNo" fieldNameLabel:@"Account No." writeType:[NSNumber numberWithInt:7] fieldData:acctNoDict];
    [acctNoCellDict setObject:[self.orderHeader objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    [acctNoCellDict setObject:[self.orderHeader objectForKey:@"FromLocationIUR"] forKey:@"FromLocationIUR"];
    [memoDisplayList addObject:acctNoCellDict];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] disableMemoFlag]) {
        [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    }
    
    
    [self.groupedDataDict setObject:memoDisplayList forKey:self.memoSectionKey];
}

- (void)createCallMemoSectionData {
//    NSString* sectionTitle = @"Memo";
    [self.sectionTitleList addObject:self.memoSectionKey];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:2];    
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    
    [self.groupedDataDict setObject:memoDisplayList forKey:self.memoSectionKey];
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

- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType {
//    NSString* sectionTitle = @"Order Details";
    [self.sectionTitleList addObject:aSectionTitle];
    NSMutableArray* detailList = [NSMutableArray arrayWithCapacity:1];
    [detailList addObject:[self createDrillDownCellDataWithFieldNameLabel:aSectionTitle orderHeaderType:anOrderHeaderType]];
    [self.groupedDataDict setObject:detailList forKey:aSectionTitle];
}

- (NSMutableDictionary*)createNumberTextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:7] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

//- (void)createCallDrillDownSectionData {
//    NSString* sectionTitle = @"Call Details";
//    [self.sectionTitleList addObject:sectionTitle];
//    NSMutableArray* callDetailList = [NSMutableArray arrayWithCapacity:1];
//    [callDetailList addObject:[]];
//    [self.groupedDataDict setObject:callDetailList forKey:sectionTitle];
//}

- (NSMutableDictionary*)createDrillDownCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel orderHeaderType:(NSNumber*)anOrderHeaderType {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:6] forKey:@"CellType"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:anOrderHeaderType forKey:@"OrderHeaderType"];
    return cellData;
}

- (void)createPrintSectionData {
    NSString* sectionTitle = @"Print";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* printDisplayList = [NSMutableArray arrayWithCapacity:1];
    [printDisplayList addObject:[self createPrintCellData]];
    
    [self.groupedDataDict setObject:printDisplayList forKey:sectionTitle];
}

- (NSMutableDictionary*)createPrintCellData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:9] forKey:@"CellType"];
    [cellData setObject:@"Print - Email" forKey:@"FieldNameLabel"];
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

- (NSMutableDictionary*)createFormTypeCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSMutableDictionary*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:12] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    return cellData;
}

- (NSMutableDictionary*)createLocationCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSDictionary*)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:4];
    [cellData setObject:[NSNumber numberWithInt:15] forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aFieldNameLabel forKey:@"FieldNameLabel"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
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

- (void)locationInputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    NSLog(@"abc %p", self.orderHeader);
}

- (void)resetContactDataInContactSection {
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:self.contactSectionKey];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* tmpCellDataDict = [tmpDisplayList objectAtIndex:i];
        NSString* tmpCellKey = [tmpCellDataDict objectForKey:@"CellKey"];
        if ([tmpCellKey isEqualToString:@"contact"]) {
            NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"contact"]];
            [contactDict setObject:[self.orderHeader objectForKey:@"contactText"] forKey:self.titleKey];
            [tmpCellDataDict setObject:contactDict forKey:@"FieldData"];
        }
    }
}

- (void)resetAcctNoDataInMemoSection {
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:self.memoSectionKey];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* tmpCellDataDict = [tmpDisplayList objectAtIndex:i];
        NSString* tmpCellKey = [tmpCellDataDict objectForKey:@"CellKey"];
        if ([tmpCellKey isEqualToString:@"acctNo"]) {            
            NSMutableDictionary* acctNoDict = [self.orderHeader objectForKey:@"acctNo"];
            [acctNoDict setObject:[self.orderHeader objectForKey:@"acctNoText"] forKey:self.titleKey];
            [tmpCellDataDict setObject:acctNoDict forKey:@"FieldData"];
        }
    }
}

@end
