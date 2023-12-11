//
//  SavedIarcosOrderDetailCallDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailCallDataManager.h"

@implementation SavedIarcosOrderDetailCallDataManager

- (void)createAllSectionData {
    [self createCallContactSectionData];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] disableMemoFlag]) {
        [self createCallMemoSectionData];
    }    
    [self createDrillDownSectionDataWithSectionTitle:@"Call Details" orderHeaderType:[NSNumber numberWithInt:2]];
}

- (void)createCallContactSectionData {
    NSString* sectionTitle = @"Contact";
    [self.sectionTitleList addObject:sectionTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* contactDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"contact"]];
    [contactDict setObject:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"contactText"]] forKey:self.titleKey];
    NSMutableDictionary* contactCellDict = [self createWriteCellDataWithCellKey:@"contact" fieldNameLabel:@"Contact" writeType:[NSNumber numberWithInt:7] fieldData:contactDict];
    [contactCellDict setObject:[ArcosUtils convertNilToZero:[self.orderHeader objectForKey:@"LocationIUR"]] forKey:@"LocationIUR"];
    
    [contactDisplayList addObject:contactCellDict];
    [contactDisplayList addObject:[self createDateHourMinLabelCellDataWithCellKey:@"orderDate" fieldNameLabel:@"Date" writeType:[NSNumber numberWithInt:1]]];
    NSMutableDictionary* callTypeDict = [NSMutableDictionary dictionaryWithDictionary:[self.orderHeader objectForKey:@"callType"]];
    [callTypeDict setObject:[self.orderHeader objectForKey:@"callTypeText"] forKey:self.titleKey];
    [contactDisplayList addObject:[self createWriteCellDataWithCellKey:@"callType" fieldNameLabel:@"Call Type" writeType:[NSNumber numberWithInt:6] fieldData:callTypeDict]];
    [contactDisplayList addObject:[self createReadLabelCellDataWithCellKey:@"EmployeeIUR" fieldNameLabel:@"Employee" fieldData:[self employeeName:[self.orderHeader objectForKey:@"EmployeeIUR"]]]];
    
    [self.groupedDataDict setObject:contactDisplayList forKey:sectionTitle];
}

@end
