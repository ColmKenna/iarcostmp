//
//  SavedIarcosOrderDetailDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailDataManager.h"
@interface SavedIarcosOrderDetailDataManager ()
- (void)processRemoteCommonRawDataProcessor;
- (NSMutableDictionary*)createActionTableDataDict:(NSString*)aTitle actionType:(NSNumber*)anActionType imageFileName:(NSString*)anImageFileName;
@end

@implementation SavedIarcosOrderDetailDataManager
@synthesize orderNumber = _orderNumber;
@synthesize orderHeader = _orderHeader;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize savedIarcosOrderDetailBaseDataManager = _savedIarcosOrderDetailBaseDataManager;
@synthesize isContactDetailsShowed = _isContactDetailsShowed;
@synthesize isOrderDetailsShowed = _isOrderDetailsShowed;
@synthesize isMemoDetailsShowed = _isMemoDetailsShowed;
@synthesize actionTableDataDictList = _actionTableDataDictList;
@synthesize taskObjectList = _taskObjectList;
@synthesize selectedEmailRecipientDict = _selectedEmailRecipientDict;

- (void)dealloc {
    self.orderNumber = nil;
    self.orderHeader = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.savedIarcosOrderDetailBaseDataManager = nil;
    self.actionTableDataDictList = nil;
    self.taskObjectList = nil;
    self.selectedEmailRecipientDict = nil;
    
    [super dealloc];
}

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData {
    self.orderNumber = [aCellData objectForKey:@"OrderNumber"];
    self.orderHeader = [[ArcosCoreData sharedArcosCoreData] editingOrderHeaderWithOrderNumber:self.orderNumber];
    self.sectionTitleList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    if ([[self.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.savedIarcosOrderDetailBaseDataManager = [[[SavedIarcosOrderDetailOrderDataManager alloc] init] autorelease];
    } else {
        self.savedIarcosOrderDetailBaseDataManager = [[[SavedIarcosOrderDetailCallDataManager alloc] init] autorelease];
    }
    self.savedIarcosOrderDetailBaseDataManager.orderHeader = self.orderHeader;
    self.savedIarcosOrderDetailBaseDataManager.sectionTitleList = self.sectionTitleList;
    self.savedIarcosOrderDetailBaseDataManager.groupedDataDict = self.groupedDataDict;
    [self.savedIarcosOrderDetailBaseDataManager createAllSectionData];
}

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
}

- (BOOL)saveTheOrderHeader {
    return [[ArcosCoreData sharedArcosCoreData] saveOrderHeader:self.orderHeader];
}

- (void)processRemoteOrderDetailRawData:(ArcosGenericClass*)arcosGenericClass cellDict:(NSMutableDictionary*)aCellDict {
    self.orderNumber = [ArcosUtils convertStringToNumber:[arcosGenericClass Field15]];
    self.orderHeader = [NSMutableDictionary dictionaryWithCapacity:24];
    [self.orderHeader setObject:[NSNumber numberWithInt:1] forKey:@"NumberOflines"];
    [self.orderHeader setObject:[ArcosUtils convertStringToNumber:[arcosGenericClass Field1]] forKey:@"OrderHeaderIUR"];
    NSNumber* auxLocationIUR = [ArcosUtils convertNilToZero:[aCellDict objectForKey:@"LocationIUR"]];
    [self.orderHeader setObject:auxLocationIUR forKey:@"LocationIUR"];
    NSArray* auxLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:auxLocationIUR];
    if ([auxLocationList count] > 0) {
        NSDictionary* auxLocationDict = [auxLocationList objectAtIndex:0];
        NSString* auxLocationCode = [ArcosUtils convertNilToEmpty:[auxLocationDict objectForKey:@"LocationCode"]];
        [self.orderHeader setObject:auxLocationCode forKey:@"LocationCode"];
    }
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field2]] forKey:@"CustName"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field3]] forKey:@"Address1"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field4]] forKey:@"Address2"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field5]] forKey:@"Address3"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field6]] forKey:@"Address4"];
    NSNumber* contactIURNumber = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field18]]];
    NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [contactDict setObject:contactIURNumber forKey:@"IUR"];
    [self.orderHeader setObject:contactDict forKey:@"contact"];
    NSString* contactText = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field19]];
    if ([contactText isEqualToString:@""]) {
        contactText = [GlobalSharedClass shared].unassignedText;
    }
    [self.orderHeader setObject:contactText forKey:@"contactText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field16]] forKey:@"orderDateText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field31]] forKey:@"callTypeText"];    
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field8]] forKey:@"Employee"];
    [self.orderHeader setObject:[ArcosUtils convertStringToNumber:[arcosGenericClass Field15]] forKey:@"OrderNumber"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field20]] forKey:@"deliveryDateText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field22]] forKey:@"wholesalerText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field14]] forKey:@"statusText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field10]] forKey:@"orderTypeText"];
    [self.orderHeader setObject:[NSString stringWithFormat:@"%.2f", [[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field27]] floatValue]] forKey:@"totalGoodsText"];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        [self.orderHeader setObject:[NSString stringWithFormat:@"%.2f", [[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field27]] floatValue]] forKey:@"totalGoodsText"];
    } else {
        [self.orderHeader setObject:[NSString stringWithFormat:@"%.2f", ([[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field27]] floatValue] + [[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field34]] floatValue])] forKey:@"totalGoodsText"];
    }
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field29]] forKey:@"custRef"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field30]] forKey:@"acctNoText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field28]] forKey:@"memo"];
    [self.orderHeader setObject:[SettingManager employeeIUR] forKey:@"EmployeeIUR"];
    [self.orderHeader setObject:[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field27]] forKey:@"TotalGoods"];
    [self.orderHeader setObject:[ArcosUtils convertStringToFloatNumber:[arcosGenericClass Field34]] forKey:@"TotalVat"];
    [self.orderHeader setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field24]]] forKey:@"invoiceRef"];
    [self.orderHeader setObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field33]]]] forKey:@"InvoiceHeaderIUR"];
    NSNumber* formIUR = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field11]]];
    [self.orderHeader setObject:formIUR forKey:@"FormIUR"];
    NSDictionary* auxFormTypeDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:formIUR];    
    if (auxFormTypeDict != nil) {
        NSMutableDictionary* formTypeDict = [NSMutableDictionary dictionaryWithDictionary:auxFormTypeDict];
        [self.orderHeader setObject:formTypeDict forKey:@"formType"];
    }
    NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [acctNoDict setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field30]] forKey:@"acctNo"];
    [acctNoDict setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field30]] forKey:@"Title"];
    [self.orderHeader setObject:acctNoDict forKey:@"acctNo"];
    NSNumber* orderTypeNumber = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field9]]];
    NSMutableDictionary* orderTypeDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [orderTypeDict setObject:orderTypeNumber forKey:@"DescrDetailIUR"];
    
    [self.orderHeader setObject:orderTypeDict forKey:@"type"];
    NSNumber* callTypeIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:2];
    [self.orderHeader setObject:[NSMutableDictionary dictionaryWithObject:callTypeIUR forKey:@"DescrDetailIUR"] forKey:@"callType"];
    NSNumber* wholesalerIUR = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field21]]];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field25] forKey:@"DeliveryInstructions1"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field26] forKey:@"DeliveryInstructions2"];
    NSMutableDictionary* wholesalerDict = [[[ArcosCoreData sharedArcosCoreData] locationWithIUR: wholesalerIUR] objectAtIndex:0];
    if (wholesalerDict == nil) {
        wholesalerDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [wholesalerDict setObject:wholesalerIUR forKey:@"LocationIUR"];        
    }
    [self.orderHeader setObject:wholesalerDict forKey:@"wholesaler"];
    [self.orderHeader setObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"] forKey:@"memoType"];
    
    int subObjectsCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[[arcosGenericClass SubObjects] count]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:subObjectsCount];
    for (int i = 0; i < subObjectsCount; i++) {
        ArcosGenericClass* subArcosGenericClass = [[arcosGenericClass SubObjects] objectAtIndex:i];
        [productIURList addObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field11]]];
    }
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    //come back later
    NSMutableArray* orderlineList = [NSMutableArray arrayWithCapacity:subObjectsCount];
    for (int i = 0; i < subObjectsCount; i++) {
        ArcosGenericClass* subArcosGenericClass = [[arcosGenericClass SubObjects] objectAtIndex:i];
        NSMutableDictionary* orderlineDict = [NSMutableDictionary dictionaryWithCapacity:12];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field2]] forKey:@"Qty"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field3]] forKey:@"Bonus"];
        [orderlineDict setObject:[ArcosUtils convertStringToFloatNumber:[subArcosGenericClass Field7]] forKey:@"LineValue"];
        [orderlineDict setObject:[ArcosUtils convertStringToFloatNumber:[subArcosGenericClass Field18]] forKey:@"vatAmount"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field10]] forKey:@"DiscountPercent"];
        NSNumber* tmpProductIUR = [ArcosUtils convertStringToNumber:[subArcosGenericClass Field11]];
        [orderlineDict setObject:tmpProductIUR forKey:@"ProductIUR"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field12]] forKey:@"InStock"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field13]] forKey:@"FOC"];
        [orderlineDict setObject:[ArcosUtils convertStringToNumber:[subArcosGenericClass Field17]] forKey:@"Testers"];
        NSDictionary* aProduct = [productDictHashMap objectForKey:tmpProductIUR];
        [orderlineList addObject:[ProductFormRowConverter createStandardOrderLine:orderlineDict product:aProduct]];
    }
    [self.orderHeader setObject:orderlineList forKey:@"RemoteOrderline"];
    [self.orderHeader setObject:[NSNumber numberWithInt:1] forKey:@"CoordinateType"];
    
    self.savedIarcosOrderDetailBaseDataManager = [[[SavedIarcosOrderDetailRemoteOrderDataManager alloc] init] autorelease];
    [self processRemoteCommonRawDataProcessor];
}

