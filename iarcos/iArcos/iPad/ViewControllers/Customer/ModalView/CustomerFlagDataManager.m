//
//  CustomerFlagDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerFlagDataManager.h"

@implementation CustomerFlagDataManager
@synthesize originalDisplayList = _originalDisplayList;
@synthesize displayList = _displayList;
@synthesize locationIUR = _locationIUR;
@synthesize changedDataList = _changedDataList;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR{
    self = [super init];
    if (self != nil) {
        self.originalDisplayList = [NSMutableArray array];
        self.displayList = [NSMutableArray array];
        self.locationIUR = aLocationIUR;
    }
    return self;
}

-(void)dealloc {
    if (self.originalDisplayList != nil) { self.originalDisplayList = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.changedDataList != nil) { self.changedDataList = nil; }    
    
    [super dealloc];
}

//LocationFlag 0: unticked; 1: ticked;
- (void)createBasicData {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='LF' and Active = 1"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",@"Active",@"Tooltip",nil];
    
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    for(NSDictionary* aDict in objectsArray){
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [newDict setObject:[NSNumber numberWithInt:0] forKey:@"LocationFlag"];
        [newDict setObject:[NSNumber numberWithInt:0] forKey:@"ContactIUR"];
        [self.displayList addObject:newDict];
    }
}

- (void)processRawData:(NSMutableArray*)anArrayOfData {
    [self createBasicData];
    for (int i = 0; i < [anArrayOfData count]; i++) {
        ArcosGenericClass* arcosGenericClass = [anArrayOfData objectAtIndex:i];
        for (int j = 0; j < [self.displayList count]; j++) {
            NSMutableDictionary* cellData = [self.displayList objectAtIndex:j];
            if ([[arcosGenericClass Field2] isEqualToString:[[cellData objectForKey:@"DescrDetailIUR"] stringValue]] ) {
                [cellData setObject:[NSNumber numberWithInt:1] forKey:@"LocationFlag"];
                [cellData setObject:[ArcosUtils convertStringToNumber:[arcosGenericClass Field3]] forKey:@"ContactIUR"];
                [self.displayList replaceObjectAtIndex:j withObject:cellData];
                break;
            }
        }
    }
    for(NSMutableDictionary* aDict in self.displayList){
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [self.originalDisplayList addObject:newDict];
    }
}

- (void)updateChangedData:(NSNumber*)aLocationFlag indexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    [cellData setObject:aLocationFlag forKey:@"LocationFlag"];
    [self.displayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
}

- (void)getChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellData = [self.displayList objectAtIndex:i];
        NSMutableDictionary* originalCellData = [self.originalDisplayList objectAtIndex:i];
        if ([[cellData objectForKey:@"LocationFlag"] intValue] != [[originalCellData objectForKey:@"LocationFlag"] intValue]) {
//            [self.changedDataList addObject:cellData];
            ArcosCreateRecordObject* arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
            NSMutableArray* fieldNames = [NSMutableArray arrayWithObjects:@"LocationIUR", @"ContactIUR", @"DescrDetailIUR", @"CreateDelete", nil];
            NSMutableArray* fieldValues = [NSMutableArray arrayWithCapacity:4];
            [fieldValues addObject:[self.locationIUR stringValue]];
            [fieldValues addObject:[[cellData objectForKey:@"ContactIUR"] stringValue]];
            [fieldValues addObject:[[cellData objectForKey:@"DescrDetailIUR"] stringValue]];            
            NSString* actionType = [[cellData objectForKey:@"LocationFlag"] intValue] == 0 ? @"D" : @"S";
            [fieldValues addObject: actionType];
            
            arcosCreateRecordObject.FieldNames = fieldNames;
            arcosCreateRecordObject.FieldValues = fieldValues;
            [self.changedDataList addObject:arcosCreateRecordObject];
            [arcosCreateRecordObject release];            
        }
    }
}

@end
