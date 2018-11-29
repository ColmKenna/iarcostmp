//
//  MeetingBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseDataManager.h"

@implementation MeetingBaseDataManager
@synthesize meetingCellKeyDefinition = _meetingCellKeyDefinition;
@synthesize headOfficeDataObjectDict = _headOfficeDataObjectDict;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.meetingCellKeyDefinition = [[[MeetingCellKeyDefinition alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.meetingCellKeyDefinition = nil;
    self.headOfficeDataObjectDict = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    
}

- (NSMutableDictionary*)createDefaultIURDict {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"];
    [cellData setObject:@"Tap to change" forKey:@"Title"];
    
    return cellData;
}

- (NSMutableDictionary*)createDefaultEmployeeDict {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:0] forKey:@"IUR"];
    [cellData setObject:@"" forKey:@"Title"];
    
    return cellData;
}

- (NSMutableDictionary*)createStringCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createLocationCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createEmployeeCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createTextViewCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:[NSNumber numberWithInt:5] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createIURCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData descrTypeCode:(NSString*)aDescrTypeCode {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [tmpDataDict setObject:[NSNumber numberWithInt:6] forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    [tmpDataDict setObject:aDescrTypeCode forKey:@"DescrTypeCode"];
    return tmpDataDict;
}


@end
