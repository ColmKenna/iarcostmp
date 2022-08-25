//
//  ArcosCoreData.m
//  Arcos
//
//  Created by David Kilmartin on 28/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"

@implementation ArcosCoreData
SYNTHESIZE_SINGLETON_FOR_CLASS(ArcosCoreData);

@synthesize addManagedObjectContext=__addManagedObjectContext;
@synthesize fetchManagedObjectContext=__fetchManagedObjectContext;
@synthesize deleteManagedObjectContext=__deleteManagedObjectContext;
@synthesize editManagedObjectContext=__editManagedObjectContext;
@synthesize importManagedObjectContext=__importManagedObjectContext;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize arcosCoreDataManager = _arcosCoreDataManager;
@synthesize arcosDescriptionTrManager = _arcosDescriptionTrManager;

-(id)init{
    self=[super init];
    if (self!=nil) {
        self.arcosCoreDataManager = [[[ArcosCoreDataManager alloc] init] autorelease];
        self.arcosDescriptionTrManager = [[[ArcosDescriptionTrManager alloc] init] autorelease];
    }
    
    return self;
}
#pragma mark core data access region
- (NSMutableArray*)allLocations{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SortKey",@"Name",nil];
    
    //using fetch with context
    //NSPredicate* predicate=[NSPredicate predicateWithFormat:@"SortKey=%@",@"S"];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    //NSArray* objectsArray=[fetchedResultsController fetchedObjects];
    NSMutableArray* objectsArrayUM=[[[NSMutableArray alloc]init]autorelease];
    for (Location* aLoc in objectsArray) {
        
        [objectsArrayUM addObject:[[[LocationUM alloc]initWithManagedLocation:aLoc]autorelease]];
    }
    
    return objectsArrayUM;
}
//get the group in the core data
#pragma mark location related data
- (NSMutableArray*)locationGroups {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"MasterLocationIUR",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"MasterLocationIUR", nil];
    
    NSPredicate* predicate = nil;
    NSNumber* needInactiveRecord = [SettingManager DisplayInactiveRecord];
    if (![needInactiveRecord boolValue]) {
        predicate = [NSPredicate predicateWithFormat:@"Active=1"];
    }

    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSMutableArray* groupList = [NSMutableArray arrayWithCapacity:([objectsArray count] + 2)];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        NSNumber* masterid = [aDict objectForKey:@"MasterLocationIUR"];
        if ([masterid intValue] == 0) {
            continue;
        }
        NSMutableDictionary* location = [[self locationWithIURWithoutCheck:masterid]objectAtIndex:0];
        NSString* masterName = [ArcosUtils convertNilToEmpty:[location objectForKey:@"Name"]];
        NSNumber* imageIur = [location objectForKey:@"ImageIUR"];
        NSNumber* activeNumber = [location objectForKey:@"Active"];
        
        if (location == nil) {
            masterName = [NSString stringWithFormat:@"Unknown Group IUR -%d",[masterid intValue]];
            imageIur = [NSNumber numberWithInt:0];
            activeNumber = [NSNumber numberWithInt:0];
        }
        [newDict setObject:imageIur forKey:@"ImageIUR"];
        [newDict setObject:masterName forKey:@"Detail"];
        [newDict setObject:masterid forKey:@"DescrDetailIUR"];
        [newDict setObject:activeNumber forKey:@"Active"];
        [groupList addObject:newDict];
    }
    NSSortDescriptor* titleDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Detail" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [groupList sortUsingDescriptors:[NSArray arrayWithObject:titleDescriptor]];
    [groupList insertObject:[self.arcosDescriptionTrManager createUnAssignedDescrDetailDict] atIndex:0];
    [groupList insertObject:[self.arcosDescriptionTrManager createIndependentGroupDescrDetailDict] atIndex:1];
    NSMutableArray* resultObjectList = [NSMutableArray arrayWithCapacity:[groupList count]];
    
    for (NSDictionary* aDict in groupList) {
        NSMutableDictionary* myDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [myDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Detail"]]] forKey:@"Title"];
        [resultObjectList addObject:myDict];
    }
    return resultObjectList;
}
//get the type of the locations
- (NSMutableArray*)locationTypes{
//    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode='LT' and Active = 1"];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"DescrTypeCode",@"DescrDetailIUR",@"Detail",@"ImageIUR",@"DescrDetailCode" ,nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    [objectsArray insertObject:[self.arcosDescriptionTrManager createUnAssignedDescrDetailDict] atIndex:0];
//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
//    for(NSDictionary* aDict in objectsArray){
//        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
//        [newDict setObject:@"Type" forKey:@"Type"];
//        NSString* name=[aDict objectForKey:@"Detail"];
//
//        //add group id to the dictionary
//        if (name !=nil&&![name isEqualToString:@""]) {
//            [newDict setObject:name forKey:@"MasterName"];
//            [theGroups setObject:newDict forKey:name];
//            
//        }
//        
//    }
    NSMutableArray* resultObjectList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* myDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [myDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Detail"]]] forKey:@"Title"];
        [resultObjectList addObject:myDict];
    }
    return resultObjectList;
    
}
- (NSMutableArray*)locationContactTypes {
//    NSMutableDictionary* theGroups = [[[NSMutableDictionary alloc]init]autorelease];
    NSMutableArray* contactTypeList = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='CO' and Active = 1"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"Active",@"ImageIUR",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    for(NSDictionary* aDict in objectsArray){
        NSMutableArray* contactLocationObjectList = [[ArcosCoreData sharedArcosCoreData] contactLocationWithCOIUR:[aDict objectForKey:@"DescrDetailIUR"]];
        if ([contactLocationObjectList count] == 0) {
            continue;
        }
        [contactTypeList addObject:aDict];
    }
    
    [contactTypeList insertObject:[self.arcosDescriptionTrManager createUnAssignedDescrDetailDict] atIndex:0];
    
    NSMutableArray* resultObjectList = [NSMutableArray arrayWithCapacity:[contactTypeList count]];
    
    for (NSDictionary* aDict in contactTypeList) {
        NSMutableDictionary* myDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [myDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Detail"]]] forKey:@"Title"];
        [resultObjectList addObject:myDict];
    }
    return resultObjectList;
}
-(NSMutableArray*)locationFromGeoBoundBox:(CGRect)boundBox{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    
    //check need predicate or not
    NSPredicate* predicate=nil;
   // NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"Latitude<=%f and Latitude>=%f and Longitude>=%f and Longitude<=%f and Active=1",boundBox.origin.x,boundBox.origin.x+boundBox.size.height,boundBox.origin.y,boundBox.origin.y+boundBox.size.width];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"Latitude<=%f and Latitude>=%f and Longitude>=%f and Longitude<=%f",boundBox.origin.x,boundBox.origin.x+boundBox.size.height,boundBox.origin.y,boundBox.origin.y+boundBox.size.width];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
//    NSLog(@"%d locations from the bound box",[objectsArray count]);
    return objectsArray;
    
}
- (NSString*)locationNameWithIUR:(NSNumber*)anIUR{
    
    NSArray* properties=[NSArray arrayWithObjects:@"Name", nil];
    
    //check need predicate or not
    NSPredicate* predicate=nil;
   // NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];

    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d and Active=1",[anIUR intValue]];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSString* name = @"";
    if ([objectsArray count]>0&&objectsArray!=nil) {
        name=[[objectsArray objectAtIndex:0]objectForKey:@"Name"];
        //check if the name is empty
//        if ([name isEqualToString:@""]) {
//            name=@"Noname Shop";
//        }
    }else{
        if ([anIUR intValue]==0) {//group with master iur 0
            //name=@"IndependentGroup";
        }else{//group with NO master group name
            name=[NSString stringWithFormat: @"Unknown Location--%d",[anIUR intValue]];
        }
    }
    if ([objectsArray count]==0) {
        return @"";
    }
    return name;
}
- (Location*)locationMAWithIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d and Active=1",[anIUR intValue]];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
    }else{
        return nil;
    }
}
- (NSMutableArray*)locationWithIUR:(NSNumber*)anIUR{
    //check need predicate or not
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d and Active=1",[anIUR intValue]];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    }
        
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    if ([objectsArray count]>0) {
        return objectsArray;
    }else{
        return nil;
    }
}
- (NSMutableArray*)locationWithIURWithoutCheck:(NSNumber *)anIUR {
    //check need predicate or not
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [anIUR intValue]];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
    
    if ([objectsArray count] > 0) {
        return objectsArray;
    }else{
        return nil;
    }
}
- (NSMutableArray*)locationsWithIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@",anIURList];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}
- (NSMutableArray*)outletsWithMasterIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType{
    NSPredicate* predicate=nil;
//    NSLog(@"start fecthing!!");
    
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];

    if ([anIUR intValue]<0) {//search all outlets
        if (![needInactiveRecord boolValue]) {
            predicate=[NSPredicate predicateWithFormat:@"MasterLocationIUR>=0 and Active=1"];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"MasterLocationIUR>=0"];
        }
    }else{
        if (![needInactiveRecord boolValue]) {
            predicate=[NSPredicate predicateWithFormat:@"MasterLocationIUR=%d and Active=1",[anIUR intValue]];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"MasterLocationIUR=%d",[anIUR intValue]];
        }
    }
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];

    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:resultType needDistinct:NO ascending:nil];
    
//    for (NSDictionary* aDict in objectsArray) {
//        NSLog(@"outlet----->%@",[aDict objectForKey:@"Name"]);
//    }
    if ([objectsArray count]>0) {

//        NSLog(@"end fecthing!!");

        return objectsArray;

    }else{
        return nil;
    }
}
- (NSMutableArray*)retrieveLocationWithPredicate:(NSPredicate*)aPredicate {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Name", nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:aPredicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        return objectsArray;
    } else {
        return nil;
    }
}
- (NSMutableArray*)outletsWithLTIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType{    
    //check need predicate or not
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];

    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"LTiur=%d and Active=1",[anIUR intValue]];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"LTiur=%d",[anIUR intValue]];
    }
    
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:resultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {

        NSLog(@"end fecthing!!");
        
        return objectsArray;
        
    }else{
        return nil;
    }
    
}
- (BOOL)isGroupForIUR:(NSNumber*)anIUR{
    NSPredicate* predicate;
    if ([anIUR intValue]<0) {//search all outlets
        return NO;
    }else{
        predicate=[NSPredicate predicateWithFormat:@"MasterLocationIUR=%d",[anIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        return YES;
        
    }else{
        return NO;
    }
    
}

- (void)updateLocationWithFieldName:(NSString*)aFieldName withActualContent:(id)anActualContent withLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d",[aLocationIUR intValue]];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];    
    NSString *propertyType = @"";
    for (Location* obj in objectsArray) {
        if ([aFieldName isEqualToString:@"ShortName"]) {
            [obj setSortKey:[NSString stringWithFormat:@"%@", anActualContent]];
            [obj setShortName:[NSString stringWithFormat:@"%@", anActualContent]];
        } else {
            NSDictionary* propsDict = [PropertyUtils classPropsFor:[obj class]];
            NSArray* allKeyList = [propsDict allKeys];
            bool isFound = false;
            for (int i = 0; i < [allKeyList count]; i++) {
                NSString* aKey = [allKeyList objectAtIndex:i];
                if ([aKey caseInsensitiveCompare:aFieldName] == NSOrderedSame)  {
                    aFieldName = aKey;
                    propertyType = [propsDict objectForKey:aKey];
                    isFound = true;
                    break;
                }
            }
            if (!isFound) {
                NSLog(@"Core Data field name is incompatible with the one in the server.");
                return;
            }
            NSString* methodName = [NSString stringWithFormat:@"set%@:", aFieldName];
//            NSLog(@"methodName is %@, %@", propertyType, methodName);
            SEL selector = NSSelectorFromString(methodName);
            
            if ([propertyType isEqualToString:@"NSNumber"]) {
                [obj performSelector:selector withObject:[NSNumber numberWithInt:[anActualContent intValue]]];            
            } else if ([propertyType isEqualToString:@"NSString"]) {
                [obj performSelector:selector withObject:[NSString stringWithFormat:@"%@", anActualContent]];
            }
        }                
        [self saveContext:self.fetchManagedObjectContext];
    }
}

- (void)locationWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    Location* location = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Location" 
                        inManagedObjectContext:context];
    location.Active = [NSNumber numberWithInt:1];
    location.Headoffice = [NSNumber numberWithInt:0];
    NSDictionary* propsDict = [PropertyUtils classPropsFor:[location class]];
    
//    NSLog(@"propsDict is %@", propsDict);
    for (int i = 0; i < [aFieldNameList count]; i++) {
        NSString* aFieldName = [aFieldNameList objectAtIndex:i];
        NSString* aFieldValue = [aFieldValueList objectAtIndex:i];
        if ([aFieldName isEqualToString:@"ShortName"]) {
            [location setSortKey:aFieldValue];
            [location setShortName:aFieldValue];
        } else {
            [PropertyUtils updateRecord:location fieldName:aFieldName fieldValue:aFieldValue propDict:propsDict];
        }        
    }    
    location.LocationIUR = anIUR;
    
    [self saveContext:self.addManagedObjectContext];
}
//LocLocLink
- (NSMutableArray*)getLocLocLink:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and FromLocationIUR = %d", [aLocationIUR intValue], [aFromLocationIUR intValue]];
    return [self fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString*)aDescrCodeType {
    NSString* condition = [NSString stringWithFormat:@"DescrTypeCode='%@'", aDescrCodeType];
//    NSLog(@"DescrCodeType in core data is %@", aDescrCodeType);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:condition];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"Active",@"ImageIUR",@"DescrDetailCode",nil];
    NSMutableArray* descrList = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    [descrList insertObject:[self.arcosDescriptionTrManager createUnAssignedDescrDetailDict] atIndex:0];
    
    return [self.arcosCoreDataManager convertDescrDetailDictList:descrList];
}

- (NSMutableArray*)descrDetailWithL5CodeList:(NSArray*)aL5CodeList descrTypeCode:(NSString*)aDescrTypeCode active:(int)anActive {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and Active = %d and DescrDetailCode in %@", aDescrTypeCode, anActive, aL5CodeList];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"ImageIUR", @"Detail", @"DescrDetailCode", nil];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    return [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSMutableArray*)descrDetailWithDescrDetailIUR:(NSNumber*)aDescrDetailIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR = %@", aDescrDetailIUR];
    return [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSNumber*)countDescrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode {
    NSPredicate* predicate = nil;
    if (aParentCode != nil) {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and ParentCode = %@", aDescrCodeType, aParentCode];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@", aDescrCodeType];
    }
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectArray objectAtIndex:0];
}

- (NSMutableArray*)descrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode = %@", aDescrTypeCode, aDescrDetailCode];
    NSArray* properties = [NSArray arrayWithObjects:@"Detail", nil];
    return  [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode = %@", aDescrTypeCode, aDescrDetailCode];
    return  [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSMutableArray*)descrDetailWithPredicate:(NSPredicate*)aPredicate sortByArray:(NSArray*)anSortArray {
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"Active",nil];
    NSMutableArray* descrList = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:aPredicate withSortDescNames:anSortArray withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableArray* newObjectsArray = [NSMutableArray array];
    
    for (NSDictionary* aDict in descrList) {
        NSMutableDictionary* myDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        if ([aDict objectForKey:@"Detail"]==nil) {
            [myDict setObject:@"Not Defined" forKey:@"Title"];
        } else{
            [myDict setObject:[aDict objectForKey:@"Detail"] forKey:@"Title"];
        }
        [newObjectsArray addObject:myDict];
    }
    return newObjectsArray;
}

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString *)aDescrTypeCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@", aDescrTypeCode];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    return [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (void)updateDescrDetailWithFieldName:(NSString*)aFieldName fieldValue:(id)aFieldValue descrTypeCode:(NSString*)aDescrTypeCode descrDetailIUR:(NSNumber*)aDescrDetailIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR = %d and DescrTypeCode = %@",[aDescrDetailIUR intValue], aDescrTypeCode];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] <= 0) return;
    DescrDetail* descrDetailObj = [objectsArray objectAtIndex:0];
    NSString* methodName = [NSString stringWithFormat:@"set%@:", aFieldName];
    NSLog(@"updateDescrDetail methodName is %@", methodName);
    SEL selector = NSSelectorFromString(methodName);
    [descrDetailObj performSelector:selector withObject:aFieldValue];
    [self saveContext:self.fetchManagedObjectContext];

}

- (void)createDescrDetailWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList descrTypeCode:(NSString*)aDescrTypeCode {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    DescrDetail* descrDetail = [NSEntityDescription
                        insertNewObjectForEntityForName:@"DescrDetail" 
                        inManagedObjectContext:context];    
    descrDetail.DescrTypeCode = aDescrTypeCode;
    for (int i = 0; i < [aFieldNameList count]; i++) {
        NSString* methodName = [NSString stringWithFormat:@"set%@:", [aFieldNameList objectAtIndex:i]];
        NSLog(@"createDescrDetail methodName is %@ %@", methodName, [aFieldValueList objectAtIndex:i]);
        SEL selector = NSSelectorFromString(methodName);
        [descrDetail performSelector:selector withObject:[aFieldValueList objectAtIndex:i]];
    }
    
    [self saveContext:self.addManagedObjectContext];
}

- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode {
    NSPredicate* predicate = [self.arcosCoreDataManager descrDetailWithDescrCodeType:aDescrCodeType parentCode:aParentCode];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"ImageIUR", @"Detail", @"DescrDetailCode", nil];
    return [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  
                          withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType 
                           needDistinct:NO ascending:nil];
}

- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode checkActive:(BOOL)aCheckFlag {
    NSPredicate* predicate = [self.arcosCoreDataManager descrDetailWithDescrCodeType:aDescrCodeType parentCode:aParentCode checkActive:aCheckFlag];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"ImageIUR", @"Detail", @"DescrDetailCode", nil];
    NSMutableArray* descrList = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties
                          withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType
                           needDistinct:NO ascending:nil];
    [descrList insertObject:[self.arcosDescriptionTrManager createUnAssignedDescrDetailDict] atIndex:0];
    
    return [self.arcosCoreDataManager convertDescrDetailDictList:descrList];
}

//descrtype
- (NSMutableArray*)allDescrType {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"DescrTypeCode",nil];
    NSMutableArray* descrTypeList = [self fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return descrTypeList;
}


- (void)saveGeoLocationWithLocationIUR:(NSNumber*)anIUR withLat:(NSNumber*)lat withLon:(NSNumber*)lon{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d objects fecthed from the fetched result ! for location IUR %d, set location to lat %f  lon %f",[objectsArray count],[anIUR intValue],[lat floatValue],[lon floatValue]);
    for (Location* obj in objectsArray) {
        [obj setLatitude:lat];
        [obj setLongitude:lon];
        [obj setCompetitor1:[NSNumber numberWithInt:99]];
        [self saveContext:self.fetchManagedObjectContext];
    }
}
#

#pragma mark presenter data
- (NSMutableDictionary*)productsWithPresentDoc{
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"ProductIUR",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"ProductIUR", nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:properties  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    
    for(NSDictionary* aDict in objectsArray){
        NSNumber* productIUR=[aDict objectForKey:@"ProductIUR"];
        NSMutableArray* products=[self productWithIUR:productIUR withResultType:NSManagedObjectResultType ];
        
        if ([products count]>0) {
            Product* aProduct=[products objectAtIndex:0];
            NSMutableDictionary* productDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
            
            //handle the nil description
            if (aProduct.Description==nil||[aProduct.Description isEqualToString:@""]) {
                [productDict setObject:@"Unkwon product description"forKey:@"description"];
            }else{
                [productDict setObject:aProduct.Description forKey:@"description"];
                
            }
            
            [productDict setObject:aProduct.ProductIUR forKey:@"IUR"];
            [productDict setObject:aProduct.ImageIUR forKey:@"imageIUR"];
            [productDict setObject:@"ProductType" forKey:@"GroupType"];
            
            
            //handle the nil description
            NSString* combinationKey=[NSString stringWithFormat:@"%@->%d",aProduct.Description, [aProduct.ProductIUR intValue]];
            [theGroups setObject:productDict forKey:combinationKey];
            //            if (aProduct.Description==nil||[aProduct.Description isEqualToString:@""]) {
            //                [theGroups setObject: productDict forKey:@"Unkwon product description"];
            //            }else{
            //                [theGroups setObject: productDict forKey:aProduct.Description];
            //            }
            
        }
        
    }
    
    return theGroups;
    
}
- (NSMutableDictionary*)fileTypes{
    
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@",@"FT"];
    NSArray* properties=[NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"ImageIUR", nil];
    
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    //NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    
    for(DescrDetail* aDesc in objectsArray){
        NSMutableDictionary* descDict=[[[NSMutableDictionary alloc]init]autorelease];
        [descDict setObject:aDesc.Detail forKey:@"description"];
        [descDict setObject:aDesc.DescrDetailIUR forKey:@"IUR"];
        [descDict setObject:aDesc.ImageIUR forKey:@"ImageIUR"];
        [descDict setObject:@"FileType" forKey:@"GroupType"];
        
        [theGroups setObject: descDict forKey:aDesc.Detail];
    }
    
    return theGroups;
}
- (NSMutableArray*)filesWithTypeIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType{

    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"FileTypeIUR=%d",[anIUR intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    //adding group image and file type image to file dictionary
    NSMutableArray* objectsMutableCopy=[[[NSMutableArray alloc]init ]autorelease];
    for (NSDictionary* aFile in objectsArray) {
        NSMutableDictionary* dictMutableCopy=[[[NSMutableDictionary alloc]initWithDictionary:aFile]autorelease];
        //file type image
        NSNumber* fileTypeIUR=[aFile objectForKey:@"FileTypeIUR"];
        NSDictionary* aFileTypeDesc=[self descriptionWithIUR:fileTypeIUR];
        if (aFileTypeDesc!=nil) {
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"ImageIUR"] forKey:@"FileImageIUR"];
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"DescrDetailCode"] forKey:@"Type"];
        }
        //file group image
        NSString* l5Code=[aFile objectForKey:@"L5code"];
        NSMutableArray* L5GroupDesc=[self l5GroupWithTypeCode:l5Code];
        if (L5GroupDesc !=nil && [L5GroupDesc count]>0) {
            DescrDetail* detail=[L5GroupDesc objectAtIndex:0];
            [dictMutableCopy setObject:detail.ImageIUR forKey:@"L5GroupImageIUR"];
        }
        //add the file to array
        [objectsMutableCopy addObject:dictMutableCopy];
    }
    //check any items int he array
    if ([objectsMutableCopy count]>0) {
        return objectsMutableCopy;
        
    }else{
        return nil;
    }
}
- (NSMutableArray*)filesWithProductIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"ProductIUR=%d",[anIUR intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    //adding group image and file type image to file dictionary
    NSMutableArray* objectsMutableCopy=[[[NSMutableArray alloc]init ]autorelease];
    for (NSDictionary* aFile in objectsArray) {
        NSMutableDictionary* dictMutableCopy=[[[NSMutableDictionary alloc]initWithDictionary:aFile]autorelease];
        //file type image
        NSNumber* fileTypeIUR=[aFile objectForKey:@"FileTypeIUR"];
        NSDictionary* aFileTypeDesc=[self descriptionWithIUR:fileTypeIUR];
        if (aFileTypeDesc!=nil) {
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"ImageIUR"] forKey:@"FileImageIUR"];
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"DescrDetailCode"] forKey:@"Type"];
        }
        //file group image
        NSString* l5Code=[aFile objectForKey:@"L5code"];
        NSMutableArray* L5GroupDesc=[self l5GroupWithTypeCode:l5Code];
        if (L5GroupDesc !=nil && [L5GroupDesc count]>0) {
            DescrDetail* detail=[L5GroupDesc objectAtIndex:0];
            [dictMutableCopy setObject:detail.ImageIUR forKey:@"L5GroupImageIUR"];
        }
        //add the file to array
        [objectsMutableCopy addObject:dictMutableCopy];
    }
    //check any items int the array
    if ([objectsMutableCopy count]>0) {
        return objectsMutableCopy;
        
    }else{
        return nil;
    }
    
}

- (NSMutableDictionary*)productL5Group{
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"L5code",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"L5code", nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:properties  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
   // NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    for(NSDictionary* aDict in objectsArray){
        NSString* L5Code=[aDict objectForKey:@"L5code"];        
        NSMutableArray* groupTypeName=[self l5GroupWithTypeCode:L5Code];
        
        if ([groupTypeName count]>0&&L5Code!=nil) {
            NSMutableDictionary* descDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
            DescrDetail* detail=[groupTypeName objectAtIndex:0];
            NSLog(@"group type name %@ for L5Code %@",detail.Detail,L5Code);

            [descDict setObject:L5Code forKey:@"groupTypeCode"];
            [descDict setObject:@"L5GroupType" forKey:@"GroupType"];
            [descDict setObject:detail.Detail forKey:@"description"];
            [descDict setObject:detail.ImageIUR forKey:@"ImageIUR"];

            if (detail.Detail !=nil && ![detail.Detail isEqual:@""]) {
                [theGroups setObject: descDict forKey:detail.Detail];
            }
        }

    }
    return theGroups;
}
- (NSMutableArray*)l5GroupWithTypeCode:(NSString*)typeCode{
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode='L5' AND DescrDetailCode=%@",typeCode];
    //NSArray* properties=[NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail", nil];
    
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    //NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    
    
    return objectsArray;
}

- (NSMutableArray*)filesWithGroupType:(NSString*)typeCode{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"L5code=%@",typeCode];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    //adding group image and file type image to file dictionary
    NSMutableArray* objectsMutableCopy=[[[NSMutableArray alloc]init ]autorelease];
    for (NSDictionary* aFile in objectsArray) {
        NSMutableDictionary* dictMutableCopy=[[[NSMutableDictionary alloc]initWithDictionary:aFile]autorelease];
        //file type image
        NSNumber* fileTypeIUR=[aFile objectForKey:@"FileTypeIUR"];
        NSDictionary* aFileTypeDesc=[self descriptionWithIUR:fileTypeIUR];
        if (aFileTypeDesc!=nil) {
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"ImageIUR"] forKey:@"FileImageIUR"];
            [dictMutableCopy setObject:[aFileTypeDesc objectForKey:@"DescrDetailCode"] forKey:@"Type"];
        }
        //file group image
        NSString* l5Code=[aFile objectForKey:@"L5code"];
        NSMutableArray* L5GroupDesc=[self l5GroupWithTypeCode:l5Code];
        if (L5GroupDesc !=nil && [L5GroupDesc count]>0) {
            DescrDetail* detail=[L5GroupDesc objectAtIndex:0];
            [dictMutableCopy setObject:detail.ImageIUR forKey:@"L5GroupImageIUR"];
        }
        //add the file to array
        [objectsMutableCopy addObject:dictMutableCopy];
    }
    //check any items int he array
    if ([objectsMutableCopy count]>0) {
        return objectsMutableCopy;
        
    }else{
        return nil;
    }
    return nil;
    
}
- (NSMutableArray*)productWithIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType{
    NSPredicate* predicate;
    if ([anIUR intValue]<0) {//search all product
        predicate=[NSPredicate predicateWithFormat:@"ProductIUR>=0"];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"ProductIUR=%d",[anIUR intValue]];
    }
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:resultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        return objectsArray;
        
    }else{
        return nil;
    }
    
}
- (NSMutableArray*)productWithL5Code:(NSString*)code{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"L5Code = %@",code];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d is found for l5 code %@",[objectsArray count],code);
    if ([objectsArray count]>0) {
        return objectsArray;
        
    }else{
        return nil;
    }
}

