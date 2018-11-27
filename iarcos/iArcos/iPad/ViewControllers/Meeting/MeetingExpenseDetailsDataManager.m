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
@synthesize headOfficeDataObjectDict = _headOfficeDataObjectDict;
@synthesize iurKey = _iurKey;
@synthesize exTypeKey = _exTypeKey;
@synthesize expDateKey = _expDateKey;
@synthesize commentsKey = _commentsKey;
@synthesize totalAmountKey = _totalAmountKey;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.iurKey = @"IUR";
        self.exTypeKey = @"ExType";
        self.expDateKey = @"ExpDate";
        self.commentsKey = @"Comments";
        self.totalAmountKey = @"TotalAmount";
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.iurKey = nil;
    self.exTypeKey = nil;
    self.expDateKey = nil;
    self.commentsKey = nil;
    self.totalAmountKey = nil;
    self.headOfficeDataObjectDict = nil;
    
    [super dealloc];
}

- (void)createSkeletonData {
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary* exTypeDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [exTypeDataDict setObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"];
    [exTypeDataDict setObject:@"Tap for Expense Type" forKey:@"Title"];
    [self.displayList addObject:[self createIURCellDataWithCellKey:self.exTypeKey fieldData:exTypeDataDict]];
    [self.displayList addObject:[self createDateCellDataWithCellKey:self.expDateKey fieldData:[NSDate date]]];
    [self.displayList addObject:[self createTextCellDataWithCellKey:self.commentsKey fieldData:@""]];
    [self.displayList addObject:[self createDecimalCellDataWithCellKey:self.totalAmountKey fieldData:@""]];
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

- (void)displayListHeadOfficeAdaptor {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:i];
        NSString* auxCellKey = [cellDataDict objectForKey:@"CellKey"];
        [self.headOfficeDataObjectDict setObject:[cellDataDict objectForKey:@"FieldData"] forKey:auxCellKey];
    }
}


@end
