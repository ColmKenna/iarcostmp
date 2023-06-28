//
//  MATFormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "MATFormRowsDataManager.h"

@implementation MATFormRowsDataManager
@synthesize originalDisplayList = _originalDisplayList;
@synthesize displayList = _displayList;
@synthesize originalFieldNames = _originalFieldNames;
@synthesize fieldNames = _fieldNames;
@synthesize qtyBonDisplayList = _qtyBonDisplayList;
@synthesize originalQtyBonDisplayList = _originalQtyBonDisplayList;
@synthesize totalClickTime = _totalClickTime;
@synthesize currentFormDetailDict = _currentFormDetailDict;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.originalDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.displayList = [[[NSMutableArray alloc] init] autorelease];
        self.qtyBonDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.originalQtyBonDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.totalClickTime = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.originalDisplayList != nil) { self.originalDisplayList = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.originalFieldNames != nil) { self.originalFieldNames = nil; }    
    if (self.fieldNames != nil) { self.fieldNames = nil; }
    if (self.qtyBonDisplayList != nil) { self.qtyBonDisplayList = nil; }
    self.originalQtyBonDisplayList = nil;
    self.currentFormDetailDict = nil;
    
    [super dealloc];
}
/*
- (void)processRawData:(NSMutableArray*)aDisplayList {
    for (int i = 0; i < [aDisplayList count]; i++) {
        ArcosGenericClass* cellData = [aDisplayList objectAtIndex:i];
        NSNumber* productIUR = [ArcosUtils convertStringToNumber:[cellData Field1]];
        NSString* details = [cellData Field2];
        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
        NSString* combinationKey = [NSString stringWithFormat:@"%@->%d", details, [productIUR intValue]];
        
        [formRow setObject:combinationKey forKey:@"CombinationKey"];
        [formRow setObject:productIUR forKey:@"ProductIUR"];
        [formRow setObject:[ArcosUtils convertStringToFloatNumber:[cellData Field18]] forKey:@"UnitPrice"];
        [formRow setObject:details forKey:@"Details"];
        [formRow setObject:[ArcosUtils convertNilToEmpty:[cellData Field20]] forKey:@"OrderPadDetails"];
        [formRow setObject:[ArcosUtils convertNilToEmpty:[cellData Field19]] forKey:@"ProductCode"];
        [formRow setObject:[ArcosUtils convertNilToEmpty:[cellData Field21]] forKey:@"ProductSize"];
        [formRow setObject:[NSNumber numberWithInt:78] forKey:@"Bonusby"];
        
        [formRow setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
        [formRow setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
        [formRow setObject:[NSNumber numberWithFloat:0] forKey:@"LineValue"];
        [formRow setObject:[NSNumber numberWithFloat:0] forKey:@"DiscountPercent"];
        [formRow setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [formRow setObject:indexPath forKey:@"indexPath"];
        formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        [self.qtyBonDisplayList addObject:formRow];
    }
}
*/
- (void)newProcessRawData:(NSMutableArray*)aDisplayList locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[aDisplayList count]];
    for (int i = 0; i < [aDisplayList count]; i++) {
        ArcosGenericClass* cellData = [aDisplayList objectAtIndex:i];
        NSNumber* productIUR = [ArcosUtils convertStringToNumber:[cellData Field1]];
        [productIURList addObject:productIUR];
    }
    NSMutableArray* auxProductDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
//    NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:aLocationIUR productIURList:productIURList];
//    NSMutableArray* productsList = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:auxProductDictList priceHashMap:priceHashMap];
    NSMutableArray* productsList = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:auxProductDictList productIURList:productIURList locationIUR:aLocationIUR packageIUR:aPackageIUR];
    NSMutableDictionary* productHashMap = [NSMutableDictionary dictionaryWithCapacity:[productsList count]];
    for (NSDictionary* aProductDict in productsList) {
        NSNumber* productIURKey = [aProductDict objectForKey:@"ProductIUR"];
        [productHashMap setObject:aProductDict forKey:productIURKey];
    }
    NSDictionary* productDict = nil;
    self.qtyBonDisplayList = [NSMutableArray arrayWithCapacity:[aDisplayList count]];
    for (int i = 0; i < [aDisplayList count]; i++) {
        ArcosGenericClass* cellData = [aDisplayList objectAtIndex:i];
        NSNumber* productIUR = [ArcosUtils convertStringToNumber:[cellData Field1]];
        productDict = [productHashMap objectForKey:productIUR];
        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
        if (productDict != nil) {
            formRow = [ProductFormRowConverter createFormRowWithProduct:[NSMutableDictionary dictionaryWithDictionary:productDict]];
        } else {
            formRow = [ProductFormRowConverter createBlankFormRowWithProductIUR:productIUR];
        }
        formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        [self.qtyBonDisplayList addObject:formRow];
    }
    self.originalQtyBonDisplayList = [NSMutableArray arrayWithArray:self.qtyBonDisplayList];
}