- (NSMutableArray*)presenterProducts{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"displaySequence",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
    if ([objectsArray count]>0) {
        //NSLog(@"presenter product return %@",objectsArray);
        return objectsArray;
        
    }else{
        return [NSMutableArray array];
    }
}

- (NSMutableArray*)presenterProductsActiveOnly:(BOOL)aFlag {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"displaySequence", nil];
    NSPredicate* predicate = nil;
    if (aFlag) {
        predicate = [NSPredicate predicateWithFormat:@"Active = 1"];
    }
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
    if ([objectsArray count] > 0) {
        return objectsArray;        
    } else {
        return [NSMutableArray array];
    }
}

- (NSMutableArray*)activeProductWithL5Code:(NSString*)anL5Code {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"L5Code = [c] %@ and ColumnDescription >='1'", anL5Code];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d is found for l5 code %@", [objectsArray count], anL5Code);
    if ([objectsArray count] > 0) {
        return objectsArray;        
    }else{
        return nil;
    }
}

- (NSMutableArray*)activeProductWithLxCode:(NSString*)anLxCode orderLevel:(NSNumber*)anOrderLevel {
    NSPredicate* predicate = nil;
    switch ([anOrderLevel intValue]) {
        case 0:
        case 5:
            predicate = [NSPredicate predicateWithFormat:@"L5Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"L1Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"L2Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
        case 3:
            predicate = [NSPredicate predicateWithFormat:@"L3Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
        case 4:
            predicate = [NSPredicate predicateWithFormat:@"L4Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
            
        default:
            predicate = [NSPredicate predicateWithFormat:@"L5Code = [c] %@ and ColumnDescription >='1'", anLxCode];
            break;
    }    
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d is found for l%d code %@", [objectsArray count], [anOrderLevel intValue], anLxCode);
    if ([objectsArray count] > 0) {
        return objectsArray;        
    }else{
        return nil;
    }
}

- (NSMutableArray*)activeProductWithL5CodeList:(NSArray*)anL5CodeList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"L5Code in %@ and ColumnDescription >='1'", anL5CodeList];
    NSArray* properties = [NSArray arrayWithObjects:@"ProductIUR", @"L5Code", nil];
    return [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
}

- (NSNumber*)countActiveProductWithL5Code:(NSString*)anL5Code {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"L5Code = [c] %@ and ColumnDescription >='1'", anL5Code];
    NSMutableArray* objectsArray = 
    [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}

- (NSMutableArray*)activeProductWithL3Code:(NSString*)anL3Code l5Code:(NSString*)anL5Code {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"L3Code = [c] %@ and L5Code = [c] %@ and ColumnDescription >='1'",anL3Code , anL5Code];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d is found for l3l5 code %@*%@", [objectsArray count], anL3Code,anL5Code);
    if ([objectsArray count] > 0) {
        return objectsArray;        
    }else{
        return nil;
    }
}

- (NSMutableArray*)activeProduct:(NSString*)aBranchLxCodeContent branchLxCode:(NSString*)aBranchLxCode leafLxCodeContent:(NSString*)anLeafLxCodeContent leafLxCode:(NSString*)anLeafLxCode {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K = [c] %@ and %K = [c] %@ and ColumnDescription >='1'",aBranchLxCode,aBranchLxCodeContent, anLeafLxCode, anLeafLxCodeContent];
    if (aBranchLxCodeContent == nil) {
        predicate = [NSPredicate predicateWithFormat:@"%K = [c] %@ and ColumnDescription >='1'",anLeafLxCode,anLeafLxCodeContent];
    }
    if (anLeafLxCodeContent == nil) {
        predicate = [NSPredicate predicateWithFormat:@"%K = [c] %@ and ColumnDescription >='1'",aBranchLxCode,aBranchLxCodeContent];
    }
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
    if ([objectsArray count] > 0) {
        return objectsArray;        
    }else{
        return nil;
    }
}
#pragma mark new presenter data
// the type of presenter files, EmployeeIUR in Presenter table is used to hold those type id
//  1 BRCH  Brochure
//  2 PDF  PDF file
//  3 PPT  PPT file
//  4 SOUN  Sound only
//  5 IMG  Still image
//  6 VID  Video
//  7 GRID  5*4 images 
//  8 SLID  Sliding images
//  9 WEB  web link
//  10 FACT  2 sided fact sheet
//  11 TXT  Simple text file

- (NSMutableArray*)presenterParentProducts:(NSNumber*)locationParentIUR{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"displaySequence",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"parentIUR=0 and LocationIUR=%d and Active = 1",[locationParentIUR intValue]];

    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
    if ([objectsArray count]>0) {
        //NSLog(@"presenter product return %@",objectsArray);
        return objectsArray;
        
    }else{
        return [NSMutableArray array];
    }
}
- (NSMutableArray*)presenterChildrenWithParentIUR:(NSNumber*)parentIUR{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"displaySequence",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"parentIUR=%@",parentIUR];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
    if ([objectsArray count]>0) {
//        NSLog(@"presenter %d has %d children",[parentIUR intValue],[objectsArray count]);
        
        return objectsArray;
        
    }else{
        return [NSMutableArray array];
    }
}
- (NSDictionary*)presenterWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"IUR=%@",anIUR];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
    }else{
        return nil;
    }
}
- (NSMutableArray*)presenterWithIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR in %@",anIURList];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    return objectsArray;
}
#pragma mark order data
//order data display
- (NSNumber*)orderWithOrderNumber:(int)anOrderNumber {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %d", anOrderNumber];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}

- (NSMutableArray*)allOrdersWithSortKey:(NSString*)aKey withLocationIUR:(NSNumber*)anIUR{
    NSLog(@"Start get all Order");
    NSPredicate* predicate;
    if (anIUR!=nil) {
        if ([anIUR intValue]<0) {//search all objects
            predicate=[NSPredicate predicateWithFormat:@"LocationIUR>=0"];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
        }
    }else{
        predicate=[NSPredicate predicateWithFormat:@"LocationIUR>=0"];
    }
    
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:aKey,nil];
    NSArray* properties=[NSArray arrayWithObjects:@"OrderNumber", @"OrderDate",@"Points",@"DeliveryDate",@"TotalGoods",@"LocationIUR",@"WholesaleIUR",@"EnteredDate",@"OrderHeaderIUR",@"NumberOflines",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    
//    NSLog(@"total %d of order are found",[objectsArray count]);
    
    NSMutableArray* alteredArray=[[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[[NSMutableDictionary alloc]initWithDictionary:aDict];
        NSMutableArray* aLocaiton=[self locationWithIUR:[aDict objectForKey:@"LocationIUR"]];
        NSNumber* orderHeaderIUR=[newDict objectForKey:@"OrderHeaderIUR"];

        if (aLocaiton!=nil) {
            [newDict setObject:[[aLocaiton objectAtIndex:0] objectForKey:@"Name"] forKey:@"Name"];
            [newDict setObject:[self fullAddressWith:[aLocaiton objectAtIndex:0]] forKey:@"Address"];
            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
            
            //if order is sent then seal the order
            if ([orderHeaderIUR intValue]>0) {
                [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
            }else{
                [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCealed"];
            }
            
        }
        NSMutableArray* aWholesalerLocaiton=[self locationWithIUR:[aDict objectForKey:@"WholesaleIUR"]];
        if (aWholesalerLocaiton!=nil) {
            [newDict setObject:[[aWholesalerLocaiton objectAtIndex:0] objectForKey:@"Name"] forKey:@"WholesalerName"];
            [newDict setObject:[self fullAddressWith:[aWholesalerLocaiton objectAtIndex:0]] forKey:@"WholesalerAddress"];            
        }
        [alteredArray addObject:newDict];
        [newDict release];
    }
    NSLog(@"End get all Order");

    return alteredArray;
}
- (NSMutableArray*)allOrderLinesWithOrderNumber:(NSNumber*)aNumber withSortKey:(NSString*)aKey locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSArray* sortDescNames=[NSArray arrayWithObjects:aKey,nil];
    NSArray* properties=[NSArray arrayWithObjects:@"UnitPrice", @"LineValue",@"Qty",@"DiscountPercent",@"Bonus",@"ProductIUR",@"OrderNumber",@"OrderLine",@"InStock",@"FOC",@"PPIUR",@"Testers",nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"OrderNumber=%d",[aNumber intValue]];
    
    NSMutableArray* auxObjectsArray=[self fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableArray* objectsArray = [NSMutableArray arrayWithCapacity:[auxObjectsArray count]];
    for (int i = 0; i < [auxObjectsArray count]; i++) {
        NSDictionary* auxObjectDict = [auxObjectsArray objectAtIndex:i];
        NSMutableDictionary* resultObjectDict = [NSMutableDictionary dictionaryWithDictionary:auxObjectDict];
        [resultObjectDict setObject:[NSNumber numberWithInt:[[auxObjectDict objectForKey:@"PPIUR"] intValue]] forKey:@"RRIUR"];
        [objectsArray addObject:resultObjectDict];
    }
    
//    NSLog(@"total %d of order line are found",[objectsArray count]);
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* tmpProductDict = [objectsArray objectAtIndex:i];
        [productIURList addObject:[tmpProductDict objectForKey:@"ProductIUR"]];
    }
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
//    NSMutableDictionary* priceHashMap = [self retrievePriceWithLocationIUR:aLocationIUR productIURList:productIURList];
//    productDictList = [self.arcosCoreDataManager processPriceProductList:productDictList priceHashMap:priceHashMap];
    productDictList = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:productDictList productIURList:productIURList locationIUR:aLocationIUR packageIUR:aPackageIUR];
    
    
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    
    //found product name for order lines
    NSMutableArray* newObjectArray=[[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* tempDict=[[[NSMutableDictionary alloc]initWithDictionary:aDict]autorelease];
        [tempDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        NSNumber* productIUR=[aDict objectForKey:@"ProductIUR"];
//        NSMutableArray* products=[self productWithIUR:productIUR withResultType:NSManagedObjectResultType];
//        Product* aProduct=[products objectAtIndex:0];
        NSDictionary* aProduct = [productDictHashMap objectForKey:productIUR];
        [newObjectArray addObject:[ProductFormRowConverter createStandardOrderLine:tempDict product:aProduct]];
    }
    return newObjectArray;
    
}
- (NSMutableArray*)allOrderToday{

    return  [self ordersWithDataRangeStart:[[GlobalSharedClass shared]today] withEndDate:[NSDate date]];
}
- (NSMutableArray*)allOrderWeek{
    return [self ordersWithDataRangeStart:[[GlobalSharedClass shared]thisWeek] withEndDate:[NSDate date]];
}
- (NSMutableArray*)allOrderThisMonth{
    return [self ordersWithDataRangeStart:[[GlobalSharedClass shared]thisMonth] withEndDate:[NSDate date]];
}
- (NSMutableArray*)allOrderThisYear{
    return [self ordersWithDataRangeStart:[[GlobalSharedClass shared]thisYear] withEndDate:[NSDate date]];
}
- (NSMutableDictionary*)orderTotalValues{

    NSMutableArray* orderToday=[self allOrderToday];
    NSMutableArray* orderWeek=[self allOrderWeek];
    NSMutableArray* orderMonth=[self allOrderThisMonth];
    NSMutableArray* orderYear=[self allOrderThisYear];
    
    NSNumber* todayTotal=[orderToday valueForKeyPath:@"@sum.TotalGoods"];
    NSNumber* weekTotal=[orderWeek valueForKeyPath:@"@sum.TotalGoods"];
    NSNumber* monthTotal=[orderMonth valueForKeyPath:@"@sum.TotalGoods"];
    NSNumber* yearTotal=[orderYear valueForKeyPath:@"@sum.TotalGoods"];
    
    NSMutableDictionary* totalValues=[NSMutableDictionary dictionaryWithObjectsAndKeys:todayTotal,@"todayTotal",weekTotal,@"weekTotal",monthTotal,@"monthTotal",yearTotal,@"yearTotal", nil];
    
    return totalValues;

}

- (NSMutableArray*)ordersWithDataRangeStart:(NSDate*)startDate withEndDate:(NSDate*)endDate{
    NSPredicate* predicate=nil;
    //NSLog(@"start getting orders list");
    //check lastOrderWithOrderNumber
//    NSLog(@"need order form %@ to %@",startDate,endDate);
    
    if (startDate==nil&&endDate!=nil) {//to the end of date
        predicate=[NSPredicate predicateWithFormat:@"OrderDate <=%@ ",endDate];
    }
    if (startDate!=nil&&endDate==nil) {//start with start date
        predicate=[NSPredicate predicateWithFormat:@"OrderDate >=%@ ",startDate];
    }
    if (startDate!=nil&&endDate!=nil) {//between start date and end date
        predicate=[NSPredicate predicateWithFormat:@"OrderDate >=%@ AND OrderDate <=%@",startDate,endDate];
    }
    
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"OrderDate",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"OrderNumber", @"OrderDate",@"Points",@"DeliveryDate",@"TotalGoods",@"LocationIUR",@"OrderHeaderIUR",@"EnteredDate",@"NumberOflines",@"OSiur",@"FormIUR",@"ContactIUR",@"WholesaleIUR",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    
    NSMutableArray* resultObjectList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (OrderHeader* tmpOrderHeader in objectsArray) {
        NSMutableDictionary* resultObjectDict = [NSMutableDictionary dictionaryWithCapacity:14];
        [resultObjectDict setObject:tmpOrderHeader.OrderNumber forKey:@"OrderNumber"];
        [resultObjectDict setObject:tmpOrderHeader.OrderDate forKey:@"OrderDate"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.Points] forKey:@"Points"];
        [resultObjectDict setObject:tmpOrderHeader.DeliveryDate forKey:@"DeliveryDate"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.TotalGoods] forKey:@"TotalGoods"];
        [resultObjectDict setObject:tmpOrderHeader.LocationIUR forKey:@"LocationIUR"];
        [resultObjectDict setObject:tmpOrderHeader.OrderHeaderIUR forKey:@"OrderHeaderIUR"];
        [resultObjectDict setObject:tmpOrderHeader.EnteredDate forKey:@"EnteredDate"];
        [resultObjectDict setObject:tmpOrderHeader.NumberOflines forKey:@"NumberOflines"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.OSiur] forKey:@"OSiur"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.FormIUR] forKey:@"FormIUR"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.ContactIUR] forKey:@"ContactIUR"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.WholesaleIUR] forKey:@"WholesaleIUR"];
        [resultObjectDict setObject:[ArcosUtils convertNilToZero:tmpOrderHeader.call.CTiur] forKey:@"CTiur"];
        [resultObjectList addObject:resultObjectDict];
    }
//    NSLog(@"total %d of order are found",[ArcosUtils convertNSUIntegerToUnsignedInt:[resultObjectList count]]);
    return resultObjectList;
}

- (NSNumber*)countCallsWithDataRangeStart:(NSDate*)aStartDate withEndDate:(NSDate*)anEndDate {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderDate >=%@ AND OrderDate <=%@ And NumberOflines = 0",aStartDate, anEndDate];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectArray objectAtIndex:0];
}

- (NSMutableArray*)ordersWithLocationIUR:(NSNumber*)aLocationIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ and OrderDate >= %@ AND OrderDate <= %@", aLocationIUR, aStartDate, anEndDate];
    NSArray* properties = [NSArray arrayWithObject:@"NumberOflines"];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

//- (NSMutableArray*)ordersWithCustomerIUR:(NSNumber*)anIUR{
//    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"LocationIUR = %@ AND orderlines.@count > 0",anIUR];
//
//    NSArray* sortDescNames=[NSArray arrayWithObjects:@"OrderDate",nil];
//    NSArray* properties=[NSArray arrayWithObjects:@"OrderNumber", @"OrderDate",@"Points",@"DeliveryDate",@"TotalGoods",@"LocationIUR",@"OrderHeaderIUR",@"EnteredDate",@"NumberOflines",@"OSiur",@"FormIUR",@"ContactIUR",@"WholesaleIUR",nil];
//    
//    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
//    
////    NSLog(@"total %d of order are found",[objectsArray count]);
//    
//    return objectsArray;
//}
//- (NSMutableArray*)callsWithCustomerIUR:(NSNumber*)anIUR{
//    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"LocationIUR = %@ AND orderlines.@count <= 0",anIUR];
//    
//    NSArray* sortDescNames=[NSArray arrayWithObjects:@"OrderDate",nil];
//    NSArray* properties=[NSArray arrayWithObjects:@"OrderNumber", @"OrderDate",@"Points",@"DeliveryDate",@"TotalGoods",@"LocationIUR",@"OrderHeaderIUR",@"EnteredDate",@"NumberOflines",@"OSiur",@"FormIUR",@"ContactIUR",@"WholesaleIUR",nil];
//    
//    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
//    
////    NSLog(@"total %d of order are found",[objectsArray count]);
//    
//    return objectsArray;
//}

- (NSMutableArray*)lastOrderWithOrderNumber:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %d",[anIUR intValue]];
    NSArray* properties = [NSArray arrayWithObjects:@"OrderNumber", @"OrderDate",@"Points",@"DeliveryDate",@"TotalGoods",@"LocationIUR",@"OrderHeaderIUR",@"EnteredDate",@"NumberOflines",@"OSiur",@"FormIUR",@"ContactIUR",@"WholesaleIUR",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    return objectsArray;
}

//order taking
- (NSMutableDictionary*)orderForms{
    
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Details",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"Details",@"IUR", nil];
    
    
    //check need predicate or not
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];

    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"Active=1"];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    //NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    for(NSDictionary* aDict in objectsArray){
        NSNumber* iur=[aDict objectForKey:@"IUR"];
        NSString* detail=[aDict objectForKey:@"Details"];
        
        
        //add group id to the dictionary
        if (detail !=nil&&![detail isEqualToString:@""]) {
            [theGroups setObject:iur forKey:detail];
        }
        
    }
    
    return theGroups;
}
- (NSMutableDictionary*)selectionWithOrderIUR:(NSNumber*)anIUR{
    
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SequenceDivider",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"Details",@"SequenceDivider", nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"FormIUR=%d and ProductIUR=0 and SequenceNumber=0",[anIUR intValue]];

    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    for(NSDictionary* aDict in objectsArray){
        NSNumber* sequenceDivider=[aDict objectForKey:@"SequenceDivider"];
        NSString* detail=[aDict objectForKey:@"Details"];

        
        //add group id to the dictionary
        if (detail !=nil&&![detail isEqualToString:@""]) {
            [theGroups setObject:sequenceDivider forKey:detail];
        }
        
    }
    
    return theGroups;
    
}
- (NSMutableArray*)selectionWithFormIUR:(NSNumber*)anIUR{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SequenceDivider",nil];
    //NSArray* properties=[NSArray arrayWithObjects:@"Details",@"SequenceDivider", nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"FormIUR=%d and ProductIUR=0 and SequenceNumber=0",[anIUR intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];


    if ([objectsArray count]>0) {
        return objectsArray;
        
    }else{
        return nil;
    }
}

- (NSMutableArray*)formDetail {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Details",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"Details",@"IUR",@"Active",@"ImageIUR", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1"];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSArray* keys = [NSArray arrayWithObjects:@"Details", @"IUR", @"Active", nil];
    NSArray* objs = [NSArray arrayWithObjects:@"All", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
    NSDictionary* constantDict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
    [objectsArray insertObject:constantDict atIndex:0];
    
    NSMutableArray* resultObjectsArray = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[aDict objectForKey:@"Details"] forKey:@"Title"];
        [resultObjectsArray addObject:newDict];
    }
    return resultObjectsArray;
}

- (NSMutableArray*)formDetailWithoutAll {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Details",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"Details",@"IUR",@"Active",@"FormType",@"PrintDeliveryDocket",@"ShowSeperators",@"ImageIUR", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1"];
    return [self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];    
}

- (NSDictionary*)formDetailWithFormIUR:(NSNumber*)aFormIUR {
    NSArray* properties = [NSArray arrayWithObjects:@"Details",@"IUR",@"Active",@"FormType",@"PrintDeliveryDocket",@"ShowSeperators",@"DefaultDeliveryDate",@"FontSize",@"BackColor", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [aFormIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];
    } else{
        return nil;
    }
}

- (NSDictionary*)formDetailWithFormType:(NSString*)aFormType {
    NSArray* properties = [NSArray arrayWithObjects:@"Details",@"IUR",@"Active",@"FormType",@"PrintDeliveryDocket",@"ShowSeperators",@"DefaultDeliveryDate", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormType = %@", aFormType];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];
    } else{
        return nil;
    }
}

- (BOOL)deleteFormDetailWithFormIUR:(NSNumber*)aFormIUR {
    @try {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d",[aFormIUR intValue]];
        NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        for (FormDetail* aFormDetail in objectsArray) {
            [self.fetchManagedObjectContext deleteObject:aFormDetail];
        }
        [self saveContext:self.fetchManagedObjectContext];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (NSMutableDictionary*)formRowWithDividerIUR:(NSNumber*)anIUR withFormIUR:(NSNumber*)formIUR{
    
    NSMutableDictionary* theGroups=[[[NSMutableDictionary alloc]init]autorelease];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SequenceDivider",@"SequenceNumber",nil];
    //NSArray* properties=[NSArray arrayWithObjects:@"Details",@"SequenceDivider", nil];
    NSPredicate* predicate=nil;
    if (formIUR!=nil) {
        if ([anIUR intValue]>0) {//all rows belong to the  form
            predicate=[NSPredicate predicateWithFormat:@"SequenceDivider=%d and ProductIUR > 0 and FormIUR=%d",[anIUR intValue],[formIUR intValue]];
        }else{//all rows belong to the given form and divider
            predicate=[NSPredicate predicateWithFormat:@"SequenceDivider>0 and ProductIUR > 0 and FormIUR=%d",[formIUR intValue]];
        }
        
    }else{//all rows belong to the given form and divider
        predicate=[NSPredicate predicateWithFormat:@"SequenceDivider=%d and ProductIUR > 0 and FormIUR=%d",[anIUR intValue],[formIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
        

//    NSLog(@"%d objects fecthed from the fetched result !",[objectsArray count]);
    
    for(NSDictionary* aDict in objectsArray){
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        NSString* detail=[aDict objectForKey:@"Details"];
        
        //add group id to the dictionary by using the combinated key
        NSString* productIUR=[[aDict objectForKey:@"ProductIUR"]stringValue];
        NSString* combinKey=[detail stringByAppendingFormat:@"->%@",productIUR];
        if (detail !=nil&&![detail isEqualToString:@""]) {
            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
            [newDict setObject:combinKey forKey:@"CombinationKey"];
            [theGroups setObject:newDict forKey:combinKey];
            //NSLog(@"the combination key is %@",combinKey);
        }
        
    }
    
    return theGroups;
}
- (NSMutableArray*)dividerFormRowsWithDividerIUR:(NSNumber*)anIUR formIUR:(NSNumber*)aFormIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"SequenceDivider",@"SequenceNumber",nil];
    NSPredicate* predicate = nil;
    if ([anIUR intValue]>0) {
        predicate = [NSPredicate predicateWithFormat:@"FormIUR=%d and SequenceDivider=%d",[aFormIUR intValue],[anIUR intValue]];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"FormIUR=%d and SequenceDivider>0",[aFormIUR intValue]];
    }
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {        
        return [self formRowProductProcessCenter:objectsArray locationIUR:aLocationIUR packageIUR:aPackageIUR];
    } else {
        return [NSMutableArray array];
    }
}

- (NSMutableArray*)formRowWithDividerIURSortByNatureOrder:(NSNumber*)anIUR withFormIUR:(NSNumber*)formIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SequenceDivider",@"SequenceNumber",nil];
    //NSArray* properties=[NSArray arrayWithObjects:@"Details",@"SequenceDivider", nil];
    NSPredicate* predicate=nil;
    if (formIUR!=nil) {
        if ([anIUR intValue]>0) {//all rows belong to the  form
            predicate=[NSPredicate predicateWithFormat:@"SequenceDivider=%d and ProductIUR > 0 and FormIUR=%d",[anIUR intValue],[formIUR intValue]];
        }else{//all rows belong to the given form and divider
            predicate=[NSPredicate predicateWithFormat:@"SequenceDivider>0 and ProductIUR > 0 and FormIUR=%d",[formIUR intValue]];
        }
        
    }else{//all rows belong to the given form and divider
        predicate=[NSPredicate predicateWithFormat:@"SequenceDivider=%d and ProductIUR > 0 and FormIUR=%d",[anIUR intValue],[formIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
//    NSLog(@"form row number -- %d form divider iur %d  form iur  %d",[objectsArray count],[anIUR intValue],[formIUR intValue]);    
    
    if ([objectsArray count]>0) {        
        return [self formRowProductProcessCenter:objectsArray locationIUR:aLocationIUR packageIUR:aPackageIUR];
    }else{
        return [NSMutableArray array];
    }
    
}

- (NSDictionary*)formRowWithFormIUR:(NSNumber*)aFormIUR productIUR:(NSNumber*)aProductIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormIUR = %d and ProductIUR = %d",[aFormIUR intValue], [aProductIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];
    } else {
        return nil;
    }    
}

- (NSMutableArray*)formRowWithFormIUR:(NSNumber*)aFormIUR dividerRecordIUR:(NSNumber*)anDividerRecordIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"SequenceNumber",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormIUR=%d and Level5IUR = %d and ProductIUR > 0", [aFormIUR intValue],[anDividerRecordIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        return [self formRowProductProcessCenter:objectsArray locationIUR:aLocationIUR packageIUR:aPackageIUR];
    } else {
        return [NSMutableArray array];
    }
}

