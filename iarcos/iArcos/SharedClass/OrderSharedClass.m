//
//  OrderSharedClass.m
//  Arcos
//
//  Created by David Kilmartin on 27/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//



#import "OrderSharedClass.h"
#import "GlobalSharedClass.h"
#import "ArcosCoreData.h"
#import "SettingManager.h"
#import "ArcosOrderRestoreUtils.h"
#import "ArcosConfigDataManager.h"
#import "ArcosRootViewController.h"
#import "ArcosStockonHandUtils.h"

@interface OrderSharedClass () {
    ArcosOrderRestoreUtils* _arcosOrderRestoreUtils;
}
@property(nonatomic, retain) ArcosOrderRestoreUtils* arcosOrderRestoreUtils;
-(BOOL)checkOrderlineSequence:(NSArray*)orderlineList;
@end

@implementation OrderSharedClass
SYNTHESIZE_SINGLETON_FOR_CLASS(OrderSharedClass);

@synthesize currentOrderForm;
@synthesize currentOrderCart;
@synthesize currentOrderHeader;


@synthesize currentFormIUR;
@synthesize currentSelectionIUR;
@synthesize arcosOrderRestoreUtils = _arcosOrderRestoreUtils;
@synthesize lastPositionDict = _lastPositionDict;
-(id)init{
    self=[super init];
    if (self!=nil) {
        //make a service instance
        // initialize stuff here
        self.currentOrderForm=[NSMutableDictionary dictionary];
        self.currentOrderCart=[NSMutableDictionary dictionary];
        self.currentOrderHeader=[NSMutableDictionary dictionary];
        [self setOrderHeaderToDefault];
        
        self.currentFormIUR=nil;
        self.currentSelectionIUR=nil;
        self.arcosOrderRestoreUtils = [[[ArcosOrderRestoreUtils alloc] init] autorelease];
        self.lastPositionDict = [NSMutableDictionary dictionaryWithCapacity:2];//Key ProductIUR, IndexPath
    }
    
    return self;
}

- (void)dealloc {
    self.currentOrderForm = nil;
    self.currentOrderCart = nil;
    self.currentOrderHeader = nil;
    self.currentFormIUR = nil;
    self.currentSelectionIUR = nil;
    self.arcosOrderRestoreUtils = nil;
    self.lastPositionDict = nil;
    
    [super dealloc];
}

