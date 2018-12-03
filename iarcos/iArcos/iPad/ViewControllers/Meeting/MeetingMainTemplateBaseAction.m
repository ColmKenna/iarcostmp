//
//  MeetingMainTemplateBaseAction.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateBaseAction.h"

@implementation MeetingMainTemplateBaseAction
@synthesize target = _target;
@synthesize retrieveMeetingMainTemplateDataSelector = _retrieveMeetingMainTemplateDataSelector;

- (instancetype)initWithTarget:(id)aTarget {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
    }
    return self;
}

- (void)retrieveMeetingMainTemplateData {
    [self.target performSelector:self.retrieveMeetingMainTemplateDataSelector];
}


@end