- (NSMutableArray*)processEntryPriceProductList:(NSMutableArray*)aProductList productIURList:(NSMutableArray*)aProductIURList locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:aLocationIUR];
    NSDictionary* locationDict = nil;
    if (locationList != nil && [locationList count] > 0) {
        locationDict = [locationList objectAtIndex:0];
        NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
        if (configDict != nil) {
            NSNumber* auxConfigDefaultCUiur = [configDict objectForKey:@"DefaultCUiur"];
            NSNumber* auxLocationCUiur = [locationDict objectForKey:@"CUiur"];
            if ([auxConfigDefaultCUiur intValue] != [auxLocationCUiur intValue]) {
                aProductList = [self.arcosCoreDataManager processCUiurWithProductList:aProductList];
            }
        }
    }
    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableUsePriceListFlag]) {
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] enableUsePriceProductGroupFlag]) {
            NSMutableDictionary* priceHashMap = [self retrievePriceWithLocationIUR:aLocationIUR productIURList:aProductIURList];
            NSMutableDictionary* bonusDealHashMap = [self retrieveBonusDealWithLocationIUR:aLocationIUR productIURList:aProductIURList];
            aProductList = [self.arcosCoreDataManager processPriceProductList:aProductList priceHashMap:priceHashMap bonusDealHashMap:bonusDealHashMap];
            NSMutableDictionary* masterPriceHashMap = [self retrievePriceWithLocationIUR:[locationDict objectForKey:@"MasterLocationIUR"] productIURList:aProductIURList];
            aProductList = [self.arcosCoreDataManager processMasterPriceProductList:aProductList masterPriceHashMap:masterPriceHashMap masterBonusDealHashMap:bonusDealHashMap];
        } else {
            NSMutableDictionary* pgPriceHashMap = [self retrievePriceWithLocationIUR:[locationDict objectForKey:@"PGiur"] productIURList:aProductIURList];
            NSMutableDictionary* pgBonusDealHashMap = [self retrieveBonusDealWithLocationIUR:[locationDict objectForKey:@"PGiur"] productIURList:aProductIURList];
            aProductList = [self.arcosCoreDataManager processPriceProductList:aProductList priceHashMap:pgPriceHashMap bonusDealHashMap:pgBonusDealHashMap];
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
            NSNumber* auxPGiur = [[self retrievePackageWithIUR:aPackageIUR] objectForKey:@"pGiur"];
            
            NSMutableDictionary* pgPriceHashMap = [self retrievePriceWithLocationIUR:auxPGiur productIURList:aProductIURList];
            aProductList = [self.arcosCoreDataManager processPriceProductList:aProductList priceHashMap:pgPriceHashMap];
        }
    }
    int auxPriceOverride = [[locationDict objectForKey:@"PriceOverride"] intValue];    
    if (auxPriceOverride != 0) {
        aProductList = [self.arcosCoreDataManager processPriceOverrideWithProductList:aProductList priceOverride:auxPriceOverride];
    }    
    return aProductList;
}

- (NSMutableArray*)formRowProductProcessCenter:(NSMutableArray*)anObjectArray locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[anObjectArray count]];
    for (NSDictionary* aDict in anObjectArray) {
        NSNumber* auxProductIUR = [aDict objectForKey:@"ProductIUR"];
        if ([auxProductIUR intValue] == 0 || [auxProductIUR intValue] == -1) continue;
        [productIURList addObject:auxProductIUR];
    }
    NSMutableArray* productsList = [self productWithProductIURList:productIURList];
    productsList = [self processEntryPriceProductList:productsList productIURList:productIURList locationIUR:aLocationIUR packageIUR:aPackageIUR];
    NSMutableDictionary* productHashMap = [NSMutableDictionary dictionaryWithCapacity:[productsList count]];
    for (NSDictionary* aProductDict in productsList) {
        NSNumber* productIURKey = [aProductDict objectForKey:@"ProductIUR"];
        [productHashMap setObject:aProductDict forKey:productIURKey];
    }
    NSMutableArray* newFormRowList = [NSMutableArray arrayWithCapacity:[anObjectArray count]];
    for (NSDictionary* aDict in anObjectArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        NSNumber* productIUR = [newDict objectForKey:@"ProductIUR"];
        NSDictionary* productDict = nil;
        productDict = [productHashMap objectForKey:productIUR];
        if (productDict != nil) {
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:[NSMutableDictionary dictionaryWithDictionary:productDict]];
            NSMutableDictionary* orderPadFormRow = [ProductFormRowConverter createOrderPadFormRowWrapper:formRow formRow:newDict];
            [newFormRowList addObject:orderPadFormRow];
        } else {//product not found relating to the form row
            if ([productIUR intValue] == 0 || [productIUR intValue] == -1) {
                [newFormRowList addObject:newDict];
            } else {
                [newDict setObject:[NSDecimalNumber zero] forKey:@"UnitPrice"];
                [newDict setObject:[NSNumber numberWithInt:0] forKey:@"UnitsPerPack"];
                [newDict setObject:[NSNumber numberWithInt:78] forKey:@"Bonusby"];
                [newDict setObject:[NSNumber numberWithInt:9999] forKey:@"StockAvailable"];
                [newDict setObject:@"Product not found" forKey:@"Details"];
                [newDict setObject:@"" forKey:@"OrderPadDetails"];
                [newDict setObject:@"" forKey:@"ProductCode"];
                [newDict setObject:@"" forKey:@"ProductSize"];
            }            
        }        
        
    }
    return newFormRowList;
}

- (BOOL)deleteFormRowWithFormIUR:(NSNumber*)aFormIUR {
    @try {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormIUR = %d",[aFormIUR intValue]];
        NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        for (FormRow* aFormRow in objectsArray) {
            [self.fetchManagedObjectContext deleteObject:aFormRow];
        }
        [self saveContext:self.fetchManagedObjectContext];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (NSMutableDictionary*)createFormRowWithProductIUR:(NSNumber*)anIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSPredicate* predicate;
    if ([anIUR intValue]<0) {//search all product
        return nil;
    }else{
        predicate=[NSPredicate predicateWithFormat:@"ProductIUR=%d",[anIUR intValue]];
    }
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    NSMutableDictionary* formRow=[NSMutableDictionary dictionary];
    if ([objectsArray count]>0) {
        NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
        for (NSDictionary* aDict in objectsArray) {
            [productIURList addObject:[aDict objectForKey:@"ProductIUR"]];
        }
        objectsArray = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:objectsArray productIURList:productIURList locationIUR:aLocationIUR packageIUR:aPackageIUR];
        NSMutableDictionary* product=[objectsArray objectAtIndex:0];
        formRow = [ProductFormRowConverter createFormRowWithProduct:product];
        return formRow;
    }else{
        return nil;
    }
}
- (BOOL)updateOrderLine:(NSMutableDictionary*)orderLine{
    NSNumber* orderLineNumber=[orderLine objectForKey:@"OrderLine"];
    NSNumber* orderNumber=[orderLine objectForKey:@"OrderNumber"];
    NSPredicate* predicate =[NSPredicate predicateWithFormat:@"OrderNumber=%d AND OrderLine=%d",[orderNumber intValue],[orderLineNumber intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    BOOL isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    NSNumber* priorOrderLineQty = [NSNumber numberWithInt:0];
    
    if ([objectsArray count]>0 && objectsArray!=nil) {
        OrderLine* OL=[objectsArray objectAtIndex:0];
        NSString* auxOrderTypeCode = @"";
        if (isVanSalesEnabledFlag) {
            NSNumber* auxOTiur = OL.orderheader.OTiur;
            NSDictionary* auxDescrDetailDict = [self descriptionWithIUR:auxOTiur];
            auxOrderTypeCode = [auxDescrDetailDict objectForKey:@"DescrDetailCode"];
        }
        if (isVanSalesEnabledFlag) {            
            priorOrderLineQty = [NSNumber numberWithInt:[OL.Qty intValue]];
        }
        OL.DiscountPercent=[orderLine objectForKey:@"DiscountPercent"];
        OL.Bonus=[orderLine objectForKey:@"Bonus"];
        OL.LineValue=[orderLine objectForKey:@"LineValue"];
        OL.Qty=[orderLine objectForKey:@"Qty"];
        OL.InStock = [orderLine objectForKey:@"InStock"];
        OL.FOC = [orderLine objectForKey:@"FOC"];
        OL.UnitPrice = [orderLine objectForKey:@"UnitPrice"];
        OL.PPIUR = [orderLine objectForKey:@"RRIUR"];
        OL.Testers = [orderLine objectForKey:@"Testers"];
        [self saveContext:self.fetchManagedObjectContext];                
        if (isVanSalesEnabledFlag && [auxOrderTypeCode isEqualToString:[GlobalSharedClass shared].vansCode]) {
            ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
            [arcosStockonHandUtils updateStockonHandWithOrderLine:orderLine priorOrderLineQty:priorOrderLineQty];
            [arcosStockonHandUtils release];
        }
        return YES;

    }else{
        return NO;
    }    
}
- (BOOL)deleteOrderLine:(NSMutableDictionary*)orderLine{
    NSNumber* orderLineNumber=[orderLine objectForKey:@"OrderLine"];
    NSNumber* orderNumber=[orderLine objectForKey:@"OrderNumber"];
    
    return [self deleteOrderLineWithOrderNumber:orderNumber withLineNumber:orderLineNumber];
}
- (BOOL)deleteOrderLinesWithOrderNumber:(NSNumber*)orderNumber{
    NSPredicate* predicate =[NSPredicate predicateWithFormat:@"OrderNumber=%d",[orderNumber intValue]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0 && objectsArray!=nil) {
        for (OrderLine* OL in objectsArray) {
            [self deleteOrderLineWithOrderNumber:orderNumber withLineNumber:OL.OrderLine];
        }
        return YES;
        
    }else{
        return NO;
    }
    
}
- (BOOL)deleteOrderLineWithOrderNumber:(NSNumber*)orderNumber withLineNumber:(NSNumber*)lineNumber{
    
    NSPredicate* predicate =[NSPredicate predicateWithFormat:@"OrderNumber=%d AND OrderLine=%d",[orderNumber intValue],[lineNumber intValue]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    BOOL isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    NSMutableArray* deleteOrderLineList = [[[NSMutableArray alloc] init] autorelease];
    
    if ([objectsArray count]>0 && objectsArray!=nil) {
        OrderLine* OL=[objectsArray objectAtIndex:0];
        NSString* auxOrderTypeCode = @"";
        if (isVanSalesEnabledFlag) {
            NSNumber* auxOTiur = OL.orderheader.OTiur;
            NSDictionary* auxDescrDetailDict = [self descriptionWithIUR:auxOTiur];
            auxOrderTypeCode = [auxDescrDetailDict objectForKey:@"DescrDetailCode"];
            [deleteOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:OL]];
        } 
        //decrese the order header number of lines
        NSNumber* NOL= OL.orderheader.NumberOflines;
        NOL=[NSNumber numberWithInt:[NOL intValue]-1];
        OL.orderheader.NumberOflines=NOL;
        
        [self.fetchManagedObjectContext deleteObject:OL];
        [self saveContext:self.fetchManagedObjectContext];        
        if (isVanSalesEnabledFlag && [auxOrderTypeCode isEqualToString:[GlobalSharedClass shared].vansCode]) {
            ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
            [arcosStockonHandUtils updateStockonHandWithOrderLines:deleteOrderLineList actionType:1];
            [arcosStockonHandUtils release];
        }
        return YES;
        
    }else{
        return NO;
    }
    
}
- (BOOL)deleteOrderHeader:(NSMutableDictionary*)orderHeader{
    NSNumber* orderNumber=[orderHeader objectForKey:@"OrderNumber"];
    return [self deleteOrderHeaderWithOrderNumber:orderNumber];
}
- (BOOL)deleteOrderHeaderWithOrderNumber:(NSNumber*)orderNumber{
    NSPredicate* predicate =[NSPredicate predicateWithFormat:@"OrderNumber=%d",[orderNumber intValue]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    NSMutableArray* deleteOrderLineList = [[[NSMutableArray alloc] init] autorelease];
    BOOL isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    if ([objectsArray count]>0 && objectsArray!=nil) {
        OrderHeader* OH=[objectsArray objectAtIndex:0];
        NSString* auxOrderTypeCode = @"";
        if (isVanSalesEnabledFlag) {
            NSNumber* auxOTiur = OH.OTiur;
            NSDictionary* auxDescrDetailDict = [self descriptionWithIUR:auxOTiur];
            auxOrderTypeCode = [auxDescrDetailDict objectForKey:@"DescrDetailCode"];
        }
        //delete order lines belong to the order header        
        for (OrderLine* OL in OH.orderlines) {
            if (isVanSalesEnabledFlag) {                
                [deleteOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:OL]];
            }
            [self.fetchManagedObjectContext deleteObject:OL];
        }
        //delete order lines belong to the order header
        for (CallTran* CT in OH.calltrans) {
            [self.fetchManagedObjectContext deleteObject:CT];
        }
        
        //delete call
        if (OH.call !=nil) {
            [self.fetchManagedObjectContext deleteObject:OH.call];
        }
        //delete memo
        if (OH.memo !=nil) {
            [self.fetchManagedObjectContext deleteObject:OH.memo];
        }
        
        [self.fetchManagedObjectContext deleteObject:OH];
        
        
        [self saveContext:self.fetchManagedObjectContext];
        
        if (isVanSalesEnabledFlag && [auxOrderTypeCode isEqualToString:[GlobalSharedClass shared].vansCode]) {
            ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
            [arcosStockonHandUtils updateStockonHandWithOrderLines:deleteOrderLineList actionType:1];
            [arcosStockonHandUtils release];
        }
        return YES;
        
    }else{
        return NO;
    }
}

- (BOOL)saveOrderLineWithOrderNumber:(NSNumber*)anOrderNumber withOrderlines:(NSMutableDictionary*)anOrderLinesDict {
    OrderHeader* OH = [self orderHeaderWithOrderNumber:anOrderNumber];
    if (OH == nil) {//does order header return 0 or nil
        return NO;
    }
    if ([anOrderLinesDict count] == 0) {
        return NO;
    }
    NSMutableArray* deleteOrderLineList = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* addOrderLineList = [[[NSMutableArray alloc] init] autorelease];
    BOOL isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    NSString* auxOrderTypeCode = @"";
    if (isVanSalesEnabledFlag) {
        NSNumber* auxOTiur = OH.OTiur;
        NSDictionary* auxDescrDetailDict = [self descriptionWithIUR:auxOTiur];
        auxOrderTypeCode = [auxDescrDetailDict objectForKey:@"DescrDetailCode"];
    }
    NSMutableDictionary* formRowDict = [[ArcosCoreData sharedArcosCoreData] formRowWithDividerIUR:[NSNumber numberWithInt:-1] withFormIUR:OH.FormIUR];
    if ([formRowDict count] == 0) {// normal way
        NSMutableArray* sortedKeys = [[OrderSharedClass sharedOrderSharedClass] createAlphabeticSortedKey:[anOrderLinesDict allValues]];
        for (OrderLine* tmpOL in OH.orderlines) {
            if (isVanSalesEnabledFlag) {
                [deleteOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:tmpOL]];
            }            
            [self.fetchManagedObjectContext deleteObject:tmpOL];
        }
        //convert order lines to object set
        NSMutableSet* orderLinesSet = [NSMutableSet set];
        int lineNumber = 0;
        for (NSString* key in sortedKeys) {
            lineNumber++;
            NSMutableDictionary* orderLine = [anOrderLinesDict objectForKey:key];
            //convert order line dictionary to object
            OrderLine* OL = [self createOrderLineWithOrderHeader:OH orderLine:orderLine lineNumber:lineNumber context:self.fetchManagedObjectContext];
            if (isVanSalesEnabledFlag) {
                [addOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:OL]];
            }            
            //add to the set
            [orderLinesSet addObject:OL];
        }
        [OH addOrderlines:orderLinesSet];
        OH.NumberOflines = [NSNumber numberWithInt:lineNumber];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSMutableSet* orderLinesSet = [NSMutableSet set];
        int lineNumber = 0;
        NSMutableDictionary* productIURDict = [NSMutableDictionary dictionary];
        for(NSString* tmpKey in anOrderLinesDict) {
            NSMutableDictionary* tmpOrderlineDict = [anOrderLinesDict objectForKey:tmpKey];
            [productIURDict setObject:tmpOrderlineDict forKey:[tmpOrderlineDict objectForKey:@"ProductIUR"]];
        }
        NSSortDescriptor* orderLineDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"OrderLine" ascending:YES];
        NSArray* sortedOrderlines = [OH.orderlines sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderLineDescriptor]];
        for (OrderLine* tmpOL in OH.orderlines) {
            if (isVanSalesEnabledFlag) {
                [deleteOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:tmpOL]];
            }
            [self.fetchManagedObjectContext deleteObject:tmpOL];
        }
        for (OrderLine* tmpOL in sortedOrderlines) {
            NSMutableDictionary* orderLine = [productIURDict objectForKey:tmpOL.ProductIUR];
            if (orderLine != nil) {
                lineNumber = [tmpOL.OrderLine intValue];
                OrderLine* OL = [self createOrderLineWithOrderHeader:OH orderLine:orderLine lineNumber:lineNumber context:self.fetchManagedObjectContext];
                if (isVanSalesEnabledFlag) {
                    [addOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:OL]];
                }
                //add to the set
                [orderLinesSet addObject:OL];
                [anOrderLinesDict removeObjectForKey:[orderLine objectForKey:@"CombinationKey"]];
            }
        }
        
        NSMutableArray* sortedKeyList = [[OrderSharedClass sharedOrderSharedClass] createAlphabeticSortedKey:[anOrderLinesDict allValues]];
        for (NSString* key in sortedKeyList) {
            lineNumber++;
            NSMutableDictionary* orderLine = [anOrderLinesDict objectForKey:key];
            //convert order line dictionary to object
            OrderLine* OL = [self createOrderLineWithOrderHeader:OH orderLine:orderLine lineNumber:lineNumber context:self.fetchManagedObjectContext];
            if (isVanSalesEnabledFlag) {
                [addOrderLineList addObject:[self.arcosCoreDataManager createOrderLineWithManagedOrderLine:OL]];
            }
            //add to the set
            [orderLinesSet addObject:OL];
        }
        [OH addOrderlines:orderLinesSet];
        OH.NumberOflines = [NSNumber numberWithUnsignedInteger:[orderLinesSet count]];
        [self saveContext:self.fetchManagedObjectContext];
    }
    if (isVanSalesEnabledFlag && [auxOrderTypeCode isEqualToString:[GlobalSharedClass shared].vansCode]) {
        ArcosStockonHandUtils* arcosStockonHandUtils = [[ArcosStockonHandUtils alloc] init];
        [arcosStockonHandUtils updateStockonHandWithOrderLines:deleteOrderLineList actionType:1];
        [arcosStockonHandUtils updateStockonHandWithOrderLines:addOrderLineList actionType:0];
        [arcosStockonHandUtils release];
    }
    return YES;
}

- (OrderLine*)createOrderLineWithOrderHeader:(OrderHeader*)anOrderHeader orderLine:(NSMutableDictionary*)anOrderLine lineNumber:(int)aLineNumber context:(NSManagedObjectContext*)aContext {
    OrderLine* OL = [NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:self.fetchManagedObjectContext];
    OL.OrderLine = [NSNumber numberWithInt:aLineNumber];
    OL.LocationIUR = anOrderHeader.LocationIUR;
    OL.OrderNumber = anOrderHeader.OrderNumber;
    OL.ProductIUR = [anOrderLine objectForKey:@"ProductIUR"];
    OL.OrderDate = anOrderHeader.OrderDate;
    OL.UnitPrice = [anOrderLine objectForKey:@"UnitPrice"];
    OL.Bonus = [anOrderLine objectForKey:@"Bonus"];
    OL.Qty = [anOrderLine objectForKey:@"Qty"];
    OL.LineValue = [anOrderLine objectForKey:@"LineValue"];
    OL.DiscountPercent = [anOrderLine objectForKey:@"DiscountPercent"];
    OL.InStock = [anOrderLine objectForKey:@"InStock"];
    OL.FOC = [anOrderLine objectForKey:@"FOC"];
    OL.PPIUR = [anOrderLine objectForKey:@"RRIUR"];
    OL.Testers = [anOrderLine objectForKey:@"Testers"];
    //line to order header
    OL.orderheader = anOrderHeader;
    return OL;
}

- (OrderHeader*)orderHeaderWithOrderNumber:(NSNumber*)orderNumber{
    
    NSPredicate* predicate =[NSPredicate predicateWithFormat:@"OrderNumber=%d",[orderNumber intValue]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0 && objectsArray!=nil) {

        return [objectsArray objectAtIndex:0];
        
    }else{
        return nil;
    }
}
- (NSMutableDictionary*)editingOrderHeaderWithOrderNumber:(NSNumber*)orderNumber{
    NSMutableDictionary* returnOrderHeader=[NSMutableDictionary dictionary];

    OrderHeader* orderHeader=[self orderHeaderWithOrderNumber:orderNumber];
//    NSLog(@"IUR of location to fetcth is %d IUR is %d",[orderHeader.WholesaleIUR intValue],[orderHeader.OrderHeaderIUR intValue]);

    if (orderHeader==nil) {
        return nil;
    }
    //set order cust name, address and value
    NSString* custName= [self locationNameWithIUR:orderHeader.LocationIUR];
    NSMutableArray* customer=[self locationWithIUR:orderHeader.LocationIUR];
    NSMutableDictionary* aCustomer=[customer objectAtIndex:0];
    if (aCustomer != nil) {
        [returnOrderHeader setObject:aCustomer forKey:@"Customer"];
    }
    NSString* custAddress=[self fullAddressWith:aCustomer];
    NSString* locationCode = [ArcosUtils convertNilToEmpty:[aCustomer objectForKey:@"LocationCode"]];
    [returnOrderHeader setObject:locationCode forKey:@"LocationCode"];
    //adding a locationIUR
    [returnOrderHeader setObject: orderHeader.LocationIUR forKey:@"LocationIUR"];
    
    [returnOrderHeader setObject: custName forKey:@"CustName"];
    [returnOrderHeader setObject: custAddress forKey:@"CustAddress"];
    [returnOrderHeader setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCustomer objectForKey:@"Address1"]]] forKey:@"Address1"];
    [returnOrderHeader setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCustomer objectForKey:@"Address2"]]] forKey:@"Address2"];
    [returnOrderHeader setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCustomer objectForKey:@"Address3"]]] forKey:@"Address3"];
    [returnOrderHeader setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aCustomer objectForKey:@"Address4"]]] forKey:@"Address4"];
    [returnOrderHeader setObject:orderHeader.EmployeeIUR forKey:@"EmployeeIUR"];
    [returnOrderHeader setObject:orderHeader.FormIUR forKey:@"FormIUR"];
    NSDictionary* auxFormTypeDict = [self formDetailWithFormIUR:orderHeader.FormIUR];
    if (auxFormTypeDict != nil) {
        NSMutableDictionary* formTypeDict = [NSMutableDictionary dictionaryWithDictionary:auxFormTypeDict];
        [returnOrderHeader setObject:formTypeDict forKey:@"formType"];
    }
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:orderHeader.EmployeeIUR];
    [returnOrderHeader setObject:[NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]] forKey:@"Employee"];
    [returnOrderHeader setObject: orderHeader.OrderNumber forKey:@"OrderNumber"];
    [returnOrderHeader setObject: orderHeader.OrderHeaderIUR forKey:@"OrderHeaderIUR"];
    [returnOrderHeader setObject: orderHeader.NumberOflines forKey:@"NumberOflines"];
    
    [returnOrderHeader setObject: [orderHeader.DocketIUR stringValue]  forKey:@"orderNumberText"];
    [returnOrderHeader setObject: [NSString stringWithFormat:@"%1.2f", [orderHeader.TotalGoods floatValue]] forKey:@"totalGoodsText"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToZero:orderHeader.TotalGoods] forKey:@"TotalGoods"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToZero:orderHeader.TotalQty] forKey:@"TotalQty"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToZero:orderHeader.TotalBonus] forKey:@"TotalBonus"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:orderHeader.DeliveryInstructions1] forKey:@"DeliveryInstructions1"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:orderHeader.DeliveryInstructions2] forKey:@"DeliveryInstructions2"];
    //set order date to today
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate* orderDate=orderHeader.OrderDate;
    [returnOrderHeader setObject: orderDate forKey:@"orderDate"];
    [returnOrderHeader setObject:[formatter stringFromDate:orderDate] forKey:@"orderDateText"];
    
    // order status , order type , call type , memo type
    NSNumber* OSiur=orderHeader.OSiur;
//    NSLog(@"order status iur is %d",[OSiur intValue]);
    NSDictionary* aDescrption=[self descriptionWithIUR:OSiur];
//    NSLog(@"order status desc is %@",aDescrption);

    [returnOrderHeader setObject:aDescrption forKey:@"status"];
    [returnOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"statusText"];
    
    NSNumber* OTiur=orderHeader.OTiur;
//    NSLog(@"order type iur is %d",[OTiur intValue]);
    aDescrption=[self descriptionWithIUR:OTiur];