#pragma mark order form
-(BOOL)anyForm{
    if ([self.currentOrderForm count]>0) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isFormExist:(NSString*)formName{
    if([self.currentOrderForm objectForKey:formName]!=nil){
        return YES;
    }else{
        return NO;
    }
}
-(NSString*)getFormName{
    if ([self anyForm]) {
        NSArray* keys=[self.currentOrderForm allKeys];
        return [keys objectAtIndex:0];
    }else{
        return @"";
    }
}
-(void)insertForm:(NSString*)formName{
    [self.currentOrderForm setObject:[NSMutableDictionary dictionary] forKey:formName];
}
-(void)insertFormIUR:(NSNumber*)aFormIUR {
    [self.currentOrderForm setObject:[NSMutableDictionary dictionary] forKey:aFormIUR];
}

-(void)clearForms{
    [self.currentOrderForm removeAllObjects];
}

-(BOOL)anySelections{
    NSArray* keys=[self.currentOrderForm allKeys];
    if ([keys count]<=0) {
        return NO;//no form
    }
    
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
    if (form!=nil) {
        if ([form count]>0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
-(BOOL)isSelectionExist:(NSString*)selectionName{
    NSArray* keys=[self.currentOrderForm allKeys];
    if ([keys count]<=0) {
        return NO;//no form
    }
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
    
    if (form!=nil) {
        if ([form objectForKey:selectionName]!=nil) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
-(BOOL)insertSelection:(NSString*)selectionName{
    NSArray* keys=[self.currentOrderForm allKeys];
    if ([keys count]<=0) {
        return NO;//no form
    }
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
    
    if (form!=nil) {
        if(![self isSelectionExist:selectionName]){
            [form setObject:[NSMutableDictionary dictionary] forKey:selectionName];
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(BOOL)anyFormRowsForSelection:(NSString*)selectionName{
    NSArray* keys=[self.currentOrderForm allKeys];
    if ([keys count]<=0) {
        return NO;//no form
    }
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
    if (form==nil) {
        return NO;//no form
    }
    
    NSMutableDictionary* selection=[form objectForKey:selectionName];
    if (selection==nil) {
        return NO;//no selection
    }
    
    if([selection count]>0){
        return YES;//something in the selection
    }else{
        return NO;//nothing in the secleciton
    }
}
-(NSMutableDictionary*)formRowsFromSelection:(NSString*)selectionName{
    NSMutableDictionary* formRows;
    if ([self anyFormRowsForSelection:selectionName]) {
        NSArray* keys=[self.currentOrderForm allKeys];
        NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
        NSMutableDictionary* selection=[form objectForKey:selectionName];
        formRows=selection;
    }else{
        formRows=[NSMutableDictionary dictionary];
    }
    return formRows;
}
-(BOOL)setFormRows:(NSMutableDictionary*)formRows ForSelection:(NSString*)selectionName{
    NSArray* keys=[self.currentOrderForm allKeys];
    if ([keys count]<=0) {
        return NO;//no form
    }
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[keys objectAtIndex:0]];
    if (form==nil) {
        return NO;//no form
    }
    
    NSMutableDictionary* selection=[form objectForKey:selectionName];
    if (selection==nil) {
        return NO;//no selection
    }
    
    [form setObject:[NSMutableDictionary dictionaryWithDictionary:formRows ]forKey:selectionName];
    
    
    return YES;
}
-(BOOL)debugOrderForm{
    NSArray* formKeys=[self.currentOrderForm allKeys];
//    NSLog(@"%d form in the order dict ",[formKeys count]);
    if ([formKeys count]<=0) {
        return NO;//no form
    }
    NSMutableDictionary* form=[self.currentOrderForm objectForKey:[formKeys objectAtIndex:0]];

    if (form==nil) {
        return NO;//no form
    }
    
//    NSArray*  selectionKeys=[form allKeys];
//    NSLog(@"%d selection in the form %@ ", [selectionKeys count],[formKeys objectAtIndex:0]);
    
//    for (NSString* key in selectionKeys) {
//        NSLog(@"%d row in the selection %@ ",[[form objectForKey:key ]count],key);
//    }

    return YES;
}
-(BOOL)isProductInCurrentFormWithIUR:(NSNumber*)anIUR{
    for (NSString* key1 in self.currentOrderForm) {//form layer
        NSMutableDictionary* selection=[self.currentOrderForm objectForKey:key1];
        for (NSString* key2 in selection) {//selection layer
            NSMutableDictionary* rows=[selection objectForKey:key2];
            //NSLog(@"selection to check %@",selection);
            for (NSString* key3 in rows){
                NSMutableDictionary* row=[rows objectForKey:key3];
                NSNumber* productIUR=[row objectForKey:@"ProductIUR"];
                if ([anIUR isEqualToNumber:productIUR]) {
                    return YES;
                }
            }

        }
    }
    return NO;
}
#pragma mark order line
-(BOOL)saveOrderLine:(NSMutableDictionary*)anOrderLine{
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAutosaveFlag]) {
        [self.arcosOrderRestoreUtils loadOrderlineWithDict:anOrderLine];
    }
    //save the order to the cart
    NSString* detail=[anOrderLine objectForKey:@"Details"];
    NSNumber* productIUR=[anOrderLine objectForKey:@"ProductIUR"];
    NSString* cartKey=[NSString stringWithFormat:@"%@->%@",detail,[productIUR stringValue]];
//    NSLog(@"input order line key is %@",cartKey);
    
    NSMutableDictionary* orderLine=[self.currentOrderCart objectForKey:cartKey];
    
    NSNumber* isSelected=[anOrderLine objectForKey:@"IsSelected"];
    if (orderLine==nil&&[isSelected boolValue]) {
        if (anOrderLine!=nil) {
            [self.currentOrderCart setObject:anOrderLine forKey:cartKey];
        }
    }else{
        if ([isSelected boolValue]) {
            [self.currentOrderCart setObject:anOrderLine forKey:cartKey];
        }else{
            [self.currentOrderCart removeObjectForKey:cartKey];
        }
    }
//    NSLog(@"cart values %@",self.currentOrderCart);
    return YES;
}
-(NSMutableArray*)getSortedCartKeys:(NSArray*)valueList{
    NSMutableArray* sortedKeys=[NSMutableArray array];
//    sortedKeys=[[[self.currentOrderCart keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSMutableDictionary* order1=(NSMutableDictionary*)obj1;
//        NSMutableDictionary* order2=(NSMutableDictionary*)obj2;
//        
//        NSString* orderName1=[order1 objectForKey:@"Details"];
//        NSString* orderName2=[order2 objectForKey:@"Details"];
//        return [orderName1 compare:orderName2];
//
//    }]mutableCopy]autorelease];
    
//    NSLog(@"sorted keys %@",sortedKeys);
//    NSArray* valueList = [self.currentOrderCart allValues];
    NSArray* resultValueList = nil;
    if ([self checkOrderlineSequence:valueList]) {
        NSSortDescriptor* sequenceDivider = [[[NSSortDescriptor alloc] initWithKey:@"SequenceDivider" ascending:YES] autorelease];
        NSSortDescriptor* sequenceNumber = [[[NSSortDescriptor alloc] initWithKey:@"SequenceNumber" ascending:YES] autorelease];
        resultValueList = [valueList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sequenceDivider, sequenceNumber, nil]];
    } else {
        NSSortDescriptor* brandDesc = [[[NSSortDescriptor alloc] initWithKey:@"OrderPadDetails" ascending:YES] autorelease];
        NSSortDescriptor* combineKeyDesc = [[[NSSortDescriptor alloc] initWithKey:@"CombinationKey" ascending:YES] autorelease];
        resultValueList = [valueList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:brandDesc, combineKeyDesc, nil]];
    }
    
    for (int i = 0; i < [resultValueList count]; i++) {
        NSMutableDictionary* anOrderLine = [resultValueList objectAtIndex:i];
        [sortedKeys addObject:[anOrderLine objectForKey:@"CombinationKey"]];
    }
    return sortedKeys;
}
-(NSMutableArray*)createAlphabeticSortedKey:(NSArray*)valueList {
    NSMutableArray* sortedKeys = [NSMutableArray array];
    NSSortDescriptor* brandDesc = [[[NSSortDescriptor alloc] initWithKey:@"OrderPadDetails" ascending:YES] autorelease];
    NSSortDescriptor* combineKeyDesc = [[[NSSortDescriptor alloc] initWithKey:@"CombinationKey" ascending:YES] autorelease];
    NSArray* resultValueList = [valueList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:brandDesc, combineKeyDesc, nil]];
    for (int i = 0; i < [resultValueList count]; i++) {
        NSMutableDictionary* anOrderLine = [resultValueList objectAtIndex:i];
        [sortedKeys addObject:[anOrderLine objectForKey:@"CombinationKey"]];
    }
    return sortedKeys;
}
-(BOOL)anyOrderLine{
    if (self.currentOrderCart !=nil && [self.currentOrderCart count]>0) {
        return YES;
    }
    return NO;
}
#pragma mark customer
-(NSString*)currentCustomerName{
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        NSMutableArray* locations=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        NSMutableDictionary* locationDict=[locations objectAtIndex:0];
        
        if (locationDict!=nil) {
//            NSLog(@"location name is %@",[locationDict objectForKey:@"Name"]);
            return [locationDict objectForKey:@"Name"];
        }else{
            return  @"No Customer Selected";
        }
    }else{
        return @"No Customer Selected";
    }
}
-(NSString*)currentCustomerAddress{
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        NSMutableArray* locations=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        NSMutableDictionary* locationDict=[locations objectAtIndex:0];
        
        if (locationDict!=nil) {
//            NSLog(@"location address is %@",[[ArcosCoreData sharedArcosCoreData]fullAddressWith:locationDict]);

            return [[ArcosCoreData sharedArcosCoreData]fullAddressWith:locationDict];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}
-(NSString*)currentCustomerPhoneNumber{
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        NSMutableArray* locations=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        NSMutableDictionary* locationDict=[locations objectAtIndex:0];
        
        if (locationDict!=nil) {
//            NSLog(@"location phone number is %@",[locationDict objectForKey:@"PhoneNumber"]);
            return [locationDict objectForKey:@"PhoneNumber"];
        }else{
            return  @"";
        }
    }else{
        return @"";
    }
}
-(NSString*)currentContactName {
    if ([GlobalSharedClass shared].currentSelectedContactIUR == nil) {
        return @"";
    }
    if ([[GlobalSharedClass shared].currentSelectedContactIUR intValue] == 0) {
        return [GlobalSharedClass shared].unassignedText;
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
    if ([contactList count] > 0) {
        NSDictionary* contactDict = [contactList objectAtIndex:0];
        return [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Forename"]],[ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Surname"]]]];
    }
    return @"";
}

