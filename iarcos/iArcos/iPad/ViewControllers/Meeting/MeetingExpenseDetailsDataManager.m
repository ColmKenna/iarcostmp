//
//  MeetingExpenseDetailsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseDetailsDataManager.h"

@implementation MeetingExpenseDetailsDataManager
@synthesize displayList = _displayList;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.iur = @"IUR";
        self.exType = @"ExType";
        self.expDate = @"ExpDate";
        self.comments = @"Comments";
        self.totalAmount = @"TotalAmount";
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.iur = nil;
    self.exType = nil;
    self.expDate = nil;
    self.comments = nil;
    self.totalAmount = nil;
    
    [super dealloc];
}

- (void)createSkeletonData {
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* iurCellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [iurCellData setObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"];
    [iurCellData setObject:@"Tap for Expense Type" forKey:@"Title"];
    [self.displayList addObject:[self createIURCellDataWithCellKey:self.iur fieldData:iurCellData]];
    [self.displayList addObject:[self createDateCellDataWithCellKey:self.expDate fieldData:[NSDate date]]];
    [self.displayList addObject:[self createTextCellDataWithCellKey:self.comments fieldData:@""]];
    [self.displayList addObject:[self createDecimalCellDataWithCellKey:self.totalAmount fieldData:@""]];
}

- (NSMutableDictionary*)createIURCellDataWithCellKey:(NSString*)aCellKey fieldData:(NSMutableDictionary*)aFieldData {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:aCellKey forKey:@"CellKey"];
    [cellDataDict setObject:aFieldData forKey:@"FieldData"];
    [cellDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    return cellDataDict;
}

- (NSMutableDictionary*)createDateCellDataWithCellKey:(NSString*)aCellKey fieldData:(NSDate*)aFieldData {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:aCellKey forKey:@"CellKey"];    
    [cellDataDict setObject:aFieldData forKey:@"FieldData"];
    [cellDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    return cellDataDict;
}

- (NSMutableDictionary*)createTextCellDataWithCellKey:(NSString*)aCellKey fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:aCellKey forKey:@"CellKey"];
    [cellDataDict setObject:aFieldData forKey:@"FieldData"];
    [cellDataDict setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    return cellDataDict;
}

- (NSMutableDictionary*)createDecimalCellDataWithCellKey:(NSString*)aCellKey fieldData:(NSString*)aFieldData {
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:aCellKey forKey:@"CellKey"];
    [cellDataDict setObject:aFieldData forKey:@"FieldData"];
    [cellDataDict setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    return cellDataDict;
}

- (void)dataInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [cellDataDict setObject:aData forKey:@"FieldData"];    
}


@end
