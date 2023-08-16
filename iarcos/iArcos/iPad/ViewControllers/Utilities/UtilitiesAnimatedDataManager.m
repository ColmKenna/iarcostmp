//
//  UtilitiesAnimatedDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 30/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesAnimatedDataManager.h"

@implementation UtilitiesAnimatedDataManager
@synthesize tylyBarDisplayList = _tylyBarDisplayList;
@synthesize tylyTableDisplayList = _tylyTableDisplayList;
@synthesize maxOfTyBarAxis = _maxOfTyBarAxis;
@synthesize maxOfLyBarAxis = _maxOfLyBarAxis;
@synthesize maxOfBarAxis = _maxOfBarAxis;
@synthesize monthMapDict = _monthMapDict;
@synthesize tylyTableKeyList = _tylyTableKeyList;
@synthesize tylyTableHeadingList = _tylyTableHeadingList;
@synthesize tyBarIdentifier = _tyBarIdentifier;
@synthesize lyBarIdentifier = _lyBarIdentifier;
@synthesize monthTableDisplayList = _monthTableDisplayList;
@synthesize monthTableFieldNames = _monthTableFieldNames;
@synthesize originalMonthTableDisplayList = _originalMonthTableDisplayList;
@synthesize originalMonthTableFieldNames = _originalMonthTableFieldNames;
@synthesize monthPieLegendList = _monthPieLegendList;
@synthesize monthPieNullLabelDisplayList = _monthPieNullLabelDisplayList;
@synthesize monthPieLabelDisplayList = _monthPieLabelDisplayList;
@synthesize monthPieDisplayList = _monthPieDisplayList;
@synthesize monthPieRawDisplayList = _monthPieRawDisplayList;
@synthesize monthPieIdentifier = _monthPieIdentifier;
@synthesize lineDetailList = _lineDetailList;
@synthesize lineTargetList = _lineTargetList;
@synthesize lineActualList = _lineActualList;
@synthesize maxOfLineYAxis = _maxOfLineYAxis;
@synthesize configDict = _configDict;
@synthesize pnfDescrDetailCode = _pnfDescrDetailCode;
@synthesize pnfDetail = _pnfDetail;
//@synthesize monthPieCompositeResultList = _monthPieCompositeResultList;
@synthesize monthPieNormalBarCount = _monthPieNormalBarCount;
@synthesize totalClickTime = _totalClickTime;
@synthesize detailClickTime = _detailClickTime;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.tylyBarDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.tylyTableDisplayList = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray* monthMapValueList = [NSMutableArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May",@"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
        NSMutableArray* monthMapKeyList = [NSMutableArray arrayWithCapacity:8];
        for (int i = 1; i <= 12; i++) {
            [monthMapKeyList addObject:[NSNumber numberWithInt:i]];
        }    
        self.monthMapDict = [NSDictionary dictionaryWithObjects:monthMapValueList forKeys:monthMapKeyList];
        self.tylyTableKeyList = [NSMutableArray arrayWithObjects:@"LY",@"TY",@"Diff",@"DiffPercent", nil];
        self.tylyTableHeadingList = [NSMutableArray arrayWithObjects:@"PREV",@"THIS",@"DIFF",@"%", nil];
        self.tyBarIdentifier = @"Bar Plot 1";
        self.lyBarIdentifier = @"Bar Plot 2";
        self.monthPieLegendList = [NSMutableArray array];
        self.monthPieDisplayList = [NSMutableArray array];
        self.monthPieRawDisplayList = [NSMutableArray array];
        self.monthPieIdentifier = @"IdMonthPieChart";
        self.lineDetailList = [NSMutableArray array];
        self.lineTargetList = [NSMutableArray array];
        self.lineActualList = [NSMutableArray array];
        self.configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
        self.pnfDescrDetailCode = @"PRODUCTNF";
        self.pnfDetail = @"Product not found";
        self.monthPieNormalBarCount = 10;
        self.totalClickTime = 0;
        self.detailClickTime = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.tylyBarDisplayList != nil) { self.tylyBarDisplayList = nil; }
    if (self.tylyTableDisplayList != nil) { self.tylyTableDisplayList = nil; }
    if (self.maxOfTyBarAxis != nil) { self.maxOfTyBarAxis = nil; }
    if (self.maxOfLyBarAxis != nil) { self.maxOfLyBarAxis = nil; }    
    if (self.maxOfBarAxis != nil) { self.maxOfBarAxis = nil; }
    self.monthMapDict = nil;
    if (self.tylyTableKeyList != nil) { self.tylyTableKeyList = nil; }
    self.tylyTableHeadingList = nil;
    self.tyBarIdentifier = nil;
    self.lyBarIdentifier = nil;
    if (self.monthTableDisplayList != nil) { self.monthTableDisplayList = nil;}
    if (self.monthTableFieldNames != nil) { self.monthTableFieldNames = nil;}
    if (self.originalMonthTableDisplayList != nil) { self.originalMonthTableDisplayList = nil;}
    if (self.originalMonthTableFieldNames != nil) { self.originalMonthTableFieldNames = nil;}
    if (self.monthPieLegendList != nil) { self.monthPieLegendList = nil;}
    if (self.monthPieNullLabelDisplayList != nil) { self.monthPieNullLabelDisplayList = nil;}
    if (self.monthPieLabelDisplayList != nil) { self.monthPieLabelDisplayList = nil;}
    if (self.monthPieDisplayList != nil) { self.monthPieDisplayList = nil;}
    self.monthPieRawDisplayList = nil;
    self.monthPieIdentifier = nil;
    if (self.lineDetailList != nil) { self.lineDetailList = nil; }
    if (self.lineTargetList != nil) { self.lineTargetList = nil; }
    if (self.lineActualList != nil) { self.lineActualList = nil; }    
    if (self.maxOfLineYAxis != nil) { self.maxOfLineYAxis = nil; }
    self.configDict = nil;
    self.pnfDescrDetailCode = nil;
    self.pnfDetail = nil;
