//
//  OrderDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailDataManager.h"
@interface OrderDetailDataManager()
- (NSMutableDictionary*)createActionTableDataDict:(NSString*)aTitle actionType:(NSNumber*)anActionType imageFileName:(NSString*)anImageFileName;
@end

@implementation OrderDetailDataManager
@synthesize orderDetailBaseDataManager = _orderDetailBaseDataManager;
//@synthesize orderDetailOrderDataManager = _orderDetailOrderDataManager;
//@synthesize orderDetailCallDataManager = _orderDetailCallDataManager;
@synthesize orderNumber = _orderNumber;
@synthesize savedOrderDetailCellData = _savedOrderDetailCellData;
@synthesize orderHeader = _orderHeader;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize actionTableDataDictList = _actionTableDataDictList;
//@synthesize titleKey = _titleKey;

- (id)init {
    self = [super init];
    if (self != nil) {
//        self.titleKey = @"Title";
    }
    return self;
}

- (void)dealloc {
    if (self.orderDetailBaseDataManager != nil) { self.orderDetailBaseDataManager = nil; }
//    if (self.orderDetailOrderDataManager != nil) { self.orderDetailOrderDataManager = nil; }
//    if (self.orderDetailCallDataManager != nil) { self.orderDetailCallDataManager = nil; }    
    if (self.orderNumber != nil) { self.orderNumber = nil; }
    if (self.savedOrderDetailCellData != nil) { self.savedOrderDetailCellData = nil; }
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    self.actionTableDataDictList = nil;
//    if (self.titleKey != nil) { self.titleKey = nil; }    
    
    [super dealloc];
}

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData {
    self.savedOrderDetailCellData = aCellData;
    self.orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    self.orderHeader = [[ArcosCoreData sharedArcosCoreData] editingOrderHeaderWithOrderNumber:self.orderNumber];
    self.sectionTitleList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    if ([[self.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.orderDetailBaseDataManager = [[[OrderDetailOrderDataManager alloc] init] autorelease];
    } else {
        self.orderDetailBaseDataManager = [[[OrderDetailCallDataManager alloc] init] autorelease];
    }
    self.orderDetailBaseDataManager.orderHeader = self.orderHeader;
    self.orderDetailBaseDataManager.sectionTitleList = self.sectionTitleList;
    self.orderDetailBaseDataManager.groupedDataDict = self.groupedDataDict;
    [self.orderDetailBaseDataManager createAllSectionData];
//    [self createLocationSectionData];    
//    [self createContactSectionData];
//    [self createOrderDetailsSectionData];
//    [self createMemoSectionData];
}
/*
 *DataStructure Specification
 *CellType nsnumber 1:DateCell 2:readLabelCell 3:writeLabelCell 4:textFieldCell 5:TextViewCell
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
/*
- (void)createLocationSectionData {
    NSString* sectionTitle = @"Location";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* locationDisplayList = [NSMutableArray arrayWithCapacity:5];
    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"CustName" fieldNameLabel:@"Name" fieldData:[self.orderHeader objectForKey:@"CustName"]]];
    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address1" fieldNameLabel:@"Address" fieldData:[self.orderHeader objectForKey:@"Address1"]]];
    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address2" fieldNameLabel:@"" fieldData:[self.orderHeader objectForKey:@"Address2"]]];
    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address3" fieldNameLabel:@"" fieldData:[self.orderHeader objectForKey:@"Address3"]]];
    [locationDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"Address4" fieldNameLabel:@"" fieldData:[self.orderHeader objectForKey:@"Address4"]]];
    [self.groupedDataDict setObject:locationDisplayList forKey:sectionTitle];
}

- (void)createContactSectionData {
    NSString* sectionTitle = @"Contact";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"contact"]];
    [contactDict setObject:[self.orderHeader objectForKey:@"contactText"] forKey:self.titleKey];
    
    [contactDisplayList addObject:[self createWriteCellDataWithCellKey:@"contact" fieldNameLabel:@"Name" writeType:[NSNumber numberWithInt:7] fieldData:contactDict]];
    [contactDisplayList addObject:[self createDateLabelCellDataWithCellKey:@"orderDate" fieldNameLabel:@"Date" writeType:[NSNumber numberWithInt:1]]];
    NSMutableDictionary* callTypeDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"callType"]];
    [callTypeDict setObject:[self.orderHeader objectForKey:@"callTypeText"] forKey:self.titleKey];
    [contactDisplayList addObject:[self createWriteCellDataWithCellKey:@"callType" fieldNameLabel:@"Call Type" writeType:[NSNumber numberWithInt:6] fieldData:callTypeDict]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"EmployeeIUR" fieldNameLabel:@"Employee" fieldData:[self employeeName:[self.orderHeader objectForKey:@"EmployeeIUR"]]]];
    
    [self.groupedDataDict setObject:contactDisplayList forKey:sectionTitle];    
}

- (void)createOrderDetailsSectionData {
    NSString* sectionTitle = @"Order Details";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* orderDetailDisplayList = [NSMutableArray arrayWithCapacity:6];
    [orderDetailDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"OrderNumber" fieldNameLabel:@"Number" fieldData:[ArcosUtils convertNumberToIntString:[self.orderHeader objectForKey:@"OrderNumber"]]]];
    [orderDetailDisplayList addObject:[self createDateLabelCellDataWithCellKey:@"deliveryDate" fieldNameLabel:@"Delivery" writeType:[NSNumber numberWithInt:0]]];
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

- (void)createMemoSectionData {
    NSString* sectionTitle = @"Memo";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* memoDisplayList = [NSMutableArray arrayWithCapacity:2];
    [memoDisplayList addObject:[self createTextFieldCellDataWithCellKey:@"custRef" fieldNameLabel:@"Customer Ref" fieldData:[self.orderHeader objectForKey:@"custRef"]]];
    [memoDisplayList addObject:[self createTextViewCellDataWithCellKey:@"memo" fieldNameLabel:@"Memo" fieldData:[self.orderHeader objectForKey:@"memo"]]];
    
    [self.groupedDataDict setObject:memoDisplayList forKey:sectionTitle];
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

- (NSString*)employeeName:(NSNumber*)anEmployeeIUR {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:anEmployeeIUR];
    return [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
}

- (NSMutableDictionary*)addTitleToDict:(NSString*)aCellKey titleKey:(NSString*)aTitleKey {
    NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:aCellKey]];
    [tmpDict setObject:[self.orderHeader objectForKey:aTitleKey] forKey:self.titleKey];
    return tmpDict;
}
*/

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:theIndexpath];
    NSString* cellKey = [cellData objectForKey:@"CellKey"];
    [cellData setObject:data forKey:@"FieldData"];
    [self.orderHeader setObject:data forKey:cellKey];
//    NSLog(@"After amending, order header is: %@",self.orderHeader);
}

