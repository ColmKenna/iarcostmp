//
//  EmailRecipientAccountOverviewDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 14/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientAccountOverviewDataManager.h"

@implementation EmailRecipientAccountOverviewDataManager

- (void)getAllRecipients {
    [self getLocationRecipient];
    [self getEmployeeRecipient];
    if ([self.displayList count] > 0) {
        NSString* sectionType = @"Recipients";
        [self.sectionTypeList addObject:sectionType];
        [self.groupedDataDict setObject:self.displayList forKey:sectionType];
    }
    [self createOtherRecipient];
}

@end
