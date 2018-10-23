//
//  EmailRecipientBaseDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientBaseDataManager.h"

@implementation EmailRecipientBaseDataManager
@synthesize locationIUR = _locationIUR;
@synthesize displayList = _displayList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize sectionTypeList = _sectionTypeList;
@synthesize wholesalerDict = _wholesalerDict;
@synthesize isSealedBOOLNumber = _isSealedBOOLNumber;

- (void)dealloc {
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    if (self.sectionTypeList != nil) { self.sectionTypeList = nil; }
    if (self.wholesalerDict != nil) { self.wholesalerDict = nil; }
    if (self.isSealedBOOLNumber != nil) { self.isSealedBOOLNumber = nil; }    
    
    [super dealloc];
}

- (void)getAllRecipients {
    
}

- (void)getLocationRecipient {
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:self.locationIUR];
    if ([locationList count] > 0) {
        NSMutableDictionary* locationDict = [locationList objectAtIndex:0];
        NSString* email = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Email"]]];
        NSString* name = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]]];
        if (![email isEqualToString:@""] && ![name isEqualToString:@""]) {
            NSMutableDictionary* recipientDict = [self createRecipient:name email:email recipientType:[GlobalSharedClass shared].locationDefaultImageIUR];
            [self.displayList addObject:recipientDict];
        }
    }
}

- (void)getContactRecipient {
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] orderContactsWithLocationIUR:self.locationIUR];
    if ([contactList count] > 0) {
        for (int i = 0; i < [contactList count]; i++) {
            NSMutableDictionary* contactDict = [contactList objectAtIndex:i];
            NSString* email = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Email"]]];
            if (![email isEqualToString:@""]) {
                NSString* name = [contactDict objectForKey:@"Title"];
                NSMutableDictionary* recipientDict = [self createRecipient:name email:email recipientType:[GlobalSharedClass shared].contactDefaultImageIUR];
                [self.displayList addObject:recipientDict];
            }
        }
    }
}

- (void)getWholesalerRecipient {
    if ([self.isSealedBOOLNumber boolValue]) return;
    if ([[self.wholesalerDict allKeys] count] == 0) return;
    NSString* email = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.wholesalerDict objectForKey:@"Email"]]];
    if (![email isEqualToString:@""]) {
        NSMutableDictionary* recipientDict = [self createRecipient:[self.wholesalerDict objectForKey:@"Title"] email:email recipientType:[GlobalSharedClass shared].wholesalerDefaultImageIUR];
        [self.displayList addObject:recipientDict];
    }
    
}

- (void)getEmployeeRecipient {
    NSMutableArray* employeeList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    for (int i = 0; i < [employeeList count]; i++) {
        NSMutableDictionary* employeeDict = [employeeList objectAtIndex:i];
        NSString* email = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Email"]]];
        NSString* name = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Title"]]];
        if (![email isEqualToString:@""] && ![name isEqualToString:@""]) {
            NSMutableDictionary* recipientDict = [self createRecipient:name email:email recipientType:[GlobalSharedClass shared].employeeDefaultImageIUR];
            [self.displayList addObject:recipientDict];
        }
    }
}

- (void)createOtherRecipient {
    NSMutableArray* tmpOtherDisplayList = [NSMutableArray arrayWithCapacity:1];
    NSMutableDictionary* recipientDict = [self createRecipient:@"OTHER" email:@"" recipientType:[NSNumber numberWithInt:-1]];
    [tmpOtherDisplayList addObject:recipientDict];
    NSString* sectionType = @"Other";
    [self.sectionTypeList addObject:sectionType];
    [self.groupedDataDict setObject:tmpOtherDisplayList forKey:sectionType];
}

- (NSMutableDictionary*)createRecipient:(NSString*)aTitle email:(NSString*)anEmail recipientType:(NSNumber*)aRecipientType {
    NSMutableDictionary* recipientDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [recipientDict setObject:[NSString stringWithFormat:@"%@", aTitle] forKey:@"Title"];
    [recipientDict setObject:[NSString stringWithFormat:@"%@", anEmail] forKey:@"Email"];
    [recipientDict setObject:[NSNumber numberWithInt:[aRecipientType intValue]] forKey:@"RecipientType"];
    return recipientDict;
}


@end
