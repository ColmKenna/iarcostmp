//
//  MeetingMainTemplateCreateAction.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateCreateAction.h"

@implementation MeetingMainTemplateCreateAction

- (instancetype)initWithTarget:(id)aTarget {
    self = [super initWithTarget:aTarget];
    if (self != nil) {
        self.retrieveMeetingMainTemplateDataSelector = NSSelectorFromString(@"retrieveCreateMeetingMainTemplateData");
    }
    return self;
}



@end