//    self.monthPieCompositeResultList = nil;
                
    [super dealloc];
}

- (void)processRawData:(ArcosGenericReturnObject*)result {
    NSMutableArray* tmpDisplayList = result.ArrayOfData;
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        ArcosGenericClass* tmpArcosGenericClass = [tmpDisplayList objectAtIndex:i];
        NSMutableDictionary* tmpDict = [NSMutableDictionary dictionary];                     
                
        [tmpDict setObject:[ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field11]]] forKey:@"TY"];
        [tmpDict setObject:[ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field12]]] forKey:@"LY"];
        [tmpDict setObject:[ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field15]]] forKey:@"Diff"];
        [tmpDict setObject:[ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field16]]] forKey:@"DiffPercent"];
        [tmpDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field3]]] forKey:@"monthNumber"];
        
        [self.tylyBarDisplayList insertObject:tmpDict atIndex:0];
    }
    self.maxOfTyBarAxis = [self.tylyBarDisplayList valueForKeyPath:@"@max.TY"];
    self.maxOfLyBarAxis = [self.tylyBarDisplayList valueForKeyPath:@"@max.LY"];
    self.maxOfBarAxis = [self.maxOfTyBarAxis floatValue] > [self.maxOfLyBarAxis floatValue] ? self.maxOfTyBarAxis : self.maxOfLyBarAxis;
}

- (void)processMonthPieRawData:(ArcosGenericReturnObject*)result {
    NSMutableArray* tmpDisplayList = result.ArrayOfData;
    NSMutableArray* finalResultDictList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    float totalYearQty = 0.0;
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        ArcosGenericClass* tmpArcosGenericClass = [tmpDisplayList objectAtIndex:i];
        NSMutableDictionary* tmpFinalResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
//        [self.monthPieLegendList addObject:[tmpArcosGenericClass Field2]];
        [tmpFinalResultDict setObject:[ArcosUtils convertNilToEmpty:[tmpArcosGenericClass Field2]] forKey:@"StdTitle"];
        [finalResultDictList addObject:tmpFinalResultDict];
        NSNumber* tmpMonthQty = [ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:[tmpArcosGenericClass Field16]]]];
        [self.monthPieRawDisplayList addObject:tmpMonthQty];
        totalYearQty += [tmpMonthQty floatValue];
    }
    for (int i = 0; i < [self.monthPieRawDisplayList count]; i++) {
        NSMutableDictionary* tmpFinalResultDict = [finalResultDictList objectAtIndex:i];
        NSNumber* tmpMonthQty = [self.monthPieRawDisplayList objectAtIndex:i];
        float tmpMonthPercentage = 0;
        if (totalYearQty == 0) {
            tmpMonthPercentage = 100;
        } else {
            tmpMonthPercentage = [tmpMonthQty floatValue] / totalYearQty * 100;
        }
        [tmpFinalResultDict setObject:[NSNumber numberWithFloat:tmpMonthPercentage] forKey:@"Percentage"];
//        [self.monthPieDisplayList addObject:[NSNumber numberWithFloat:tmpMonthPercentage]];
    }
