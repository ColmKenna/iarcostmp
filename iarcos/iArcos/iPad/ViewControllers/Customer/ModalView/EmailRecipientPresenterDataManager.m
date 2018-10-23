//
//  EmailRecipientPresenterDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 11/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientPresenterDataManager.h"

@implementation EmailRecipientPresenterDataManager

- (void)getAllRecipients {
    if (self.locationIUR != nil) {
        [self getLocationRecipient];
        [self getContactRecipient];
    }    
    if ([self.displayList count] > 0) {
        NSString* sectionType = @"Recipients";
        [self.sectionTypeList addObject:sectionType];
        [self.groupedDataDict setObject:self.displayList forKey:sectionType];
    }
    [self createOtherRecipient];
}

@end
