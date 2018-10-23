//
//  CustomerIarcosSavedOrderDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosSavedOrderDataManager.h"
@interface CustomerIarcosSavedOrderDataManager ()
- (BOOL)checkToIgnoreCallWithOrderHeader:(OrderHeader*)anOrderHeader locationDefaultContactIUR:(NSNumber*)aLocationDefaultContactIUR;
- (NSMutableDictionary*)createTableDataDict:(NSString*)aTitle numberOfLines:(NSNumber*)aNumberOfLines imageFileName:(NSString*)anImageFileName;
@end

@implementation CustomerIarcosSavedOrderDataManager
@synthesize displayList = _displayList;
@synthesize locationIUR = _locationIUR;
@synthesize currentSelectedOrderHeader = _currentSelectedOrderHeader;
@synthesize sendingIndexPath = _sendingIndexPath;
@synthesize sendingOrderNumber = _sendingOrderNumber;
@synthesize sendingSuccessFlag = _sendingSuccessFlag;
@synthesize remoteTableDataDictList = _remoteTableDataDictList;
@synthesize currentNumberOflines = _currentNumberOflines;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];
        self.locationIUR = aLocationIUR;
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.locationIUR = nil;
    self.currentSelectedOrderHeader = nil;
    self.sendingIndexPath = nil;
    self.sendingOrderNumber = nil;
    self.remoteTableDataDictList = nil;
    self.currentNumberOflines = nil;
    
    [super dealloc];
}

