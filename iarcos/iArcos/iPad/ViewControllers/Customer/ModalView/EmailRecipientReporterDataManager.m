//
//  EmailRecipientReporterDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientReporterDataManager.h"

@implementation EmailRecipientReporterDataManager

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
