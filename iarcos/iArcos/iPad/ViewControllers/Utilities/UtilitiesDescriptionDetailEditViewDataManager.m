//
//  UtilitiesDescriptionDetailEditViewDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailEditViewDataManager.h"

@implementation UtilitiesDescriptionDetailEditViewDataManager
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize tableCellData = _tableCellData;
@synthesize isNewRecord = _isNewRecord;
@synthesize dbFieldNameList = _dbFieldNameList;
@synthesize updatedFieldNameList = _updatedFieldNameList;
@synthesize updatedFieldValueList = _updatedFieldValueList;
@synthesize createFieldValueList = _createFieldValueList;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray arrayWithCapacity:4];
        self.originalDisplayList = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 2; i++) {
            [self createTemplateWithCellValue:@""];            
        }
        [self createTemplateWithCellValue:[NSNumber numberWithInt:1]];
        [self createTemplateWithCellValue:[NSNumber numberWithInt:0]];        
        
        self.isNewRecord = YES;
        self.dbFieldNameList = [NSMutableArray arrayWithObjects:@"DescrDetailCode", @"Detail", @"Active", @"ForDetailing", nil];
    }
    return self;
}

-(void)createTemplateWithCellValue:(id)aCellValue {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:aCellValue forKey:@"contentString"];
    [cellData setObject:aCellValue forKey:@"actualContent"];
    NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [self.displayList addObject:cellData];
    [self.originalDisplayList addObject:originalCellData];
}

-(void)processRawData:(NSMutableDictionary*)aCellData {
    self.isNewRecord = NO;
//    NSLog(@"aCellData: %@", aCellData);
    [self createTextCellValue:[aCellData objectForKey:@"DescrDetailCode"] withIndex:0];
    [self createTextCellValue:[aCellData objectForKey:@"Detail"] withIndex:1];
    [self createNumberCellValue:[aCellData objectForKey:@"Active"] withIndex:2];
    [self createNumberCellValue:[aCellData objectForKey:@"ForDetailing"] withIndex:3];    
}

-(void)createTextCellValue:(NSString*)aCellValue withIndex:(int)anIndex {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndex];
    NSString* cellContentData = [ArcosUtils convertNilToEmpty:aCellValue];    
    [cellData setObject:cellContentData forKey:@"contentString"];
    [cellData setObject:cellContentData forKey:@"actualContent"];
    NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [self.originalDisplayList replaceObjectAtIndex:anIndex withObject:originalCellData];
    [self.displayList replaceObjectAtIndex:anIndex withObject:cellData];
}

-(void)createNumberCellValue:(NSNumber*)aCellValue withIndex:(int)anIndex {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndex];
    [cellData setObject:aCellValue forKey:@"contentString"];
    [cellData setObject:aCellValue forKey:@"actualContent"];
    NSMutableDictionary* originalCellData = [NSMutableDictionary dictionaryWithDictionary:cellData];
    [self.originalDisplayList replaceObjectAtIndex:anIndex withObject:originalCellData];
    [self.displayList replaceObjectAtIndex:anIndex withObject:cellData];
}

-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aContentString forKey:@"contentString"];
    [cellData setObject:anActualContent forKey:@"actualContent"];
    [self.displayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
//    NSLog(@"self.displayList is : %@", self.displayList);
}

- (void) dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.originalDisplayList != nil) { self.originalDisplayList = nil; }
    if (self.tableCellData != nil) { self.tableCellData = nil; }
    if (self.dbFieldNameList != nil) { self.dbFieldNameList = nil; }       
    if (self.updatedFieldNameList != nil) { self.updatedFieldNameList = nil; }
    if (self.updatedFieldValueList != nil) { self.updatedFieldValueList = nil; }
    if (self.createFieldValueList != nil) { self.createFieldValueList = nil; }
    
    [super dealloc];
}

-(void)getChangedDataList {
    self.updatedFieldNameList = [NSMutableArray array];
    self.updatedFieldValueList = [NSMutableArray array];
//    NSLog(@"displayList: %@", self.displayList);
//    NSLog(@"originalDisplayList: %@", self.originalDisplayList);
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellData = [self.displayList objectAtIndex:i];
        NSMutableDictionary* originalCellData = [self.originalDisplayList objectAtIndex:i];
        id contentString = [cellData objectForKey:@"contentString"];
        if ([contentString isKindOfClass:[NSString class]]) {
            if (![contentString isEqualToString:[originalCellData objectForKey:@"contentString"]]) {
                [self.updatedFieldNameList addObject:[self.dbFieldNameList objectAtIndex:i]];
                [self.updatedFieldValueList addObject:[cellData objectForKey:@"actualContent"]];
            }
        } else if([contentString isKindOfClass:[NSNumber class]]) {
            if (![contentString isEqualToNumber:[originalCellData objectForKey:@"contentString"]]) {
                [self.updatedFieldNameList addObject:[self.dbFieldNameList objectAtIndex:i]];
                [self.updatedFieldValueList addObject:[cellData objectForKey:@"actualContent"]];
            }
        }        
    }
}

- (void)prepareForCreateProcess {
    self.createFieldValueList = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellData = [self.displayList objectAtIndex:i];
        [self.createFieldValueList addObject:[cellData objectForKey:@"actualContent"]];
    }    
}



@end
