//
//  MeetingMainTemplateUpdateAction.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateUpdateAction.h"

@implementation MeetingMainTemplateUpdateAction

- (instancetype)initWithTarget:(id)aTarget {
    self = [super initWithTarget:aTarget];
    if (self != nil) {
        self.retrieveMeetingMainTemplateDataSelector = NSSelectorFromString(@"retrieveUpdateMeetingMainTemplateData");
    }
    return self;
}

@end
