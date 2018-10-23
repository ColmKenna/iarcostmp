//
//  EmailRecipientEmployeeDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 26/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientEmployeeDataManager.h"

@implementation EmailRecipientEmployeeDataManager

- (void)getAllRecipients {
    [self getEmployeeRecipient];
    if ([self.displayList count] > 0) {
        NSString* sectionType = @"Recipients";
        [self.sectionTypeList addObject:sectionType];
        [self.groupedDataDict setObject:self.displayList forKey:sectionType];
    }
    [self createOtherRecipient];
}

@end