- (void)orderListingWithLocationIUR:(NSNumber*)aLocationIUR locationDefaultContactIUR:(NSNumber*)aLocationDefaultContactIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@", aLocationIUR];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] checkDrilldownOfOrderCall] && aLocationDefaultContactIUR != nil && [aLocationDefaultContactIUR intValue] != 0) {
        predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ or ContactIUR = %@", aLocationIUR, aLocationDefaultContactIUR];
    }
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderDate",nil];
    NSMutableArray* orderList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    
    NSMutableArray* orderCallTypeIURList = [NSMutableArray array];
    NSMutableArray* employeeIURList = [NSMutableArray array];
    NSMutableArray* contactIURList = [NSMutableArray array];
    NSMutableArray* locationIURList = [NSMutableArray array];
    for (int i = 0; i < [orderList count]; i++) {
        OrderHeader* tmpOrderHeader = [orderList objectAtIndex:i];
        if ([self checkToIgnoreCallWithOrderHeader:tmpOrderHeader locationDefaultContactIUR:aLocationDefaultContactIUR]) continue;
        NSNumber* orderTypeIUR = tmpOrderHeader.OTiur;
        NSNumber* callTypeIUR = tmpOrderHeader.call.CTiur;
        NSNumber* employeeIUR = tmpOrderHeader.EmployeeIUR;
        if (orderTypeIUR != nil && ![orderCallTypeIURList containsObject:orderTypeIUR]) {
            [orderCallTypeIURList addObject:orderTypeIUR];
        }
        if (callTypeIUR != nil && ![orderCallTypeIURList containsObject:callTypeIUR]) {
            [orderCallTypeIURList addObject:callTypeIUR];
        }
        if (![employeeIURList containsObject:employeeIUR]) {
            [employeeIURList addObject:employeeIUR];
        }
        if ([tmpOrderHeader.NumberOflines intValue] == 0) {//
            if ([tmpOrderHeader.ContactIUR intValue] != 0) {
                if (![contactIURList containsObject:tmpOrderHeader.ContactIUR]) {
                    [contactIURList addObject:tmpOrderHeader.ContactIUR];
                }
            } else {
                if (![locationIURList containsObject:tmpOrderHeader.LocationIUR]) {
                    [locationIURList addObject:tmpOrderHeader.LocationIUR];
                }
            }
        } else {
            if (![locationIURList containsObject:tmpOrderHeader.WholesaleIUR]) {
                [locationIURList addObject:tmpOrderHeader.WholesaleIUR];
            }
        }
    }
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:orderCallTypeIURList];
    NSMutableDictionary* descrDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailList count]];
    for (int i = 0; i < [descrDetailList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [descrDetailList objectAtIndex:i];
        NSNumber* descrDetailIUR = [tmpDescrDetailDict objectForKey:@"DescrDetailIUR"];
        [descrDetailHashMap setObject:tmpDescrDetailDict forKey:descrDetailIUR];
    }
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] employeeWithIURList:employeeIURList];
    NSMutableDictionary* employeeHashMap = [NSMutableDictionary dictionaryWithCapacity:[employeeList count]];
    for (int i = 0; i < [employeeList count]; i++) {
        NSDictionary* tmpEmployeeDict = [employeeList objectAtIndex:i];
        NSNumber* employeeIUR = [tmpEmployeeDict objectForKey:@"IUR"];
        [employeeHashMap setObject:tmpEmployeeDict forKey:employeeIUR];
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIURList:contactIURList];
    NSMutableDictionary* contactHashMap = [NSMutableDictionary dictionaryWithCapacity:[contactList count]];
    for (int i = 0; i < [contactList count]; i++) {
        NSDictionary* tmpContactDict = [contactList objectAtIndex:i];
        NSNumber* contactIUR = [tmpContactDict objectForKey:@"IUR"];
        [contactHashMap setObject:tmpContactDict forKey:contactIUR];
    }
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationsWithIURList:locationIURList];
    NSMutableDictionary* locationHashMap = [NSMutableDictionary dictionaryWithCapacity:[locationList count]];
    for (int i = 0; i < [locationList count]; i++) {
        NSDictionary* tmpLocationDict = [locationList objectAtIndex:i];
        NSNumber* locationIUR = [tmpLocationDict objectForKey:@"LocationIUR"];
        [locationHashMap setObject:tmpLocationDict forKey:locationIUR];
    }
    
    self.displayList = [NSMutableArray arrayWithCapacity:[orderList count]];
    for (int i = 0; i < [orderList count]; i++) {
        OrderHeader* tmpOrderHeader = [orderList objectAtIndex:i];
        if ([self checkToIgnoreCallWithOrderHeader:tmpOrderHeader locationDefaultContactIUR:aLocationDefaultContactIUR]) continue;
        NSMutableDictionary* orderCallDict = [NSMutableDictionary dictionary];
        if ([tmpOrderHeader.OrderHeaderIUR intValue] == 0) {
            [orderCallDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSealed"];
        } else {
            [orderCallDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSealed"];
        }
        [orderCallDict setObject:tmpOrderHeader.OrderHeaderIUR forKey:@"OrderHeaderIUR"];
        [orderCallDict setObject:tmpOrderHeader.LocationIUR forKey:@"LocationIUR"];
        [orderCallDict setObject:tmpOrderHeader.OrderNumber forKey:@"OrderNumber"];
        [orderCallDict setObject:tmpOrderHeader.OrderDate forKey:@"OrderDate"];
        [orderCallDict setObject:tmpOrderHeader.NumberOflines forKey:@"NumberOflines"];
        [orderCallDict setObject:tmpOrderHeader.DeliveryDate forKey:@"DeliveryDate"];
        [orderCallDict setObject:tmpOrderHeader.FormIUR forKey:@"FormIUR"];
        NSNumber* myContactIUR = tmpOrderHeader.ContactIUR;
        if (myContactIUR == nil) {
            [orderCallDict setObject:[NSNumber numberWithInt:0] forKey:@"ContactIUR"];
        } else {
            [orderCallDict setObject:myContactIUR forKey:@"ContactIUR"];
        }
        
        NSDictionary* employeeDict = [employeeHashMap objectForKey:tmpOrderHeader.EmployeeIUR];
        if (employeeDict != nil) {
            NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
            [orderCallDict setObject:employeeName forKey:@"Employee"];
        }
        if ([tmpOrderHeader.NumberOflines intValue] == 0) {//contact
            NSDictionary* CTDict = [descrDetailHashMap objectForKey:tmpOrderHeader.call.CTiur];
            [orderCallDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.call.CTiur] forKey:@"CTiur"];
            [orderCallDict setObject:[ArcosUtils convertNilToEmpty:[CTDict objectForKey:@"Detail"]] forKey:@"CallTypeText"];
            if ([tmpOrderHeader.ContactIUR intValue] == 0) {
                NSDictionary* locationDict = [locationHashMap objectForKey:tmpOrderHeader.LocationIUR];
                [orderCallDict setObject:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]] forKey:@"LocationNameText"];
            } else {
                NSDictionary* contactDict = [contactHashMap objectForKey:tmpOrderHeader.ContactIUR];
                NSString* contactName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Forename"]], [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Surname"]]];
                [orderCallDict setObject:contactName forKey:@"ContactNameText"];
            }
        } else {
            NSDictionary* OTDict = [descrDetailHashMap objectForKey:tmpOrderHeader.OTiur];
            [orderCallDict setObject:[ArcosUtils convertNilToEmpty:[OTDict objectForKey:@"Detail"]] forKey:@"OrderTypeText"];
            [orderCallDict setObject:tmpOrderHeader.TotalGoods forKey:@"TotalGoods"];
            NSDictionary* wholesaleDict = [locationHashMap objectForKey:tmpOrderHeader.WholesaleIUR];
            [orderCallDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.WholesaleIUR] forKey:@"WholesaleIUR"];
            [orderCallDict setObject:[ArcosUtils convertNilToEmpty:[wholesaleDict objectForKey:@"Name"]] forKey:@"WholesaleNameText"];
        }
        [self.displayList addObject:orderCallDict];
    }
