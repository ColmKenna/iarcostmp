//
//  CustomerMemoDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerMemoDataManager.h"

@implementation CustomerMemoDataManager
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize changedDataList = _changedDataList;
@synthesize locationMemoDateString = _locationMemoDateString;
@synthesize locationMemoOriginalDisplayList = _locationMemoOriginalDisplayList;
@synthesize locationMemoChangedDataList = _locationMemoChangedDataList;
@synthesize isLocationMemoExistent = _isLocationMemoExistent;
@synthesize locationIUR = _locationIUR;
@synthesize locationMemoArcosCreateRecordObject = _locationMemoArcosCreateRecordObject;

-(id)init{
    self = [super init];
    if (self !=  nil) {
        self.displayList = [[[NSMutableArray alloc] init] autorelease];
        self.originalDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
        self.locationMemoDateString = @"01/01/2050";
        self.locationMemoOriginalDisplayList = [[[NSMutableArray alloc] init] autorelease];
        self.locationMemoChangedDataList = [[[NSMutableArray alloc] init] autorelease];
        self.isLocationMemoExistent = NO;
    }
    return self;
}

-(void)dealloc{
    if (self.displayList != nil) { self.displayList
        = nil;}
    if (self.originalDisplayList != nil) { self.originalDisplayList
        = nil;}
    if (self.changedDataList != nil) { self.changedDataList
        = nil;}
    if (self.locationMemoDateString != nil) { self.locationMemoDateString = nil; }
    if (self.locationMemoOriginalDisplayList != nil) { self.locationMemoOriginalDisplayList = nil; }
    if (self.locationMemoChangedDataList != nil) { self.locationMemoChangedDataList = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; } 
    if (self.locationMemoArcosCreateRecordObject != nil) { self.locationMemoArcosCreateRecordObject = nil; }
    
    [super dealloc];
}

-(void)processRawData:(NSMutableArray*)aDataList {    
    self.displayList = aDataList;
    self.originalDisplayList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];        
        ArcosGenericClass* originalArcosGenericClass = [[ArcosGenericClass alloc] init];
        for (int i = 1; i <= 7; i++) {
            NSString* methodName = [NSString stringWithFormat:@"Field%d", i];            
            SEL selector = NSSelectorFromString(methodName);
            NSString* originalMethodName = [NSString stringWithFormat:@"set%@:", methodName];
            SEL originalSelector = NSSelectorFromString(originalMethodName);
            [originalArcosGenericClass performSelector:originalSelector withObject:[arcosGenericClass performSelector:selector]];
        }
        
        [self.originalDisplayList addObject:originalArcosGenericClass];
        [originalArcosGenericClass release];
    }
    [self checkLocationMemoExistence];
}

-(void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath {
    ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:anIndexPath.row];
    arcosGenericClass.Field4 = data;
    [self.displayList replaceObjectAtIndex:anIndexPath.row withObject:arcosGenericClass];
}

-(NSMutableArray*)getChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 1; i < [self.displayList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:i];        
        ArcosGenericClass* originalArcosGenericClass = [self.originalDisplayList objectAtIndex:i];
        if (![[arcosGenericClass Field4] isEqualToString:[originalArcosGenericClass Field4]]) {
            [self.changedDataList addObject:arcosGenericClass];
        }
    }
    return self.changedDataList;
}

-(NSMutableArray*)getAllChangedDataList {
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:i];        
        ArcosGenericClass* originalArcosGenericClass = [self.originalDisplayList objectAtIndex:i];
        if (![[arcosGenericClass Field4] isEqualToString:[originalArcosGenericClass Field4]]) {
            [self.changedDataList addObject:arcosGenericClass];
        }
    }
    return self.changedDataList;
}

//location memo always sits on the top
-(void)checkLocationMemoExistence {
    if ([self.displayList count] > 0) {
        ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:0];
        @try {
            NSString* dateentered = [[arcosGenericClass Field1] substringToIndex:10];
            if ([dateentered isEqualToString:self.locationMemoDateString]) {//location memo exists
                self.isLocationMemoExistent = YES;
            } else {                
                [self.displayList insertObject:[self createLocationMemoArcosGenericClass] atIndex:0];
                self.locationMemoOriginalDisplayList = [NSMutableArray arrayWithCapacity:1];
                [self.locationMemoOriginalDisplayList addObject:[self createLocationMemoArcosGenericClass]];
                [self.originalDisplayList insertObject:[self createLocationMemoArcosGenericClass] atIndex:0];
                self.isLocationMemoExistent = NO;
            }
        }
        @catch (NSException *exception) {
//            [ArcosUtils showMsg:[exception reason] delegate:nil];
            [ArcosUtils showDialogBox:[exception reason] title:@"" target:[ArcosUtils getRootView] handler:nil];
        }
    } else if ([self.displayList count] == 0) {
        self.displayList = [NSMutableArray arrayWithCapacity:1];
        [self.displayList insertObject:[self createLocationMemoArcosGenericClass] atIndex:0];
        self.locationMemoOriginalDisplayList = [NSMutableArray arrayWithCapacity:1];
        [self.locationMemoOriginalDisplayList addObject:[self createLocationMemoArcosGenericClass]];
        [self.originalDisplayList insertObject:[self createLocationMemoArcosGenericClass] atIndex:0];
        self.isLocationMemoExistent = NO;
    }
}

-(NSString*)employeeName{
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    return [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
}

-(ArcosGenericClass*)createLocationMemoArcosGenericClass {
    ArcosGenericClass* locationMemoArcosGenericClass = [[[ArcosGenericClass alloc] init] autorelease];
    locationMemoArcosGenericClass.Field1 = self.locationMemoDateString;
    locationMemoArcosGenericClass.Field2 = @"";
    locationMemoArcosGenericClass.Field3 = [self employeeName];
    locationMemoArcosGenericClass.Field4 = @"";
    locationMemoArcosGenericClass.Field5 = @"Location Memo";
    return locationMemoArcosGenericClass;
}

-(NSMutableArray*)getLocationMemoChangedDataList {
    self.locationMemoChangedDataList = [[[NSMutableArray alloc] init] autorelease];
    ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:0];        
    ArcosGenericClass* originalArcosGenericClass = [self.locationMemoOriginalDisplayList objectAtIndex:0];
    if (![[arcosGenericClass Field4] isEqualToString:[originalArcosGenericClass Field4]]) {
        self.locationMemoArcosCreateRecordObject = [[[ArcosCreateRecordObject alloc] init] autorelease];
        NSMutableArray* fieldNameList = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray* fieldValueList = [NSMutableArray arrayWithCapacity:4];
        [fieldNameList addObject:@"LocationIUR"];
        [fieldValueList addObject:[self.locationIUR stringValue]];
        [fieldNameList addObject:@"EmployeeIUR"];
        [fieldValueList addObject:[[SettingManager employeeIUR] stringValue]];
        [fieldNameList addObject:@"DateEntered"];
        [fieldValueList addObject:self.locationMemoDateString];
        [fieldNameList addObject:@"Details"];
        [fieldValueList addObject:[arcosGenericClass Field4]];
        self.locationMemoArcosCreateRecordObject.FieldNames = fieldNameList;
        self.locationMemoArcosCreateRecordObject.FieldValues = fieldValueList;
        [self.locationMemoChangedDataList addObject:self.locationMemoArcosCreateRecordObject];
    }
    return self.locationMemoChangedDataList;
}

@end
