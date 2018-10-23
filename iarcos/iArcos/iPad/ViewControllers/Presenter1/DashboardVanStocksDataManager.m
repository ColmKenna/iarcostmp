//
//  DashboardVanStocksDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDataManager.h"

@implementation DashboardVanStocksDataManager
@synthesize fileName = _fileName;
@synthesize displayList = _displayList;
@synthesize commaDelimiter = _commaDelimiter;
@synthesize vanStockDictList = _vanStockDictList;
@synthesize expectedFieldCount = _expectedFieldCount;
@synthesize firstDate = _firstDate;
@synthesize existingObjectDict = _existingObjectDict;
@synthesize existingObjectList = _existingObjectList;
@synthesize rowPointer = _rowPointer;
@synthesize isSaveRecordLoadingFinished = _isSaveRecordLoadingFinished;
@synthesize productCodeList = _productCodeList;
@synthesize formDetails = _formDetails;
@synthesize vanSalesFormDetailDict = _vanSalesFormDetailDict;

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.fileName = @"VAN_sales_";
        self.commaDelimiter = @",";
        self.expectedFieldCount = 3;
        self.formDetails = @"VAN SALES";
    }
    
    return self;
}

- (void)dealloc {
    self.fileName = nil;
    self.displayList = nil;
    self.commaDelimiter = nil;
    self.vanStockDictList = nil;
    self.firstDate = nil;
    self.existingObjectDict = nil;
    self.existingObjectList = nil;
    self.productCodeList = nil;
    self.formDetails = nil;
    self.vanSalesFormDetailDict = nil;
    
    [super dealloc];
}

- (NSString*)retrieveFileName {
    return [NSString stringWithFormat:@"%@%@.csv", self.fileName, [SettingManager employeeIUR]];
}

- (void)retrieveStockOnOrderProducts {
    NSArray* properties = [NSArray arrayWithObjects:@"ProductIUR", @"ProductCode", @"Description", @"Productsize", @"StockonOrder", @"StockonHand", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' AND (StockonOrder != 0 OR StockonHand != 0)"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderPadDetails", @"Description", nil];
    self.displayList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
}

- (NSMutableDictionary*)createVanStockDictWithFieldList:(NSArray*)aFieldList {
    NSMutableDictionary* vanStockDict = [NSMutableDictionary dictionaryWithCapacity:3];
    @try {
        [vanStockDict setObject:[aFieldList objectAtIndex:0] forKey:@"Date"];
        [vanStockDict setObject:[aFieldList objectAtIndex:1] forKey:@"ProductCode"];
//        [vanStockDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[aFieldList objectAtIndex:2]]] forKey:@"StockonOrder"];
        [vanStockDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[aFieldList objectAtIndex:2]]] forKey:@"StockonHand"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }    
    return vanStockDict;
}

- (void)processRawData:(NSArray*)aRecordList {
    self.productCodeList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    self.vanStockDictList = [NSMutableArray arrayWithCapacity:[aRecordList count]]; 
    BOOL dateRetrievedFlag = NO;
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.commaDelimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            if (!dateRetrievedFlag) {
                self.firstDate = [ArcosUtils trim:[fieldList objectAtIndex:0]];
                dateRetrievedFlag = YES;
            }            
            NSString* productCode = [ArcosUtils trim:[fieldList objectAtIndex:1]];
            [self.productCodeList addObject:productCode];
            [self.vanStockDictList addObject:[self createVanStockDictWithFieldList:fieldList]];
        }
    }        
}

- (void)retrieveExistingObjectDict {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductCode in %@", self.productCodeList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderPadDetails", @"Description",nil];
    self.existingObjectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[self.existingObjectList count]];
    for (Product* aProduct in self.existingObjectList) {
        [self.existingObjectDict setObject:aProduct forKey:aProduct.ProductCode];
    }
}

- (void)loadObjectWithDict:(NSMutableDictionary*)aDict {
    NSString* productCode = [aDict objectForKey:@"ProductCode"];
    Product* existingProduct = [self.existingObjectDict objectForKey:productCode];
    if (existingProduct != nil) {
//        existingProduct.StockonOrder = [aDict objectForKey:@"StockonOrder"];
        existingProduct.StockonHand = [NSNumber numberWithInt:[[aDict objectForKey:@"StockonHand"] intValue]];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
        [self createFormRowWithProductDict:existingProduct];        
    }
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductCode = %@", productCode];
//    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    if ([objectArray count] > 0) {
//        Product* existingProduct = [objectArray objectAtIndex:0];
//        existingProduct.StockonOrder = [aDict objectForKey:@"StockonOrder"];
//        existingProduct.StockonHand = [aDict objectForKey:@"StockonHand"];
//        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
//    }    
}

