//
//  CheckoutDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CheckoutDataManager.h"

@implementation CheckoutDataManager
@synthesize currentIndexPath = _currentIndexPath;
@synthesize topxList = _topxList;
@synthesize isNotFirstTimeCustomerMsg = _isNotFirstTimeCustomerMsg;
@synthesize topxNumber = _topxNumber;
@synthesize flaggedProductsNumber = _flaggedProductsNumber;
@synthesize isNotFirstTimeCompanyMsg = _isNotFirstTimeCompanyMsg;
@synthesize currentFormDetailDict = _currentFormDetailDict;

- (void)dealloc {
    self.currentIndexPath = nil;
    self.topxList = nil;
    self.currentFormDetailDict = nil;
    
    [super dealloc];
}

- (NSNumber*)getCurrentLocationIUR {
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    }
    return locationIUR;
}

- (NSMutableArray*)getAccountNoList:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR {
    NSMutableArray* accountNoList = [NSMutableArray array];
    if ([aLocationIUR intValue] == 0) return accountNoList;
    NSMutableArray* locLocLinkList = [[ArcosCoreData sharedArcosCoreData] getLocLocLink:aLocationIUR fromLocationIUR:aFromLocationIUR];
    
    
    if ([locLocLinkList count] > 0) {
        NSDictionary* locLocLinkDict = [locLocLinkList objectAtIndex:0];
        NSString* customerCode = [locLocLinkDict objectForKey:@"CustomerCode"];
        if (customerCode != nil && ![[ArcosUtils trim:customerCode] isEqualToString:@""]) {
            NSString* delimiter = @",";
            NSRange rng = [customerCode rangeOfString:delimiter];
            if (rng.location == NSNotFound) {
                NSString* secondDelimiter = @"|";
                NSRange secondRng = [customerCode rangeOfString:secondDelimiter];
                if (secondRng.location != NSNotFound) {
                    delimiter = secondDelimiter;
                }
            }
            NSArray* accountNoComponentList = [customerCode componentsSeparatedByString:delimiter];
            for (int i = 0; i < [accountNoComponentList count]; i++) {
                NSMutableDictionary* accountNoDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [accountNoDict setObject:[ArcosUtils convertNilToEmpty:[accountNoComponentList objectAtIndex:i]] forKey:@"acctNo"];
                [accountNoDict setObject:[ArcosUtils convertNilToEmpty:[accountNoComponentList objectAtIndex:i]] forKey:@"Title"];
                [accountNoList addObject:accountNoDict];
            }
        }
    }
    return accountNoList;
}

- (NSMutableDictionary*)getAcctNoMiscDataDict:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR {
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [miscDataDict setObject:[GlobalSharedClass shared].accountNoText forKey:@"Title"];
    [miscDataDict setObject:aLocationIUR forKey:@"LocationIUR"];
    [miscDataDict setObject:aFromLocationIUR forKey:@"FromLocationIUR"];
    [miscDataDict setObject:[[OrderSharedClass sharedOrderSharedClass]currentCustomerName] forKey:@"Name"];
    return miscDataDict;
}

- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword orderFormDetails:(NSString*)anOrderFormDetails {
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithDescriptionKeyword:aKeyword];
    NSMutableArray* displayList = nil;
    if (products == nil) {
        displayList = [NSMutableArray array];
    } else {
        displayList = [NSMutableArray arrayWithCapacity:[products count]];
        for (NSMutableDictionary* aProduct in products) {//loop products
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct orderFormDetails:anOrderFormDetails];
            //sync the row with current cart
            formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
            [displayList addObject:formRow];
        }
    }
    return displayList;
}

- (void)retrieveTopxListWithLocationIUR:(NSNumber*)aLocationIUR orderFormDetails:(NSString*)anOrderFormDetails {
    self.topxNumber = 0;
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"TOPX"];
    if ([objectList count] > 0) {
        NSDictionary* descrDetailDict = [objectList objectAtIndex:0];
        NSString* detail = [descrDetailDict objectForKey:@"Detail"];
        self.topxNumber = [[ArcosUtils convertStringToNumber:detail] intValue];
    }
    if (self.topxNumber == 0) {
        self.topxList = nil;
        return;
    }
    self.topxList = [self processLocationProductMATDataWithLocationIUR:aLocationIUR topx:self.topxNumber orderFormDetails:anOrderFormDetails];
}