- (void)clearAllSubViews:(UIView*)aView {
    NSUInteger length = [[aView subviews] count];
    for (int i = 0; i < length; i++) {
        UILabel* tmpLabel = [[aView subviews] objectAtIndex:i];
        tmpLabel.text = nil;
    }
}

- (void)createMATFormRowsData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 12;
    arcosFormDetailBO.Details = @"Dynamic";
    arcosFormDetailBO.DefaultDeliverDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 101;
    arcosFormDetailBO.Type = @"101";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)syncQtyBonDisplayList {
    for (int i = 0; i < [self.qtyBonDisplayList count]; i++) {
        NSMutableDictionary* aRow = [self.qtyBonDisplayList objectAtIndex:i];
        NSString* combinationkey = [NSString stringWithFormat:@"%@->%d", [aRow objectForKey:@"Details"],[[aRow objectForKey:@"ProductIUR"]intValue]];
        
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:combinationkey];
        if (aDict != nil) {
            [self.qtyBonDisplayList replaceObjectAtIndex:i withObject:aDict];
        } else {
//            [aRow setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
//            [aRow setObject:[NSNumber numberWithInt:0] forKey:@"Qty"];
//            [aRow setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
//            [aRow setObject:[NSNumber numberWithInt:0] forKey:@"DiscountPercent"];
//            [aRow setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
//            [aRow setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
            [ProductFormRowConverter resetFormRowFigureWithFormRowDict:aRow];
        }        
    }
}

- (void)processLocationProductMATData:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    NSArray* properties = [NSArray arrayWithObjects:@"productIUR", @"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",@"dateLastModified",@"inStock",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@", aLocationIUR];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* tmpProductDict = [objectsArray objectAtIndex:i];
        [productIURList addObject:[tmpProductDict objectForKey:@"productIUR"]];
    }
    NSMutableArray* auxProductDictList = [[ArcosCoreData sharedArcosCoreData] productWithProductIURList:productIURList];