//    NSLog(@"displaylist: %@", self.displayList);
}

- (BOOL)checkToIgnoreCallWithOrderHeader:(OrderHeader*)anOrderHeader locationDefaultContactIUR:(NSNumber*)aLocationDefaultContactIUR {
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] checkDrilldownOfOrderCall] && [anOrderHeader.NumberOflines intValue] == 0 && aLocationDefaultContactIUR != nil && [aLocationDefaultContactIUR intValue] != 0){
        if([anOrderHeader.ContactIUR intValue] == [aLocationDefaultContactIUR intValue]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (NSMutableArray*)createTableDataDictList {
    NSMutableArray* tableDataList = [NSMutableArray arrayWithCapacity:2];
    [tableDataList addObject:[self createTableDataDict:@"Order" numberOfLines:[NSNumber numberWithInt:1] imageFileName:@"Order_sent.png"]];
    [tableDataList addObject:[self createTableDataDict:@"Call" numberOfLines:[NSNumber numberWithInt:0] imageFileName:@"Memo_sent.png"]];
    return tableDataList;
}

- (NSMutableDictionary*)createTableDataDict:(NSString*)aTitle numberOfLines:(NSNumber*)aNumberOfLines imageFileName:(NSString*)anImageFileName{
    NSMutableDictionary* tableDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tableDataDict setObject:aTitle forKey:@"Title"];
    [tableDataDict setObject:aNumberOfLines forKey:@"NumberOflines"];
    [tableDataDict setObject:anImageFileName forKey:@"ImageFileName"];
    return tableDataDict;
}

- (void)processRemoteOrderRawData:(NSMutableArray*)aDataList {
    self.displayList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    NSMutableDictionary* descrDetailIURHashMap = [NSMutableDictionary dictionary];
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        NSString* OTIURStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field10]];
        if (![OTIURStr isEqualToString:@""]) {
            [descrDetailIURHashMap setObject:[ArcosUtils convertStringToNumber:OTIURStr] forKey:OTIURStr];
        }
        NSString* OSIURStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field11]];
        if (![OSIURStr isEqualToString:@""]) {
            [descrDetailIURHashMap setObject:[ArcosUtils convertStringToNumber:OSIURStr] forKey:OSIURStr];
        }
        
    }
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithArray:[descrDetailIURHashMap allValues]];
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:descrDetailIURList];
    NSMutableDictionary* descrDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailList count]];
    for (int i = 0; i < [descrDetailList count]; i++) {
        NSDictionary* descrDetailDict = [descrDetailList objectAtIndex:i];
        [descrDetailHashMap setObject:[ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"Detail"]] forKey:[descrDetailDict objectForKey:@"DescrDetailIUR"]];
    }
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:14];
        [cellData setObject:[NSNumber numberWithInt:1] forKey:@"NumberOflines"];
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSealed"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field1] forKey:@"OrderHeaderIUR"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field2] forKey:@"OrderNumber"];
        NSDate* orderDate = [ArcosUtils dateFromString:arcosGenericClass.Field3 format:[GlobalSharedClass shared].dateFormat];
        orderDate = [ArcosUtils addHours:1 date:orderDate];
        [cellData setObject:orderDate forKey:@"OrderDate"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field8] forKey:@"WholesaleNameText"];
        [cellData setObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field9]]] forKey:@"WholesaleIUR"];
        [cellData setObject:[ArcosUtils convertStringToFloatNumber:arcosGenericClass.Field5] forKey:@"TotalGoods"];
        NSDate* deliveryDate = [ArcosUtils dateFromString:arcosGenericClass.Field6 format:[GlobalSharedClass shared].dateFormat];
        deliveryDate = [ArcosUtils addHours:1 date:deliveryDate];
        [cellData setObject:deliveryDate forKey:@"DeliveryDate"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field4] forKey:@"Employee"];
        NSNumber* auxOTIUR = [ArcosUtils convertStringToNumber:arcosGenericClass.Field10];
        NSString* auxOrderTypeDesc = [descrDetailHashMap objectForKey:auxOTIUR];
        if (auxOrderTypeDesc == nil) {
//            [cellData setObject:[GlobalSharedClass shared].unassignedText forKey:@"OrderTypeText"];
            auxOrderTypeDesc = [GlobalSharedClass shared].unassignedText;
        }