//    NSLog(@"order type desc is %@",aDescrption);
    
    [returnOrderHeader setObject:aDescrption forKey:@"type"];
    [returnOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"orderTypeText"];
    
    NSNumber* CTiur=orderHeader.call.CTiur;
    if (CTiur!=nil) {
        aDescrption=[self descriptionWithIUR:CTiur];
        [returnOrderHeader setObject:aDescrption forKey:@"callType"];
        [returnOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"callTypeText"];
    }else{
        [returnOrderHeader setObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"] forKey:@"callType"];
        [returnOrderHeader setObject:@"None" forKey:@"callTypeText"];
    }
   
    NSNumber* MTiur=orderHeader.memo.MTIUR;
    if (MTiur!=nil) {
        aDescrption=[self descriptionWithIUR:MTiur];
        if (aDescrption!=nil) {
            [returnOrderHeader setObject:aDescrption forKey:@"memoType"];
            [returnOrderHeader setObject:[aDescrption objectForKey:@"Detail"] forKey:@"memoTypeText"];
            [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:orderHeader.memo.Details] forKey:@"memo"];
        }
        

    }else{
        [returnOrderHeader setObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"] forKey:@"memoType"];
        [returnOrderHeader setObject:@"None"forKey:@"memoTypeText"];
        [returnOrderHeader setObject:@"" forKey:@"memo"];

    }
    
    //delivery date and wholesaler and  contact
    NSDate* deliveryDate=orderHeader.DeliveryDate;
    [returnOrderHeader setObject: deliveryDate forKey:@"deliveryDate"];
    [returnOrderHeader setObject:[formatter stringFromDate:deliveryDate] forKey:@"deliveryDateText"];
    
    //wholesaler
    NSNumber* wholesalerIur=orderHeader.WholesaleIUR;
    if (wholesalerIur == nil) {
        [returnOrderHeader setObject:[NSNumber numberWithInt:0] forKey:@"FromLocationIUR"];
    } else {
        [returnOrderHeader setObject:wholesalerIur forKey:@"FromLocationIUR"];
    }
    NSMutableDictionary* wholesaler=[[self locationWithIUR:wholesalerIur]objectAtIndex:0];
//    NSLog(@"wholesaler is %@",     wholesaler);
    if (wholesaler!=nil) {
        [returnOrderHeader setObject: wholesaler forKey:@"wholesaler"];
        NSString* wholesalerName=[self locationNameWithIUR:wholesalerIur];
//        NSLog(@"wholesalerName is %@", wholesalerName);
        [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:wholesalerName] forKey:@"wholesalerText"];
    }else{
        [returnOrderHeader setObject: [NSMutableDictionary dictionary] forKey:@"wholesaler"];
        NSString* wholesalerName=@"No Wholesaler";
        [returnOrderHeader setObject:wholesalerName forKey:@"wholesalerText"];
    }
    
    //contact
    NSNumber* contactIur=orderHeader.ContactIUR;//need check 0 iur
    NSMutableArray* contact=[self contactWithIUR:contactIur];
    NSMutableDictionary* aContact=nil;
    if(contact!=nil&&[contact count]>0){
        aContact=[contact objectAtIndex:0];
    }
        
    if (contact!=nil&&aContact !=nil) {
        [returnOrderHeader setObject: aContact forKey:@"contact"];
    }else{
        [returnOrderHeader setObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"IUR"]  forKey:@"contact"];
    }

    
    if ([contact count]<=0) {
        [returnOrderHeader setObject:[GlobalSharedClass shared].unassignedText forKey:@"contactText"];
    }else{
        NSMutableDictionary* aContact=[contact objectAtIndex:0];
        NSString* fullName = @"";
        if ([[aContact objectForKey:@"IUR"] intValue] == 0) {
            fullName = [GlobalSharedClass shared].unassignedText;
        } else {
            NSString* forename=[aContact objectForKey:@"Forename"];
            NSString* surname=[aContact objectForKey:@"Surname"];
            if (forename==nil) {
                forename=@"";
            }
            if (surname==nil) {
                surname=@"";
            }
            fullName = [NSString stringWithFormat:@"%@ %@",forename,surname];
            if ([forename isEqualToString:@""]&&[surname isEqualToString:@""]) {
                fullName=@"Noname Staff";
            }
        }
        
        [returnOrderHeader setObject:fullName forKey:@"contactText"];
    }   
    
    //reference and memo
    if (orderHeader.CustomerRef!=nil) {
        [returnOrderHeader setObject:orderHeader.CustomerRef forKey:@"custRef"];
    }else{
        [returnOrderHeader setObject:@"" forKey:@"custRef"];
    }
    NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [acctNoDict setObject:[ArcosUtils convertNumberToIntString:orderHeader.PromotionIUR] forKey:@"acctNo"];
    [acctNoDict setObject:[ArcosUtils convertNumberToIntString:orderHeader.PromotionIUR] forKey:@"Title"];
    [returnOrderHeader setObject:acctNoDict forKey:@"acctNo"];
    if ([orderHeader.PromotionIUR intValue] == 0) {
        [returnOrderHeader setObject:[GlobalSharedClass shared].unassignedText forKey:@"acctNoText"];
    } else {
        [returnOrderHeader setObject:[ArcosUtils convertNumberToIntString:orderHeader.PromotionIUR]  forKey:@"acctNoText"];
    }
    
    if (orderHeader.memo!=nil) {//need check nil memo
        [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:orderHeader.memo.Details] forKey:@"memo"];
    }else{
        [returnOrderHeader setObject:@"" forKey:@"memo"];
    }
    
    //geto location
    [returnOrderHeader setObject:orderHeader.Latitude forKey:@"latitude"];
    [returnOrderHeader setObject:orderHeader.Longitude forKey:@"longitude"];
    [returnOrderHeader setObject:[ArcosUtils convertNilToEmpty:orderHeader.InvoiseRef] forKey:@"invoiceRef"];
        
    //releas the instance
    [formatter release];
    [returnOrderHeader setObject:[ArcosUtils convertNilToZero:orderHeader.PosteedIUR] forKey:@"PosteedIUR"];
    return returnOrderHeader;
    
}
- (BOOL)saveOrderHeader:(NSMutableDictionary*)orderHeader{
//    NSLog(@"order header will be save %@",orderHeader);
    if (orderHeader==nil) {//check order header 
        return NO;
    }
    NSNumber* orderHeaderIUR=[orderHeader objectForKey:@"OrderHeaderIUR"];
    if ([orderHeaderIUR intValue]>0) {//can't save the sent order
        return NO;
    }
    NSNumber* orderNumber=[orderHeader objectForKey:@"OrderNumber"];
    if (orderNumber==nil||[orderNumber intValue]==0) {//is order number nil or 0
        return NO;
    }
    
    OrderHeader* OH=[self orderHeaderWithOrderNumber:orderNumber];
    if (OH==nil) {//is order header return 0 or nil
        return NO;
    }
    NSDictionary* customerDict = [orderHeader objectForKey:@"Customer"];
    if (customerDict != nil) {
        OH.LocationIUR = [customerDict objectForKey:@"LocationIUR"];
        OH.LocationCode = [customerDict objectForKey:@"LocationCode"];
    }
    //setting the company iur and employee iur    
    NSMutableDictionary* wholesaler=[orderHeader objectForKey:@"wholesaler"];
    NSMutableDictionary* status=[orderHeader objectForKey:@"status"];
    NSMutableDictionary* type=[orderHeader objectForKey:@"type"];
    NSMutableDictionary* callType=[orderHeader objectForKey:@"callType"];
    NSMutableDictionary* memoType=[orderHeader objectForKey:@"memoType"];
    NSMutableDictionary* contact=[orderHeader objectForKey:@"contact"];
    NSDictionary* formTypeDict = [orderHeader objectForKey:@"formType"];
    if (formTypeDict != nil) {
        OH.FormIUR = [formTypeDict objectForKey:@"IUR"];
    }
    
    //OH.EnteredDate=[NSDate date];
//    NSLog(@"order header to save is %@",OH.EnteredDate);
    OH.OrderDate=[orderHeader objectForKey:@"orderDate"];
    OH.DeliveryDate=[orderHeader objectForKey:@"deliveryDate"];
    OH.DeliveryInstructions1 = [orderHeader objectForKey:@"DeliveryInstructions1"];
    OH.WholesaleIUR=[wholesaler objectForKey:@"LocationIUR"];
    OH.OSiur=[status objectForKey:@"DescrDetailIUR"];
    OH.OTiur=[type objectForKey:@"DescrDetailIUR"];
    OH.CustomerRef=[orderHeader objectForKey:@"custRef"];
    NSMutableDictionary* acctNoDict = [orderHeader objectForKey:@"acctNo"];
    OH.PromotionIUR = [ArcosUtils convertStringToNumber:[acctNoDict objectForKey:@"acctNo"]];
    if (contact!=nil) {
        OH.ContactIUR=[contact objectForKey:@"IUR"];
    }else{
        OH.ContactIUR=[NSNumber numberWithInt:0];
    }
    
    //Memo
    NSString* memoText=[orderHeader objectForKey:@"memo"];
    NSNumber* memoTypeIUR=[memoType objectForKey:@"DescrDetailIUR"];
    Memo* MO=nil;
    if (![memoText isEqualToString:@""]) {//someting in the memo
        if (OH.memo!=nil) {//order header has memo
            MO=OH.memo; 
        }else{//order header has no memo create one
            MO=[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.fetchManagedObjectContext];
        }
        MO.Details=memoText;
        MO.MTIUR=memoTypeIUR;
        MO.EmployeeIUR=OH.EmployeeIUR;
        MO.DateEntered=OH.OrderDate;
        MO.Subject=@"Order Memo";
        MO.LocationIUR=OH.LocationIUR;
        if (OH.ContactIUR!=nil) {
            MO.ContactIUR=OH.ContactIUR;
        }else{
            MO.ContactIUR=[NSNumber numberWithInt:0];
        }
        //link to order header
        MO.orderheader=OH;
        OH.memo=MO;
    }else{
        if (OH.memo!=nil) {
            //delete the memo
        }
    }
        
    //create Call object
    NSNumber* callTypeIUR=[callType objectForKey:@"DescrDetailIUR"];
//    NSDictionary* aDesc=[self descriptionWithIUR:callTypeIUR];
//    NSNumber* toggle1 = [aDesc objectForKey:@"Toggle1"];
    
    Call* CA=nil;
    if (OH.call!=nil) {//order header has call
        CA=OH.call;
    }else{//order header has no call create one
        CA=[NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:self.fetchManagedObjectContext];
    }
    CA.ContactIUR=OH.ContactIUR;
    CA.CTiur=callTypeIUR;
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
//    }else{
//        if (OH.call!=nil) {
//            //delete call
//
//        }
//        
//    }
    
    //Calltrans
    if ([orderHeader objectForKey:@"CallTrans"]!=nil) {
        NSSet* calltransSet=OH.calltrans;
        ArcosArrayOfCallTran* calltrans=[orderHeader objectForKey:@"CallTrans"];

        //delete all old calltrans
        if (calltrans!=nil&&[calltrans count]>0) {
            for(CallTran* CT in calltransSet){
                [self.fetchManagedObjectContext deleteObject:CT];
            }
        }
        

        //Add new calltrans
        NSMutableSet* newCallTransSet=[NSMutableSet set];
        
        for (ArcosCallTran* aCalltran in calltrans) {
            CallTran* CT=[NSEntityDescription insertNewObjectForEntityForName:@"CallTran" inManagedObjectContext:self.fetchManagedObjectContext];
            
            CT.Reference=aCalltran.Reference;
            CT.Score=[NSNumber numberWithInt: aCalltran.Score];
            CT.DetailLevelIUR=aCalltran.DetailLevel;
            CT.DetailIUR=[NSNumber numberWithInt:aCalltran.DetailIUR];
            CT.ProductIUR=[NSNumber numberWithInt:aCalltran.ProductIUR];
            CT.DTiur=[NSNumber numberWithInt:aCalltran.DTIUR];
            
            //link call tran to the oreder header
            CT.orderheader=OH;
            
            [newCallTransSet addObject:CT];
        }
        
        [OH addCalltrans:newCallTransSet];    
        
    }
    
    [self saveContext:self.fetchManagedObjectContext];
    return YES;
}
- (BOOL)updateOrderHeaderTotalGoods:(NSNumber*)totalGoods withOrderNumber:(NSNumber*)orderNumber{
    if (orderNumber==nil||totalGoods==nil) {
        return NO;
    }
    OrderHeader* OH=[self orderHeaderWithOrderNumber:orderNumber];
    
    if (OH==nil) {
        return NO;
    }
    OH.TotalGoods=[NSDecimalNumber decimalNumberWithString:[totalGoods stringValue]];
    [self saveContext:self.fetchManagedObjectContext];
    return YES;
}
//order sending
- (BOOL)saveSentOrderWithOrderHeaderBO:(ArcosOrderHeaderBO*)orderHeaderBO{
    if (orderHeaderBO==nil) {//is order header object empty
        return NO;
    }
    if (orderHeaderBO.IUR<=0||orderHeaderBO.OrderNumber<=0||orderHeaderBO.DocketIUR<=0) {//is required feilds invalid
        return NO;
    }
    //get crospondent order header from core data
    OrderHeader* OH=[self orderHeaderWithOrderNumber:[NSNumber numberWithInt: orderHeaderBO.DocketIUR]];

    if (OH==nil) {//no order related to the order number
        return NO;
    }
    // update the order header iur and order number
    if ([OH.NumberOflines intValue] == 0) {
        OrderHeader* auxOrderHeader = [self orderHeaderWithOrderNumber:[NSNumber numberWithInt: orderHeaderBO.OrderNumber]];
        if (auxOrderHeader == nil) {
            OH.OrderNumber=[NSNumber numberWithInt: orderHeaderBO.OrderNumber];
        }
    } else {
        OH.OrderNumber=[NSNumber numberWithInt: orderHeaderBO.OrderNumber];
    }
    OH.OrderHeaderIUR=[NSNumber numberWithInt: orderHeaderBO.IUR ];
    OH.DocketIUR=[NSNumber numberWithInt: -1];
    NSLog(@"order number %d need to save",orderHeaderBO.OrderNumber );
    // update order lines
    for (OrderLine* OL in OH.orderlines) {
        OL.OrderNumber=OH.OrderNumber;
    } 
    
    // update the memo
    if (OH.memo!=nil&&orderHeaderBO.Memo!=nil) {
        OH.memo.IUR=[NSNumber numberWithInt: orderHeaderBO.Memo.iur];
        OH.memo.MTIUR=[NSNumber numberWithInt: orderHeaderBO.Memo.MTiur];
        OH.memo.ContactIUR=[NSNumber numberWithInt: orderHeaderBO.Memo.Contactiur];
        OH.memo.CallIUR=[NSNumber numberWithInt: orderHeaderBO.Memo.Calliur];
        OH.memo.TableIUR=[NSNumber numberWithInt: orderHeaderBO.Memo.Tableiur];
        OH.memo.EmployeeIUR=[NSNumber numberWithInt: orderHeaderBO.Memo.Employeeiur];
        OH.memo.FullFilled=[NSNumber numberWithBool: orderHeaderBO.Memo.FullFilled];
        OH.memo.DateEntered=orderHeaderBO.Memo.DateEntered;
        OH.memo.Details=orderHeaderBO.Memo.Details;
        OH.memo.Subject=orderHeaderBO.Memo.Subject;
        
        OH.MemoIUR=[NSNumber numberWithInt:orderHeaderBO.MemoIUR];
    }
    // update the call
    if (OH.call!=nil&&orderHeaderBO.Call!=nil) {
        OH.call.IUR=[NSNumber numberWithInt: orderHeaderBO.Call.iur];
        OH.call.ContactIUR=[NSNumber numberWithInt: orderHeaderBO.Call.ContactIUR];
        OH.call.LocationIUR=[NSNumber numberWithInt: orderHeaderBO.Call.LocationIUR];
        OH.call.MeetingIUR=[NSNumber numberWithInt: orderHeaderBO.Call.MeetingIUR];
        OH.call.CTiur=[NSNumber numberWithInt: orderHeaderBO.Call.CTIUR];
        OH.call.ThisCallMemoIUR=[NSNumber numberWithInt: orderHeaderBO.Call.ThisCallMemoIUR];
        OH.call.NextCallMemoIUR=[NSNumber numberWithInt: orderHeaderBO.Call.NextCallMemoIUR];
        OH.call.CallDate=orderHeaderBO.Call.CallDate;
        OH.call.EmployeeIUR=[NSNumber numberWithInt: orderHeaderBO.Call.EmployeeIUR];
        OH.call.CallCost=orderHeaderBO.Call.CallCost;
        OH.call.Longitude=orderHeaderBO.Call.Longitude;
        OH.call.Latitude=orderHeaderBO.Call.Latitude;
    }
    
    
    [self saveContext:self.fetchManagedObjectContext];
    for (int i = 0; i < [orderHeaderBO.Lines count]; i++) {
        ArcosOrderLineBO* arcosOrderLineBO = [orderHeaderBO.Lines objectAtIndex:i];
        if ([arcosOrderLineBO.BatchRef containsString:[GlobalSharedClass shared].pxDbName]) {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %d and OrderLine = %d", arcosOrderLineBO.OrderNumber, arcosOrderLineBO.OrderLine];
            NSMutableArray* auxObjectArray = [self fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
            if ([auxObjectArray count] > 0) {
                OrderLine* auxOrderLine = [auxObjectArray objectAtIndex:0];
                auxOrderLine.InStock = [NSNumber numberWithInt:arcosOrderLineBO.InStock];
                auxOrderLine.FOC = [NSNumber numberWithInt:arcosOrderLineBO.FOC];
                [self saveContext:self.fetchManagedObjectContext];
            }
        }
    }
    return YES;
}
//- (BOOL)updateOrderLineForOrderHeaderBO:(ArcosOrderHeaderBO*)orderHeaderBO{
//    if (orderHeaderBO==nil) {//is order header object empty
//        return NO;
//    }
//    if (orderHeaderBO.IUR<=0||orderHeaderBO.OrderNumber<=0||orderHeaderBO.DocketIUR<=0) {//is required feilds invalid
//        return NO;
//    }
//    //get crospondent order header from core data
//    OrderHeader* OH=[self orderHeaderWithOrderNumber:[NSNumber numberWithInt: orderHeaderBO.DocketIUR]];
//    OH.DocketIUR=[NSNumber numberWithInt: orderHeaderBO.OrderNumber];
//
//    if (OH==nil) {//no order related to the order number
//        return NO;
//    }
//    // update the order header iur and order number
//    OH.OrderHeaderIUR=[NSNumber numberWithInt: orderHeaderBO.IUR ];
//    OH.OrderNumber=[NSNumber numberWithInt: orderHeaderBO.DocketIUR];
////    NSLog(@"%d lines for order number %d",[orderHeaderBO.Lines count],orderHeaderBO.OrderNumber);
//    //add order lines
//    if ([orderHeaderBO.Lines count]>0) {
//        NSMutableSet* orderLinesSet=[NSMutableSet set];
////        NSLog(@"%d order lines back",[orderHeaderBO.Lines count]);
//        int linenumber=0;
//        for (ArcosOrderLineBO* orderLine in orderHeaderBO.Lines) {
//            linenumber++;
////            NSLog(@"order line save is %@",orderLine);
//            //convert order line dictionary to object
//            OrderLine* OL=[NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:self.fetchManagedObjectContext];
//            OL.OrderLine=[NSNumber numberWithInt:orderLine.OrderLine];
//            OL.LocationIUR=OH.LocationIUR;
//            OL.OrderNumber=OH.OrderNumber;
//            OL.ProductIUR=[NSNumber numberWithInt:orderLine.ProductIUR];
//            OL.OrderDate=OH.OrderDate;
//            OL.UnitPrice=orderLine.UnitPrice ;
//            OL.Bonus=[NSNumber numberWithInt:orderLine.Bonus];
//            OL.Qty=[NSNumber numberWithInt:orderLine.Qty];
//            OL.LineValue=orderLine.LineValue;
//            OL.DiscountPercent=orderLine.DiscountPercent;
//            
//            //line to order header
//            OL.orderheader=OH;
//            
//            //add to the set
//            [orderLinesSet addObject:OL];
//        }
//        OH.NumberOflines=[NSNumber numberWithInt:linenumber];
//        [OH addOrderlines:orderLinesSet];
//        
//    }
//    
//    [self saveContext:self.fetchManagedObjectContext];
//
//    return YES;
//}
- (void)changeOrderHeaderIurWithOrderNumber:(NSNumber*)orderNumber WithValue:(NSNumber*)value{
    OrderHeader* OH=[self orderHeaderWithOrderNumber:orderNumber];
    OH.OrderHeaderIUR=value;
    OH.OSiur=[SettingManager defaultOrderSentStatus];
    [self saveContext:self.fetchManagedObjectContext];
}
#pragma mark image data
- (UIImage*)thumbWithIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"IUR=%d",[anIUR intValue]];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Image" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];

    if ([objectsArray count]>0&&objectsArray!=nil) {
        Image* anImage=[objectsArray objectAtIndex:0];
        UIImage* image=[UIImage imageWithData:anImage.Thumbnail];
        return image;
    }else{
        return nil;
    }
}
- (UIImage*)thumbWithDescIUR:(NSNumber*)anIUR{
    NSDictionary* aDesc=[self descriptionWithIUR:anIUR];
    if (aDesc==nil) {
        return nil;
    }
    NSNumber* anImageIUR=[aDesc objectForKey:@"ImageIUR"];
    
    UIImage* anImage=[self thumbWithIUR:anImageIUR];
    
    return anImage;
}
#pragma mark check out data
//check out data
- (NSMutableArray*)orderWholeSalers{
    //NSNumber* wholeSalerIUR=[[GlobalSharedClass shared].appSetting objectForKey:@"WholesalerTypeIUR"];
    NSNumber* wholeSalerIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:6];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"LTiur=%d and Active=1",[wholeSalerIUR intValue]];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Name",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[[NSMutableArray alloc]init];
    
    for (NSDictionary* aDict in objectsArray) {
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
        
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[aDict objectForKey:@"Name"] forKey:@"Title"];
        [newObjectsArray addObject:newDict];
        
        [loopPool drain];
    }
    return [newObjectsArray autorelease];
}
- (NSMutableArray*)orderStatus{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ and Active=1",@"OS"];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    //NSNumber* defaultOS=[[GlobalSharedClass shared].appSetting objectForKey:@"PendingOrderIUR"];
    NSNumber* defaultOS = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:3];

    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[aDict objectForKey:@"Detail"] forKey:@"Title"];
        NSNumber* descrDetailIUR=[aDict objectForKey:@"DescrDetailIUR"];
        
        //set the default flag
        if ([defaultOS isEqualToNumber:descrDetailIUR]) {
            [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDefault"];
        }else{
            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
        }
        
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}
- (NSMutableArray*)orderTypes{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ and Active=1",@"OT"];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    //NSNumber* defaultOT=[[GlobalSharedClass shared].appSetting objectForKey:@"OrderTypeIUR"];
    NSNumber* defaultOT = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:4];

    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        if ([aDict objectForKey:@"Detail"]==nil) {
            [newDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [newDict setObject:[aDict objectForKey:@"Detail"] forKey:@"Title"];
        }        NSNumber* descrDetailIUR=[aDict objectForKey:@"DescrDetailIUR"];
        
        //set the default flag
        if ([defaultOT isEqualToNumber:descrDetailIUR]) {
            [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDefault"];
        }else{
            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
        }
        
        
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}
- (NSMutableArray*)callTypes{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ and Active=1",@"CT"];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    //NSNumber* defaultCT=[[GlobalSharedClass shared].appSetting objectForKey:@"CallTypeIUR"];
    NSNumber* defaultCT = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:2];

    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        
        if ([aDict objectForKey:@"Detail"]==nil) {
            [newDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [newDict setObject:[aDict objectForKey:@"Detail"] forKey:@"Title"];
        }
        NSNumber* descrDetailIUR=[aDict objectForKey:@"DescrDetailIUR"];
        
        //set the default flag
        if ([defaultCT isEqualToNumber:descrDetailIUR]) {
            [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDefault"];
        }else{
            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
        }
        
        
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}
- (NSMutableArray*)orderContactsWithLocationIUR:(NSNumber*)anIUR{
    NSMutableArray* objectsArray=[NSMutableArray array];
    //get the conloclink base on the location iur
    NSMutableArray* conloclinks=[self conlocLinksWithLocationIUR:anIUR];
    
    //loop through the conloclinks and find the contacts associate with it 
    for (NSDictionary* aDict in conloclinks) {
        NSNumber* contactIUR=[aDict objectForKey:@"ContactIUR"];
        NSMutableDictionary* tmpContactDict = [self compositeContactWithIUR:contactIUR];
        if (tmpContactDict != nil) {
            [objectsArray addObject:tmpContactDict];
        }
//        NSMutableArray* contacts=[self contactWithIUR:contactIUR]; 
//        if ([contacts count]>0&&contacts!=nil) {
//            NSMutableDictionary* newDict= [NSMutableDictionary dictionaryWithDictionary:[contacts objectAtIndex:0]];
//            NSString* forename=[newDict objectForKey:@"Forename"];
//            NSString* surname=[newDict objectForKey:@"Surname"];
//            if (forename==nil) {
//                forename=@"";
//            }
//            if (surname==nil) {
//                surname=@"";
//            }
//            NSString* fullName=[NSString stringWithFormat:@"%@ %@",forename,surname];
//            if ([forename isEqualToString:@""]&&[surname isEqualToString:@""]) {
//                fullName=@"Noname Staff";
//            }
////            NSLog(@"full name of contact is %@",fullName);
//            
//            [newDict setObject:fullName forKey:@"Title"];
//            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
//            [objectsArray addObject:newDict];
//        }
    }
//    NSLog( @"%d number of contact for location iur %d",[objectsArray count],[anIUR intValue] );
    if ([objectsArray count] > 0) {
        NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Forename" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [objectsArray sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    }
    return objectsArray;
}

- (NSMutableDictionary*)compositeContactWithIUR:(NSNumber*)anIUR {
    NSMutableArray* contacts = [self contactWithIUR:anIUR];
    if ([contacts count] == 0) return nil;
    NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:[contacts objectAtIndex:0]];
    NSString* fullName = [ArcosUtils contactFullName:newDict];
    [newDict setObject:fullName forKey:@"Title"];
    [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
    return newDict;
}

- (NSUInteger)locationContactsWithLocationIUR:(NSNumber*)anIUR {
    //get the conloclink base on the location iur
    NSMutableArray* conloclinks = [self conlocLinksWithLocationIUR:anIUR];
    NSMutableArray* contactIURList = [NSMutableArray arrayWithCapacity:[conloclinks count]];
    for (NSDictionary* aDict in conloclinks) {
        [contactIURList addObject:[aDict objectForKey:@"ContactIUR"]];
    }
    NSMutableArray* contactDictList = [self contactWithIURList:contactIURList];
    return [contactDictList count];
}
- (NSMutableArray*)contactWithIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"IUR=%d",[anIUR intValue]];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Forename",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    return objectsArray;
}

- (NSMutableArray*)contactWithIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR in %@",anIURList];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}
- (NSMutableArray*)conlocLinksWithLocationIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"LocationIUR",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"ConLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    return objectsArray;
}
- (NSMutableArray*)conlocLinksWithContactIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"ContactIUR=%d",[anIUR intValue]];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"ContactIUR",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"ConLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    return objectsArray;
}
- (NSMutableArray*)conlocLinksWithContactIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ContactIUR in %@", anIURList];
    