//    self.monthPieNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[self.monthPieDisplayList count]];
//    self.monthPieLabelDisplayList = [NSMutableArray arrayWithArray:self.monthPieDisplayList];
//    for (int i = 0; i < [self.monthPieRawDisplayList count]; i++) {
//        [self.monthPieNullLabelDisplayList addObject:[NSNull null]];
//    }
    [self monthPieFinalResultProcessorWithDataList:finalResultDictList];
}

- (void)processLineRawData:(ArcosGenericReturnObject*)result {
    NSMutableArray* tmpDisplayList = result.ArrayOfData;
    float accumulatedTarget = 0.0;
    float accumulatedActual = 0.0;
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        ArcosGenericClass* tmpArcosGenericClass = [tmpDisplayList objectAtIndex:i];
        [self.lineDetailList addObject:[tmpArcosGenericClass Field1]];
        NSNumber* tmpTarget = [ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:[tmpArcosGenericClass Field2]]]];
        accumulatedTarget += [tmpTarget floatValue];
        NSNumber* tmpActual = [ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:[tmpArcosGenericClass Field3]]]];
        accumulatedActual += [tmpActual floatValue]; 
//        [self.lineTargetList addObject:[NSNumber numberWithFloat:accumulatedTarget]];
        [self.lineTargetList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber numberWithDouble:i], @"x", [NSNumber numberWithFloat:accumulatedTarget], @"y", nil]];
        [self.lineActualList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber numberWithDouble:i], @"x", [NSNumber numberWithFloat:accumulatedActual], @"y", nil]];
        
//        [self.lineActualList addObject:[NSNumber numberWithFloat:accumulatedActual]];
    }
    self.maxOfLineYAxis = [self getMax:self.lineTargetList dataList:self.lineActualList];
}

- (NSNumber*)getMax:(NSMutableArray*)aTargetList dataList:(NSMutableArray*)anActualList {
    NSNumber* lastObjTarget = [[aTargetList lastObject] objectForKey:@"y"];
    NSNumber* lastObjActual = [[anActualList lastObject] objectForKey:@"y"];
    return ([lastObjTarget floatValue] > [lastObjActual floatValue]) ? lastObjTarget : lastObjActual;
}

