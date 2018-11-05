//
//  MeetingDetailsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingDetailsDataManager.h"

@implementation MeetingDetailsDataManager
@synthesize displayList = _displayList;

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:9];
    [self.displayList addObject:[self createDateTimeCell]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Code"]];
    [self.displayList addObject:[self createLocationCellWithFieldName:@"Venue"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Status"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Type"]];
    [self.displayList addObject:[self createIURCellWithFieldName:@"Style"]];
    [self.displayList addObject:[self createStringCellWithFieldName:@"Title"]];
    [self.displayList addObject:[self createEmployeeCellWithFieldName:@"Operator"]];
    [self.displayList addObject:[self createTextViewCellWithFieldName:@"Comments"]];
}

- (NSMutableDictionary*)createDateTimeCell {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [tmpDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createStringCellWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createLocationCellWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDataDict setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createEmployeeCellWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDataDict setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createTextViewCellWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDataDict setObject:[NSNumber numberWithInt:5] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createIURCellWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmpDataDict setObject:[NSNumber numberWithInt:6] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    return tmpDataDict;
}

@end