//    NSLog(@"start fecthing conlocLinksWithContactIURList!!");
    
    NSArray* sortDescNames = nil;//[NSArray arrayWithObjects:@"ContactIUR",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"ConLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    return objectsArray;
}
- (BOOL)deleteConLocLinkWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d",[anIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"ConLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0 && objectsArray != nil) {
        ConLocLink* aConLocLink = [objectsArray objectAtIndex:0];        
        [self.fetchManagedObjectContext deleteObject:aConLocLink];
        [self saveContext:self.fetchManagedObjectContext];
        return YES;
    }else{
        return NO;
    }
}
- (NSMutableDictionary*)theLastOrderWithLocationIUR:(NSNumber*)anIUR{
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"EnteredDate"];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxDate"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSDateAttributeType];
    
    
    //NSArray* properties=[NSArray arrayWithObjects:expressionDescription ,nil];
    NSPredicate* predicateOrder=nil;
    if (anIUR !=nil && [anIUR intValue]>0) {//lastorder of a given location
        predicateOrder=[NSPredicate predicateWithFormat:@"LocationIUR=%d && NumberOflines>0",[anIUR intValue]];
    }
    
    //new test
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"EnteredDate",nil];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicateOrder withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    //end new test
    
    //NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:properties  withPredicate:predicateOrder withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    [expressionDescription release];
    
    if ([objectsArray count]>0 && objectsArray!=nil) {
        // NSPredicate* predicate=   [NSPredicate predicateWithFormat:@"EnteredDate=%@",[[objectsArray objectAtIndex:0]objectForKey:@"maxDate"]];
        

       // NSMutableArray* objectsArray1=[self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicate
       //                                          withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil]; 
        
        if ([objectsArray count]>0 && objectsArray!=nil) {
//            NSLog(@"the last  order for %@  is %@",anIUR,[objectsArray objectAtIndex:0]);

            return [objectsArray objectAtIndex:0];
            
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
}
- (OrderHeader*)theLastOrderHeaderWithLocationIUR:(NSNumber*)anIUR {
    NSPredicate* predicateOrder = [NSPredicate predicateWithFormat:@"LocationIUR=%d",[anIUR intValue]];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"EnteredDate",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicateOrder withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count]>0 && objectsArray!=nil) {
        return [objectsArray objectAtIndex:0];
    }else{
        return nil;
    }
}
#pragma mark description data
- (NSDictionary*)descriptionWithIUR:(NSNumber*)anIUR{
    
    return [self descriptionWithIUR:anIUR needActive:NO];
}
- (NSDictionary*)descriptionWithIURActive:(NSNumber*)anIUR{
    return [self descriptionWithIUR:anIUR needActive:YES];
}

- (NSDictionary*)descriptionWithIUR:(NSNumber *)anIUR needActive:(BOOL)active{
    NSPredicate* predicate=nil;
    
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    //NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if ([anIUR intValue]<0) {//search all objects
        if (active) {
            predicate=[NSPredicate predicateWithFormat:@"DescrDetailIUR>=0 and Active=1"];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"DescrDetailIUR>=0"];
        }
    }else{
        if (active) {
            predicate=[NSPredicate predicateWithFormat:@"DescrDetailIUR=%d and Active=1",[anIUR intValue]];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"DescrDetailIUR=%d ",[anIUR intValue]];
            
        }
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
        
    }else{
        return nil;
    }
}

- (NSMutableArray*)descriptionWithIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR in %@",anIURList];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count]>0) {
        return objectsArray;
    }else{
        return nil;
    }
}


- (NSDictionary*)descrTypeWithTypeCode:(NSString*)aCode{
    NSPredicate* predicate=nil;

    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ and Active=1",aCode];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ ",aCode];
        
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
        
    }else{
        return nil;
    }
}

- (NSDictionary*)descrTypeAllRecordsWithTypeCode:(NSString*)aCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode=%@ ",aCode];        
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
    
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];        
    }else{
        return nil;
    }
}
#pragma mark save order
//save the order
-(BOOL)saveOrder:(NSMutableDictionary*)anOrder{
//    NSLog(@"save an order %@",anOrder);
    // order header data
    NSMutableDictionary* orderHeader=[anOrder objectForKey:@"OrderHeader"];
    
    NSMutableDictionary* wholesaler=[orderHeader objectForKey:@"wholesaler"];
    NSMutableDictionary* status=[orderHeader objectForKey:@"status"];
    NSMutableDictionary* type=[orderHeader objectForKey:@"type"];
    NSMutableDictionary* callType=[orderHeader objectForKey:@"callType"];
    NSMutableDictionary* memoType=[orderHeader objectForKey:@"memoType"];
    NSMutableDictionary* contact=[orderHeader objectForKey:@"contact"];
    
    //order line
    NSMutableDictionary* orderLines=[anOrder objectForKey:@"OrderLines"];
    NSMutableArray* sortedKeys = [NSMutableArray array];
//    sortedKeys = [[[orderLines keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSMutableDictionary* order1=(NSMutableDictionary*)obj1;
//        NSMutableDictionary* order2=(NSMutableDictionary*)obj2;
//        
//        NSString* orderName1=[order1 objectForKey:@"Details"];
//        NSString* orderName2=[order2 objectForKey:@"Details"];
//        return [orderName1 compare:orderName2];
//        
//    }]mutableCopy]autorelease];
    sortedKeys = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[orderLines allValues]];
    //memo
    NSString* memo=[anOrder objectForKey:@"Memo"];
    //call
    NSString* custRef=[anOrder objectForKey:@"CustomerRef"];
    NSMutableDictionary* acctNoDict = [anOrder objectForKey:@"AccountNo"];
    //location
    NSNumber* locatinIUR=[anOrder objectForKey:@"LocationIUR"];
    NSString* locationCode=@"";
    NSMutableArray* locationArray=[self locationWithIUR:locatinIUR];
    if ([locationArray count]>0) {
        NSMutableDictionary* location=[locationArray objectAtIndex:0];
        locationCode=[location objectForKey:@"LocationCode"];
    }
    //Employee IUR
    NSNumber* employeeIUR=[anOrder objectForKey:@"EmployeeIUR"];
    //form iur
    NSNumber* formIUR=[anOrder objectForKey:@"FormIUR"];
    //order number
    NSNumber* orderNumber=[anOrder objectForKey:@"OrderNumber"];
    
    //check is the order header and order line valid
    if (orderHeader==nil || orderLines==nil) {
        return NO;
    }
    
    //convert order header dictionary to object
    OrderHeader* OH=[NSEntityDescription insertNewObjectForEntityForName:@"OrderHeader" inManagedObjectContext:self.addManagedObjectContext];
    OH.EnteredDate=[NSDate date];
    OH.LocationIUR=locatinIUR;
    OH.LocationCode=locationCode;
    OH.EmployeeIUR=employeeIUR;
    OH.FormIUR=formIUR;
    OH.OrderNumber=orderNumber;

        //order header data
    //OH.OrderNumber=0; need to be increament number in setting
    OH.CustomerRef=custRef;
    OH.PromotionIUR = [ArcosUtils convertStringToNumber:[acctNoDict objectForKey:@"acctNo"]];
    OH.PosteedIUR = [ArcosUtils convertNilToZero:[anOrder objectForKey:@"PosteedIUR"]];
    OH.OrderDate=[orderHeader objectForKey:@"orderDate"];
    OH.OSiur=[status objectForKey:@"DescrDetailIUR"];
    OH.OTiur=[type objectForKey:@"DescrDetailIUR"];
    OH.DeliveryDate=[orderHeader objectForKey:@"deliveryDate"];
    OH.DeliveryInstructions1 = [orderHeader objectForKey:@"DeliveryInstructions1"];
    OH.WholesaleIUR=[wholesaler objectForKey:@"LocationIUR"];
    NSLog(@"wholesaler iur to save is %d",[OH.WholesaleIUR intValue]);
    if (contact!=nil) {
        OH.ContactIUR=[contact objectForKey:@"IUR"];
    }else{
        OH.ContactIUR=[NSNumber numberWithInt:0];
    }
    OH.TotalGoods=[orderHeader objectForKey:@"TotalGoods"];
    OH.TotalQty=[orderHeader objectForKey:@"TotalQty"];
    OH.TotalBonus=[orderHeader objectForKey:@"TotalBonus"];
    OH.NumberOflines=[orderHeader objectForKey:@"NumberOflines"];
    OH.Latitude=[orderHeader objectForKey:@"latitude"];
    OH.Longitude=[orderHeader objectForKey:@"longitude"];
    OH.ExchangeRate=[NSDecimalNumber decimalNumberWithString:@"1.0"];
    NSMutableArray* invoiceRefList = [orderHeader objectForKey:@"invoiceRef"];
    OH.InvoiseRef= [invoiceRefList componentsJoinedByString:@"|"];
    NSNumber* callCost = [anOrder objectForKey:@"CallCost"];
    if (callCost != nil) {
        OH.CallCost = [NSDecimalNumber decimalNumberWithString:[callCost stringValue]];
    }
    

    
    //convet order lines to object set
    NSMutableSet* orderLinesSet=[NSMutableSet set];
    int lineNumber=0;
    for (NSString* key in sortedKeys) {
        lineNumber++;
        NSMutableDictionary* orderLine=[orderLines objectForKey:key];
        //convert order line dictionary to object
        OrderLine* OL=[NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:self.addManagedObjectContext];
        OL.OrderLine=[NSNumber numberWithInt:lineNumber];
        OL.LocationIUR=OH.LocationIUR;
        OL.OrderNumber=OH.OrderNumber;
        OL.ProductIUR=[orderLine objectForKey:@"ProductIUR"];
        OL.OrderDate=OH.OrderDate;
        OL.UnitPrice=[orderLine objectForKey:@"UnitPrice"];
        OL.Bonus=[orderLine objectForKey:@"Bonus"];
        OL.Qty=[orderLine objectForKey:@"Qty"];
        OL.LineValue=[orderLine objectForKey:@"LineValue"];
        OL.DiscountPercent=[orderLine objectForKey:@"DiscountPercent"];
        OL.InStock = [orderLine objectForKey:@"InStock"];
        OL.FOC = [orderLine objectForKey:@"FOC"];
        OL.PPIUR = [orderLine objectForKey:@"RRIUR"];
        OL.Testers = [orderLine objectForKey:@"Testers"];
        //line to order header
        OL.orderheader=OH;
        
        //add to the set
        [orderLinesSet addObject:OL];
    }
    
    //call trans
    ArcosArrayOfCallTran* calltrans=[anOrder objectForKey:@"CallTrans"];
    if (calltrans !=nil) {
        NSMutableSet* callTransSet=[NSMutableSet set];

        for (ArcosCallTran* aCalltran in calltrans) {
            CallTran* CT=[NSEntityDescription insertNewObjectForEntityForName:@"CallTran" inManagedObjectContext:self.addManagedObjectContext];
            
            CT.Reference=aCalltran.Reference;
            CT.Score=[NSNumber numberWithInt: aCalltran.Score];
            CT.DetailLevelIUR=aCalltran.DetailLevel;
            CT.DetailIUR=[NSNumber numberWithInt:aCalltran.DetailIUR];
            CT.ProductIUR=[NSNumber numberWithInt:aCalltran.ProductIUR];
            CT.DTiur=[NSNumber numberWithInt:aCalltran.DTIUR];
            
            //link call tran to the oreder header
            CT.orderheader=OH;
            [callTransSet addObject:CT];
        }
        
        [OH addCalltrans:callTransSet];
    }
    
    
    //create Memo object
    Memo* MO=nil;
    if (memo!=nil&&![memo isEqualToString:@""]) {
        MO=[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.addManagedObjectContext];
        MO.Details=memo;
        MO.MTIUR=[memoType objectForKey:@"DescrDetailIUR"];
        MO.EmployeeIUR=OH.EmployeeIUR;
        MO.DateEntered=[NSDate date];
        MO.Subject=@"Order Memo";
        MO.LocationIUR=OH.LocationIUR;
        if (contact!=nil) {
            MO.ContactIUR=[contact objectForKey:@"IUR"];
        }else{
            MO.ContactIUR=[NSNumber numberWithInt:0];
        }
        //link to order header
        MO.orderheader=OH;
        OH.memo=MO;
        
    }
    
    //create Call object
    NSNumber* callTypeIUR=[callType objectForKey:@"DescrDetailIUR"];
//    NSDictionary* aDesc=[self descriptionWithIUR:callTypeIUR];
//    NSNumber* toggle1 = [aDesc objectForKey:@"Toggle1"];

    Call* CA=nil;
    CA=[NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:self.addManagedObjectContext];
    CA.ContactIUR=OH.ContactIUR;
    CA.CTiur=callTypeIUR;
    CA.CallDate=OH.OrderDate;
    CA.EmployeeIUR=OH.EmployeeIUR;
    CA.Latitude=OH.Latitude;
    CA.Longitude=OH.Longitude;
    CA.LocationIUR=OH.LocationIUR;
    
    //line to order header
    CA.orderheader=OH;
    OH.call=CA;
//    if (![toggle1 boolValue]) {//if not toggle then save
//        
//    }
    
    //link up the relationships
    [OH addOrderlines:orderLinesSet];
    //link memo and call
    if (MO!=nil&&CA!=nil) {
        MO.call=CA;
        CA.memo=MO;
    }

    
    [self saveContext:self.addManagedObjectContext];
    return YES;
}
-(BOOL)saveCall:(NSMutableDictionary*)aCall{
    // order header data
    NSMutableDictionary* orderHeader=[aCall objectForKey:@"OrderHeader"];
    NSMutableDictionary* callType=[orderHeader objectForKey:@"callType"];
    NSMutableDictionary* memoType=[orderHeader objectForKey:@"memoType"];
    NSMutableDictionary* contact=[orderHeader objectForKey:@"contact"];
    
    //memo
    NSString* memo=[aCall objectForKey:@"Memo"];
    //Employee IUR
    NSNumber* employeeIUR=[aCall objectForKey:@"EmployeeIUR"];
    //location
    NSNumber* locatinIUR=[aCall objectForKey:@"LocationIUR"];
    
    //check is the order header and order line valid
    if (orderHeader==nil) {
        return NO;
    }
    
    if (memo==nil||[memo isEqualToString:@""]) {
        return NO;
    }
    //create Memo object
    Memo* MO=nil;
    MO=[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.addManagedObjectContext];
    MO.Details=memo;
    MO.MTIUR=[memoType objectForKey:@"DescrDetailIUR"];
    MO.EmployeeIUR=employeeIUR;
    MO.DateEntered=[NSDate date];
    MO.Subject=@"Call Memo";
    MO.LocationIUR=locatinIUR;
    if (contact!=nil) {
        MO.ContactIUR=[contact objectForKey:@"IUR"];
    }else{
        MO.ContactIUR=[NSNumber numberWithInt:0];
    }
    
    //create Call object
    NSNumber* callTypeIUR=[callType objectForKey:@"DescrDetailIUR"];
    //NSDictionary* aDesc=[self descriptionWithIUR:callTypeIUR];
    //NSNumber* toggle1 = [aDesc objectForKey:@"Toggle1"];
    
    Call* CA=nil;
    //if (![toggle1 boolValue]) {//if not toggle then save
        CA=[NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:self.addManagedObjectContext];
        
        if (contact!=nil) {
            CA.ContactIUR=[contact objectForKey:@"IUR"];
        }else{
            CA.ContactIUR=[NSNumber numberWithInt:0];
        }
    
        CA.CTiur=callTypeIUR;
        CA.CallDate=[NSDate date];
        CA.EmployeeIUR=employeeIUR;
        CA.LocationIUR=locatinIUR;
        CA.Latitude=[orderHeader objectForKey:@"latitude"];
        CA.Longitude=[orderHeader objectForKey:@"longitude"];
        
    //}
    //link memo and call
    CA.memo=MO;
    MO.call=CA;
    
    //save to coredata
    [self saveContext:self.addManagedObjectContext];
    return YES;
}
#pragma mark setting
//setting
-(NSMutableDictionary*)getSetting{
    //load default setting. will be removed when setting tab is done
    [self loadDefaultSetting];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Setting" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
        
    }else{
        return nil;
    }
}
-(void)loadDefaultSetting{
    //check any setting
     NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Setting" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count]>0) {
        return;
    }
    
    //save default setting
    Setting* Setting=[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.addManagedObjectContext];
  //Bayer  
    Setting.WholesalerTypeIUR=[NSNumber numberWithInt:217];
    Setting.PendingOrderIUR=[NSNumber numberWithInt:229];
    Setting.OrderTypeIUR=[NSNumber numberWithInt:239];
    Setting.CallTypeIUR=[NSNumber numberWithInt:164];
    
    //Blackhall
//    Setting.WholesalerTypeIUR=[NSNumber numberWithInt:1248];
//    Setting.PendingOrderIUR=[NSNumber numberWithInt:322];
//    Setting.OrderTypeIUR=[NSNumber numberWithInt:332];
//    Setting.CallTypeIUR=[NSNumber numberWithInt:824];
    
    Setting.MemoTypeIUR=[NSNumber numberWithInt:228];
    Setting.NeedInactiveRecord=[NSNumber numberWithBool:NO];
    Setting.DefaultFormIUR=[NSNumber numberWithInt:8];
    Setting.DownloadServer=@"http://www.stratait.ie/downloads/";
    Setting.WebServiceServer=@"http://www.strataarcos.com/copydataservice/service.asmx";
    Setting.EmployeeIUR=[NSNumber numberWithInt:88888];
    Setting.NextOrderNumber=[NSNumber numberWithInt:1000];
    
    [self saveContext:self.addManagedObjectContext];

}
-(void)updateNextOrderNumber;{
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Setting" withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        Setting* setting=[objectsArray objectAtIndex:0];
        setting.NextOrderNumber=[NSNumber numberWithInt: [setting.NextOrderNumber intValue]+1]; 
        [self saveContext:self.fetchManagedObjectContext];
    }else{
        return;
    }
}
-(NSMutableArray*)settingSelectionWithType:(NSString*)type{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"DescrTypeCode=%@ and Active=1",type];
    
//    NSLog(@"start fecthing!!");
    
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Detail",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        if ([aDict objectForKey:@"Detail"]==nil) {
            [newDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [newDict setObject:[aDict objectForKey:@"Detail"] forKey:@"Title"];
        }        
        
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}
-(NSMutableArray*)settingOrderForms{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Details",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"Details",@"IUR", nil];
    
    
    //check need predicate or not
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"Active=1"];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[aDict objectForKey:@"IUR"] forKey:@"DescrDetailIUR"];
        [newDict setObject:[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Details"]] forKey:@"Detail"];

        if ([aDict objectForKey:@"Details"]==nil) {
            [newDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [newDict setObject:[aDict objectForKey:@"Details"] forKey:@"Title"];
        }        
        
        [newObjectsArray addObject:newDict];
    }
    
    return newObjectsArray;
}
-(NSMutableDictionary*)formWithIUR:(NSNumber*)anIUR{
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Details",nil];
    NSArray* properties=[NSArray arrayWithObjects:@"Details",@"IUR", nil];
    
    
    //check need predicate or not
    NSPredicate* predicate=nil;
    //NSNumber* needInactiveRecord=[[GlobalSharedClass shared].appSetting objectForKey:@"NeedInactiveRecord"];
    NSNumber* needInactiveRecord=[SettingManager DisplayInactiveRecord];
    
    if (![needInactiveRecord boolValue]) {
        predicate=[NSPredicate predicateWithFormat:@"Active=1 AND IUR=%d",[anIUR intValue]];
    }else{
        predicate=[NSPredicate predicateWithFormat:@"IUR=%d",[anIUR intValue]];
    }
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"FormDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray=[NSMutableArray array];
    
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[aDict objectForKey:@"IUR"] forKey:@"DescrDetailIUR"];
        [newDict setObject:[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Details"]] forKey:@"Detail"];
        
        if ([aDict objectForKey:@"Details"]==nil) {
            [newDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [newDict setObject:[aDict objectForKey:@"Details"] forKey:@"Title"];
        }        
        
        [newObjectsArray addObject:newDict];
    }
    
    if ([newObjectsArray count]>0) {
        return [newObjectsArray objectAtIndex:0];
        
    }else{
        return nil;
    }
}

#pragma mark Detailing
//detailing
-(NSMutableArray*)detailingQA{
    
    NSMutableArray* QAs=[NSMutableArray arrayWithArray:[self detailingQAProduct]];
    [QAs addObjectsFromArray:[self detailingQADesc]];
    
    return QAs;
    
}
-(NSMutableArray*)detailingQAProduct{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Active=1 AND FOrDetailing = %@",[NSNumber numberWithBool:YES]];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SamplesAvailable",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    //convert product to call tran object
    NSMutableArray* newObjectArray=[NSMutableArray array];
    
    if ([objectsArray count]>0) {
        for ( int i=0;i<[objectsArray count]; i++) {
            Product* aProduct=[objectsArray objectAtIndex:i];
            
            NSMutableDictionary* callTran=[NSMutableDictionary dictionary];
            [callTran setObject:aProduct.ProductIUR forKey:@"ProductIUR"];
            [callTran setObject:@"DT" forKey:@"DetailLevel"];
            [callTran setObject:aProduct.Description forKey:@"Label"];
            [newObjectArray addObject:callTran];
            
        }
        
    }
    return newObjectArray;
}
-(NSMutableArray*)detailingQADesc{
        
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Active=1 AND ForDetailing = %@ AND  (DescrTypeCode='L1' OR DescrTypeCode='L2' OR DescrTypeCode='L3' OR DescrTypeCode='L4' OR DescrTypeCode='L5') ",[NSNumber numberWithBool:YES]];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"ProfileOrder",nil];

    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    //convert product to call tran object
    NSMutableArray* newObjectArray=[NSMutableArray array];
    if ([objectsArray count]>0) {
        for ( int i=0;i<[objectsArray count]; i++) {
            DescrDetail* aDesc=[objectsArray objectAtIndex:i];
            
            NSMutableDictionary* callTran=[NSMutableDictionary dictionary];
            [callTran setObject:aDesc.DescrDetailIUR forKey:@"DescIUR"];
            [callTran setObject:@"DT" forKey:@"DetailLevel"];
            if (aDesc.Detail==nil) {
                [callTran setObject:@"" forKey:@"Label"];
            }else{
                [callTran setObject:aDesc.Detail forKey:@"Label"];
            }
            [callTran setObject:[ArcosUtils convertNilToEmpty:aDesc.DetailingFiles] forKey:@"DetailingFiles"];
            [callTran setObject:[ArcosUtils convertNilToEmpty:aDesc.DescrDetailCode] forKey:@"DescrDetailCode"];
            [newObjectArray addObject:callTran];
            
        }
    }
    return newObjectArray;
}
-(NSMutableArray*)detailingSamples{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Active=1 AND ForSampling = %@",[NSNumber numberWithBool:YES]];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"SamplesAvailable",nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    //convert product to call tran object
    NSMutableArray* newObjectArray=[NSMutableArray array];
    
    if ([objectsArray count]>0) {
        for ( int i=0;i<[objectsArray count]; i++) {
            Product* aProduct=[objectsArray objectAtIndex:i];
            
            NSMutableDictionary* callTran=[NSMutableDictionary dictionary];
            [callTran setObject:aProduct.ProductIUR forKey:@"IUR"];
            [callTran setObject:@"SM" forKey:@"DetailLevel"];
            [callTran setObject:aProduct.Description forKey:@"Label"];
            [newObjectArray addObject:callTran];
        }
        
    }
    return newObjectArray;
}
-(NSMutableArray*)batchsWithProductIUR:(NSNumber*)anIUR{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Active=1 AND ForSampling = %@ AND ProductIUR = %@",[NSNumber numberWithBool:YES],anIUR];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectArray=[NSMutableArray array];
    
    if ([objectsArray count]>0&&objectsArray!=nil) {
        Product* aProduct=[objectsArray objectAtIndex:0];
        NSString* batches=aProduct.Scoreprocedure;
        if (batches==nil) {//no batches
            batches=@"N/A";
        }
        NSArray* batchesArray=[batches componentsSeparatedByString:@","];
        NSLog(@"batches array for %@ %@ is %@",aProduct.Description,aProduct.ProductIUR,batchesArray);
        if ([batchesArray count]>0) {
            for(NSString* aBatch in batchesArray){
                NSMutableDictionary* aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:aBatch,@"Title",aBatch,@"Value",aProduct.ProductIUR,@"ProductIUR", nil];
                [newObjectArray addObject:aDict];
                
            }
        }
        return newObjectArray;
        
    }else{
        return nil;
    }

    
}

-(NSMutableArray*)detailingRNG{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Active=1 AND DescrTypeCode = %@",@"PI"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ProfileOrder", nil];
    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:YES]];
    
    //convert product to call tran object
    NSMutableArray* newObjectArray=[NSMutableArray array];
    if ([objectsArray count]>0) {
        for ( int i=0;i<[objectsArray count]; i++) {
            DescrDetail* aDesc=[objectsArray objectAtIndex:i];
            
            NSMutableDictionary* callTran=[NSMutableDictionary dictionary];
            [callTran setObject:aDesc.DescrDetailIUR forKey:@"IUR"];
            [callTran setObject:@"RG" forKey:@"DetailLevel"];
            if (aDesc.Detail==nil) {
                [callTran setObject:@"" forKey:@"Label"];
            }else{
                [callTran setObject:aDesc.Detail forKey:@"Label"];
            }
            [newObjectArray addObject:callTran];
            
        }
    }
    return newObjectArray;
}

- (void)clearTables{
    [self clearTableWithName:@"Location"];
    [self clearTableWithName:@"DescrDetail"];
    [self clearTableWithName:@"DescrType"];
    [self clearTableWithName:@"Contact"];
    [self clearTableWithName:@"ConLocLink"];
    [self clearTableWithName:@"Product"];
    [self clearTableWithName:@"File"];
    [self clearTableWithName:@"Image"];
    [self clearTableWithName:@"OrderLine"];
    [self clearTableWithName:@"OrderHeader"];
    [self clearTableWithName:@"FormRow"];
    [self clearTableWithName:@"FormDetail"];
    [self clearTableWithName:@"Contact"];
    [self clearTableWithName:@"ConLocLink"];
    [self clearTableWithName:@"DescrType"];
    [self clearTableWithName:@"Presenter"];
}
- (void)clearTableWithName:(NSString*)aName{
    
	NSManagedObjectContext *context = self.deleteManagedObjectContext;
	
	// Remove current Contents first
	
	NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity:[NSEntityDescription entityForName:aName inManagedObjectContext:context]];
	NSArray *result = [context executeFetchRequest:fetch error:nil];
	for (id item in result) {
		[context deleteObject:item];
//		NSLog(@"deleting %@ record from coredata",aName);
        [self saveContext:context];
        [context refreshObject:item mergeChanges:NO];
	}
//    [self saveContext:context];
	//[result release];
}
- (void)clearAllTables {
    NSArray* entityList = [self allEntities];
    for (int i = 0; i < [entityList count]; i++) {
        NSEntityDescription* entity = [entityList objectAtIndex:i];
        [self clearTableWithName:entity.name];
    }
}
- (void)updatePresenterWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [anIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        Presenter* presenter = [objectsArray objectAtIndex:0];
//        presenter.L5code = @"180";
        presenter.ProductIUR = [NSNumber numberWithInt:1252];
        [self saveContext:self.fetchManagedObjectContext];
    }
}

