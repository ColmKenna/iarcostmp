//
//  MeetingMainTemplateBaseAction.h
//  iArcos
//
//  Created by David Kilmartin on 03/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingMainTemplateActionDelegate.h"

@interface MeetingMainTemplateBaseAction : NSObject <MeetingMainTemplateActionDelegate> {
    id _target;
    SEL _retrieveMeetingMainTemplateDataSelector;
}

@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL retrieveMeetingMainTemplateDataSelector;

- (instancetype)initWithTarget:(id)aTarget;

@end