#pragma mark order header
-(NSMutableDictionary*)getADefaultOrderHeader{
    NSMutableDictionary* aOrderHeader=[NSMutableDictionary dictionary];
    //set order date to today
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [aOrderHeader setObject:[NSDate date] forKey:@"orderDate"];
    [aOrderHeader setObject:[formatter stringFromDate:[NSDate date]] forKey:@"orderDateText"];
    
    //default order status , order type , call type , memo type
    NSNumber* defaultOS = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:3];
    NSDictionary* aDescrption=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:defaultOS];
    if (aDescrption!=nil) {
        [aOrderHeader setObject:aDescrption forKey:@"status"];
        [aOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"statusText"]; 
    }
    
    
    NSNumber* defaultOT = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:4];
    aDescrption=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:defaultOT];
    if (aDescrption!=nil) {
        [aOrderHeader setObject:aDescrption forKey:@"type"];
        [aOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"orderTypeText"];
    }
    
    NSNumber* defaultCT = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:2];
    aDescrption=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:defaultCT];
    if (aDescrption!=nil) {
        [aOrderHeader setObject:aDescrption forKey:@"callType"];
        [aOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"callTypeText"];
    }
    
    NSNumber* defaultMT = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:8];
    
    aDescrption=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:defaultMT];
    if (aDescrption!=nil) {
        [aOrderHeader setObject:aDescrption forKey:@"memoType"];
        [aOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"memoTypeText"];
    }
    
    
    
    //delivery date and wholesaler and  contact
    //[self.currentOrderHeader removeObjectForKey:@"deliveryDate"];
    [aOrderHeader setObject:[NSDate date] forKey:@"deliveryDate"];
    [aOrderHeader setObject:[formatter stringFromDate:[NSDate date]] forKey:@"deliveryDateText"];
    [aOrderHeader setObject:@"" forKey:@"DeliveryInstructions1"];
    
    //[self.currentOrderHeader removeObjectForKey:@"wholesaler"];
    [aOrderHeader setObject:@"Touch to pick a wholesaler"forKey:@"wholesalerText"];
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    NSNumber* defaultWholesalerIUR = [configDict objectForKey:@"DefaultWholesalerIUR"];
    if ([defaultWholesalerIUR intValue] != 0) {
        NSMutableArray* wholesalerObjectList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:defaultWholesalerIUR];
        if ([wholesalerObjectList count] == 1) {
            NSMutableDictionary* wholesalerDict = [wholesalerObjectList objectAtIndex:0];
            //        NSLog(@"default wholesalerDict:%@", wholesalerDict);
            [aOrderHeader setObject:wholesalerDict forKey:@"wholesaler"];
            [aOrderHeader setObject:[wholesalerDict objectForKey:@"Name"] forKey:@"wholesalerText"];
        }
    }
    NSMutableArray* wholesalerList = [[ArcosCoreData sharedArcosCoreData]orderWholeSalers];    
    if ([wholesalerList count] == 1) {
        NSMutableDictionary* wholesalerDict = [wholesalerList objectAtIndex:0];
//        NSLog(@"default wholesalerDict:%@", wholesalerDict);
        [aOrderHeader setObject:wholesalerDict forKey:@"wholesaler"];
        [aOrderHeader setObject:[wholesalerDict objectForKey:@"Name"] forKey:@"wholesalerText"];
    }
    // the last order
    /*
    NSNumber* currentLocationIUR=[GlobalSharedClass shared].currentSelectedLocationIUR;
    
    NSMutableDictionary* theLastOrder=nil;
    if (currentLocationIUR!=nil) {
        theLastOrder=[[ArcosCoreData sharedArcosCoreData]theLastOrderWithLocationIUR:currentLocationIUR];
    }
    if (theLastOrder !=nil) {
        // NSLog("the last order is %@",theLastOrder);
        NSMutableArray* wholeSalers=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:[theLastOrder objectForKey:@"WholesaleIUR"]];
        NSMutableDictionary* wholeSaler=[wholeSalers objectAtIndex:0];
        
        if(wholeSaler !=nil ){
            [aOrderHeader setObject:wholeSaler forKey:@"wholesaler"];
            [aOrderHeader setObject:[wholeSaler objectForKey:@"Name"] forKey:@"wholesalerText"];
        }
    }
     */
    
    //[self.currentOrderHeader removeObjectForKey:@"contact"];
    [aOrderHeader setObject:@"Touch to pick a contact"forKey:@"contactText"];
    
    //reference and memo
    [aOrderHeader setObject:@"" forKey:@"custRef"];
    /*
     *acctNoDict spec Key:acctNo,Title
     */
    NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [acctNoDict setObject:@"" forKey:@"acctNo"];
    [acctNoDict setObject:@"" forKey:@"Title"];
    [aOrderHeader setObject:acctNoDict forKey:@"acctNo"];
    [aOrderHeader setObject:@"Touch to pick an account no." forKey:@"acctNoText"];
    [aOrderHeader setObject:@"" forKey:@"memo"];
    
    NSNumber* auxEmployeeIUR = [SettingManager employeeIUR];
    NSDictionary* auxEmployeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:auxEmployeeIUR];
    if (auxEmployeeDict != nil) {
        [aOrderHeader setObject:auxEmployeeDict forKey:@"employee"];
        [aOrderHeader setObject:[NSString stringWithFormat:@"%@ %@", [auxEmployeeDict objectForKey:@"ForeName"], [auxEmployeeDict objectForKey:@"Surname"]] forKey:@"employeeText"];
    } else {
        [aOrderHeader setObject:@"Touch to pick an employee" forKey:@"employeeText"];
    }
    
    //geto location
    [aOrderHeader setObject:[NSNumber numberWithFloat:0.0f] forKey:@"latitude"];
    [aOrderHeader setObject:[NSNumber numberWithFloat:0.0f] forKey:@"longitude"];
    
    NSMutableArray* invoiceRefList = [NSMutableArray arrayWithCapacity:4];
    [invoiceRefList addObject:@""];
    [invoiceRefList addObject:[NSNumber numberWithInt:0]];
    [invoiceRefList addObject:[NSNumber numberWithInt:0]];
    [invoiceRefList addObject:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat]];
    
    [aOrderHeader setObject:invoiceRefList forKey:@"invoiceRef"];
    
    [formatter release];
    
    return aOrderHeader;

}
-(void)setOrderHeaderToDefault{
    if (self.currentOrderHeader==nil) {
        return;
    }
    
    self.currentOrderHeader=[self getADefaultOrderHeader];
    
}
-(void)refreshCurrentOrderDate{
    //set order date to today
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [self.currentOrderHeader setObject:[NSDate date] forKey:@"orderDate"];
    [self.currentOrderHeader setObject:[formatter stringFromDate:[NSDate date]] forKey:@"orderDateText"];
    [self.currentOrderHeader setObject:[NSDate date] forKey:@"deliveryDate"];
    [self.currentOrderHeader setObject:[formatter stringFromDate:[NSDate date]] forKey:@"deliveryDateText"];
    @try {
        NSMutableArray* invoiceRefList = [self.currentOrderHeader objectForKey:@"invoiceRef"];
        [invoiceRefList replaceObjectAtIndex:3 withObject:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [formatter release];
}
-(void)resetTheWholesellerWithLocation:(NSNumber*)anIUR{
    NSMutableDictionary* theLastOrder=nil;
    if (anIUR!=nil) {
        theLastOrder=[[ArcosCoreData sharedArcosCoreData]theLastOrderWithLocationIUR:anIUR];
    }
    if (theLastOrder !=nil) {
//        NSLog("the last order is %@",theLastOrder);
//        NSLog(@"outter loop %@", theLastOrder);
        NSMutableArray* wholeSalers=[[ArcosCoreData sharedArcosCoreData]locationWithIUR:[theLastOrder objectForKey:@"WholesaleIUR"]];
        NSMutableDictionary* wholeSaler=[wholeSalers objectAtIndex:0];
        
        if(wholeSaler !=nil ){
//            NSLog(@"inner loop %@", wholeSaler);
            [self.currentOrderHeader setObject:wholeSaler forKey:@"wholesaler"];
            [self.currentOrderHeader setObject:[wholeSaler objectForKey:@"Name"] forKey:@"wholesalerText"];
            if ([[theLastOrder objectForKey:@"PromotionIUR"] intValue]!= 0) {
                NSString* acctNo = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:[theLastOrder objectForKey:@"PromotionIUR"]]];
                NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
                [acctNoDict setObject:acctNo forKey:@"acctNo"];
                [acctNoDict setObject:acctNo forKey:@"Title"];
                [self.currentOrderHeader setObject:acctNoDict forKey:@"acctNo"];
                [self.currentOrderHeader setObject:acctNo forKey:@"acctNoText"];
            }
            
        }
    }
}