- (NSMutableArray*)processLocationProductMATDataWithLocationIUR:(NSNumber*)aLocationIUR topx:(int)aTopxNum orderFormDetails:(NSString*)anOrderFormDetails {
    NSArray* properties = [NSArray arrayWithObjects:@"productIUR", @"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",@"dateLastModified",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@", aLocationIUR];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* tmpProductDict = [objectsArray objectAtIndex:i];
        [productIURList addObject:[tmpProductDict objectForKey:@"productIUR"]];
    }
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    NSMutableArray* auxObjectList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithDictionary:[objectsArray objectAtIndex:i]];
        
        int totalValue = 0;
        for (int i = 3; i <= 15 ; i++) {
            int qtyIndex = i + 10;
            NSString* qtyField = [NSString stringWithFormat:@"qty%d", qtyIndex];
            NSString* qtyFieldMethodName = [NSString stringWithFormat:@"objectForKey:"];
            SEL qtySelector = NSSelectorFromString(qtyFieldMethodName);
            NSNumber* qtyValue = [cellData performSelector:qtySelector withObject:qtyField];
            totalValue += [qtyValue intValue];
        }
        [cellData setObject:[NSNumber numberWithInt:totalValue] forKey:@"TotalValue"];
        [auxObjectList addObject:cellData];
    }
    NSSortDescriptor* totalValueDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"TotalValue" ascending:NO selector:@selector(compare:)] autorelease];
    [auxObjectList sortUsingDescriptors:[NSArray arrayWithObjects:totalValueDescriptor, nil]];
    
    NSDictionary* productDict = nil;
    int length = [ArcosUtils convertNSUIntegerToUnsignedInt:[auxObjectList count]];
    if (aTopxNum < length) {
        length = aTopxNum;
    }
    NSMutableArray* resultList = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        NSMutableDictionary* auxCellData = [auxObjectList objectAtIndex:i];
        NSNumber* productIUR = [auxCellData objectForKey:@"productIUR"];
        productDict = [productDictHashMap objectForKey:productIUR];
        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
        if (productDict != nil) {
            formRow = [ProductFormRowConverter createFormRowWithProduct:[NSMutableDictionary dictionaryWithDictionary:productDict] orderFormDetails:anOrderFormDetails];
        } else {
            formRow = [ProductFormRowConverter createBlankFormRowWithProductIUR:productIUR];
        }
        NSString* combinedKey = [formRow objectForKey:@"CombinationKey"];
        if ([[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:combinedKey] == nil) {
            [resultList addObject:formRow];
        }
    }
    return resultList;
}

- (void)removeTopxElementWithDataDict:(NSMutableDictionary*)aDataDict {
    for (int i = 0; i < [self.topxList count]; i++) {
        NSMutableDictionary* cellDict = [self.topxList objectAtIndex:i];
        if ([[cellDict objectForKey:@"CombinationKey"] isEqualToString:[aDataDict objectForKey:@"CombinationKey"]]) {
            [self.topxList removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)retrieveTopCompanyProductsWithOrderFormDetails:(NSString*)anOrderFormDetails {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* OUiurNumber = [employeeDict objectForKey:@"OUiur"];
    NSPredicate* predicate = nil;
    if ([OUiurNumber intValue] == 0) {
        predicate = [NSPredicate predicateWithFormat:@"FlagIUR != 0"];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"FlagIUR = %@", OUiurNumber];
    }
     
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableArray* resultList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* productDict = [objectsArray objectAtIndex:i];
        NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:[NSMutableDictionary dictionaryWithDictionary:productDict] orderFormDetails:anOrderFormDetails];
        NSString* combinedKey = [formRow objectForKey:@"CombinationKey"];
        if ([[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:combinedKey] == nil) {
            [resultList addObject:formRow];
        }
    }
    self.flaggedProductsNumber = 0;
    if (self.topxList == nil || [self.topxList count] == 0) {
        self.topxList = [NSMutableArray array];
    }
    for (int i = 0; i < [resultList count]; i++) {
        NSMutableDictionary* tmpFormRow = [resultList objectAtIndex:i];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CombinationKey = %@", [tmpFormRow objectForKey:@"CombinationKey"]];
        NSArray* tmpObjectList = [self.topxList filteredArrayUsingPredicate:predicate];
        if ([tmpObjectList count] == 0) {
            self.flaggedProductsNumber++;
            [self.topxList addObject:tmpFormRow];
        }
    }
}

- (BOOL)checkScannedProductInTopxList:(NSMutableDictionary*)aProductDict {
    BOOL existingFlag = NO;
    for (int i = 0; i < [self.topxList count]; i++) {
        NSMutableDictionary* auxTopxDict = [self.topxList objectAtIndex:i];
        if ([[auxTopxDict objectForKey:@"CombinationKey"] isEqualToString:[aProductDict objectForKey:@"CombinationKey"]]) {
            existingFlag = YES;
            break;
        }
    }
    return existingFlag;
}

@end
