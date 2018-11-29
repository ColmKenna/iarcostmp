//
//  MeetingCostingsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingCostingsDataManager.h"

@implementation MeetingCostingsDataManager
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
    self.displayList = [NSMutableArray arrayWithCapacity:3];
    [self.displayList addObject:[self createIntegerCellDataWithFieldName:@"Overall Cost" cellKey:self.meetingCellKeyDefinition.estimatedCostKey fieldData:@""]];
    [self.displayList addObject:[self createDecimalCellDataWithFieldName:@"Cost Per Head" cellKey:self.meetingCellKeyDefinition.estimatedCostPerHeadKey fieldData:@""]];
    [self.displayList addObject:[self createIntegerCellDataWithFieldName:@"Attendees" cellKey:self.meetingCellKeyDefinition.estimatedAttendeesKey fieldData:@""]];
}

- (NSMutableDictionary*)createIntegerCellDataWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(NSString*)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    [tmpDataDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    return tmpDataDict;
}

- (NSMutableDictionary*)createDecimalCellDataWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(NSString*)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aCellKey forKey:@"CellKey"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    [tmpDataDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    return tmpDataDict;
}

- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpDataDict setObject:aData forKey:@"FieldData"];
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