- (void)resetVanStockData {
    //come back later
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"StockonOrder != 0 and StockonHand != 0"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"StockonHand != 0"];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext withEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    for (Product* aProduct in objectArray) {
//        aProduct.StockonOrder = [NSNumber numberWithInt:0];
        aProduct.StockonHand = [NSNumber numberWithInt:0];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (BOOL)orderButtonPressed:(UIViewController*)aTarget {
    NSMutableArray* idealProductList = [self retrieveIdealProductList];
    if ([idealProductList count] == 0) {
        [ArcosUtils showDialogBox:@"No ideal product found" title:@"" delegate:nil target:aTarget tag:0 handler:^(UIAlertAction *action) {}];
        return NO;
    }
    NSString* locationCode = [self retrieveLocationCodeWithEmployeeIUR:[SettingManager employeeIUR]];    
    if ([locationCode isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"No location code found" title:@"" delegate:nil target:aTarget tag:0 handler:^(UIAlertAction *action) {}];
        return NO;
    }
    NSMutableArray* locationList = [self retrieveLocationWithLocationCode:locationCode];
    if ([locationList count] == 0) {
        [ArcosUtils showDialogBox:@"No location found" title:@"" delegate:nil target:aTarget tag:0 handler:^(UIAlertAction *action) {}];
        return NO;
    }
    NSDictionary* locationDict = [locationList objectAtIndex:0];
    NSNumber* CTiur = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:2];
    NSNumber* OSiur = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:3];
//    NSNumber* OTiur = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:4];
    NSNumber* OTiur = [NSNumber numberWithInt:0];