- (void)processRemoteCallDetailRawData:(ArcosGenericClass*)arcosGenericClass cellDict:(NSMutableDictionary*)aCellDict {
    self.orderNumber = [ArcosUtils convertStringToNumber:[arcosGenericClass Field1]];
    self.orderHeader = [NSMutableDictionary dictionaryWithCapacity:14];
    [self.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"NumberOflines"];
    [self.orderHeader setObject:[ArcosUtils convertNilToZero:[aCellDict objectForKey:@"LocationIUR"]] forKey:@"LocationIUR"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field3]] forKey:@"CustName"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field4]] forKey:@"Address1"];
    [self.orderHeader setObject:@"" forKey:@"Address2"];
    [self.orderHeader setObject:@"" forKey:@"Address3"];
    [self.orderHeader setObject:@"" forKey:@"Address4"];
    
    NSString* contactText = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field13]];
    if ([contactText isEqualToString:@""]) {
        contactText = [GlobalSharedClass shared].unassignedText;
    }
    [self.orderHeader setObject:contactText forKey:@"contactText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field2]] forKey:@"orderDateText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field6] forKey:@"callTypeText"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field8]] forKey:@"Employee"];
    [self.orderHeader setObject:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field11]] forKey:@"memo"];
    int subObjectsCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[[arcosGenericClass SubObjects] count]];
    NSMutableArray* calltranList = [NSMutableArray arrayWithCapacity:subObjectsCount];
    for (int i = 0; i < subObjectsCount; i++) {
        ArcosGenericClass* subArcosGenericClass = [[arcosGenericClass SubObjects] objectAtIndex:i];
        ArcosCallTran* arcosCallTran = [[ArcosCallTran alloc] init];
        arcosCallTran.DetailIUR = [[ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:subArcosGenericClass.Field8]] intValue];
        arcosCallTran.Reference = [ArcosUtils convertNilToEmpty:subArcosGenericClass.Field9];
        arcosCallTran.Score = [[ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:subArcosGenericClass.Field10]] intValue];
        arcosCallTran.DetailLevel = [ArcosUtils convertNilToEmpty:subArcosGenericClass.Field11];
        if ([arcosCallTran.DetailLevel isEqualToString:@"PS"]) {
            arcosCallTran.Reference = [ArcosUtils convertNilToEmpty:subArcosGenericClass.Field10];
        }
        if ([arcosCallTran.DetailLevel isEqualToString:@"MC"]) {
            arcosCallTran.Reference = [NSString stringWithFormat:@"%@|%@", [ArcosUtils convertNilToEmpty:subArcosGenericClass.Field4], [ArcosUtils convertNilToEmpty:subArcosGenericClass.Field3]];
        }
        arcosCallTran.ProductIUR = [[ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:subArcosGenericClass.Field12]] intValue];
        [calltranList addObject:arcosCallTran];
        [arcosCallTran release];
    }
    [self.orderHeader setObject:calltranList forKey:@"RemoteCallTrans"];
    [self.orderHeader setObject:[NSNumber numberWithInt:1] forKey:@"CoordinateType"];
    self.savedIarcosOrderDetailBaseDataManager = [[[SavedIarcosOrderDetailRemoteCallDataManager alloc] init] autorelease];
    [self processRemoteCommonRawDataProcessor];
}

- (void)processRemoteCommonRawDataProcessor {
    self.sectionTitleList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    
    self.savedIarcosOrderDetailBaseDataManager.orderHeader = self.orderHeader;
    self.savedIarcosOrderDetailBaseDataManager.sectionTitleList = self.sectionTitleList;
    self.savedIarcosOrderDetailBaseDataManager.groupedDataDict = self.groupedDataDict;
    [self.savedIarcosOrderDetailBaseDataManager createAllSectionData];
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
