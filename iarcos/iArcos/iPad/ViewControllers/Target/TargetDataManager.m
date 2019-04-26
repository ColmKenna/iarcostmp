//
//  TargetDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetDataManager.h"

@implementation TargetDataManager
@synthesize displayList = _displayList;
@synthesize monthMapDict = _monthMapDict;

- (instancetype)init {
    self = [super init]; 
    if (self) {
        NSMutableArray* monthMapValueList = [NSMutableArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May",@"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
        NSMutableArray* monthMapKeyList = [NSMutableArray arrayWithCapacity:8];
        for (int i = 1; i <= 12; i++) {
            [monthMapKeyList addObject:[NSNumber numberWithInt:i]];
        }    
        self.monthMapDict = [NSDictionary dictionaryWithObjects:monthMapValueList forKeys:monthMapKeyList];
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.monthMapDict = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray array];
}

- (void)removeData {
    self.displayList = [NSMutableArray array];
}

- (void)processRawData:(ArcosArrayOfEmployeeTargets*)aDataList {
    self.displayList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosEmployeeTargets* arcosEmployeeTargets = [aDataList objectAtIndex:i];
        NSString* auxTitle = [ArcosUtils convertNilToEmpty:arcosEmployeeTargets.Title];
        NSNumber* cellType = [NSNumber numberWithInt:0];
        @try {
            NSString* tmpCellTypeString = [auxTitle substringToIndex:1];
            if (![ArcosValidator isInteger:tmpCellTypeString]) continue;
            cellType = [ArcosUtils convertStringToNumber:tmpCellTypeString];
            switch ([cellType intValue]) {
                case 2: {
                    [self addResultDataItemDictWithCellType:[NSNumber numberWithInt:0] title:auxTitle data:arcosEmployeeTargets];
                    [self addResultDataItemDictWithCellType:[NSNumber numberWithInt:1] title:auxTitle data:arcosEmployeeTargets];
                }                    
                    break;                    
                default: {
                    [self addResultDataItemDictWithCellType:cellType title:auxTitle data:arcosEmployeeTargets];
                }
                    break;
            }
        }
        @catch(NSException* exception) {
//            NSLog(@"%@", [exception reason]);
        }
    }
    
}

- (void)processG1RawData:(ArcosDashBoardData*)anArcosDashBoardData {
    @try {
        NSMutableArray* dashBoardDataRows = anArcosDashBoardData.Rows;
        NSString* g1Title = @"";
        NSMutableArray* narrativeList = [NSMutableArray array];
        NSMutableArray* valueList = [NSMutableArray array];
        for (int i = 0; i < [dashBoardDataRows count]; i++) {
            ArcosDashBoardRowData* tmpArcosDashBoardRowData = [dashBoardDataRows objectAtIndex:i];
            NSMutableArray* detailList = tmpArcosDashBoardRowData.Detail;
            if ([tmpArcosDashBoardRowData.Title isEqualToString:@"ReportTitle"]) {
                g1Title = [ArcosUtils convertNilToEmpty:[detailList objectAtIndex:0]];
            }
            if ([tmpArcosDashBoardRowData.Title isEqualToString:@"Details"]) {
                for (int m = 0; m < [tmpArcosDashBoardRowData.Detail count]; m++) {
                    [narrativeList addObject:[ArcosUtils convertNilToEmpty:[tmpArcosDashBoardRowData.Detail objectAtIndex:m]]];
                }
            }
            if ([tmpArcosDashBoardRowData.Title isEqualToString:@"Value"]) {
                for (int n = 0; n < [tmpArcosDashBoardRowData.Detail count]; n++) {
                    [valueList addObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:[tmpArcosDashBoardRowData.Detail objectAtIndex:n]]]];
                }
            }
        }
        if ([narrativeList count] == 0 || [narrativeList count] != [valueList count]) return;
        NSMutableArray* auxDataList = [NSMutableArray array];
        for (int i = 0; i < [narrativeList count]; i++) {
            [auxDataList addObject:[self createG1DataItem:[narrativeList objectAtIndex:i] value:[valueList objectAtIndex:i]]];
        }
        NSSortDescriptor* valueDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Value" ascending:YES] autorelease];
        [auxDataList sortUsingDescriptors:[NSArray arrayWithObjects:valueDescriptor,nil]];
        [self.displayList addObject:[self createG1DataWithTitle:g1Title subTitle:@"Feb 2019" dataList:auxDataList]];
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

