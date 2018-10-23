//
//  SavedOrderPresenterTranDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 22/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SavedOrderPresenterTranDataManager.h"
#import "SettingManager.h"
@interface SavedOrderPresenterTranDataManager ()
- (NSMutableArray*)allSortedPresenterTran;
- (NSMutableArray*)allSortedUnsentCallOrderHeader;
- (void)categoriseSortedListIntoGroup:(NSMutableArray*)aSortedList;
- (NSString*)createCombinedKeyWithPTranDict:(NSDictionary*)aPTranDict;
- (NSString*)createCombinedKeyWithCallOrderHeaderDict:(NSDictionary*)aCallOrderHeaderDict;
- (void)saveCallOrderHeaderWithOrderNumber:(NSNumber*)anOrderNumber ptran:(NSMutableArray*)ptranList;
- (NSString*)createCallTranCombinedKey:(NSString*)aDetailLevelIUR detailIUR:(NSNumber*)aDetailIUR;
- (void)createNewCallOrderHeaderWithPtranList:(NSMutableArray*)ptranList employeeIUR:(NSNumber*)anEmployeeIUR callTypeDict:(NSDictionary*)aCallTypeDict orderNumber:(NSNumber*)anOrderNumber;
- (NSDictionary*)descriptionWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode;
- (void)deleteAllPtranRecord;
@end

@implementation SavedOrderPresenterTranDataManager
@synthesize sortedKeyList = _sortedKeyList;
@synthesize ptranListDict = _ptranListDict;
@synthesize callOrderHeaderDict = _callOrderHeaderDict;
@synthesize ptDetailLevelIUR = _ptDetailLevelIUR;
@synthesize employeeIUR = _employeeIUR;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.ptDetailLevelIUR = @"PS";
    }
    return self;
}

- (void)dealloc {
    self.sortedKeyList = nil;
    self.ptranListDict = nil;
    self.callOrderHeaderDict = nil;
    self.ptDetailLevelIUR = nil;
    self.employeeIUR = nil;
    
    [super dealloc];
}

- (void)processPresenterTransaction {
    self.sortedKeyList = [NSMutableArray array];
    self.ptranListDict = [NSMutableDictionary dictionary];
    self.callOrderHeaderDict = [NSMutableDictionary dictionary];
    
    NSMutableArray* sortedPresenterTranList = [self allSortedPresenterTran];
    if ([sortedPresenterTranList count] == 0) return;
    [self categoriseSortedListIntoGroup:sortedPresenterTranList];
    NSMutableArray* sortedUnsentCallOrderHeaderList = [self allSortedUnsentCallOrderHeader];
    for (int i = 0; i < [sortedUnsentCallOrderHeaderList count]; i++) {
        NSDictionary* tmpCallOrderHeaderDict = [sortedUnsentCallOrderHeaderList objectAtIndex:i];
        NSString* tmpCallCombinedKey = [self createCombinedKeyWithCallOrderHeaderDict:tmpCallOrderHeaderDict];
        [self.callOrderHeaderDict setObject:[tmpCallOrderHeaderDict objectForKey:@"OrderNumber"] forKey:tmpCallCombinedKey];
    }
    
//    NSLog(@"aaa: %@\n%@\n%@",self.sortedKeyList,self.ptranListDict,self.callOrderHeaderDict);
    NSNumber* employeeIUR = [SettingManager employeeIUR];
    NSDictionary* callTypeDict = [self descriptionWithDescrTypeCode:@"CT" descrDetailCode:@"PRSH"];
    NSNumber* myOrderNumber = [[GlobalSharedClass shared] currentTimeStamp];
    for (int i = 0; i < [self.sortedKeyList count]; i++) {
        NSString* ptranKey = [self.sortedKeyList objectAtIndex:i];
        NSNumber* orderNumber = [self.callOrderHeaderDict objectForKey:ptranKey];
        if (orderNumber != nil) {
            [self saveCallOrderHeaderWithOrderNumber:orderNumber ptran:[self.ptranListDict objectForKey:ptranKey]];
        } else {
            myOrderNumber = [NSNumber numberWithUnsignedInt:[myOrderNumber unsignedIntValue] + 1];
            [self createNewCallOrderHeaderWithPtranList:[self.ptranListDict objectForKey:ptranKey] employeeIUR:employeeIUR callTypeDict:callTypeDict orderNumber:myOrderNumber];
        }
    }
    [self deleteAllPtranRecord];
}

