//
//  EmailRecipientPhotoDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientPhotoDataManager.h"

@implementation EmailRecipientPhotoDataManager

- (void)getAllRecipients {
    [self getLocationRecipient];
    [self getContactRecipient];
    [self getEmployeeRecipient];
    if ([self.displayList count] > 0) {
        NSString* sectionType = @"Recipients";
        [self.sectionTypeList addObject:sectionType];
        [self.groupedDataDict setObject:self.displayList forKey:sectionType];
    }
    [self createOtherRecipient];
}

@end