- (void)addResultDataItemDictWithCellType:(NSNumber*)aCellType title:(NSString*)anAuxTitle data:(ArcosEmployeeTargets*)anArcosEmployeeTargets {
    @try {
        NSString* resultTitle = [anAuxTitle substringFromIndex:1];
        NSNumber* auxActualNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.CurrentActual];
        NSNumber* auxTargetNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.CurrentTarget];
        NSNumber* auxYtdActualNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.YtdActual];
        NSNumber* auxYtdTargetNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.ytdTarget];
        NSString* auxDescription = [NSString stringWithFormat:@"%@ for %@", [ArcosUtils trim:[ArcosUtils convertNilToEmpty:anArcosEmployeeTargets.TargetFieldUsed]], [ArcosUtils trim:[ArcosUtils convertNilToEmpty:anArcosEmployeeTargets.Description]]];
        NSNumber* auxDaysGoneNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.DaysGone];
        NSNumber* auxDaysTotalNumber = [NSNumber numberWithInt:anArcosEmployeeTargets.WorkDays];
        NSNumber* auxDaysLeftNumber = [NSNumber numberWithInt:[auxDaysTotalNumber intValue] - [auxDaysGoneNumber intValue]];
        NSNumber* auxNumberOfItems = [NSNumber numberWithInt:anArcosEmployeeTargets.NumberOfItems];
        NSNumber* auxCurrentPeriod = [NSNumber numberWithInt:anArcosEmployeeTargets.CurrentPeriod];
        NSMutableArray* yearActualTargetDataList = [NSMutableArray arrayWithCapacity:[auxNumberOfItems intValue]];
        for (int j = 0; j < [auxNumberOfItems intValue]; j++) {
            NSNumber* auxChildActualNumber = [anArcosEmployeeTargets.Actuals objectAtIndex:j];
            NSNumber* auxChildTargetNumber = [anArcosEmployeeTargets.Targets objectAtIndex:j];
            ArcosTargetDetail* auxArcosTargetDetail = [anArcosEmployeeTargets.TargetDetails objectAtIndex:j];
            NSString* monthTitle = @"";
            @try {
                monthTitle = [auxArcosTargetDetail.Description substringToIndex:3];
            }
            @catch(NSException* exception) {
                
            }
            [yearActualTargetDataList addObject:[self creataBarDataItemWithActual:auxChildActualNumber target:auxChildTargetNumber monthTitle:monthTitle]];
        }
        NSMutableDictionary* resultDataItemDict = [self createDataItemWithActual:auxActualNumber target:auxTargetNumber ytdActual:auxYtdActualNumber ytdTarget:auxYtdTargetNumber title:resultTitle description:auxDescription daysGone:auxDaysGoneNumber daysLeft:auxDaysLeftNumber cellType:aCellType numberOfItems:auxNumberOfItems currentPeriod:auxCurrentPeriod yearActualTargetDataList:yearActualTargetDataList];
        [self.displayList addObject:resultDataItemDict];
    }
    @catch(NSException* exception) {
        
    }    
}

- (NSMutableDictionary*)createDataItemWithActual:(NSNumber*)anActualNumber target:(NSNumber*)aTargetNumber ytdActual:(NSNumber*)aYtdActualNumber ytdTarget:(NSNumber*)aYtdTargetNumber title:(NSString*)aTitle description:(NSString*)aDescription daysGone:(NSNumber*)aDaysGone daysLeft:(NSNumber*)aDaysLeft cellType:(NSNumber*)aCellType numberOfItems:(NSNumber*)aNumberOfItems currentPeriod:(NSNumber*)aCurrentPeriod yearActualTargetDataList:(NSMutableArray*)aYearActualTargetDataList {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:12];
    [cellData setObject:anActualNumber forKey:@"Actual"];
    [cellData setObject:aTargetNumber forKey:@"Target"];
    [cellData setObject:aYtdActualNumber forKey:@"YtdActual"];
    [cellData setObject:aYtdTargetNumber forKey:@"YtdTarget"];
    [cellData setObject:aTitle forKey:@"Title"];
    [cellData setObject:aDescription forKey:@"Description"];
    [cellData setObject:aDaysGone forKey:@"DaysGone"];
    [cellData setObject:aDaysLeft forKey:@"DaysLeft"];
    [cellData setObject:aCellType forKey:@"CellType"];
    [cellData setObject:aNumberOfItems forKey:@"NumberOfItems"];
    [cellData setObject:aCurrentPeriod forKey:@"CurrentPeriod"];
    [cellData setObject:aYearActualTargetDataList forKey:@"DataList"];
    
    return cellData;
}

- (NSMutableDictionary*)creataBarDataItemWithActual:(NSNumber*)anActual target:(NSNumber*)aTarget monthTitle:(NSString*)aMonthTitle {
    NSMutableDictionary* barDataItem = [NSMutableDictionary dictionaryWithCapacity:3];
    [barDataItem setObject:anActual forKey:@"Actual"];
    [barDataItem setObject:aTarget forKey:@"Target"];
    [barDataItem setObject:aMonthTitle forKey:@"Month"];    
    return barDataItem;
}

- (NSMutableDictionary*)createG1DataWithTitle:(NSString*)aTitle subTitle:(NSString*)aSubTitle dataList:(NSMutableArray*)aDataList {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellData setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    [cellData setObject:aTitle forKey:@"Title"];
    [cellData setObject:aSubTitle forKey:@"SubTitle"];
    [cellData setObject:aDataList forKey:@"DataList"];
    
    return cellData;
}

- (NSMutableDictionary*)createG1DataItem:(NSString*)aNarrative value:(NSNumber*)aValue {
    NSMutableDictionary* dataItem = [NSMutableDictionary dictionaryWithCapacity:2];
    [dataItem setObject:aNarrative forKey:@"Narrative"];
    [dataItem setObject:aValue forKey:@"Value"];
    
    return dataItem;
}

@end