//        else {
//            [cellData setObject:auxOrderTypeDesc forKey:@"OrderTypeText"];
//        }
        NSNumber* auxOSIUR = [ArcosUtils convertStringToNumber:arcosGenericClass.Field11];
        NSString* auxOrderStatusDesc = [descrDetailHashMap objectForKey:auxOSIUR];
        if (auxOrderStatusDesc == nil) {
            auxOrderStatusDesc = [GlobalSharedClass shared].unassignedText;
        }
        [cellData setObject:[NSString stringWithFormat:@"%@ (%@)", auxOrderTypeDesc, auxOrderStatusDesc] forKey:@"OrderTypeText"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field7] forKey:@"LocationIUR"];
        [cellData setObject:[NSNumber numberWithInt:0] forKey:@"ContactIUR"];
        [cellData setObject:[NSNumber numberWithInt:1] forKey:@"FormIUR"];
        [self.displayList addObject:cellData];
    }
}

- (void)processRemoteCallRawData:(NSMutableArray*)aDataList {
    self.displayList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:12];
        [cellData setObject:[NSNumber numberWithInt:0] forKey:@"NumberOflines"];
        [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSealed"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field1] forKey:@"OrderHeaderIUR"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field1] forKey:@"OrderNumber"];
        NSDate* orderDate = [ArcosUtils dateFromString:arcosGenericClass.Field2 format:[GlobalSharedClass shared].dateFormat];
        orderDate = [ArcosUtils addHours:1 date:orderDate];
        [cellData setObject:orderDate forKey:@"OrderDate"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field8] forKey:@"ContactIUR"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field3] forKey:@"LocationNameText"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field3] forKey:@"ContactNameText"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field5] forKey:@"Employee"];
        [cellData setObject:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field4] forKey:@"CallTypeText"];
        [cellData setObject:[ArcosUtils convertStringToNumber:arcosGenericClass.Field7] forKey:@"LocationIUR"];
        [cellData setObject:[ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field10]]] forKey:@"CTiur"];
        [cellData setObject:[NSNumber numberWithInt:1] forKey:@"FormIUR"];
        [self.displayList addObject:cellData];
    }
}

- (void)normaliseData {
    self.sendingSuccessFlag = NO;
}

@end
