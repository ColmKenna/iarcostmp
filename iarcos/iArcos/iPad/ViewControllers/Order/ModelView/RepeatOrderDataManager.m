//
//  RepeatOrderDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 18/09/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "RepeatOrderDataManager.h"

@implementation RepeatOrderDataManager
@synthesize orderStatusIUR = _orderStatusIUR;


- (void)dealloc {
    self.orderStatusIUR = nil;
    
    [super dealloc];
}

- (void)repeatOrderWithDataDict:(NSMutableDictionary*)anOrderHeader {
    NSDate* currentDate = [NSDate date];
    NSMutableDictionary* wholesaler = [anOrderHeader objectForKey:@"wholesaler"];
    NSMutableDictionary* type = [anOrderHeader objectForKey:@"type"];
    NSMutableDictionary* callType = [anOrderHeader objectForKey:@"callType"];
    NSMutableDictionary* memoType = [anOrderHeader objectForKey:@"memoType"];
    NSMutableDictionary* contact = [anOrderHeader objectForKey:@"contact"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag] && [[type objectForKey:@"DescrDetailCode"] isEqualToString:[GlobalSharedClass shared].vansCode]) {        
        NSArray* orderLines = [anOrderHeader objectForKey:@"OrderLines"];
        if ([[anOrderHeader objectForKey:@"CoordinateType"] intValue] == 1) {
            orderLines = [anOrderHeader objectForKey:@"RemoteOrderline"];
        }
        ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
        [arcosStockonHandUtils updateStockonHandWithOrderLines:orderLines actionType:0];
        [arcosStockonHandUtils release];
    }
    
    OrderHeader* OH = [NSEntityDescription insertNewObjectForEntityForName:@"OrderHeader" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    OH.EnteredDate = currentDate;
    NSNumber* locatinIUR = [anOrderHeader objectForKey:@"LocationIUR"];
    NSString* locationCode = @"";
    NSMutableArray* locationArray = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:locatinIUR];
    if ([locationArray count] > 0) {
        NSMutableDictionary* location = [locationArray objectAtIndex:0];
        locationCode = [location objectForKey:@"LocationCode"];
    }
    OH.LocationIUR = locatinIUR;
    OH.LocationCode = locationCode;
    NSNumber* employeeIUR = [anOrderHeader objectForKey:@"EmployeeIUR"];
    NSNumber* formIUR = [anOrderHeader objectForKey:@"FormIUR"];
    OH.EmployeeIUR = employeeIUR;
    OH.FormIUR = formIUR;
    OH.OrderNumber = [[GlobalSharedClass shared] currentTimeStamp];
    NSString* memo = [anOrderHeader objectForKey:@"memo"];
    NSString* custRef = [anOrderHeader objectForKey:@"custRef"];
    NSMutableDictionary* acctNoDict = [anOrderHeader objectForKey:@"acctNo"];
    OH.CustomerRef = custRef;
    OH.PromotionIUR = [ArcosUtils convertStringToNumber:[acctNoDict objectForKey:@"acctNo"]];
    OH.PosteedIUR = [ArcosUtils convertNilToZero:[anOrderHeader objectForKey:@"PosteedIUR"]];
    OH.OrderDate = currentDate;
    OH.OSiur = [ArcosUtils convertNilToZero:self.orderStatusIUR];
    OH.OTiur = [ArcosUtils convertNilToZero:[type objectForKey:@"DescrDetailIUR"]];
    OH.DeliveryDate = currentDate;
    OH.WholesaleIUR = [wholesaler objectForKey:@"LocationIUR"];
    if (contact!=nil) {
        OH.ContactIUR = [contact objectForKey:@"IUR"];
    } else {
        OH.ContactIUR = [NSNumber numberWithInt:0];
    }
    OH.TotalGoods = [anOrderHeader objectForKey:@"TotalGoods"];
    OH.TotalVat = [anOrderHeader objectForKey:@"TotalVat"];
    OH.TotalQty = [ArcosUtils convertNilToZero:[anOrderHeader objectForKey:@"TotalQty"]];
    OH.TotalBonus = [ArcosUtils convertNilToZero:[anOrderHeader objectForKey:@"TotalBonus"]];