//    NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:aLocationIUR productIURList:productIURList];
//    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:auxProductDictList priceHashMap:priceHashMap];
    NSMutableArray* productDictList = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:auxProductDictList productIURList:productIURList locationIUR:aLocationIUR packageIUR:aPackageIUR];
    
    
    NSMutableDictionary* productDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[productDictList count]];
    for (int i = 0; i < [productDictList count]; i++) {
        NSDictionary* productDict = [productDictList objectAtIndex:i];
        [productDictHashMap setObject:productDict forKey:[productDict objectForKey:@"ProductIUR"]];
    }
    
    self.displayList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    self.qtyBonDisplayList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    if ([objectsArray count] > 0) {
        self.fieldNames = [[[ArcosGenericClass alloc] init] autorelease];
    } else {
        self.fieldNames = nil;
    }
    NSMutableDictionary* locationProductMATDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectsArray count]];
    NSDictionary* productDict = nil;
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* cellData = [objectsArray objectAtIndex:i];
        if (i == 0) {
            NSDate* dateLastModified = [cellData objectForKey:@"dateLastModified"];
            if (dateLastModified == nil) {
                dateLastModified = [NSDate date];
            }
//            NSLog(@"date: %@", dateLastModified);
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMM"];
            NSString* myMonthStr = [df stringFromDate:dateLastModified];
//            NSLog(@"myMonthStr: %@", myMonthStr);
            [self.fieldNames setField15:myMonthStr];
            int monthStep = 0;
            for (int i = 14; i > 2; i--) {
                monthStep--;
                NSDate* tmpDateLastModified = [ArcosUtils addMonths:monthStep date:dateLastModified];
                NSString* tmpMonthStr = [df stringFromDate:tmpDateLastModified];
                NSString* valueFirstMethodName = [NSString stringWithFormat:@"setField%d:",i];
                SEL firstSelector = NSSelectorFromString(valueFirstMethodName);
                [self.fieldNames performSelector:firstSelector withObject:tmpMonthStr];
            }
            [df release];
        }
        
        NSNumber* productIUR = [cellData objectForKey:@"productIUR"];
        [locationProductMATDictHashMap setObject:cellData forKey:productIUR];
        productDict = [productDictHashMap objectForKey:productIUR];
        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
        if (productDict != nil) {
            formRow = [ProductFormRowConverter createFormRowWithProduct:[NSMutableDictionary dictionaryWithDictionary:productDict]];
        } else {
            formRow = [ProductFormRowConverter createBlankFormRowWithProductIUR:productIUR];
        }
        formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        [self.qtyBonDisplayList addObject:formRow];
    }
    NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"OrderPadDetails" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Details" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [self.qtyBonDisplayList sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, detailsDescriptor, nil]];
    self.originalQtyBonDisplayList = [NSMutableArray arrayWithArray:self.qtyBonDisplayList];
    for (int i = 0; i < [self.qtyBonDisplayList count]; i++) {
        NSMutableDictionary* formRow = [self.qtyBonDisplayList objectAtIndex:i];
        ArcosGenericClass* arcosGenericClass = [[ArcosGenericClass alloc] init];
        arcosGenericClass.Field1 = [ArcosUtils convertNumberToIntString:[formRow objectForKey:@"ProductIUR"]];
        arcosGenericClass.Field2 = [formRow objectForKey:@"Details"];
        arcosGenericClass.Field20 = [formRow objectForKey:@"OrderPadDetails"];
        arcosGenericClass.Field19 = [formRow objectForKey:@"ProductCode"];
        arcosGenericClass.Field21 = [formRow objectForKey:@"ProductSize"];
        NSDictionary* cellData = [locationProductMATDictHashMap objectForKey:[formRow objectForKey:@"ProductIUR"]];
        int totalValue = 0;
        for (int i = 3; i <= 15 ; i++) {
            int qtyIndex = i + 10;
            NSString* qtyField = [NSString stringWithFormat:@"qty%d", qtyIndex];
//            qtyField = qtyIndex < 10 ? [NSString stringWithFormat:@"qty0%d", qtyIndex] : [NSString stringWithFormat:@"qty%d", qtyIndex];
            NSString* qtyFieldMethodName = [NSString stringWithFormat:@"objectForKey:"];
            SEL qtySelector = NSSelectorFromString(qtyFieldMethodName);
            NSNumber* qtyValue = [cellData performSelector:qtySelector withObject:qtyField];
//            NSLog(@"qty: %@", qtyValue);
            totalValue += [qtyValue intValue];
            NSString* fieldMethodName = [NSString stringWithFormat:@"setField%d:", i];
            SEL fieldSelector = NSSelectorFromString(fieldMethodName);
            [arcosGenericClass performSelector:fieldSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qtyValue]]];
        }
        arcosGenericClass.Field16 = [NSString stringWithFormat:@"%d", totalValue];
        arcosGenericClass.Field22 = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:[formRow objectForKey:@"StockAvailable"]]];
//        [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:[cellData objectForKey:@"inStock"]]];
        [self.displayList addObject:arcosGenericClass];
        [arcosGenericClass release];
    }    
    self.originalDisplayList = [NSMutableArray arrayWithArray:self.displayList];
}

- (void)retrieveQtyBonDisplayListWithDisplayList:(NSMutableArray*)aDisplayList {
    NSMutableDictionary* productIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[aDisplayList count]];
    for (int i = 0; i < [aDisplayList count]; i++) {
        ArcosGenericClass* auxFormRowGenericClass = [aDisplayList objectAtIndex:i];
        [productIURHashMap setObject:auxFormRowGenericClass.Field1 forKey:auxFormRowGenericClass.Field1];        
    }
    [self.qtyBonDisplayList removeAllObjects];
    for (int i = 0; i < [self.originalQtyBonDisplayList count]; i++) {
        NSMutableDictionary* auxQtyBonDict = [self.originalQtyBonDisplayList objectAtIndex:i];
        NSNumber* auxProductIUR = [auxQtyBonDict objectForKey:@"ProductIUR"];
        NSString* auxProductIURStr = [ArcosUtils convertNumberToIntString:auxProductIUR];
        if ([productIURHashMap objectForKey:auxProductIURStr] != nil) {
            [self.qtyBonDisplayList addObject:auxQtyBonDict];
        }
    }
}

@end