//load data from soap object
- (void)LoadDescriptionWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        DescrDetail* DescrDetail = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateDescrDetailWithSoapOB:anObject descrDetail:DescrDetail];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext *context = [self addManagedObjectContext];
        DescrDetail* DescrDetail = [NSEntityDescription insertNewObjectForEntityForName:@"DescrDetail" inManagedObjectContext:context];
        [self.arcosCoreDataManager populateDescrDetailWithSoapOB:anObject descrDetail:DescrDetail];
        
        [self saveContext:context];
    }
}
- (void)LoadDescrDetailWithFieldList:(NSArray*)aFieldList existingDescrDetailDict:(NSMutableDictionary*)anExistingDescrDetailDict {
    NSNumber* descrDetailIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    DescrDetail* aDescrDetail = [anExistingDescrDetailDict objectForKey:descrDetailIUR];
    if (aDescrDetail != nil) {
        [self.arcosCoreDataManager populateDescrDetailWithFieldList:aFieldList descrDetail:aDescrDetail];
//        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext *context = [self importManagedObjectContext];
        DescrDetail* DescrDetail = [NSEntityDescription
                            insertNewObjectForEntityForName:@"DescrDetail"
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateDescrDetailWithFieldList:aFieldList descrDetail:DescrDetail];
        
//        [self saveContext:self.addManagedObjectContext];
    }
}
- (void)LoadProductWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    // Remove current Contents first
    //[self clearTableWithName:@"Product"];
    
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR = %d", anObject.IUR];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"Product is existed.");
        Product* Product = [objectsArray objectAtIndex:0];        
        [self.arcosCoreDataManager populateProductWithSoapOB:anObject product:Product];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"Product is not existed.");
        NSManagedObjectContext *context = [self addManagedObjectContext];
        Product *Product = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Product" 
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateProductWithSoapOB:anObject product:Product];
//        NSLog(@"Write Product record to coredata");
        
        [self saveContext:self.addManagedObjectContext];
    }
}
- (void)LoadProductWithFieldList:(NSArray*)aFieldList existentProductDict:(NSMutableDictionary*)anExistentProductDict {
    NSNumber* productIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Product* aProduct = [anExistentProductDict objectForKey:productIUR];
    if (aProduct != nil) {
        [self.arcosCoreDataManager populateProductWithFieldList:aFieldList product:aProduct];
//        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSManagedObjectContext *context = [self addManagedObjectContext];
        NSManagedObjectContext *context = [self importManagedObjectContext];
        Product *Product = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Product"
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateProductWithFieldList:aFieldList product:Product];
        
//        [self saveContext:self.addManagedObjectContext];
    }
}
- (void)loadLocationProductMATWithFieldList:(NSArray*)aFieldList existingLocationProductMATDict:(NSMutableDictionary*)anExistingLocationProductMATDict levelIUR:(NSNumber*)aLevelIUR {
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %d and productIUR = %d", [[ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]] intValue], [[ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:1]] intValue]];
//    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil
//                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    NSString* combinationKey = [NSString stringWithFormat:@"%@->%@", [aFieldList objectAtIndex:0], [aFieldList objectAtIndex:1]];
    LocationProductMAT* anLocationProductMAT = [anExistingLocationProductMATDict objectForKey:combinationKey];
    if (anLocationProductMAT != nil) {
        [self.arcosCoreDataManager populateLocationProductMATWithFieldList:aFieldList locationProductMAT:anLocationProductMAT levelIUR:aLevelIUR];
//        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [self importManagedObjectContext];
        LocationProductMAT* locationProductMAT = [NSEntityDescription
                            insertNewObjectForEntityForName:@"LocationProductMAT"
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateLocationProductMATWithFieldList:aFieldList locationProductMAT:locationProductMAT levelIUR:aLevelIUR];
        
//        [self saveContext:self.addManagedObjectContext];
    }
}
- (BOOL)LoadLocationWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    // Remove current Contents first
    //[self clearTableWithName:@"Location"];
//    if ([[ArcosUtils convertStringToNumber:anObject.Field1] intValue] <=0) {
//        return NO;
//    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"Location is existed.");
        Location* Location = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateLocationWithSoapOB:anObject location:Location];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"Location is not existed.");
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Location* Location = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Location" 
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateLocationWithSoapOB:anObject location:Location];
//        NSLog(@"Write Location record to coredata");
        
        [self saveContext:self.addManagedObjectContext];
    }
    
    return  YES;     
}
- (void)LoadPackageWithFieldList:(NSArray*)aFieldList existingPackageDict:(NSMutableDictionary*)anExistingPackageDict {
    NSNumber* packageIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Package* aPackage = [anExistingPackageDict objectForKey:packageIUR];
    if (aPackage != nil) {
        [self.arcosCoreDataManager populatePackageWithFieldList:aFieldList package:aPackage];
    } else {
        NSManagedObjectContext* context = [self importManagedObjectContext];
        Package* Package = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Package"
                                  inManagedObjectContext:context];
        [self.arcosCoreDataManager populatePackageWithFieldList:aFieldList package:Package];
    }
}
- (void)LoadLocationWithFieldList:(NSArray*)aFieldList existingLocationDict:(NSMutableDictionary*)anExistingLocationDict {
    NSNumber* locationIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Location* anLocation = [anExistingLocationDict objectForKey:locationIUR];
    if (anLocation != nil) {
        [self.arcosCoreDataManager populateLocationWithFieldList:aFieldList location:anLocation];
//        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [self importManagedObjectContext];
        Location* Location = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Location"
                                  inManagedObjectContext:context];
        [self.arcosCoreDataManager populateLocationWithFieldList:aFieldList location:Location];
//        [self saveContext:self.addManagedObjectContext];
    }
}

- (void)LoadPriceWithFieldList:(NSArray*)aFieldList existingPriceDict:(NSMutableDictionary*)anExistingPriceDict existingPromotionDict:(NSMutableDictionary*)anExistingPromotionDict {
    NSNumber* priceIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    Price* aPrice = [anExistingPriceDict objectForKey:priceIUR];
    NSString* auxBonusDeal = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[aFieldList objectAtIndex:10]]];
    if (aPrice != nil) {
        if ([auxBonusDeal isEqualToString:@"DELETE"]) {
            NSManagedObjectContext* context = [self importManagedObjectContext];
            [context deleteObject:aPrice];
        } else {
            [self.arcosCoreDataManager populatePriceWithFieldList:aFieldList price:aPrice];
        }
    } else {
        if (![auxBonusDeal isEqualToString:@"DELETE"]) {
            NSManagedObjectContext* context = [self importManagedObjectContext];
            Price* Price = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Price"
                            inManagedObjectContext:context];
            [self.arcosCoreDataManager populatePriceWithFieldList:aFieldList price:Price];
        }
    }
    Promotion* aPromotion = [anExistingPromotionDict objectForKey:priceIUR];
    if (aPromotion != nil) {
        if ([auxBonusDeal isEqualToString:@"DELETE"]) {
            NSManagedObjectContext* context = [self importManagedObjectContext];
            [context deleteObject:aPromotion];
        } else {
            [self.arcosCoreDataManager populatePromotionWithFieldList:aFieldList promotion:aPromotion];
        }
    } else {
        if ([auxBonusDeal isEqualToString:@""]) {
            return;
        }
        if (![auxBonusDeal isEqualToString:@"DELETE"]) {
            NSManagedObjectContext* context = [self importManagedObjectContext];
            Promotion* Promotion = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Promotion"
                                    inManagedObjectContext:context];
            [self.arcosCoreDataManager populatePromotionWithFieldList:aFieldList promotion:Promotion];
        }        
    }
}

-(void)loadLocLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and FromLocationIUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field2] intValue], [[ArcosUtils convertStringToNumber:anObject.Field3] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        LocLocLink* LocLocLink = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateLocLocLinkWithSoapOB:anObject locLocLink:LocLocLink];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        LocLocLink* LocLocLink = [NSEntityDescription
                              insertNewObjectForEntityForName:@"LocLocLink"
                              inManagedObjectContext:context];
        [self.arcosCoreDataManager populateLocLocLinkWithSoapOB:anObject locLocLink:LocLocLink];
        [self saveContext:self.addManagedObjectContext];
    }
}
- (void)loadLocLocLinkWithFieldList:(NSArray*)aFieldList existingLocLocLinkDict:(NSMutableDictionary*)anExistingLocLocLinkDict {
    NSNumber* locLocLinkIUR = [ArcosUtils convertStringToNumber:[aFieldList objectAtIndex:0]];
    LocLocLink* anLocLocLink = [anExistingLocLocLinkDict objectForKey:locLocLinkIUR];
    if (anLocLocLink != nil) {
        [self.arcosCoreDataManager populateLocLocLinkWithFieldList:aFieldList locLocLink:anLocLocLink];
//        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [self importManagedObjectContext];
        LocLocLink* LocLocLink = [NSEntityDescription
                            insertNewObjectForEntityForName:@"LocLocLink"
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateLocLocLinkWithFieldList:aFieldList locLocLink:LocLocLink];
//        [self saveContext:self.addManagedObjectContext];
    }
}

-(void)loadFormDetailsWithSoapOB:(ArcosFormDetailBO*)anObject{
    NSManagedObjectContext *context = [self addManagedObjectContext];
    FormDetail *FormDetail = [NSEntityDescription
                                insertNewObjectForEntityForName:@"FormDetail" 
                                inManagedObjectContext:context];
    FormDetail.IUR  =   [NSNumber numberWithInt:anObject.iur];
    FormDetail.Details  =   [ArcosUtils convertNilToEmpty:anObject.Details];
    FormDetail.FormType  =   anObject.Type;
    FormDetail.DefaultDeliveryDate  =   anObject.DefaultDeliveryDate;
    FormDetail.Active=[NSNumber numberWithBool: anObject.Active];
    FormDetail.PrintDeliveryDocket = [ArcosUtils convertNumberToIntString:[NSNumber numberWithBool: anObject.PrintDeliveryDocket]];
    FormDetail.ShowSeperators = [NSNumber numberWithBool:anObject.ShowSeperators];
    FormDetail.ImageIUR = [NSNumber numberWithInt:anObject.Imageiur];
    FormDetail.FontSize = [NSNumber numberWithInt:anObject.FontSize];
    FormDetail.BackColor = [ArcosUtils convertNumberToIntString:[NSNumber numberWithDouble:anObject.BackColor]];
//    NSLog(@"Write Form detail  record to coredata");
    
    [self saveContext:context];
    if (!anObject.Active) {
        [self deleteFormDetailWithFormIUR:FormDetail.IUR];
        [self deleteFormRowWithFormIUR:FormDetail.IUR];
    }
}
-(void)loadFormRowWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"FormRow is existed.");
        FormRow* FormRow = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateFormRowWithSoapOB:anObject formRow:FormRow];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"FormRow is not existed.");
        NSManagedObjectContext* context = [self addManagedObjectContext];
        FormRow* FormRow = [NSEntityDescription
                            insertNewObjectForEntityForName:@"FormRow" 
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateFormRowWithSoapOB:anObject formRow:FormRow];
//        NSLog(@"Write FormRow record to coredata");
        [self saveContext:self.addManagedObjectContext];
    }
    
}

-(void)loadWholeSalerWithSoapOB:(ArcosWholeSalerBO*)anObject{
    
}
-(void)loadDescriptionTypeWithSoapOB:(ArcosDescrTypeBO*)anObject{
    NSManagedObjectContext *context = [self addManagedObjectContext];
    DescrType *DescrType = [NSEntityDescription
                        insertNewObjectForEntityForName:@"DescrType" 
                        inManagedObjectContext:context];
    
    DescrType.Active= [NSNumber numberWithBool:anObject.Active];
    DescrType.DescrTypeCode=[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.DescrTypeCode]];
    DescrType.Details=[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.Details]];
    DescrType.IUR=[NSNumber numberWithInt:anObject.iur];
    DescrType.ParentTypeCode=[NSNumber numberWithBool:[anObject.ParentTypeCode boolValue]];
    DescrType.Imageiur = [NSNumber numberWithInt:anObject.Imageiur];
//    NSLog(@"Write DescrType  record to coredata");
    
    [self saveContext:context];
}
-(void)loadContactWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"Contact is existed.");
        Contact* Contact = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateContactWithSoapOB:anObject contact:Contact];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"Contact is not existed.");
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Contact* Contact = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Contact" 
                              inManagedObjectContext:context];
        [self.arcosCoreDataManager populateContactWithSoapOB:anObject contact:Contact];
//        NSLog(@"Write Contact record to coredata");
        
        [self saveContext:self.addManagedObjectContext];
    }
    
}
-(void)loadConLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"ConLocLink" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"ConLocLink is existed.");
        ConLocLink* ConLocLink = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateConLocLinkWithSoapOB:anObject conLocLink:ConLocLink];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"ConLocLink is not existed.");
        NSManagedObjectContext* context = [self addManagedObjectContext];
        ConLocLink* ConLocLink = [NSEntityDescription
                            insertNewObjectForEntityForName:@"ConLocLink" 
                            inManagedObjectContext:context];
        [self.arcosCoreDataManager populateConLocLinkWithSoapOB:anObject conLocLink:ConLocLink];
//        NSLog(@"Write ConLocLink record to coredata");
        
        [self saveContext:self.addManagedObjectContext];
    }
    
}
-(void)loadPresenterWithSoapOB:(ArcosPresenter*)anObject{
    NSManagedObjectContext *context = [self addManagedObjectContext];
    Presenter *Presenter = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Presenter" 
                            inManagedObjectContext:context];


    Presenter.Active=[NSNumber numberWithBool:anObject.Active];
    Presenter.FileTypeIUR=[NSNumber numberWithInt:anObject.FileTypeIUR];
    Presenter.ImageIUR=[NSNumber numberWithInt:anObject.ImageIUR];
    Presenter.IUR=[NSNumber numberWithInt:anObject.IUR];
    Presenter.L1code=anObject.L1code;
    Presenter.L2code=anObject.L2code;
    Presenter.L3code=anObject.L3code;
    Presenter.L4code=anObject.L4code;
    Presenter.L5code=anObject.L5code;
    Presenter.LocationIUR=[NSNumber numberWithInt:anObject.LocationIUR];
    Presenter.Name=anObject.Name;
    Presenter.ProductIUR=[NSNumber numberWithInt:anObject.ProductIUR];
    Presenter.URL=anObject.URL;
    Presenter.Title=anObject.Title;
    Presenter.displaySequence=[NSNumber numberWithInt:anObject.DisplaySequence];
    Presenter.employeeIUR=[NSNumber numberWithInt:anObject.EmployeeIUR];
    Presenter.fullTitle=anObject.FullTitle;
    Presenter.memoDetails=anObject.MemoDetails;
    Presenter.parentIUR=[NSNumber numberWithInt:anObject.ParentIUR];
    Presenter.FormIUR = [NSNumber numberWithInt:anObject.FormIUR];
    Presenter.OrderLevel = [NSNumber numberWithInt:anObject.OrderLevel];
    Presenter.OnPromotion = [NSNumber numberWithBool:anObject.OnPromotion];
    Presenter.minimumSeconds = [NSNumber numberWithInt:anObject.MinimumSeconds];
//    NSLog(@"Write presenter  record to coredata");
    
    [self saveContext:self.addManagedObjectContext];
}
-(void)loadImageWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [[ArcosUtils convertStringToNumber:anObject.Field1] intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Image" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
//        NSLog(@"Image is existed.");
        Image* Image = [objectsArray objectAtIndex:0];
        [self.arcosCoreDataManager populateImageWithSoapOB:anObject image:Image];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
//        NSLog(@"Image is not existed.");
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Image* Image = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Image" 
                                  inManagedObjectContext:context];
        [self.arcosCoreDataManager populateImageWithSoapOB:anObject image:Image];
//        NSLog(@"Write Image record to coredata");
        
        [self saveContext:self.addManagedObjectContext];
    }
    
}
-(void)loadEmployeeWithSoapOB:(ArcosEmployeeBO*)anObject{
    NSManagedObjectContext *context = [self addManagedObjectContext];
    Employee* Employee  = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Employee" 
                          inManagedObjectContext:context];
    Employee.IUR    =   [NSNumber numberWithInt:anObject.iur];
    Employee.EmployeeCode    =   [ArcosUtils trim:[ArcosUtils convertNilToEmpty:anObject.EmployeeCode]];
    Employee.ETiur    =   [NSNumber numberWithInt:anObject.ETiur];
    Employee.Active    =   [NSNumber numberWithBool:anObject.Active];
    Employee.Surname    =   anObject.Surname;
    Employee.ForeName    =   anObject.Forename;
    Employee.HomeNumber    =   anObject.HomeNumber;
    Employee.MobileNumber    =   anObject.MobileNumber;
    Employee.Email    =   anObject.Email;
    Employee.AllowAdd    =   [NSNumber numberWithBool:anObject.AllowAdd];
    Employee.AllowWrite    =   [NSNumber numberWithBool:anObject.AllowWrite];
    Employee.AllowDelete    =   [NSNumber numberWithBool:anObject.AllowDelete];
    Employee.SYiur    =   [NSNumber numberWithInt:anObject.SYiur];
    Employee.UTiur    =   [NSNumber numberWithInt:anObject.UTiur];
    Employee.lastiur    =   [NSNumber numberWithInt:anObject.Lastiur];
    Employee.Callcost    =   anObject.CallCost;
    Employee.LastDialup    =   anObject.LastDialup;
    Employee.SecurityLevel    =   [NSNumber numberWithInt:anObject.SecurityLevel];
    Employee.OwnDataOnly    =  [NSNumber numberWithBool:anObject.AllowAdd];
    Employee.AllowWrite    =   [NSNumber numberWithBool:anObject.OwnDataOnly];
    Employee.ImageIUR    =   [NSNumber numberWithInt:anObject.Imageiur];
    Employee.WeeklyReport    =   [NSNumber numberWithBool:anObject.WeeklyReport];
    Employee.LastOrderNumber    =   [NSNumber numberWithInt:anObject.LastOrderNumber];
    Employee.FTiur    =   [NSNumber numberWithInt:anObject.FTiur];
    Employee.OTiur    =   [NSNumber numberWithInt:anObject.OTiur];
    Employee.Password    =   anObject.Password;
    Employee.CTiur    =   [NSNumber numberWithInt:anObject.CTiur];
    Employee.Loginname    =   anObject.LoginName;
    Employee.OUiur    =   [NSNumber numberWithInt:anObject.OUiur];
    Employee.LTiur    =   [NSNumber numberWithInt:anObject.LTiur];
    Employee.PasswordLastChanged    =   anObject.PassWordLastChanged;
    Employee.LocationLookup    =   [NSNumber numberWithInt:anObject.LocationLookup];
    Employee.JourneyStartDate    =   anObject.JourneyStartDate;
//    NSLog(@"Employee.JourneyStartDate is: %@",anObject.JourneyStartDate);
    Employee.MergeID    =   [NSNumber numberWithInt:anObject.MergeID];
    Employee.LastFormIURUsed    =   [NSNumber numberWithInt:anObject.iur];
    Employee.ForceProfiling    =   [NSNumber numberWithBool:anObject.ForceProfiling];
    Employee.UseLastForm    =   [NSNumber numberWithBool:anObject.UseLastForm];
    Employee.DefaultCustomerView    =   anObject.DefaultCustomerView;
    Employee.GetLocationSalesAnalysis    =   [NSNumber numberWithBool:anObject.GetLocationSalesAnalysis];
    Employee.DefaultDateType    =   [NSNumber numberWithInt:anObject.DefaultDateType];
    //Employee.Longitude    =   anObject.Longitude;
    //Employee.Latitude    =   anObject.Latitude;
    
//    NSLog(@"Write Employee  record to coredata");
    
    [self saveContext:self.addManagedObjectContext];

    
}
-(void)loadConfigWithSoapOB:(ArcosConfig*)anObject{
    NSManagedObjectContext *context = [self addManagedObjectContext];
    Config* Config  = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Config" 
                           inManagedObjectContext:context];
    
    Config.DefauleLTiur     =   [NSNumber numberWithInt: anObject.DefaultLTiur];
    Config.DefaultCTIUR     =   [NSNumber numberWithInt: anObject.DefaultCTiur];
    Config.DefaultCUiur = [NSNumber numberWithInt:anObject.DefaultCUiur];
    Config.DefaultDataSource     =   anObject.DefaultDataSource;
    Config.AskWholesaler     =   [NSNumber numberWithBool: anObject.AskWholesaler];
    Config.DefaultSTiur     =   [NSNumber numberWithInt: anObject.DefaultSTiur];
    Config.StandardLocationCode     =   anObject.StandardLocationCode;
    Config.InvoiceDataAvailable     =   [NSNumber numberWithBool: anObject.InvoiceDataAvailable];
    Config.UseTesters     =   [NSNumber numberWithBool: anObject.UseTesters];
    Config.UseFOC     =   [NSNumber numberWithBool: anObject.UseFOC];
    Config.UseBonus     =   [NSNumber numberWithBool: anObject.UseBonus];
    Config.ShowproductCode     =   [NSNumber numberWithBool: anObject.showproductcode];
    Config.ForceOrderType     =   [NSNumber numberWithBool: anObject.ForceOrderType];
    Config.allowstatuschange     =   [NSNumber numberWithBool: anObject.allowstatuschange];
    Config.DefaultCustomerView     =   anObject.DefaultCustomerView;
    Config.AllYytdTYytdTY     =   [NSNumber numberWithBool: anObject.AllLYytdTYytdTY];
    Config.ShowlocationCode     =   [NSNumber numberWithBool: anObject.ShowLocationCode];
    Config.PointsSystemInUse     =   [NSNumber numberWithBool: anObject.PointSystemInUse];
    Config.DayofWeekend = [NSNumber numberWithInt:anObject.DayOfWeekEnd];
    Config.AllowSplitPacks = [NSNumber numberWithBool:anObject.AllowSplitPacks];
    Config.SplitDeliveryDates = [NSNumber numberWithBool:anObject.SplitDeliveryDates];
    Config.DefaultWholesalerIUR = [NSNumber numberWithInt:anObject.DefaultWholesalerIUR];
    Config.DefaultProductLevel = [NSNumber numberWithInt:anObject.DefaultProductLevel];
    Config.SMSTexting = [NSNumber numberWithInt:anObject.SMSTexting];
    Config.BonusBlockedat = [NSNumber numberWithInt:anObject.BonusBlockedAt];
//    NSLog(@"Write Config  record to coredata");
    
    [self saveContext:context];
}
-(void)loadOrderWithSoapOB:(ArcosOrderHeaderBO*)anObject{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %d", anObject.OrderNumber];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        OrderHeader* OrderHeader = [objectArray objectAtIndex:0];
        [self.arcosCoreDataManager populateOrderWithSoapOB:anObject orderHeader:OrderHeader];
        [self saveContext:self.fetchManagedObjectContext];
    } else {
        //create order header
        NSManagedObjectContext *context = [self addManagedObjectContext];
        OrderHeader *OrderHeader = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"OrderHeader"
                                    inManagedObjectContext:context];
        
        OrderHeader.OrderHeaderIUR  =   [NSNumber numberWithInt:anObject.IUR];
        OrderHeader.OrderNumber     =   [NSNumber numberWithInt:anObject.OrderNumber];
        OrderHeader.CallIUR     =   [NSNumber numberWithInt:anObject.CallIUR];
        OrderHeader.OTiur   =   [NSNumber numberWithInt:anObject.OTIUR];
        OrderHeader.PromotionIUR    =   [NSNumber numberWithInt:anObject.PromotionIUR];
        //OrderHeader.DocketIUR   =   [NSNumber numberWithInt:anObject.DocketIUR];
        OrderHeader.DocketIUR   =   [NSNumber numberWithInt:-1];
        OrderHeader.OrderDate   =   [ArcosUtils addHours:1 date:anObject.OrderDate];
        OrderHeader.EnteredDate =   anObject.EnteredDate;
        OrderHeader.CallDuration    =   [NSNumber numberWithDouble:anObject.CallDuration];
        OrderHeader.DeliveryDate    =   [ArcosUtils addHours:1 date:anObject.DeliveryDate];
        OrderHeader.OSiur   =   [NSNumber numberWithInt:anObject.OSIUR];
        OrderHeader.LocationIUR =   [NSNumber numberWithInt:anObject.LocationIUR];
        OrderHeader.ContactIUR  =   [NSNumber numberWithInt:anObject.ContactIUR];
        OrderHeader.LocationCode    =   anObject.LocationCode;
        OrderHeader.MemoIUR =   [NSNumber numberWithInt:anObject.MemoIUR];
        OrderHeader.FormIUR =   [NSNumber numberWithInt:anObject.FormIUR];
        OrderHeader.EmployeeIUR =   [NSNumber numberWithInt:anObject.EmployeeIUR];
        OrderHeader.TotalGoods  =   anObject.TotalGoods;
        OrderHeader.TotalVat    =   anObject.TotalVAT;
        OrderHeader.TotalQty    =   [NSNumber numberWithInt:anObject.TotalQTY];
        OrderHeader.TotalBonus  =   [NSNumber numberWithInt:anObject.TotalBonus];
        OrderHeader.ExchangeRate    =   anObject.ExchangeRate;
        OrderHeader.TotalBonusValue =   anObject.TotalBonusValue;
        OrderHeader.TotalFOC    =   [NSNumber numberWithInt:anObject.TotalFOC];
        OrderHeader.CallCost    =   anObject.CallCost;
        OrderHeader.DSiur   =   [NSNumber numberWithInt:anObject.DSIUR];
        OrderHeader.InvoiseRef  =   [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.InvoiceRef]];
        OrderHeader.WholesaleIUR=[NSNumber numberWithInt: anObject.WholesaleIUR];
        OrderHeader.CustomerRef = anObject.CustomerRef;
        OrderHeader.Latitude = anObject.Latitude;
        OrderHeader.Longitude = anObject.Longitude;
        OrderHeader.DeliveryInstructions1 = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.DeliveryInstructions1]];
        OrderHeader.DeliveryInstructions2 = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:anObject.DeliveryInstructions2]];
        
    //    NSLog(@"Write OrderHeader  record to coredata");
        
        //add order lines
        if ([anObject.Lines count]>0) {//has order lines
            NSMutableSet* orderLinesSet=[NSMutableSet set];
    //        NSLog(@"%d order lines back",[anObject.Lines count]);
            int linenumber=0;
            for (ArcosOrderLineBO* orderLine in anObject.Lines) {
                linenumber++;
    //            NSLog(@"order line save is %@",orderLine);
                //convert order line dictionary to object
                OrderLine* OL=[NSEntityDescription insertNewObjectForEntityForName:@"OrderLine" inManagedObjectContext:self.addManagedObjectContext];
                OL.OrderLine=[NSNumber numberWithInt:orderLine.OrderLine];
                OL.LocationIUR=OrderHeader.LocationIUR;
                OL.OrderNumber=OrderHeader.OrderNumber;
                OL.ProductIUR=[NSNumber numberWithInt:orderLine.ProductIUR];
                OL.OrderDate=OrderHeader.OrderDate;
                OL.UnitPrice=orderLine.UnitPrice ;
                OL.Bonus=[NSNumber numberWithInt:orderLine.Bonus];
                OL.Qty=[NSNumber numberWithInt:orderLine.Qty];
                OL.LineValue=orderLine.LineValue;
                OL.DiscountPercent=orderLine.DiscountPercent;
                OL.RebatePercent = orderLine.RebatePercent;
                OL.Points = [NSNumber numberWithInt:orderLine.Points];
                OL.NetRevenue = orderLine.NetRevenue;
                OL.DeliveryDate = orderLine.DeliveryDate;
                OL.TradeValue = orderLine.TradeValue;
                OL.InStock = [NSNumber numberWithInt:orderLine.InStock];
                OL.FOC = [NSNumber numberWithInt:orderLine.FOC];
                
                //line to order header
                OL.orderheader=OrderHeader;
                
                //add to the set
                [orderLinesSet addObject:OL];
            }
            OrderHeader.NumberOflines=[NSNumber numberWithInt:linenumber];
            [OrderHeader addOrderlines:orderLinesSet];
            
        }
        //add memo
        ArcosMemoBO* memoBO=anObject.Memo;
        if (memoBO != nil && memoBO.Details != nil && ![@"" isEqualToString:memoBO.Details]) {
            Memo* MO=[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];
            MO.Details=memoBO.Details;
            MO.MTIUR=[NSNumber numberWithInt: memoBO.MTiur];
            MO.EmployeeIUR=[NSNumber numberWithInt: memoBO.Employeeiur];
            MO.DateEntered=memoBO.DateEntered;
            MO.Subject=memoBO.Subject;
            MO.LocationIUR=[NSNumber numberWithInt: memoBO.Locationiur];
            MO.ContactIUR=[NSNumber numberWithInt: memoBO.Contactiur];
            //link to order header
            MO.orderheader=OrderHeader;
            OrderHeader.memo=MO;
        }
        
        [self saveContext:context];
    }
    
}

