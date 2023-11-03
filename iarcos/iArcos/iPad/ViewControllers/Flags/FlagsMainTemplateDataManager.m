//
//  FlagsMainTemplateDataManager.m
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsMainTemplateDataManager.h"

@implementation FlagsMainTemplateDataManager
@synthesize contactOrderCart = _contactOrderCart;
@synthesize actionType = _actionType;
@synthesize locationOrderCart = _locationOrderCart;
@synthesize contactText = _contactText;
@synthesize locationText = _locationText;
@synthesize iURText = _iURText;
@synthesize locationIURText = _locationIURText;
@synthesize contactAssignmentType = _contactAssignmentType;
@synthesize locationAssignmentType = _locationAssignmentType;
@synthesize contactFlagDescrTypeCode = _contactFlagDescrTypeCode;
@synthesize locationFlagDescrTypeCode = _locationFlagDescrTypeCode;

@synthesize actionTypeTitle = _actionTypeTitle;
@synthesize iURKeyText = _iURKeyText;
@synthesize assignmentType = _assignmentType;
@synthesize flagDescrTypeCode = _flagDescrTypeCode;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.contactOrderCart = [NSMutableDictionary dictionary];
        self.actionType = 0;//0 : Contact; 1: Location
        self.locationOrderCart = [NSMutableDictionary dictionary];
        self.contactText = @"Contact";
        self.locationText = @"Location";
        self.iURText = @"IUR";
        self.locationIURText = @"LocationIUR";
        self.contactAssignmentType = @"C";
        self.locationAssignmentType = @"L";
        self.contactFlagDescrTypeCode = @"CF";
        self.locationFlagDescrTypeCode = @"LF";
        
        [self defineConfigAsContact];
    }
    return self;
}

- (void)dealloc {
    self.contactOrderCart = nil;
    self.locationOrderCart = nil;
    self.contactText = nil;
    self.locationText = nil;
    self.iURText = nil;
    self.locationIURText = nil;
    self.contactAssignmentType = nil;
    self.locationAssignmentType = nil;
    self.contactFlagDescrTypeCode = nil;
    self.locationFlagDescrTypeCode = nil;

    self.actionTypeTitle = nil;
    self.iURKeyText = nil;
    self.assignmentType = nil;
    self.flagDescrTypeCode = nil;
        
    [super dealloc];
}

- (void)defineConfigAsContact {
    self.actionTypeTitle = self.contactText;
    self.iURKeyText = self.iURText;
    self.assignmentType = self.contactAssignmentType;
    self.flagDescrTypeCode = self.contactFlagDescrTypeCode;
}
- (void)defineConfigAsLocation {
    self.actionTypeTitle = self.locationText;
    self.iURKeyText = self.locationIURText;
    self.assignmentType = self.locationAssignmentType;
    self.flagDescrTypeCode = self.locationFlagDescrTypeCode;
}

- (void)saveContactToOrderCart:(NSMutableDictionary*)aContactDict {
    NSNumber* contactIUR = [aContactDict objectForKey:@"IUR"];
    NSString* cartKey = [NSString stringWithFormat:@"%@", [contactIUR stringValue]];
    
    NSMutableDictionary* existingContact = [self.contactOrderCart objectForKey:cartKey];
    
    NSNumber* isSelected = [aContactDict objectForKey:@"IsSelected"];
    if (existingContact == nil && [isSelected boolValue]) {
        [self.contactOrderCart setObject:aContactDict forKey:cartKey];
    } else {
        if ([isSelected boolValue]) {
            [self.contactOrderCart setObject:aContactDict forKey:cartKey];
        } else {
            [self.contactOrderCart removeObjectForKey:cartKey];
        }
    }
}

- (NSMutableArray*)retrieveSelectedContactListProcessor {
    NSArray* objectList = [self.contactOrderCart allValues];
    NSMutableArray* resultSelectedContactList = [NSMutableArray arrayWithArray:objectList];
    if ([resultSelectedContactList count] > 0) {
        NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Surname" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [resultSelectedContactList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    }
    return resultSelectedContactList;
}

- (void)saveLocationToOrderCart:(NSMutableDictionary*)aLocationDict {
    NSNumber* auxLocationIUR = [aLocationDict objectForKey:@"LocationIUR"];
    NSString* cartKey = [NSString stringWithFormat:@"%@", [auxLocationIUR stringValue]];
    
    NSMutableDictionary* existingLocation = [self.locationOrderCart objectForKey:cartKey];
    
    NSNumber* isSelected = [aLocationDict objectForKey:@"IsSelected"];
    if (existingLocation == nil && [isSelected boolValue]) {
        [self.locationOrderCart setObject:aLocationDict forKey:cartKey];
    } else {
        if ([isSelected boolValue]) {
            [self.locationOrderCart setObject:aLocationDict forKey:cartKey];
        } else {
            [self.locationOrderCart removeObjectForKey:cartKey];
        }
    }
}

- (NSMutableArray*)retrieveSelectedLocationListProcessor {
    NSArray* objectList = [self.locationOrderCart allValues];
    NSMutableArray* resultSelectedLocationList = [NSMutableArray arrayWithArray:objectList];
    if ([resultSelectedLocationList count] > 0) {
        NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [resultSelectedLocationList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    }
    return resultSelectedLocationList;
}

- (NSMutableArray*)dictMutableListWithData:(NSMutableArray*)aDictList {
    NSMutableArray* resultDictList = [NSMutableArray arrayWithCapacity:[aDictList count]];
    for (int i = 0; i < [aDictList count]; i++) {
        NSMutableDictionary* tmpResultDict = [NSMutableDictionary dictionaryWithDictionary:[aDictList objectAtIndex:i]];
        [resultDictList addObject:tmpResultDict];
    }    
    return resultDictList;
}

@end