- (BOOL)saveTheOrderHeader {
    return [[ArcosCoreData sharedArcosCoreData] saveOrderHeader:self.orderHeader];
}

- (NSMutableArray*)createActionTableDataDictList:(NSMutableDictionary*)aCellData {
    NSMutableArray* auxActionTableDataDictList = [NSMutableArray arrayWithCapacity:2];
    [auxActionTableDataDictList addObject:[self createActionTableDataDict:@"Email" actionType:[NSNumber numberWithInt:1] imageFileName:@"Email.png"]];
    if ([[aCellData objectForKey:@"NumberOflines"] intValue] > 0) {
        [auxActionTableDataDictList addObject:[self createActionTableDataDict:@"Repeat" actionType:[NSNumber numberWithInt:2] imageFileName:@"Repeat.png"]];
    }    
    return auxActionTableDataDictList;
}

- (NSMutableDictionary*)createActionTableDataDict:(NSString*)aTitle actionType:(NSNumber*)anActionType imageFileName:(NSString*)anImageFileName {
    NSMutableDictionary* auxActionTableDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [auxActionTableDataDict setObject:aTitle forKey:@"Title"];
    [auxActionTableDataDict setObject:anActionType forKey:@"ActionType"];
    [auxActionTableDataDict setObject:anImageFileName forKey:@"ImageFileName"];
    return auxActionTableDataDict;
}

@end
