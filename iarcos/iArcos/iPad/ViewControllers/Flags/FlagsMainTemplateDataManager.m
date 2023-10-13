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

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.contactOrderCart = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.contactOrderCart = nil;
        
    [super dealloc];
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

@end