- (void)tableDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR {
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
    
    self.monthTableDisplayList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    if ([objectsArray count] > 0) {
        self.monthTableFieldNames = [[[ArcosGenericClass alloc] init] autorelease];
    }

    NSMutableArray* auxObjectsArray = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* cellData = [objectsArray objectAtIndex:i];
        if (i == 0) {
            NSDate* dateLastModified = [cellData objectForKey:@"dateLastModified"];
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMM"];
            NSString* myMonthStr = [df stringFromDate:dateLastModified];
            [self.monthTableFieldNames setField15:myMonthStr];
            int monthStep = 0;
            for (int i = 14; i > 2; i--) {
                monthStep--;
                NSDate* tmpDateLastModified = [ArcosUtils addMonths:monthStep date:dateLastModified];
                NSString* tmpMonthStr = [df stringFromDate:tmpDateLastModified];
                NSString* valueFirstMethodName = [NSString stringWithFormat:@"setField%d:",i];
                SEL firstSelector = NSSelectorFromString(valueFirstMethodName);
                [self.monthTableFieldNames performSelector:firstSelector withObject:tmpMonthStr];
            }
            [df release];
        }
        
        NSNumber* productIUR = [cellData objectForKey:@"productIUR"];
        NSDictionary* productDict = [productDictHashMap objectForKey:productIUR];
        NSMutableDictionary* auxCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
        if (productDict != nil) {
            [ProductFormRowConverter addProductInfoToDictionary:auxCellData productDict:productDict];
        } else {
            [ProductFormRowConverter addBlankProductInfoToDictionary:auxCellData];
        }
        [auxObjectsArray addObject:auxCellData];
    }
    NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"OrderPadDetails" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Details" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [auxObjectsArray sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, detailsDescriptor, nil]];
    for (int i = 0; i < [auxObjectsArray count]; i++) {
        NSMutableDictionary* tmpAuxDataDict = [auxObjectsArray objectAtIndex:i];
        ArcosGenericClass* arcosGenericClass = [[ArcosGenericClass alloc] init];
        arcosGenericClass.Field1 = [tmpAuxDataDict objectForKey:@"ProductIUR"];
        arcosGenericClass.Field2 = [tmpAuxDataDict objectForKey:@"Details"];
        arcosGenericClass.Field20 = [tmpAuxDataDict objectForKey:@"OrderPadDetails"];
        arcosGenericClass.Field19 = [tmpAuxDataDict objectForKey:@"ProductCode"];
        arcosGenericClass.Field21 = [tmpAuxDataDict objectForKey:@"ProductSize"];
        int totalValue = 0;
        for (int i = 3; i <= 15 ; i++) {
            int qtyIndex = i + 10;
            NSString* qtyField = [NSString stringWithFormat:@"qty%d", qtyIndex];
            NSString* qtyFieldMethodName = [NSString stringWithFormat:@"objectForKey:"];
            SEL qtySelector = NSSelectorFromString(qtyFieldMethodName);
            NSNumber* qtyValue = [tmpAuxDataDict performSelector:qtySelector withObject:qtyField];
            totalValue += [qtyValue intValue];
            NSString* fieldMethodName = [NSString stringWithFormat:@"setField%d:", i];
            SEL fieldSelector = NSSelectorFromString(fieldMethodName);
            [arcosGenericClass performSelector:fieldSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qtyValue]]];
        }
        arcosGenericClass.Field16 = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalValue]];
        [self.monthTableDisplayList addObject:arcosGenericClass];
        [arcosGenericClass release];
    }
    self.originalMonthTableDisplayList = self.monthTableDisplayList;
    self.originalMonthTableFieldNames = self.monthTableFieldNames;
}