-(void)loadCallWithSoapOB:(ArcosCallBO*)anObject {
    //create order header
    NSManagedObjectContext* context = [self addManagedObjectContext];
    OrderHeader* orderHeader = [NSEntityDescription
                                insertNewObjectForEntityForName:@"OrderHeader" 
                                inManagedObjectContext:context];
    
    orderHeader.OrderHeaderIUR  =   [NSNumber numberWithInt:anObject.iur];
    orderHeader.OrderNumber     =   [NSNumber numberWithInt:anObject.iur];
//    OrderHeader.CallIUR     =   [NSNumber numberWithInt:anObject.CallIUR];
//    OrderHeader.OTiur   =   [NSNumber numberWithInt:anObject.OTIUR];
//    OrderHeader.PromotionIUR    =   [NSNumber numberWithInt:anObject.PromotionIUR];
    //OrderHeader.DocketIUR   =   [NSNumber numberWithInt:anObject.DocketIUR];
    orderHeader.DocketIUR   =   [NSNumber numberWithInt:-1];
    orderHeader.OrderDate   =   [ArcosUtils addHours:1 date:anObject.CallDate];
    orderHeader.EnteredDate =   [ArcosUtils addHours:1 date:anObject.CallDate];
//    OrderHeader.CallDuration    =   [NSNumber numberWithDouble:anObject.CallDuration];
    orderHeader.DeliveryDate    =   [ArcosUtils addHours:1 date:anObject.CallDate];
//    OrderHeader.OSiur   =   [NSNumber numberWithInt:anObject.OSIUR];
    orderHeader.LocationIUR =   [NSNumber numberWithInt:anObject.LocationIUR];
    orderHeader.ContactIUR  =   [NSNumber numberWithInt:anObject.ContactIUR];
//    OrderHeader.LocationCode    =   anObject.LocationCode;
//    OrderHeader.MemoIUR =   [NSNumber numberWithInt:anObject.MemoIUR];
//    OrderHeader.FormIUR =   [NSNumber numberWithInt:anObject.FormIUR];
    orderHeader.EmployeeIUR =   [NSNumber numberWithInt:anObject.EmployeeIUR];
//    OrderHeader.TotalGoods  =   [NSDecimalNumber numberWithInt:0];
//    OrderHeader.TotalVat    =   anObject.TotalVAT;
//    OrderHeader.TotalQty    =   [NSNumber numberWithInt:anObject.TotalQTY];
//    OrderHeader.TotalBonus  =   [NSNumber numberWithInt:anObject.TotalBonus];
//    OrderHeader.ExchangeRate    =   anObject.ExchangeRate;
//    OrderHeader.TotalBonusValue =   anObject.TotalBonusValue;
//    OrderHeader.TotalFOC    =   [NSNumber numberWithInt:anObject.TotalFOC];
    orderHeader.CallCost    =   [[[NSDecimalNumber alloc] initWithDecimal:[anObject.CallCost decimalValue]] autorelease];
//    OrderHeader.DSiur   =   [NSNumber numberWithInt:anObject.DSIUR];
//    OrderHeader.InvoiseRef  =   anObject.InvoiceRef;
//    OrderHeader.WholesaleIUR=[NSNumber numberWithInt: anObject.WholesaleIUR];
    orderHeader.NumberOflines = [NSNumber numberWithInt:0];
    orderHeader.Latitude = [NSNumber numberWithDouble:[anObject.Latitude doubleValue]];
    orderHeader.Longitude = [NSNumber numberWithDouble:[anObject.Longitude doubleValue]];
    //create Call object
    /*
    NSDictionary* aDesc = [self descriptionWithIUR:[NSNumber numberWithInt:anObject.CTIUR]];
    NSNumber* toggle1 = [aDesc objectForKey:@"Toggle1"];
    
    
    Call* CA = nil;
    if (![toggle1 boolValue]) {//if not toggle then save the call
        
    }
    */
    Call* CA = [NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:context];
    CA.ContactIUR = [NSNumber numberWithInt:anObject.ContactIUR];
    CA.CTiur = [NSNumber numberWithInt:anObject.CTIUR];
    CA.CallDate = [ArcosUtils addHours:0 date:anObject.CallDate];
    CA.EmployeeIUR = [NSNumber numberWithInt:anObject.EmployeeIUR];
    CA.Latitude= [NSNumber numberWithDouble:[anObject.Latitude doubleValue]];
    CA.Longitude= [NSNumber numberWithDouble:[anObject.Longitude doubleValue]];
    CA.LocationIUR= [NSNumber numberWithInt:anObject.LocationIUR];
    CA.ReceptionLevelIUR = [NSNumber numberWithInt:anObject.ReceptionLevelIUR];
    //line to order header
    CA.orderheader = orderHeader;
    orderHeader.call = CA;
    
    //add call trans
    if ([anObject.CallTrans count]>0) {//has call trans
        //Add new calltrans
        NSMutableSet* newCallTransSet = [NSMutableSet set];
        
        for (ArcosCallTran* aCalltran in anObject.CallTrans) {
            CallTran* CT = [NSEntityDescription insertNewObjectForEntityForName:@"CallTran" inManagedObjectContext:context];
            
            CT.Reference = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:aCalltran.Reference]];
            CT.Score = [NSNumber numberWithInt: aCalltran.Score];
            CT.DetailLevelIUR = [ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:aCalltran.DetailLevel]];
            CT.DetailIUR = [NSNumber numberWithInt:aCalltran.DetailIUR];
            CT.ProductIUR = [NSNumber numberWithInt:aCalltran.ProductIUR];
            CT.DTiur = [NSNumber numberWithInt:aCalltran.DTIUR];
            
            //link call tran to the oreder header
            CT.orderheader = orderHeader;
            
            [newCallTransSet addObject:CT];
        }
        
        [orderHeader addCalltrans:newCallTransSet];
    }
    //add memo
    if ([anObject.Memos count] > 0) {
        for (ArcosMemoBO* memoBO in anObject.Memos) {
            Memo* MO = [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];
            MO.Details = [NSString stringWithFormat:@"%@",[ArcosUtils convertNilToEmpty:memoBO.Details]];
            MO.MTIUR = [NSNumber numberWithInt: memoBO.MTiur];
            MO.EmployeeIUR = [NSNumber numberWithInt: memoBO.Employeeiur];
            MO.DateEntered = [ArcosUtils addHours:0 date:memoBO.DateEntered];
            MO.LocationIUR = [NSNumber numberWithInt: memoBO.Locationiur];
            MO.ContactIUR = [NSNumber numberWithInt: memoBO.Contactiur];
            orderHeader.MemoIUR = [NSNumber numberWithInt:memoBO.iur];
            //link to order header
            MO.orderheader = orderHeader;
            orderHeader.memo = MO;
        }
    }    
    
    [self saveContext:context];
}

-(void)loadResponseWithSoapOB:(ArcosResponseBO*)anObject {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", anObject.Iur];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] == 0) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Response* Response = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Response"
                              inManagedObjectContext:context];
        [self.arcosCoreDataManager populateResponseWithSoapOB:anObject response:Response];
        [self saveContext:self.addManagedObjectContext];
    }
}

-(void)loadSurveyWithSoapOB:(ArcosSurveyBO*)anObject {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    Survey* survey = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Survey" 
                      inManagedObjectContext:context];
    survey.IUR = [NSNumber numberWithInt:anObject.IUR];
    survey.SurveyTargetGroup = anObject.SurveyTargetGroup;
    survey.SurveyTargetTypes = anObject.SurveyTargetTypes;
    survey.Narrative = [ArcosUtils trim:anObject.Narrative];
    survey.StartDate = anObject.StartDate;
    survey.EndDate = anObject.EndDate;
    survey.UseorderPad = [NSNumber numberWithBool:anObject.UseOrderPad];
    survey.Title = [ArcosUtils trim:anObject.Title];
    
    //the process for Question table
    ArcosArrayOfQuestionBO* arcosArrayOfQuestionBO = (ArcosArrayOfQuestionBO*)[anObject Questions];
    for (ArcosQuestionBO* arcosQuestionBO in arcosArrayOfQuestionBO) {
        Question* question = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Question" 
                          inManagedObjectContext:context];
        question.IUR = [NSNumber numberWithInt:arcosQuestionBO.IUR];
        question.SurveyIUR = [NSNumber numberWithInt:arcosQuestionBO.SurveyIUR];
        question.Sequence = [NSNumber numberWithInt:arcosQuestionBO.Sequence];
        question.Narrative = [ArcosUtils trim:arcosQuestionBO.Narrative];
        question.QuestionType = [NSNumber numberWithInt:arcosQuestionBO.QuestionType];
        question.ViewAs = [NSNumber numberWithInt:arcosQuestionBO.ViewAs];
        question.tooltip = arcosQuestionBO.Tooltip;
        question.ProductIUR = [NSNumber numberWithInt:arcosQuestionBO.Weighting];
        question.sectionNo = [NSNumber numberWithInt:arcosQuestionBO.SectionNo];
        question.ResponseLimits = [ArcosUtils trim:arcosQuestionBO.ResponseLimits];
        question.active = [NSNumber numberWithBool:arcosQuestionBO.Active];
    }
    [self saveContext:context];
}

-(void)loadJourneyWithSoapOB:(ArcosJourneyBO*)anObject {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    Journey* journey = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Journey" 
                      inManagedObjectContext:context];
    journey.IUR = [NSNumber numberWithInt:anObject.Iur];
    journey.EmployeeIUR = [NSNumber numberWithInt:anObject.EmployeeIUR];
    journey.WeekNumber = [NSNumber numberWithInt:anObject.WeekNumber];
    journey.DayNumber = [NSNumber numberWithInt:anObject.DayNumber];
    journey.CallNumber = [NSNumber numberWithInt:anObject.CallNumber];
    journey.LocationIUR = [NSNumber numberWithInt:anObject.LocationIUR];
    journey.ContactIUR = [NSNumber numberWithInt:anObject.ContactIUR];
    journey.ActualCalldate = [ArcosUtils addHours:0 date:anObject.ActualCallDate];
    
    [self saveContext:context];
}

//usefull utilitiese
-(NSString*)fullAddressWith:(NSMutableDictionary*)aLocation{
    NSString* LocationAddress=@"";
    if (![[aLocation objectForKey:@"Address1"] isEqualToString:@""]&&[aLocation objectForKey:@"Address1"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address1"]];
    }
    if (![[aLocation objectForKey:@"Address2"] isEqualToString:@""]&&[aLocation objectForKey:@"Address2"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address2"]];
    }
    if (![[aLocation objectForKey:@"Address3"] isEqualToString:@""]&&[aLocation objectForKey:@"Address3"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address3"]];
    }
    if (![[aLocation objectForKey:@"Address4"] isEqualToString:@""]&&[aLocation objectForKey:@"Address4"]!=nil) {
        LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address4"]];
    }
    if (![[aLocation objectForKey:@"Address5"] isEqualToString:@""]&&[aLocation objectForKey:@"Address5"]!=nil) {
        //LocationAddress=[LocationAddress stringByAppendingFormat:@" %@",[aLocation objectForKey:@"Address5"]];
    }
    return LocationAddress;
    
}

//employee
#pragma mark employee
-(NSDictionary*)employeeWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d ",[anIUR intValue]];    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Employee" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
    
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];        
    }else{
        return nil;
    }    
}

-(NSMutableArray*)employeeWithIURList:(NSMutableArray*)anIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR in %@ ",anIURList];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Employee" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count] > 0) {
        return objectsArray;
    }else{
        return nil;
    }
}

-(NSMutableArray*)allEmployee {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ForeName",nil];    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1 and IUR != 0"];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Employee" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];        
    
    NSMutableArray* resultObjectsArray = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"ForeName"]],[ArcosUtils convertNilToEmpty:[aDict objectForKey:@"Surname"]] ] forKey:@"Title"];
        [resultObjectsArray addObject:newDict];
    }
    return resultObjectsArray;
}

-(void)editEmployeeWithIUR:(NSNumber*)anIUR journeyStartDate:(NSDate*)aDate {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %@", anIUR];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Employee" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    for (Employee* employee in objectsArray) {
        employee.JourneyStartDate = aDate;
        [self saveContext:self.fetchManagedObjectContext];
    }
}

//contact
#pragma mark contact
-(void)contactWithDataList:(NSMutableArray*)aFieldValueList contactIUR:(NSNumber*)aContactIUR titleTypeIUR:(NSNumber*)aTitleTypeIUR contactTypeIUR:(NSNumber*)aContactTypeIUR locationIUR:(NSNumber*)aLocationIUR {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    Contact* contact = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Contact" 
                        inManagedObjectContext:context];    
    contact.CLiur = [ArcosUtils convertStringToNumber:[aFieldValueList objectAtIndex:0]];
    contact.Forename = [aFieldValueList objectAtIndex:1];
    contact.Surname = [aFieldValueList objectAtIndex:2];
    contact.PhoneNumber = [aFieldValueList objectAtIndex:3];
    contact.MobileNumber = [aFieldValueList objectAtIndex:4];
    contact.Email = [aFieldValueList objectAtIndex:5];
    contact.COiur = [ArcosUtils convertStringToNumber:[aFieldValueList objectAtIndex:6]];
    contact.IUR = aContactIUR;
    [self saveContext:self.addManagedObjectContext];
}

-(void)conLocLinkWithIUR:(NSNumber*)anIUR contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    ConLocLink* conLocLink = [NSEntityDescription
                        insertNewObjectForEntityForName:@"ConLocLink" 
                        inManagedObjectContext:context];    
    conLocLink.IUR = anIUR;
    conLocLink.ContactIUR = aContactIUR;
    conLocLink.LocationIUR = aLocationIUR;
    [self saveContext:self.addManagedObjectContext];
}

- (void)updateContactWithFieldName:(NSString*)aFieldName withActualContent:(id)anActualContent withContactIUR:(NSNumber*)aContactIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d",[aContactIUR intValue]];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];    
    NSString *propertyType = @"";
    for (Contact* obj in objectsArray) {
        NSDictionary* propsDict = [PropertyUtils classPropsFor:[obj class]];
        //        NSLog(@"%@", propsDict);
        NSArray* allKeyList = [propsDict allKeys];
        bool isFound = false;
        for (int i = 0; i < [allKeyList count]; i++) {
            NSString* aKey = [allKeyList objectAtIndex:i];
            if ([aKey caseInsensitiveCompare:aFieldName] == NSOrderedSame)  {
                aFieldName = aKey;
                propertyType = [propsDict objectForKey:aKey];
                isFound = true;
                break;
            }
        }
        if (!isFound) {
            NSLog(@"Core Data field name is incompatible with the one in the server.");
            return;
        }
        NSString* methodName = [NSString stringWithFormat:@"set%@:", aFieldName];
//        NSLog(@"methodName is %@, %@", propertyType, methodName);
        SEL selector = NSSelectorFromString(methodName);
        
        if ([propertyType isEqualToString:@"NSNumber"]) {
            [obj performSelector:selector withObject:[NSNumber numberWithInt:[anActualContent intValue]]];            
        } else if ([propertyType isEqualToString:@"NSString"]) {
            [obj performSelector:selector withObject:[NSString stringWithFormat:@"%@", anActualContent]];
        }        
        [self saveContext:self.fetchManagedObjectContext];
    }
}

- (void)contactWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR {
    NSManagedObjectContext* context = [self addManagedObjectContext];
    Contact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    
    NSDictionary* propsDict = [PropertyUtils classPropsFor:[contact class]];
    
    //    NSLog(@"propsDict is %@", propsDict);
    for (int i = 0; i < [aFieldNameList count]; i++) {
        NSString* aFieldName = [aFieldNameList objectAtIndex:i];
        NSString* aFieldValue = [aFieldValueList objectAtIndex:i];
        [PropertyUtils updateRecord:contact fieldName:aFieldName fieldValue:aFieldValue propDict:propsDict];        
    }    
    contact.IUR = anIUR;
    
    [self saveContext:self.addManagedObjectContext];
}
- (NSMutableArray*)contactLocationWithCOIUR:(NSNumber*)aCOIUR {
    NSPredicate* predicate = nil;
    NSNumber* needInactiveRecord = [SettingManager DisplayInactiveRecord];
//    NSArray* sortDescNames = nil;//[NSArray arrayWithObjects:@"Surname",nil];
    
    
    if (![needInactiveRecord boolValue]) {
        if ([aCOIUR intValue] == -1) {
            predicate = [NSPredicate predicateWithFormat:@"Active=1", [aCOIUR intValue]];
        } else{   
            predicate = [NSPredicate predicateWithFormat:@"COiur=%d and Active=1", [aCOIUR intValue]];
        }
    }else{
        if ([aCOIUR intValue] == -1) {
            
        } else {
            predicate = [NSPredicate predicateWithFormat:@"COiur=%d", [aCOIUR intValue]];
        }        
    }
    return [self contactLocationWithPredicate:predicate];
}

- (NSMutableArray*)contactLocationWithPredicate:(NSPredicate*)aPredicate {
    NSArray* properties = [NSArray arrayWithObjects:@"Forename",@"Surname",@"IUR",@"cP09",@"cP10",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:properties  withPredicate:aPredicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableArray* contactLocationObjectsArray = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    if ([objectsArray count] > 0) {
        NSMutableArray* contactIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
        NSMutableDictionary* contactDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectsArray count]];
        for (NSDictionary* aContactDict in objectsArray) {
            [contactIURList addObject:[aContactDict objectForKey:@"IUR"]];
            [contactDictHashMap setObject:aContactDict forKey:[aContactDict objectForKey:@"IUR"]];
        }
        NSMutableArray* conlocLinkObjectsArray = [self conlocLinksWithContactIURList:contactIURList];
        NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[conlocLinkObjectsArray count]];
        NSMutableDictionary* tmpLocationIURDict = [NSMutableDictionary dictionaryWithCapacity:[conlocLinkObjectsArray count]];
        if ([conlocLinkObjectsArray count] > 0) {
            for (NSDictionary* aConlocLinkDict in conlocLinkObjectsArray) {
                //                [locationIURList addObject:[aConlocLinkDict objectForKey:@"LocationIUR"]];
                [tmpLocationIURDict setObject:[NSNull null] forKey:[aConlocLinkDict objectForKey:@"LocationIUR"]];
            }
            locationIURList = [NSMutableArray arrayWithArray:[tmpLocationIURDict allKeys]];
            NSMutableArray* locationObjectsArray = [self locationsWithIURList:locationIURList];
            NSMutableDictionary* locationDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[locationObjectsArray count]];
            if ([locationObjectsArray count] > 0) {
                for (NSDictionary* aLocationDict in locationObjectsArray) {
                    [locationDictHashMap setObject:aLocationDict forKey:[aLocationDict objectForKey:@"LocationIUR"]];
                }
                //finish data preparation
                for (NSDictionary* aConlocLinkDict in conlocLinkObjectsArray) {
                    NSNumber* contactIUR = [aConlocLinkDict objectForKey:@"ContactIUR"];
                    NSNumber* locationIUR = [aConlocLinkDict objectForKey:@"LocationIUR"];
                    NSDictionary* locationDict = [locationDictHashMap objectForKey:locationIUR];
                    if (locationDict == nil) {
                        continue;
                    }
                    NSDictionary* contactDict = [contactDictHashMap objectForKey:contactIUR];
                    NSMutableDictionary* contactLocationDict = [NSMutableDictionary dictionaryWithDictionary:locationDict];
                    [contactLocationDict setObject:[NSString stringWithFormat:@"%@",[ArcosUtils convertNilToEmpty:[contactLocationDict objectForKey:@"Name"]]] forKey:@"LocationName"];
                    
                    NSString* surname = [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Surname"]];
                    NSString* forename = [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Forename"]];
                    NSString* name = [NSString stringWithFormat:@"%@ %@",[NSString stringWithString:forename],[NSString stringWithString:surname]];
                    if (surname.length == 0) {
                        surname = @" ";
                    }
                    
                    [contactLocationDict setObject:name forKey:@"Name"];
                    [contactLocationDict setObject:name forKey:@"SortKey"];
                    [contactLocationDict setObject:[contactDict objectForKey:@"IUR"] forKey:@"ContactIUR"];
                    [contactLocationDict setObject:surname forKey:@"Surname"];
                    [contactLocationDict setObject:[ArcosUtils convertNilToZero:[contactDict objectForKey:@"cP09"]] forKey:@"cP09"];
                    [contactLocationDict setObject:[ArcosUtils convertNilToZero:[contactDict objectForKey:@"cP10"]] forKey:@"cP10"];
                    [contactLocationObjectsArray addObject:contactLocationDict];
                }
            }
        }
        return contactLocationObjectsArray;
    }
    return nil;
}
//config
#pragma mark config
-(NSDictionary*)configWithIUR:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d ",[anIUR intValue]];    
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Config" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
    
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];        
    }else{
        return nil;
    }
}

//survey
#pragma mark survey
-(NSMutableArray*)allSurvey {
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString* todayStr = [NSString stringWithFormat:@"%@ 00:00:00", [dateFormatter stringFromDate:[NSDate date]]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* endOfToday = [ArcosUtils endOfDay:[NSDate date]];
//    NSDate* today = [dateFormatter dateFromString:todayStr];
    NSDate* beginOfToday = [ArcosUtils beginOfDay:[NSDate date]];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"StartDate",nil];
    
    //using fetch with context
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(StartDate <= %@) AND (EndDate >= %@) and IUR != 0",endOfToday , beginOfToday];
    
    NSMutableArray* objectsArray = 
    [self fetchRecordsWithEntity:@"Survey" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
//    [dateFormatter release];
    return objectsArray;
}

-(NSMutableArray*)questionWithSurveyIUR:(NSNumber*)anIUR {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"sectionNo",@"Sequence",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SurveyIUR = %d ",[anIUR intValue]];    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Question" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    NSMutableArray* newObjectsArray = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary* aDict in objectsArray) {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:@"" forKey:@"Answer"];
        [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"Highlight"];
        [newObjectsArray addObject:newDict];
    }
    return newObjectsArray;
}

-(void)insertResponseWithDataList:(NSMutableDictionary*)aQuestionDict originalDataDict:(NSMutableDictionary*)anOriginalQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR unsendOnly:(BOOL)anUnsendOnlyFlag {
    //check whether it exists or not
    NSMutableArray* predicateList = [NSMutableArray arrayWithCapacity:2];
    [predicateList addObject:[NSPredicate predicateWithFormat:@"LocationIUR = %d and SurveyIUR = %d and ContactIUR = %d and QuestionIUR = %d", [aLocationIUR intValue], [[aQuestionDict objectForKey:@"SurveyIUR"] intValue], [aContactIUR intValue], [[aQuestionDict objectForKey:@"IUR"] intValue]]];
    if (anUnsendOnlyFlag) {
        NSDate* auxDate = [NSDate date];
        [predicateList addObject:[NSPredicate predicateWithFormat:@"IUR = 0 or (IUR != 0 and ResponseDate >= %@ and ResponseDate <= %@)", [ArcosUtils beginOfDay:auxDate], [ArcosUtils endOfDay:auxDate]]];
    }
    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ResponseDate",nil];
    NSString* auxAnswer = [aQuestionDict objectForKey:@"Answer"];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil 
                   withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count] > 0) {
        Response* anExistResponse = [objectsArray objectAtIndex:0];
        anExistResponse.Answer = auxAnswer;
        if ([anExistResponse.IUR intValue] != 0) {//sent
            anExistResponse.IUR = [NSNumber numberWithInt:0];
            anExistResponse.CallIUR = [NSNumber numberWithInt:1];//an auxiliary
            anExistResponse.ResponseDate = [NSDate date];
        } else {
            if ([anExistResponse.CallIUR intValue] == 0 && ([auxAnswer isEqualToString:@""] || [auxAnswer isEqualToString:[GlobalSharedClass shared].unknownText])) {
                [self.fetchManagedObjectContext deleteObject:anExistResponse];
            }
            if ([anExistResponse.CallIUR intValue] != 0) {
                anExistResponse.ResponseDate = [NSDate date];
            }
        }
        [self saveContext:self.fetchManagedObjectContext];
        if ([[aQuestionDict objectForKey:@"QuestionType"] intValue] == 12) {
            NSString* auxOriginalAnswer = [anOriginalQuestionDict objectForKey:@"Answer"];
            if (![auxOriginalAnswer isEqualToString:@""]) {
                NSArray* auxOriginalFileNameList = [auxOriginalAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
                for (int i = 0; i < [auxOriginalFileNameList count]; i++) {
                    NSString* auxOriginalFileName = [auxOriginalFileNameList objectAtIndex:i];
                    [self deleteCollectedWithLocationIUR:aLocationIUR comments:auxOriginalFileName];
                    NSString* auxSrcRemoveFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath], auxOriginalFileName];
                    [FileCommon removeFileAtPath:auxSrcRemoveFilePath];
                }                
            }
            if (![auxAnswer isEqualToString:@""]) {
                NSArray* auxFileNameList = [auxAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
                for (int i = 0; i < [auxFileNameList count]; i++) {
                    NSString* auxFileName = [auxFileNameList objectAtIndex:i];
                    [self insertCollectedWithLocationIUR:aLocationIUR comments:auxFileName iUR:[aQuestionDict objectForKey:@"IUR"] date:[ArcosUtils addMinutes:-i date:[NSDate date]]];
                    CompositeErrorResult* auxCompositeErrorResult = [self.arcosDescriptionTrManager copySurveyFileToPhotosWithFileName:auxFileName];
                    if (!auxCompositeErrorResult.successFlag) {
                        [ArcosUtils showMsg:auxCompositeErrorResult.errorMsg delegate:nil];
                    }
                }                
            }
        }
    } else {
        if ([auxAnswer isEqualToString:@""] || [auxAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) return;
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Response* aResponse = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Response" 
                               inManagedObjectContext:context];
        [self.arcosCoreDataManager populateResponseWithDataDict:aQuestionDict contactIUR:aContactIUR locationIUR:aLocationIUR response:aResponse];
        [self saveContext:self.addManagedObjectContext];
        if ([[aQuestionDict objectForKey:@"QuestionType"] intValue] == 12) {
            NSArray* auxFileNameList = [auxAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
            for (int i = 0; i < [auxFileNameList count]; i++) {
                NSString* auxFileName = [auxFileNameList objectAtIndex:i];
                [self insertCollectedWithLocationIUR:aLocationIUR comments:auxFileName iUR:[aQuestionDict objectForKey:@"IUR"] date:[ArcosUtils addMinutes:-i date:[NSDate date]]];
                CompositeErrorResult* aCompositeErrorResult = [self.arcosDescriptionTrManager copySurveyFileToPhotosWithFileName:auxFileName];
                if (!aCompositeErrorResult.successFlag) {
                    [ArcosUtils showMsg:aCompositeErrorResult.errorMsg delegate:nil];
                }
            }            
        }
    } 
}
-(NSDictionary*)responseWithLocationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR surveyIUR:(NSNumber*)aSurveyIUR questionIUR:(NSNumber*)aQuestionIUR {    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and ContactIUR = %d and SurveyIUR = %d and QuestionIUR = %d",[aLocationIUR intValue], [aContactIUR intValue], [aSurveyIUR intValue], [aQuestionIUR intValue]];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ResponseDate",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
//    NSLog(@"how many record from core data %d -- %@", [objectsArray count],objectsArray);
    if ([objectsArray count] > 0) {
        return [objectsArray objectAtIndex:0];
    }
    return nil;
}