#pragma mark clear current order
-(void)clearCurrentOrder{
    [self clearForms];
    [self.currentOrderCart removeAllObjects];
    [self setOrderHeaderToDefault];
    //self.currentFormIUR=nil;
    //self.currentSelectionIUR=nil;
    [self.lastPositionDict removeAllObjects];
}

#pragma mark save order
-(BOOL)saveCurrentOrder:(NSNumber**)anOrderNumberResult {
//    NSLog(@"self.currentOrderForm is: %@", self.currentOrderForm);
//    NSLog(@"self.currentOrderCart is: %@", self.currentOrderCart);
    //check order header
    NSMutableDictionary* wholesaler=[self.currentOrderHeader objectForKey:@"wholesaler"];
    NSMutableDictionary* status=[self.currentOrderHeader objectForKey:@"status"];
    NSMutableDictionary* type=[self.currentOrderHeader objectForKey:@"type"];
    NSMutableDictionary* callType=[self.currentOrderHeader objectForKey:@"callType"];
    NSMutableDictionary* contact=[self.currentOrderHeader objectForKey:@"contact"];
    
    if (contact==nil) {
        contact=[NSMutableDictionary dictionary];
        [contact setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
        [self.currentOrderHeader setObject:contact forKey:@"contact"];
    }
    //if no order do nothing
    if (![self anyForm]) {
        return NO;
    }
    if (self.currentOrderCart ==nil  ||contact==nil||wholesaler==nil||status==nil||type==nil||callType==nil) {//remove || [self.currentOrderCart count]<=0 for memo saving
        return NO;
    }

    
    //temp order dictionary
    NSMutableDictionary* order=[NSMutableDictionary dictionary];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:[GlobalSharedClass shared].startRecordingDate];
    [order setObject:[NSNumber numberWithInt:(int)duration] forKey:@"CallCost"];
    [order setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
    NSNumber* auxEmployeeIUR = [NSNumber numberWithInt:0];
    NSDictionary* auxEmployeeDict = [self.currentOrderHeader objectForKey:@"employee"];
    if (auxEmployeeDict != nil) {
        auxEmployeeIUR = [auxEmployeeDict objectForKey:@"IUR"];
    }
    [order setObject:auxEmployeeIUR
 forKey:@"EmployeeIUR"];
    [order setObject:self.currentOrderHeader forKey:@"OrderHeader"];
    [order setObject:self.currentOrderCart forKey:@"OrderLines"];
    [order setObject:[self.currentOrderHeader objectForKey:@"memo"] forKey:@"Memo"];
    [order setObject:[self.currentOrderHeader objectForKey:@"custRef"] forKey:@"CustomerRef"];
    [order setObject:[self.currentOrderHeader objectForKey:@"acctNo"] forKey:@"AccountNo"];
    NSNumber* formIUR = self.currentFormIUR;
//    if (![SettingManager restrictOrderForm]) {
//        formIUR = [NSNumber numberWithInt:0];
//    }
    [order setObject:formIUR forKey:@"FormIUR"];
    NSNumber* orderNumber=[[GlobalSharedClass shared]currentTimeStamp];
    *anOrderNumberResult = [NSNumber numberWithInt:[orderNumber intValue]];
    
    [order setObject: orderNumber forKey:@"OrderNumber"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag] && [[type objectForKey:@"DescrDetailCode"] isEqualToString:[GlobalSharedClass shared].vansCode]) {
//        [self updateStockonHandByOrderLines];
        NSArray* orderLines = [self.currentOrderCart allValues];
        ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
        [arcosStockonHandUtils updateStockonHandWithOrderLines:orderLines actionType:0];
        [arcosStockonHandUtils release];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        [order setObject:[ArcosUtils convertNilToZero:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]] forKey:@"PosteedIUR"];
    }
    //save to coredata
    BOOL isSuccess= [[ArcosCoreData sharedArcosCoreData]saveOrder:order];
    
    if (isSuccess) {
        [self clearCurrentOrder];
        [self resetTheWholesellerWithLocation:[GlobalSharedClass shared].currentSelectedLocationIUR];
        [[OrderSharedClass sharedOrderSharedClass]refreshCurrentOrderDate];
        //clear location session
        /* come back later aaa
        [GlobalSharedClass shared].currentSelectedLocationIUR=nil;
        [GlobalSharedClass shared].currentSelectedLocation=nil;
        */
        //increase the order number
        //[[GlobalSharedClass shared]increaseOrderNumber];
        ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
        ArcosStackedViewController* myLocationArcosStackedViewController = arcosRootViewController.customerMasterViewController.customerMasterDataManager.locationArcosStackedViewController;
        UINavigationController* customerListingNavigationController = [myLocationArcosStackedViewController.rcsViewControllers objectAtIndex:0];
        CustomerListingViewController* customerListingViewController = [customerListingNavigationController.viewControllers objectAtIndex:0];
        [customerListingViewController configWholesalerLogo];
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)saveAnOrderWithHearder:(NSMutableDictionary*)orderHeader withCallTrans:(ArcosArrayOfCallTran*)callTrans{
    //check order header
    NSMutableDictionary* contact=[orderHeader objectForKey:@"contact"];
    
    if (contact==nil) {
        contact=[NSMutableDictionary dictionary];
        [contact setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
        [self.currentOrderHeader setObject:contact forKey:@"contact"];
    }
    
    //temp order dictionary
    NSMutableDictionary* order=[NSMutableDictionary dictionary];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:[GlobalSharedClass shared].startRecordingDate];
    [order setObject:[NSNumber numberWithInt:(int)duration] forKey:@"CallCost"];
    NSNumber* anIUR=[orderHeader objectForKey:@"LocationIUR"];
    
    [order setObject:anIUR forKey:@"LocationIUR"];
    [order setObject:[SettingManager SettingForKeypath:@"PersonalSetting.Personal" atIndex:0]
              forKey:@"EmployeeIUR"];
    [order setObject:orderHeader forKey:@"OrderHeader"];
    [order setObject:[NSMutableDictionary dictionary] forKey:@"OrderLines"];//empty order lines
    [order setObject:[orderHeader objectForKey:@"memo"] forKey:@"Memo"];
    [order setObject:[orderHeader objectForKey:@"custRef"] forKey:@"CustomerRef"];
    [order setObject:[NSNumber numberWithInt:0] forKey:@"FormIUR"];//empty iur number
    NSNumber* orderNumber=[[GlobalSharedClass shared]currentTimeStamp];
    
    [order setObject: orderNumber forKey:@"OrderNumber"];
    
    //call trans
    [order setObject:callTrans forKey:@"CallTrans"];
    
    //save to coredata
    BOOL isSuccess= [[ArcosCoreData sharedArcosCoreData]saveOrder:order];
    
    if (isSuccess) {
        //[self clearCurrentOrder];
        //clear location session
        //[GlobalSharedClass shared].currentSelectedLocationIUR=nil;
        //[GlobalSharedClass shared].currentSelectedLocation=nil;
        return YES;
    }else{
        return NO;
    }

}
-(BOOL)saveCall{
    NSMutableDictionary* callType=[self.currentOrderHeader objectForKey:@"callType"];
    NSMutableDictionary* contact=[self.currentOrderHeader objectForKey:@"contact"];
    
    if (contact==nil) {
        contact=[NSMutableDictionary dictionary];
        [contact setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
        [self.currentOrderHeader setObject:contact forKey:@"contact"];
    }
    //if no order do nothing
    if (![self anyForm]||callType==nil) {
        return NO;
    }
    NSMutableDictionary* order=[NSMutableDictionary dictionary];
    [order setObject:self.currentOrderHeader forKey:@"OrderHeader"];
    [order setObject:[self.currentOrderHeader objectForKey:@"memo"] forKey:@"Memo"];
    [order setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
    [order setObject:[SettingManager SettingForKeypath:@"PersonalSetting.Personal" atIndex:3] forKey:@"EmployeeIUR"];
    
    //save to coredata
    BOOL isSuccess= [[ArcosCoreData sharedArcosCoreData]saveCall:order];
    
    if (isSuccess) {
        [self clearCurrentOrder];
        //clear location session
        [GlobalSharedClass shared].currentSelectedLocationIUR=nil;
        [GlobalSharedClass shared].currentSelectedLocation=nil;
        return YES;
    }else{
        return NO;
    }

}
#pragma syncing
//sync to all selection
-(BOOL)syncAllSelectionsWithRowData:(NSMutableDictionary*)data{
    NSString* rowKey=[data objectForKey:@"CombinationKey"];
    
    for (NSString* key1 in self.currentOrderForm) {//form layer
        NSMutableDictionary* selection=[self.currentOrderForm objectForKey:key1];
        for (NSString* key2 in selection) {//selection layer
            NSMutableDictionary* rows=[selection objectForKey:key2];
            if ([rows objectForKey:rowKey]!=nil) {//row layer
                [rows setObject:data forKey:rowKey];
            }
        }
    }
    
    return YES;
}
-(NSMutableDictionary*)syncNewSelection:(NSMutableDictionary*)formRows{
    NSMutableDictionary* tempFormRows=[NSMutableDictionary dictionaryWithDictionary:formRows];
    
    if (self.currentOrderCart !=nil) {
        for (NSString *key in self.currentOrderCart) {
            if ([formRows objectForKey:key]) {
                [tempFormRows setObject:[self.currentOrderCart objectForKey:key] forKey:key];
            }
        }
    }
    
    return tempFormRows;
}
-(NSMutableDictionary*)syncRowWithCurrentCart:(NSMutableDictionary*)row{
    NSString* combinationKey=[row objectForKey:@"CombinationKey"];

    if (self.currentOrderCart !=nil) {
        NSMutableDictionary* tempDict=[self.currentOrderCart objectForKey:combinationKey];
        if (tempDict!=nil) {
//            NSLog(@"form row need sync %@",[self.currentOrderCart objectForKey:combinationKey]);
            return tempDict;
        }else{
//            [row setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
//            [row setObject:[NSNumber numberWithInt:0] forKey:@"Qty"];
//            [row setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
//            [row setObject:[NSNumber numberWithFloat:0] forKey:@"DiscountPercent"];
//            [row setObject:[NSNumber numberWithFloat:0] forKey:@"LineValue"];
        }
    }
    return row;
}

-(BOOL)checkOrderlineSequence:(NSArray*)orderlineList {
    NSMutableDictionary* formIURDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [orderlineList count]; i++) {
        NSDictionary* orderlineDict = [orderlineList objectAtIndex:i];
        NSNumber* formIUR = [orderlineDict objectForKey:@"FormIUR"];
        NSNumber* sequenceDivider = [orderlineDict objectForKey:@"SequenceDivider"];
        NSNumber* sequenceNumber = [orderlineDict objectForKey:@"SequenceNumber"];
        if (formIUR == nil || sequenceDivider == nil || sequenceNumber == nil) {
            return NO;
        }
        [formIURDict setObject:formIUR forKey:formIUR];
    }
    NSArray* keyList = [formIURDict allKeys];
    if ([keyList count] != 1) {
        return NO;
    }
    NSNumber* uniqueFormIUR = [keyList objectAtIndex:0];
    NSMutableDictionary* formRowDict = [[ArcosCoreData sharedArcosCoreData] formRowWithDividerIUR:[NSNumber numberWithInt:-1] withFormIUR:uniqueFormIUR];
    if ([formRowDict count] == 0) {
        return NO;
    }
    return YES;
}

@end