- (void)barDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR {
    NSArray* properties = [NSArray arrayWithObjects:@"sales02", @"sales03",@"sales04",@"sales05", @"sales06",@"sales07",@"sales08",@"sales09",@"sales10",@"sales11",@"sales12", @"sales13",@"sales14",@"sales15",@"sales16",@"sales17",@"sales18",@"sales19",@"sales20",@"sales21",@"sales22",@"sales23",@"sales24",@"sales25",@"dateLastModified",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@", aLocationIUR];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count] == 0) return;
    NSDictionary* cellData = [objectsArray objectAtIndex:0];
    NSDate* dateLastModified = [cellData objectForKey:@"dateLastModified"];
    
    NSMutableArray* sumDataList = [NSMutableArray arrayWithCapacity:24];
    for (int i = 2; i <= 25 ; i++) {
        NSString* qtyField = i < 10 ? [NSString stringWithFormat:@"sales0%d", i] : [NSString stringWithFormat:@"sales%d", i];
        NSString* keyPath = [NSString stringWithFormat:@"@sum.%@",qtyField];
        [sumDataList addObject:[objectsArray valueForKeyPath:keyPath]];
    }
    int monthStep = -12;
    for (int i = 12; i < [sumDataList count]; i++) {
        NSNumber* tySumSales = [sumDataList objectAtIndex:i];
        NSNumber* lySumSales = [sumDataList objectAtIndex:i - 12];
        NSMutableDictionary* tmpDict = [NSMutableDictionary dictionary];
        
        [tmpDict setObject:tySumSales forKey:@"TY"];
        [tmpDict setObject:lySumSales forKey:@"LY"];
        [tmpDict setObject:[NSNumber numberWithFloat:([tySumSales floatValue] - [lySumSales floatValue])] forKey:@"Diff"];
        float diffPercent = 0.0;
        if ([tySumSales intValue] == 0) {
            diffPercent = -100;
            if ([lySumSales intValue] == 0) {
                diffPercent = 0;
            }
        } else if ([lySumSales intValue] == 0) {
            diffPercent = 100;
        } else {
            diffPercent = [tySumSales floatValue] / [lySumSales floatValue] * 100.0;
        }
        
        [tmpDict setObject:[NSNumber numberWithFloat:diffPercent] forKey:@"DiffPercent"];
        monthStep++;
        NSDate* tmpDateLastModified = [ArcosUtils addMonths:monthStep date:dateLastModified];
        [tmpDict setObject:[NSNumber numberWithInteger:[ArcosUtils monthDayWithDate:tmpDateLastModified]] forKey:@"monthNumber"];
        
        [self.tylyBarDisplayList addObject:tmpDict];
    }
    self.maxOfTyBarAxis = [self.tylyBarDisplayList valueForKeyPath:@"@max.TY"];
    self.maxOfLyBarAxis = [self.tylyBarDisplayList valueForKeyPath:@"@max.LY"];
    self.maxOfBarAxis = [self.maxOfTyBarAxis floatValue] > [self.maxOfLyBarAxis floatValue] ? self.maxOfTyBarAxis : self.maxOfLyBarAxis;
}

- (void)pieDataFromLocalWithLocationIUR:(NSNumber*)aLocationIUR levelNumber:(int)aLevelNumber {
    NSArray* properties = [NSArray arrayWithObjects:@"productIUR", @"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",@"dateLastModified",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@", aLocationIUR];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count] == 0) return;
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
    NSMutableArray* auxDataList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    int yearTotalQty = 0;
    NSMutableDictionary* auxDataHashMap = [NSMutableDictionary dictionary];
    NSMutableDictionary* levelCodeProductIURListHashMap = [NSMutableDictionary dictionary];
    for (NSDictionary* aLocationProductMATDict in objectsArray) {
        NSMutableDictionary* auxLocationProductMAT = [NSMutableDictionary dictionaryWithDictionary:aLocationProductMATDict];
        NSNumber* productIUR = [auxLocationProductMAT objectForKey:@"productIUR"];
        NSDictionary* productDict = [productDictHashMap objectForKey:productIUR];
        if (productDict != nil) {
            [auxLocationProductMAT setObject:[productDict objectForKey:@"Description"] forKey:@"Details"];
        } else {
            [auxLocationProductMAT setObject:@"Product not found" forKey:@"Details"];
            NSMutableArray* auxProductIURList = [levelCodeProductIURListHashMap objectForKey:self.pnfDescrDetailCode];
            if (auxProductIURList == nil) {
                auxProductIURList = [NSMutableArray array];
            }
            [auxProductIURList addObject:productIUR];
            [levelCodeProductIURListHashMap setObject:auxProductIURList forKey:self.pnfDescrDetailCode];
        }
        int totalQty = 0;
        for (int i = 3; i <= 15 ; i++) {
            int qtyIndex = i + 10;
            NSString* qtyField = [NSString stringWithFormat:@"qty%d", qtyIndex];
            NSString* qtyFieldMethodName = [NSString stringWithFormat:@"objectForKey:"];
            SEL qtySelector = NSSelectorFromString(qtyFieldMethodName);
            NSNumber* qtyValue = [auxLocationProductMAT performSelector:qtySelector withObject:qtyField];
            totalQty += [qtyValue intValue];
        }
        yearTotalQty += totalQty;
        [auxLocationProductMAT setObject:[NSNumber numberWithInt:totalQty] forKey:@"total"];
        [auxDataList addObject:auxLocationProductMAT];
        [auxDataHashMap setObject:auxLocationProductMAT forKey:[auxLocationProductMAT objectForKey:@"productIUR"]];
    }
//    NSLog(@"cc %d yearTotalQty:%d", aLevelNumber, yearTotalQty);
    
    if (aLevelNumber > 0 && aLevelNumber < 6) {
        NSString* descrTypeCode = [NSString stringWithFormat:@"L%d", aLevelNumber];
        NSString* levelCode = [NSString stringWithFormat:@"L%dCode", aLevelNumber];
        for (int i = 0; i < [productDictList count]; i++) {
            NSDictionary* productDict = [productDictList objectAtIndex:i];
            NSString* auxDescrDetailCode = [productDict objectForKey:levelCode];
            NSMutableArray* auxProductIURList = [levelCodeProductIURListHashMap objectForKey:auxDescrDetailCode];
            if (auxProductIURList == nil) {
                auxProductIURList = [NSMutableArray array];
            }
            [auxProductIURList addObject:[productDict objectForKey:@"ProductIUR"]];
            [levelCodeProductIURListHashMap setObject:auxProductIURList forKey:auxDescrDetailCode];
        }
//        NSLog(@"aa %@", levelCodeProductIURListHashMap);
        NSArray* keyList = [levelCodeProductIURListHashMap allKeys];
        NSMutableDictionary* levelCodeQtyHashMap = [NSMutableDictionary dictionary];
        for (int i = 0; i < [keyList count]; i++) {
            NSString* descrDetailCode = [keyList objectAtIndex:i];
            NSMutableArray* auxProductIURList = [levelCodeProductIURListHashMap objectForKey:descrDetailCode];
            int totalSum = 0;
            for (int j = 0; j < [auxProductIURList count]; j++) {
                NSNumber* auxProductIUR = [auxProductIURList objectAtIndex:j];
                NSMutableDictionary* auxLocationProductMAT = [auxDataHashMap objectForKey:auxProductIUR];
                totalSum += [[auxLocationProductMAT objectForKey:@"total"] intValue];
            }
            [levelCodeQtyHashMap setObject:[NSNumber numberWithInt:totalSum] forKey:descrDetailCode];
        }
//        NSLog(@"bb %@", levelCodeQtyHashMap);
        NSMutableArray* descrDetailDictList = [self descrDetailWithDescrDetailCodeList:keyList descrTypeCode:descrTypeCode];
        NSMutableDictionary* descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
        for (int i = 0; i < [descrDetailDictList count]; i++) {
            NSDictionary* auxDescrDetailDict = [descrDetailDictList objectAtIndex:i];
            [descrDetailDictHashMap setObject:auxDescrDetailDict forKey:[auxDescrDetailDict objectForKey:@"DescrDetailCode"]];
        }
        NSMutableArray* finalResultDictList = [NSMutableArray arrayWithCapacity:[keyList count]];
        for (int i = 0; i < [keyList count]; i++) {
            NSMutableDictionary* finalResultDict = [NSMutableDictionary dictionary];            
            NSString* auxDescrDetailCode = [keyList objectAtIndex:i];
            [finalResultDict setObject:auxDescrDetailCode forKey:@"DescrDetailCode"];
            NSDictionary* auxDescrDetailDict = [descrDetailDictHashMap objectForKey:auxDescrDetailCode];
            if (auxDescrDetailDict != nil) {                
                [finalResultDict setObject:[auxDescrDetailDict objectForKey:@"Detail"] forKey:@"Detail"];                
            } else {
                [finalResultDict setObject:@"Product Group not found" forKey:@"Detail"];
            }
            if ([auxDescrDetailCode isEqualToString:self.pnfDescrDetailCode]) {
                [finalResultDict setObject:self.pnfDetail forKey:@"Detail"];
            }
            [finalResultDictList addObject:finalResultDict];
        }
        NSSortDescriptor* detailDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Detail" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [finalResultDictList sortUsingDescriptors:[NSArray arrayWithObjects:detailDescriptor, nil]];
        
//        self.monthPieNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[auxDataList count]];
        for (NSMutableDictionary* tmpFinalResultDict in finalResultDictList) {
//            [self.monthPieLegendList addObject:[tmpFinalResultDict objectForKey:@"Detail"]];
            NSNumber* tmpTotalSum = [levelCodeQtyHashMap objectForKey:[tmpFinalResultDict objectForKey:@"DescrDetailCode"]];
            float tmpMonthPercentage = 0;
            if (yearTotalQty == 0) {
                tmpMonthPercentage = 100;
            } else {
                tmpMonthPercentage = [tmpTotalSum floatValue] / yearTotalQty * 100;
            }
            
//            [self.monthPieDisplayList addObject:[NSNumber numberWithFloat:tmpMonthPercentage]];
//            [self.monthPieNullLabelDisplayList addObject:[NSNull null]];
            [tmpFinalResultDict setObject:[tmpFinalResultDict objectForKey:@"Detail"] forKey:@"StdTitle"];
            [tmpFinalResultDict setObject:[NSNumber numberWithFloat:tmpMonthPercentage] forKey:@"Percentage"];
        }
        /*
        NSSortDescriptor* percentageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Percentage" ascending:NO selector:@selector(compare:)] autorelease];
        [finalResultDictList sortUsingDescriptors:[NSArray arrayWithObjects:percentageDescriptor, nil]];
        int auxArrayCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[finalResultDictList count]];
        int auxCompositeResultListCount = auxArrayCount;
        int arrayCountBiggerThanNornalBarCountFlag = NO;
        if (auxArrayCount > self.monthPieNormalBarCount) {
            auxArrayCount = self.monthPieNormalBarCount;
            arrayCountBiggerThanNornalBarCountFlag = YES;
            auxCompositeResultListCount = auxArrayCount + 1;
        }
        float otherTotalPercentage = 0.0;
        if (arrayCountBiggerThanNornalBarCountFlag) {
            for (int i = self.monthPieNormalBarCount; i < [finalResultDictList count]; i++) {
                NSMutableDictionary* tmpFinalResultDict = [finalResultDictList objectAtIndex:i];
                otherTotalPercentage += [[tmpFinalResultDict objectForKey:@"Percentage"] floatValue];
            }
        }
        NSMutableArray* auxCompositeResultList = [NSMutableArray arrayWithCapacity:auxCompositeResultListCount];
        for (int i = 0; i < auxArrayCount; i++) {
            [auxCompositeResultList addObject:[finalResultDictList objectAtIndex:i]];
        }
        NSSortDescriptor* compositePercentageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Percentage" ascending:YES selector:@selector(compare:)] autorelease];
        [auxCompositeResultList sortUsingDescriptors:[NSArray arrayWithObjects:compositePercentageDescriptor, nil]];
        if (arrayCountBiggerThanNornalBarCountFlag) {
            NSMutableDictionary* otherResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [otherResultDict setObject:@"Other" forKey:@"StdTitle"];
            [otherResultDict setObject:[NSNumber numberWithFloat:otherTotalPercentage] forKey:@"Percentage"];
            [auxCompositeResultList insertObject:otherResultDict atIndex:0];
        }
        self.monthPieCompositeResultList = [NSMutableArray arrayWithArray:auxCompositeResultList];
        self.monthPieDisplayList = [NSMutableArray arrayWithCapacity:[self.monthPieCompositeResultList count]];
        self.monthPieNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[self.monthPieCompositeResultList count]];
        self.monthPieLegendList = [NSMutableArray arrayWithCapacity:[self.monthPieCompositeResultList count]];
        for (int i = 0; i < [self.monthPieCompositeResultList count]; i++) {
            NSMutableDictionary* tmpDict = [self.monthPieCompositeResultList objectAtIndex:i];
            [self.monthPieLegendList addObject:[tmpDict objectForKey:@"StdTitle"]];
            [self.monthPieDisplayList addObject:[tmpDict objectForKey:@"Percentage"]];
            [self.monthPieNullLabelDisplayList addObject:[NSNull null]];
        }
        self.monthPieLabelDisplayList = [NSMutableArray arrayWithArray:self.monthPieDisplayList];
         */
        [self monthPieFinalResultProcessorWithDataList:finalResultDictList];
//        NSLog(@"TEST %@", self.monthPieLabelDisplayList);
//        NSLog(@"TESTa %@", self.monthPieDisplayList);
    } else {
        NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Details" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [auxDataList sortUsingDescriptors:[NSArray arrayWithObjects:detailsDescriptor, nil]];
//        self.monthPieNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[auxDataList count]];
        for (NSMutableDictionary* tmpLocationProductMATDict in auxDataList) {
//            [self.monthPieLegendList addObject:[tmpLocationProductMATDict objectForKey:@"Details"]];
            NSNumber* tmpMonthQty = [tmpLocationProductMATDict objectForKey:@"total"];
            float tmpMonthPercentage = 0;
            if (yearTotalQty == 0) {
                tmpMonthPercentage = 100;
            } else {
                tmpMonthPercentage = [tmpMonthQty floatValue] / yearTotalQty * 100;
            }
            
//            [self.monthPieDisplayList addObject:[NSNumber numberWithFloat:tmpMonthPercentage]];
//            [self.monthPieNullLabelDisplayList addObject:[NSNull null]];
            [tmpLocationProductMATDict setObject:[tmpLocationProductMATDict objectForKey:@"Details"] forKey:@"StdTitle"];
            [tmpLocationProductMATDict setObject:[NSNumber numberWithFloat:tmpMonthPercentage] forKey:@"Percentage"];
        }
//        self.monthPieLabelDisplayList = [NSMutableArray arrayWithArray:self.monthPieDisplayList];
        [self monthPieFinalResultProcessorWithDataList:auxDataList];
    }    
}

- (void)monthPieFinalResultProcessorWithDataList:(NSMutableArray*)aFinalResultDictList {
    NSSortDescriptor* percentageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Percentage" ascending:NO selector:@selector(compare:)] autorelease];
    [aFinalResultDictList sortUsingDescriptors:[NSArray arrayWithObjects:percentageDescriptor, nil]];
    int auxArrayCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[aFinalResultDictList count]];
    int auxCompositeResultListCount = auxArrayCount;
    int arrayCountBiggerThanNornalBarCountFlag = NO;
    if (auxArrayCount > self.monthPieNormalBarCount) {
        auxArrayCount = self.monthPieNormalBarCount;
        arrayCountBiggerThanNornalBarCountFlag = YES;
        auxCompositeResultListCount = auxArrayCount + 1;
    }
    float otherTotalPercentage = 0.0;
    if (arrayCountBiggerThanNornalBarCountFlag) {
        for (int i = self.monthPieNormalBarCount; i < [aFinalResultDictList count]; i++) {
            NSMutableDictionary* tmpFinalResultDict = [aFinalResultDictList objectAtIndex:i];
            otherTotalPercentage += [[tmpFinalResultDict objectForKey:@"Percentage"] floatValue];
        }
    }
    NSMutableArray* auxCompositeResultList = [NSMutableArray arrayWithCapacity:auxCompositeResultListCount];
    for (int i = 0; i < auxArrayCount; i++) {
        [auxCompositeResultList addObject:[aFinalResultDictList objectAtIndex:i]];
    }
//    NSSortDescriptor* compositePercentageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Percentage" ascending:YES selector:@selector(compare:)] autorelease];
//    [auxCompositeResultList sortUsingDescriptors:[NSArray arrayWithObjects:compositePercentageDescriptor, nil]];
    if (arrayCountBiggerThanNornalBarCountFlag) {
        NSMutableDictionary* otherResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [otherResultDict setObject:@"Other" forKey:@"StdTitle"];
        [otherResultDict setObject:[NSNumber numberWithFloat:otherTotalPercentage] forKey:@"Percentage"];
//        [auxCompositeResultList insertObject:otherResultDict atIndex:0];
        [auxCompositeResultList addObject:otherResultDict];
    }
//    self.monthPieCompositeResultList = [NSMutableArray arrayWithArray:auxCompositeResultList];
    self.monthPieDisplayList = [NSMutableArray arrayWithCapacity:[auxCompositeResultList count]];
    self.monthPieNullLabelDisplayList = [NSMutableArray arrayWithCapacity:[auxCompositeResultList count]];
    self.monthPieLegendList = [NSMutableArray arrayWithCapacity:[auxCompositeResultList count]];
    for (int i = 0; i < [auxCompositeResultList count]; i++) {
        NSMutableDictionary* tmpDict = [auxCompositeResultList objectAtIndex:i];
        [self.monthPieLegendList addObject:[tmpDict objectForKey:@"StdTitle"]];
        [self.monthPieDisplayList addObject:[tmpDict objectForKey:@"Percentage"]];
        [self.monthPieNullLabelDisplayList addObject:[NSNull null]];
    }
    self.monthPieLabelDisplayList = [NSMutableArray arrayWithArray:self.monthPieDisplayList];
}

- (NSMutableArray*)descrDetailWithDescrDetailCodeList:(NSArray*)aDescrDetailCodeList descrTypeCode:(NSString*)aDescrTypeCode {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = %@ and DescrDetailCode in %@", aDescrTypeCode, aDescrDetailCodeList];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"ImageIUR", @"Detail", @"DescrDetailCode", nil];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];    
}

@end