//    OH.DeliveryInstructions2 = [ArcosUtils convertNilToEmpty:[anOrderHeader objectForKey:@"DeliveryInstructions2"]];
    OH.NumberOflines = [anOrderHeader objectForKey:@"NumberOflines"];
    OH.Latitude = [ArcosUtils convertNilToZero:[anOrderHeader objectForKey:@"latitude"]];
    OH.Longitude = [ArcosUtils convertNilToZero:[anOrderHeader objectForKey:@"longitude"]];
    OH.ExchangeRate = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    OH.InvoiseRef = [anOrderHeader objectForKey:@"invoiceRef"];
    NSMutableSet* orderLineSet = [NSMutableSet set];
    NSMutableArray* orderLines = [anOrderHeader objectForKey:@"OrderLines"];
    if ([[anOrderHeader objectForKey:@"CoordinateType"] intValue] == 1) {
        orderLines = [anOrderHeader objectForKey:@"RemoteOrderline"];
    }
    int lineNumber = 0;
    for (int i = 0; i < [orderLines count]; i++) {
        lineNumber++;
        NSDictionary* auxOrderLineDict = [orderLines objectAtIndex:i];
        OrderLine* OL = [NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
        OL.OrderLine = [NSNumber numberWithInt:lineNumber];
        OL.LocationIUR = OH.LocationIUR;
        OL.OrderNumber = OH.OrderNumber;
        OL.ProductIUR = [auxOrderLineDict objectForKey:@"ProductIUR"];
        OL.OrderDate = OH.OrderDate;
        OL.UnitPrice = [auxOrderLineDict objectForKey:@"UnitPrice"];
        OL.Bonus = [auxOrderLineDict objectForKey:@"Bonus"];
        OL.Qty = [auxOrderLineDict objectForKey:@"Qty"];
        OL.LineValue = [auxOrderLineDict objectForKey:@"LineValue"];
        OL.vatAmount = [auxOrderLineDict objectForKey:@"vatAmount"];
        OL.DiscountPercent = [auxOrderLineDict objectForKey:@"DiscountPercent"];
        OL.InStock = [auxOrderLineDict objectForKey:@"InStock"];
        OL.FOC = [auxOrderLineDict objectForKey:@"FOC"];
        
        OL.orderheader = OH;
        [orderLineSet addObject:OL];
    }
    [OH addOrderlines:orderLineSet];
    
    //create Memo object
    Memo* MO = nil;
    if (memo != nil && ![memo isEqualToString:@""]) {
        MO = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
        MO.Details = memo;
        MO.MTIUR = [memoType objectForKey:@"DescrDetailIUR"];
        MO.EmployeeIUR = OH.EmployeeIUR;
        MO.DateEntered = [NSDate date];
        MO.Subject = @"Order Memo";
        MO.LocationIUR = OH.LocationIUR;
        if (contact != nil) {
            MO.ContactIUR = [contact objectForKey:@"IUR"];
        } else {
            MO.ContactIUR = [NSNumber numberWithInt:0];
        }
        //link to order header
        MO.orderheader = OH;
        OH.memo = MO;        
    }
    
    NSNumber* callTypeIUR = [callType objectForKey:@"DescrDetailIUR"];
    Call* CA = [NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    CA.ContactIUR = OH.ContactIUR;
    CA.CTiur = callTypeIUR;
    CA.CallDate = OH.OrderDate;
    CA.EmployeeIUR = OH.EmployeeIUR;
    CA.Latitude = OH.Latitude;
    CA.Longitude = OH.Longitude;
    CA.LocationIUR = OH.LocationIUR;
    
    //line to order header
    CA.orderheader = OH;
    OH.call = CA;
    
    if (MO != nil && CA != nil) {
        MO.call = CA;
        CA.memo = MO;
    }
    
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
}

@end