-(NSMutableArray*)responseWithLocationIUR:(NSNumber*)aLocationIUR surveyIUR:(NSNumber*)aSurveyIUR contactIUR:(NSNumber*)aContactIUR questionIURList:(NSMutableArray*)aQuestionIURList unsendOnly:(BOOL)anUnsendOnlyFlag {
    NSMutableArray* predicateList = [NSMutableArray arrayWithCapacity:2];
    [predicateList addObject:[NSPredicate predicateWithFormat:@"LocationIUR = %d and SurveyIUR = %d and ContactIUR = %d and QuestionIUR in %@",[aLocationIUR intValue], [aSurveyIUR intValue], [aContactIUR intValue], aQuestionIURList]];
    if (anUnsendOnlyFlag) {
        NSDate* auxDate = [NSDate date];
        [predicateList addObject:[NSPredicate predicateWithFormat:@"IUR = 0 or (IUR != 0 and ResponseDate >= %@ and ResponseDate <= %@)", [ArcosUtils beginOfDay:auxDate], [ArcosUtils endOfDay:auxDate]]];
    }
    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ResponseDate",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:YES]];
    if ([objectsArray count] > 0) {
        return objectsArray;
    }
    return nil;
}

//Journey
-(NSMutableArray*)allJourney {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"WeekNumber",@"DayNumber",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"WeekNumber",@"DayNumber",nil];    
    NSMutableArray* objectsArray = 
    [self fetchRecordsWithEntity:@"Journey" withPropertiesToFetch:properties  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectsArray;  
}

-(NSMutableArray*)journeyWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"WeekNumber = %d and DayNumber = %d", [aWeekNumber intValue], [aDayNumber intValue]];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"CallNumber",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"WeekNumber",@"DayNumber",@"CallNumber",@"LocationIUR",nil];
    NSMutableArray* objectsArray = 
    [self fetchRecordsWithEntity:@"Journey" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

-(NSDictionary*)getLocationWithIUR:(NSNumber*)aLocationIUR
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR=%d",[aLocationIUR intValue]];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count]>0) {
        return [objectsArray objectAtIndex:0];
    }else{
        return nil;
    }
}

-(NSMutableArray*)getLocationsWithPredicate:(NSPredicate*)aPredicate {
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:aPredicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        return objectsArray;
    }else{
        return nil;
    }
}

-(void)insertMemoWithData:(ArcosGenericClass*)arcosGenericClass {    
    NSDate* dateentered = [ArcosUtils dateFromString:[arcosGenericClass Field1] format:@"dd/MM/yyyy"];
    NSNumber* IUR = [ArcosUtils convertStringToNumber:[arcosGenericClass Field6]];
    NSString* details = [arcosGenericClass Field4];
    NSNumber* locationIUR = [ArcosUtils convertStringToNumber:[arcosGenericClass Field7]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [IUR intValue]];    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Memo" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];    
    if ([objectsArray count] > 0) {
        Memo* anExistMemo = [objectsArray objectAtIndex:0];
        anExistMemo.Details = details;
        [self saveContext:self.fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Memo* aMemo = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Memo" 
                       inManagedObjectContext:context];    
        aMemo.IUR = IUR;
        aMemo.LocationIUR = locationIUR;
        aMemo.Details = details;
        aMemo.DateEntered = dateentered;        
        [self saveContext:self.addManagedObjectContext];
    }
}
#pragma mark update table to server
-(NSArray*)allLocationWithNewGeo{
    
    //using fetch with context
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"Competitor1=%@",[NSNumber numberWithInt:99]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    NSLog(@"%d location objects fecthed from the fetched result !",[objectsArray count]);
    return objectsArray;
}
-(NSArray*)allNewResponse{
    //using fetch with context
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"IUR<=%@",[NSNumber numberWithInt:0]];
    NSMutableArray* objectsArray=[self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    NSLog(@"%d response objects fecthed from the fetched result !",[objectsArray count]);
    return objectsArray;
}
-(void)updateResponseWithBO:(ArcosResponseBO*)anObject{
    //check whether it exists or not
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and SurveyIUR = %d and ContactIUR = %d and QuestionIUR = %d and IUR = 0", anObject.Locationiur, anObject.Surveyiur, anObject.Contactiur,  anObject.Questioniur];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"ResponseDate",nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count]>0) {
        Response* aResponse=[objectsArray objectAtIndex:0];
        aResponse.IUR=[NSNumber numberWithInt: anObject.Iur];
        [self saveContext:self.fetchManagedObjectContext];
    }
}

#pragma mark database full information
-(NSArray*)allEntities {
    return [[self managedObjectModel] entities];
}
-(NSNumber*)entityRecordQuantity:(NSString*)anEntity {
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:anEntity withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}
-(NSMutableArray*)entityContent:(NSString*)anEntity {
    NSArray* sortDescNames = nil;
    if ([anEntity isEqualToString:@"DescrDetail"]) {
        sortDescNames = [NSArray arrayWithObjects:@"DescrTypeCode",nil];
    } else if ([anEntity isEqualToString:@"Location"]) {
        sortDescNames = [NSArray arrayWithObjects:@"LocationCode",nil];
    } else if ([anEntity isEqualToString:@"OrderHeader"]) {
        sortDescNames = [NSArray arrayWithObjects:@"OrderNumber",nil];
    }
    return [self fetchRecordsWithEntity:anEntity withPropertiesToFetch:nil  withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}
#pragma mark Product data
-(NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' and (Description CONTAINS[c] %@ OR OrderPadDetails CONTAINS[c] %@ OR ProductCode CONTAINS[c] %@ OR EAN CONTAINS[c] %@ OR PackEAN CONTAINS[c] %@)", aKeyword, aKeyword, aKeyword, aKeyword, aKeyword];
    /*
    NSMutableString* endKeyword = [NSMutableString stringWithString:aKeyword];
    unichar lastChar = [endKeyword characterAtIndex:[endKeyword length]-1] + 1;
    [endKeyword replaceCharactersInRange:NSMakeRange([endKeyword length]-1, 1) withString:[NSString stringWithFormat:@"%c", lastChar]];
    NSLog(@"aKeyword %@, endKeyword: %@", aKeyword, endKeyword);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= [c] %@ and ColumnDescription < [c] %@", aKeyword, endKeyword];
    */
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"OrderPadDetails",@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        return objectsArray;      
    }else{
        return nil;
    }
}

-(NSMutableArray*)productWithProductCodeKeyword:(NSString*)aKeyword {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1 and ProductCode BEGINSWITH[c] %@", aKeyword];
    NSArray* sortDescNames=[NSArray arrayWithObjects:@"Description",nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0) {
        return objectsArray;
    }else{
        return nil;
    }
}

-(NSNumber*)productQtyWithProductIUR:(int)aProductIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR = %d", aProductIUR];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}

- (void)createActiveProduct {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR <= 688999 and ProductIUR >= 680000"];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil 
                                                  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectsArray count] > 0) {
        NSLog(@"createActiveProduct is done.");
        for (Product* aProduct in objectsArray) {
            aProduct.Active = [NSNumber numberWithInt:1];
        }
        [self saveContext:self.fetchManagedObjectContext];
    }
}
- (NSNumber*)activeProductNumber {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Active = 1"];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}

- (NSMutableArray*)productWithL3Code:(NSString*)aL3Code {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' and L3Code = %@", aL3Code];
    NSArray* properties=[NSArray arrayWithObjects:@"L5Code", nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectsArray;
}

- (NSMutableArray*)productWithL3CodeList:(NSArray*)aL3CodeList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' and L3Code in %@", aL3CodeList];
    NSArray* properties=[NSArray arrayWithObjects:@"L3Code", @"L5Code", nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectsArray;
}

- (NSMutableArray*)productWithBranchCodeList:(NSArray *)aBranchCodeList branchLxCode:(NSString*)aBranchLxCode leafLxCode:(NSString*)anLeafLxCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' and %K in %@", aBranchLxCode, aBranchCodeList];
    NSArray* properties=[NSArray arrayWithObjects:aBranchLxCode, anLeafLxCode, nil];
    
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    return objectsArray;
}

- (NSMutableArray*)productWithProductIURList:(NSMutableArray*)aProductIURList {
//    NSLog(@"ProductIURList is: %@", aProductIURList);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR in %@", aProductIURList];
//    NSArray* properties=[NSArray arrayWithObjects:@"ProductIUR",@"UnitTradePrice",@"UnitsPerPack",@"Bonusby",@"StockAvailable",@"Description",@"OrderPadDetails",@"ProductCode",@"Productsize", nil];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

- (NSMutableArray*)productWithIURList:(NSMutableArray*)anIURList withResultType:(NSFetchRequestResultType)aResultType {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR in %@", anIURList];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:aResultType needDistinct:NO ascending:nil];
    return objectsArray;
}

//Price data
- (NSMutableDictionary*)retrievePriceWithLocationIUR:(NSNumber*)aLocationIUR productIURList:(NSMutableArray*)aProductIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ AND ProductIUR in %@", aLocationIUR, aProductIURList];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"Price" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* productIurPriceHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (NSDictionary* aPriceDict in objectArray) {
//        [productIurPriceHashMap setObject:[aProductDict objectForKey:@"RebatePercent"] forKey:[aProductDict objectForKey:@"ProductIUR"]];
        [productIurPriceHashMap setObject:aPriceDict forKey:[aPriceDict objectForKey:@"ProductIUR"]];
    }
    return productIurPriceHashMap;
}

- (NSMutableDictionary*)retrieveBonusDealWithLocationIUR:(NSNumber*)aLocationIUR productIURList:(NSMutableArray*)aProductIURList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"MemoIUr = %@ AND ProductIUR in %@", aLocationIUR, aProductIURList];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"Promotion" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* productIurBonusDealHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (NSDictionary* aBonusDealDict in objectArray) {
        [productIurBonusDealHashMap setObject:[ArcosUtils convertNilToEmpty:[aBonusDealDict objectForKey:@"Advertfiles"]] forKey:[aBonusDealDict objectForKey:@"ProductIUR"]];
    }
    return productIurBonusDealHashMap;
}

#pragma mark - Collected data
- (BOOL)deleteCollectedWithLocationIUR:(NSNumber*)aLocationIUR comments:(NSString*)aComments {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d AND Comments = %@",[aLocationIUR intValue], aComments];
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"Collected" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    
    if ([objectsArray count]>0 && objectsArray != nil) {
        Collected* collected = [objectsArray objectAtIndex:0];        
        [self.fetchManagedObjectContext deleteObject:collected];
        [self saveContext:self.fetchManagedObjectContext];
        return YES;
    }else{
        return NO;
    }
}

- (void)insertCollectedWithLocationIUR:(NSNumber*)aLocationIUR comments:(NSString*)aComments iUR:(NSNumber*)anIUR date:(NSDate*)aDate {
    NSManagedObjectContext* context = [self addManagedObjectContext];    
    Collected* collected = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Collected" 
                             inManagedObjectContext:context];
    collected.LocationIUR = aLocationIUR;
    collected.Comments = aComments;
    collected.IUR = anIUR;
    collected.DateCollected = aDate;
    [self saveContext:self.addManagedObjectContext];
}
#pragma mark - Package data
- (NSMutableDictionary*)retrieveDefaultPackageWithLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and defaultPackage = 1 and active = 1", aLocationIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"accountCode", nil];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"Package" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        return [NSMutableDictionary dictionaryWithDictionary:[objectArray objectAtIndex:0]];
    }
    return nil;
}

- (NSMutableDictionary*)retrievePackageWithIUR:(NSNumber*)aPackageIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"iUR = %@ and active = 1", aPackageIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"accountCode", nil];
    NSMutableArray* objectArray = [self fetchRecordsWithEntity:@"Package" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        return [NSMutableDictionary dictionaryWithDictionary:[objectArray objectAtIndex:0]];
    }
    return nil;
}

#pragma mark Generic method
-(NSNumber*)recordQtyWithEntityName:(NSString*)anEntityName predicate:(NSPredicate*)aPredicate {
    NSMutableArray* objectsArray = [self fetchRecordsWithEntity:anEntityName withPropertiesToFetch:nil  withPredicate:aPredicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    return [objectsArray objectAtIndex:0];
}

-(void)executeTransaction {
    if (1==1) {
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = 158386"];
        NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:nil withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        if ([objectsArray count] > 0) {
            for (LocationProductMAT* aLocationProductMAT in objectsArray) {
                aLocationProductMAT.locationIUR = [NSNumber numberWithInt:161023];
                [self saveContext:self.fetchManagedObjectContext];
            }
        }
    }
    if (1==1) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = 161023 and productIUR = 160421"];
        NSMutableArray* objectsArray = [self fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        if ([objectsArray count] > 0) {
            for (LocationProductMAT* aLocationProductMAT in objectsArray) {
                aLocationProductMAT.inStock = [NSNumber numberWithInt:5];
                [self saveContext:self.fetchManagedObjectContext];
            }
        }
    }
    /*
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Price* price = [NSEntityDescription insertNewObjectForEntityForName:@"Price"
                                                     inManagedObjectContext:context];
        price.IUR = [NSNumber numberWithInt:160429];
        price.LocationIUR = [NSNumber numberWithInt:161079];
        price.ProductIUR = [NSNumber numberWithInt:160429];
        price.UnitTradePrice = [NSNumber numberWithFloat:3.21f];
        price.RebatePercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:1.23f] decimalValue]] autorelease];
        price.DiscountPercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:2.51f] decimalValue]] autorelease];
        
        [self saveContext:context];
    }
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Price* price = [NSEntityDescription insertNewObjectForEntityForName:@"Price"
                                                     inManagedObjectContext:context];
        price.IUR = [NSNumber numberWithInt:160419];
        price.LocationIUR = [NSNumber numberWithInt:161069];
        price.ProductIUR = [NSNumber numberWithInt:160429];
        price.UnitTradePrice = [NSNumber numberWithFloat:3.21f];
        price.RebatePercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:1.02f] decimalValue]] autorelease];
        price.DiscountPercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:2.51f] decimalValue]] autorelease];
        
        [self saveContext:context];
    }
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Price* price = [NSEntityDescription insertNewObjectForEntityForName:@"Price"
                                                     inManagedObjectContext:context];
        price.IUR = [NSNumber numberWithInt:160409];
        price.LocationIUR = [NSNumber numberWithInt:161069];
        price.ProductIUR = [NSNumber numberWithInt:160426];
        price.UnitTradePrice = [NSNumber numberWithFloat:3.21f];
        price.RebatePercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:1.02f] decimalValue]] autorelease];
        price.DiscountPercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:2.51f] decimalValue]] autorelease];
        
        [self saveContext:context];
    }
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Price* price = [NSEntityDescription insertNewObjectForEntityForName:@"Price"
                                                     inManagedObjectContext:context];
        price.IUR = [NSNumber numberWithInt:160430];
        price.LocationIUR = [NSNumber numberWithInt:161080];
        price.ProductIUR = [NSNumber numberWithInt:160429];
        price.UnitTradePrice = [NSNumber numberWithFloat:3.21f];
        price.RebatePercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:1.52f] decimalValue]] autorelease];
        price.DiscountPercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:2.51f] decimalValue]] autorelease];
        
        [self saveContext:context];
    }
    
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Price* price = [NSEntityDescription insertNewObjectForEntityForName:@"Price"
                                                     inManagedObjectContext:context];
        price.IUR = [NSNumber numberWithInt:160424];
        price.LocationIUR = [NSNumber numberWithInt:161079];
        price.ProductIUR = [NSNumber numberWithInt:160424];
        price.UnitTradePrice = [NSNumber numberWithFloat:1.5f];
        price.RebatePercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:1.2f] decimalValue]] autorelease];
        price.DiscountPercent = [[[NSDecimalNumber alloc] initWithDecimal:[[NSNumber numberWithFloat:2.21f] decimalValue]] autorelease];
        
        [self saveContext:context];
    }
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Promotion* promotion = [NSEntityDescription insertNewObjectForEntityForName:@"Promotion"
                                                             inManagedObjectContext:context];
        promotion.IUR = [NSNumber numberWithInt:160429];
        promotion.MemoIUr = [NSNumber numberWithInt:161079];
        promotion.ProductIUR = [NSNumber numberWithInt:160429];
        promotion.Advertfiles = @"10~20~30~40~50~1.21~2.22~3.33~4.44~5.55";
        
        [self saveContext:context];
    }
    if (1==1) {
        NSManagedObjectContext* context = [self addManagedObjectContext];
        Promotion* promotion = [NSEntityDescription insertNewObjectForEntityForName:@"Promotion"
                                                             inManagedObjectContext:context];
        promotion.IUR = [NSNumber numberWithInt:160430];
        promotion.MemoIUr = [NSNumber numberWithInt:161080];
        promotion.ProductIUR = [NSNumber numberWithInt:160429];
        promotion.Advertfiles = @"10~20~30~40~50~1.71~2.72~3.73~4.74~5.75";
        
        [self saveContext:context];
    }
    */
}

#pragma mark core data initialize region
- (NSManagedObjectContext *)addManagedObjectContext
{
    if (__addManagedObjectContext != nil)
    {
        return __addManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator ;
    if (coordinator != nil)
    {
        __addManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [__addManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __addManagedObjectContext;
}
- (NSManagedObjectContext *)deleteManagedObjectContext
{
    if (__deleteManagedObjectContext != nil)
    {
        return __deleteManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator ;
    if (coordinator != nil)
    {
        __deleteManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [__deleteManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __deleteManagedObjectContext;
}
- (NSManagedObjectContext *)fetchManagedObjectContext
{
    if (__fetchManagedObjectContext != nil)
    {
        return __fetchManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator ;
    if (coordinator != nil)
    {
        __fetchManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [__fetchManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __fetchManagedObjectContext;
}
- (NSManagedObjectContext *)editManagedObjectContext
{
    if (__editManagedObjectContext != nil)
    {
        return __editManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator ;
    if (coordinator != nil)
    {
        __editManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [__editManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __editManagedObjectContext;
}
- (NSManagedObjectContext *)importManagedObjectContext
{
    if (__importManagedObjectContext != nil)
    {
        return __importManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator ;
    if (coordinator != nil)
    {
        __importManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [__importManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __importManagedObjectContext;
}
/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)FRCWithEntityName:(NSString*)entityName withPredicate:(NSPredicate*)aPredicate withSortDescNames:(NSArray*)sortDescNames withSectionNameKeyPath:(NSString*)sectionName {
    
    if (__fetchedResultsController != nil) {
        [__fetchedResultsController release];
    }

    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.fetchManagedObjectContext];
	[fetchRequest setEntity:entity];
	
    // Create the predicate
    if (aPredicate!=nil) {
       //predicate =[NSPredicate predicateWithFormat:@"%@",predicateString];
       [fetchRequest setPredicate:aPredicate];
    }
   
    
	// Create the sort descriptors array.
    NSMutableArray* descriptors=[[NSMutableArray alloc]init];
    for (NSString* descName in sortDescNames) {
        NSSortDescriptor *desc = [[[NSSortDescriptor alloc] initWithKey:descName ascending:YES]autorelease];
        [descriptors addObject:desc];
    }
	if ([sortDescNames count]>0&&sortDescNames!=nil) {
        [fetchRequest setSortDescriptors:descriptors];
    }
	
	
	// Create and initialize the fetch results controller.
	__fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.fetchManagedObjectContext sectionNameKeyPath:sectionName cacheName:@"Root"];
	__fetchedResultsController.delegate = self;
	
	// Memory management.
	[fetchRequest release];
	[descriptors release];
	
	return __fetchedResultsController;
}
- (NSMutableArray*)fetchRecordsWithEntity:(NSString*)entityName withPropertiesToFetch:(NSArray*)properties withPredicate:(NSPredicate*)aPredicate withSortDescNames:(NSArray*)sortDescNames withResulType:(NSFetchRequestResultType)resultType needDistinct:(BOOL)distinct ascending:(NSNumber*)isAscending{  
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.fetchManagedObjectContext];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Create the predicate
    if (aPredicate!=nil) {
        //predicate =[NSPredicate predicateWithFormat:@"%@",predicateString];
        [request setPredicate:aPredicate];
    }
    
    //order of the record
    if (isAscending==nil) {
        isAscending=[NSNumber numberWithBool:YES];
    }
    
	// Create the sort descriptors array.
    NSMutableArray* descriptors=[[NSMutableArray alloc]init];
    for (NSString* descName in sortDescNames) {
        NSSortDescriptor *desc = [[[NSSortDescriptor alloc] initWithKey:descName ascending:[isAscending boolValue] selector:@selector(caseInsensitiveCompare:)]autorelease ];

        [descriptors addObject:desc];
    }
	if ([sortDescNames count]>0&&sortDescNames!=nil) {
        [request setSortDescriptors:descriptors];
    }
    //set the result type
    [request setResultType:resultType];
    //set need distinct the attribut
    [request setReturnsDistinctResults:distinct];
    
    if ([properties count]>0&&properties!=nil) {
        //set the properties to fetch
        [request setPropertiesToFetch:properties];
    }
    // Fetch the records and handle an error  
    NSError *error = nil;  
    NSMutableArray *mutableFetchResults = [[self.fetchManagedObjectContext executeFetchRequest:request error:&error]mutableCopy];   
    
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
    
    // Memory management.
    NSMutableArray* returnArray=[NSMutableArray arrayWithArray:mutableFetchResults];
    
	[request release];
	[descriptors release];
    [mutableFetchResults release];
    
    return returnArray;
}

- (NSMutableArray*)fetchRecordsWithContext:(NSManagedObjectContext*)context withEntity:(NSString*)entityName withPropertiesToFetch:(NSArray*)properties withPredicate:(NSPredicate*)aPredicate withSortDescNames:(NSArray*)sortDescNames withResulType:(NSFetchRequestResultType)resultType needDistinct:(BOOL)distinct ascending:(NSNumber*)isAscending {
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Create the predicate
    if (aPredicate!=nil) {
        //predicate =[NSPredicate predicateWithFormat:@"%@",predicateString];
        [request setPredicate:aPredicate];
    }
    
    //order of the record
    if (isAscending==nil) {
        isAscending=[NSNumber numberWithBool:YES];
    }
    
    // Create the sort descriptors array.
    NSMutableArray* descriptors=[[NSMutableArray alloc]init];
    for (NSString* descName in sortDescNames) {
        NSSortDescriptor *desc = [[[NSSortDescriptor alloc] initWithKey:descName ascending:[isAscending boolValue] selector:@selector(caseInsensitiveCompare:)]autorelease ];
        
        [descriptors addObject:desc];
    }
    if ([sortDescNames count]>0&&sortDescNames!=nil) {
        [request setSortDescriptors:descriptors];
    }
    //set the result type
    [request setResultType:resultType];
    //set need distinct the attribut
    [request setReturnsDistinctResults:distinct];
    
    if ([properties count]>0&&properties!=nil) {
        //set the properties to fetch
        [request setPropertiesToFetch:properties];
    }
    // Fetch the records and handle an error
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error]mutableCopy];
    
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
    }
    
    // Memory management.
    NSMutableArray* returnArray=[NSMutableArray arrayWithArray:mutableFetchResults];
    
    [request release];
    [descriptors release];
    [mutableFetchResults release];
    
    return returnArray;
}

- (void)saveContext:(NSManagedObjectContext*)context;
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = context;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iArcos" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iArcos.sqlite"];
    
    //using preload DB
    //NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Arcos.sqlite"];
   // NSURL *storeURL = [[NSBundle mainBundle] URLForResource:@"Arcos" withExtension:@"sqlite"];

    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary* migrOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:migrOptions error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)dealloc{    
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [__addManagedObjectContext release];
    [__fetchManagedObjectContext release];
    [__fetchedResultsController release];
    [__deleteManagedObjectContext release];
    [__editManagedObjectContext release];
    [__importManagedObjectContext release];
    if (self.arcosCoreDataManager != nil) { self.arcosCoreDataManager = nil; }
    if (self.arcosDescriptionTrManager != nil) { self.arcosDescriptionTrManager = nil; }
    
    [super dealloc];
}
@end
