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
//        self.com
        
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
//    [self.displayList addObject:[self createIURCellDataWithCellKey:<#(NSString *)#> fieldData:<#(NSMutableDictionary *)#>]];
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


@end