//    NSNumber* FORMiur = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:7];
    NSNumber* FORMiur = [NSNumber numberWithInt:0];
    NSDate* currentDate = [NSDate date];
    OrderHeader* OH = [NSEntityDescription insertNewObjectForEntityForName:@"OrderHeader" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    OH.EnteredDate = [NSDate date];
    OH.LocationIUR = [locationDict objectForKey:@"LocationIUR"];
    OH.LocationCode = [locationDict objectForKey:@"LocationCode"];
    OH.EmployeeIUR = [SettingManager employeeIUR];
    OH.FormIUR = FORMiur;
    NSDictionary* formDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormType:@"8000"];
    if (formDetailDict != nil) {
        OH.FormIUR = [formDetailDict objectForKey:@"IUR"];
    }
    NSNumber* orderNumber = [[GlobalSharedClass shared] currentTimeStamp];
    OH.OrderNumber = orderNumber;
    OH.CustomerRef = @"";
    OH.PromotionIUR = [NSNumber numberWithInt:0];
    OH.OrderDate = currentDate;
    OH.OSiur = OSiur;
    OH.OTiur = OTiur; 
    NSMutableArray* replObjectList = [self retrieveDescrDetailWithDescrTypeCode:@"OT" descrDetailCode:@"REPL"];
    if ([replObjectList count] > 0) {
        NSDictionary* descrDetailDict = [replObjectList objectAtIndex:0];
        OH.OTiur = [descrDetailDict objectForKey:@"DescrDetailIUR"];
    }    
    OH.DeliveryDate = currentDate;    
    OH.WholesaleIUR = [NSNumber numberWithInt:0];
    NSMutableArray* wholesalerList = [[ArcosCoreData sharedArcosCoreData]orderWholeSalers];    
    if ([wholesalerList count] == 1) {
        NSMutableDictionary* wholesalerDict = [wholesalerList objectAtIndex:0];
        OH.WholesaleIUR = [wholesalerDict objectForKey:@"LocationIUR"];
    }
    OH.ContactIUR = [NSNumber numberWithInt:0];
    float totalGoods = 0.0f;
    int totalQty = 0;
    int lineNumber = 0;
    NSNumber* defaultNumberValue = [NSNumber numberWithInt:0];
    NSMutableSet* orderLineSet = [NSMutableSet set];
    for (int i = 0; i < [idealProductList count]; i++) {
        lineNumber++;
        NSDictionary* productDict = [idealProductList objectAtIndex:i];
        OrderLine* OL = [NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
        OL.OrderLine = [NSNumber numberWithInt:lineNumber];
        OL.LocationIUR = [locationDict objectForKey:@"LocationIUR"];
        OL.OrderNumber = orderNumber;
        OL.ProductIUR = [productDict objectForKey:@"ProductIUR"];
        OL.OrderDate = currentDate;
        OL.UnitPrice = [productDict objectForKey:@"UnitTradePrice"];
        int qty = [[productDict objectForKey:@"StockonOrder"] intValue] - [[productDict objectForKey:@"StockonHand"] intValue];
        totalQty += qty;
        float lineValue = [[productDict objectForKey:@"UnitTradePrice"] floatValue] * qty;        
        totalGoods += lineValue;
        OL.LineValue = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:lineValue] decimalValue]];
        OL.Qty = [NSNumber numberWithInt:qty];
        OL.Bonus = defaultNumberValue;
        OL.DiscountPercent = [NSDecimalNumber zero];
        OL.InStock = defaultNumberValue;
        OL.FOC = defaultNumberValue;
        OL.orderheader = OH;
        [orderLineSet addObject:OL];
    }
    OH.TotalGoods = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:totalGoods] decimalValue]];
    OH.TotalQty = [NSNumber numberWithInt:totalQty];
    OH.TotalBonus = defaultNumberValue;
    OH.NumberOflines = [NSNumber numberWithInt:lineNumber];
    OH.Latitude = defaultNumberValue;
    OH.Longitude = defaultNumberValue;
    OH.ExchangeRate = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    OH.InvoiseRef = @"";
    
    [OH addOrderlines:orderLineSet];
    Call* CA = nil;
    CA = [NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    CA.ContactIUR = OH.ContactIUR;
    CA.CTiur = CTiur;
    CA.CallDate = OH.OrderDate;
    CA.EmployeeIUR = OH.EmployeeIUR;
    CA.Latitude = OH.Latitude;
    CA.Longitude = OH.Longitude;
    CA.LocationIUR = OH.LocationIUR;    
    
    CA.orderheader = OH;
    OH.call = CA;
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    return YES;
}

- (NSMutableArray*)retrieveIdealProductList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"StockonOrder != 0"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderPadDetails", @"Description",nil];
    
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectArray;
}

- (NSMutableArray*)retrieveLocationWithLocationCode:(NSString*)aLocationCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationCode = %@", aLocationCode];
    
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectArray;
}

- (NSMutableArray*)retrieveDescrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode = %@", aDescrTypeCode, aDescrDetailCode];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR", nil]; 
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSString*)retrieveLocationCodeWithEmployeeIUR:(NSNumber*)anEmployeeIUR {
    NSString* locationCode = @"";
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:anEmployeeIUR];
    if (employeeDict != nil) {
        locationCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"EmployeeCode"]]];
    }
    
    return locationCode;
}

- (NSDictionary*)retrieveVanSalesFormDetail {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Details = %@", self.formDetails];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        return [objectList objectAtIndex:0];
    }
    return nil;
}

- (void)removeVanSalesFormRow {
    if (self.vanSalesFormDetailDict == nil) return;
    [[ArcosCoreData sharedArcosCoreData] deleteFormRowWithFormIUR:[self.vanSalesFormDetailDict objectForKey:@"IUR"]];
}

- (void)createFormRowWithProductDict:(Product*)aProduct {
    if (self.vanSalesFormDetailDict == nil) return;
    FormRow* FormRow = [NSEntityDescription
                        insertNewObjectForEntityForName:@"FormRow" 
                        inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    FormRow.FormIUR = [NSNumber numberWithInt:[[self.vanSalesFormDetailDict objectForKey:@"IUR"] intValue]];
    FormRow.ProductIUR = [NSNumber numberWithInt:[aProduct.ProductIUR intValue]];
    FormRow.SequenceDivider = [NSNumber numberWithInt:1];
    FormRow.SequenceNumber = [NSNumber numberWithInt:self.rowPointer + 1];
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
}

@end