- (NSMutableArray*)allSortedPresenterTran {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"date",@"locationIUR",@"contactIUR",nil];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"PTran" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

- (NSMutableArray*)allSortedUnsentCallOrderHeader {
    NSArray* properties = [NSArray arrayWithObjects:@"OrderDate",@"LocationIUR",@"ContactIUR",@"OrderNumber", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderHeaderIUR = 0 and NumberOflines = 0"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderDate",@"LocationIUR",@"ContactIUR",nil];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

- (void)categoriseSortedListIntoGroup:(NSMutableArray*)aSortedList {
    if ([aSortedList count] == 0) return;
    NSString* currentChar = @"";
    NSMutableDictionary* firstPTranDict = [aSortedList objectAtIndex:0];
    currentChar = [self createCombinedKeyWithPTranDict:firstPTranDict];
    [self.sortedKeyList addObject:currentChar];
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=1;
    
    //start sorting the customer in to the sections
    for (int i = 1; i < [aSortedList count]; i++) {
        //sotring the name into the array
        NSMutableDictionary* tmpPTranDict = [aSortedList objectAtIndex:i];
        NSString* tmpCombinedKey = [self createCombinedKeyWithPTranDict:tmpPTranDict];
        //sorting
        if ([currentChar caseInsensitiveCompare:tmpCombinedKey]==NSOrderedSame) {
            
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [self.ptranListDict setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=location+length;//bug fit to duplicate outlet entry
            length=0;
            //get the current char
            currentChar = tmpCombinedKey;
            //add char to sort key
            [self.sortedKeyList addObject:currentChar];
        }
        length++;
    }
    //the last loop or length == 1
    NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    [self.ptranListDict setObject:tempArray forKey:currentChar];
    [tempArray release];
}

- (NSString*)createCombinedKeyWithPTranDict:(NSDictionary*)aPTranDict {
    NSDate* date = [aPTranDict objectForKey:@"date"];
    NSString* dateStr = [ArcosUtils stringFromDate:date format:[GlobalSharedClass shared].dateHyphenFormat];
    NSNumber* locationIUR = [aPTranDict objectForKey:@"locationIUR"];
    NSNumber* contactIUR = [aPTranDict objectForKey:@"contactIUR"];
    return [NSString stringWithFormat:@"%@->%@->%@",dateStr,locationIUR,contactIUR];
    
}

- (NSString*)createCombinedKeyWithCallOrderHeaderDict:(NSDictionary*)aCallOrderHeaderDict {
    NSDate* date = [aCallOrderHeaderDict objectForKey:@"OrderDate"];
    NSString* dateStr = [ArcosUtils stringFromDate:date format:[GlobalSharedClass shared].dateHyphenFormat];
    NSNumber* locationIUR = [aCallOrderHeaderDict objectForKey:@"LocationIUR"];
    NSNumber* contactIUR = [aCallOrderHeaderDict objectForKey:@"ContactIUR"];
    return [NSString stringWithFormat:@"%@->%@->%@",dateStr,locationIUR,[ArcosUtils convertNilToZero:contactIUR]];
}

- (void)saveCallOrderHeaderWithOrderNumber:(NSNumber*)anOrderNumber ptran:(NSMutableArray*)ptranList {
    OrderHeader* OH = [[ArcosCoreData sharedArcosCoreData] orderHeaderWithOrderNumber:anOrderNumber];
    if (OH == nil) {
        return;
    }
    NSSet* calltransSet = OH.calltrans;
    
    NSMutableSet* newCallTransSet = [[[NSMutableSet alloc] initWithSet:calltransSet] autorelease];
    NSMutableDictionary* calltransDict = [NSMutableDictionary dictionaryWithCapacity:[newCallTransSet count]];
    for(CallTran* CT in newCallTransSet){
        [calltransDict setObject:CT forKey:[self createCallTranCombinedKey:CT.DetailLevelIUR detailIUR:CT.DetailIUR]];
    }
    for (int i = 0; i < [ptranList count]; i++) {
        NSDictionary* ptranDict = [ptranList objectAtIndex:i];
        NSString* tmpPtranKey = [self createCallTranCombinedKey:self.ptDetailLevelIUR detailIUR:[ptranDict objectForKey:@"presenterIUR"]];
        CallTran* tmpCT = [calltransDict objectForKey:tmpPtranKey];
        if (tmpCT != nil) {
            tmpCT.Score = [NSNumber numberWithInt:[tmpCT.Score intValue] + [[ptranDict objectForKey:@"duration"] intValue]];
        } else {
            CallTran* CT = [NSEntityDescription insertNewObjectForEntityForName:@"CallTran" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
            CT.DetailLevelIUR = self.ptDetailLevelIUR;
            CT.DetailIUR = [ptranDict objectForKey:@"presenterIUR"];
            CT.Score = [ptranDict objectForKey:@"duration"];
            CT.orderheader = OH;
            [newCallTransSet addObject:CT];
        }
    }
    [OH addCalltrans:newCallTransSet];
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
}

- (NSString*)createCallTranCombinedKey:(NSString*)aDetailLevelIUR detailIUR:(NSNumber*)aDetailIUR {
    return [NSString stringWithFormat:@"%@->%@",aDetailLevelIUR, aDetailIUR];
}

- (void)createNewCallOrderHeaderWithPtranList:(NSMutableArray*)ptranList employeeIUR:(NSNumber*)anEmployeeIUR callTypeDict:(NSDictionary*)aCallTypeDict orderNumber:(NSNumber*)anOrderNumber{
    NSDictionary* ptranDict = [ptranList lastObject];
    OrderHeader* OH = [NSEntityDescription insertNewObjectForEntityForName:@"OrderHeader" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    OH.EnteredDate = [NSDate date];
    OH.LocationIUR = [ptranDict objectForKey:@"locationIUR"];
    OH.ContactIUR = [ptranDict objectForKey:@"contactIUR"];
    OH.EmployeeIUR = anEmployeeIUR;
    OH.OrderNumber = anOrderNumber;
    OH.NumberOflines = [NSNumber numberWithInt:0];
    OH.Latitude = [ptranDict objectForKey:@"latitude"];
    OH.Longitude = [ptranDict objectForKey:@"longitude"];
    OH.OrderDate = [ptranDict objectForKey:@"dateTime"];
    OH.DeliveryDate = [ptranDict objectForKey:@"dateTime"];
    OH.EnteredDate = [NSDate date];
    NSMutableSet* newCallTransSet = [NSMutableSet set];
    for (int i = 0; i < [ptranList count]; i++) {
        NSDictionary* tmpPtranDict = [ptranList objectAtIndex:i];
        CallTran* CT = [NSEntityDescription insertNewObjectForEntityForName:@"CallTran" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
        CT.DetailLevelIUR = self.ptDetailLevelIUR;
        CT.DetailIUR = [tmpPtranDict objectForKey:@"presenterIUR"];
        CT.Score = [tmpPtranDict objectForKey:@"duration"];
        CT.orderheader = OH;
        [newCallTransSet addObject:CT];
    }
    [OH addCalltrans:newCallTransSet];
    
//    NSNumber* toggle1 = [aCallTypeDict objectForKey:@"Toggle1"];
    Call* CA=nil;
    if (OH.call!=nil) {//order header has call
        CA=OH.call;
    }else{//order header has no call create one
        CA=[NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    }
    CA.ContactIUR=OH.ContactIUR;
    CA.CTiur=[ArcosUtils convertNilToZero:[aCallTypeDict objectForKey:@"DescrDetailIUR"]];
    CA.CallDate=OH.OrderDate;
    CA.EmployeeIUR=OH.EmployeeIUR;
    CA.Latitude=OH.Latitude;
    CA.Longitude=OH.Longitude;
    CA.LocationIUR=OH.LocationIUR;
    
    //line to order header
    CA.orderheader=OH;
    OH.call=CA;
//    if (![toggle1 boolValue]) {//if not toggle then save the call
//        
//    }
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
}

- (NSDictionary*)descriptionWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode = %@",aDescrTypeCode, aDescrDetailCode];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];
    } else {
        return nil;
    }
}

- (void)deleteAllPtranRecord {
    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"PTran"];
}

@end
