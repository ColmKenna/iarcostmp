//
//  MeetingBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingCellKeyDefinition.h"

@interface MeetingBaseDataManager : NSObject {
    MeetingCellKeyDefinition* _meetingCellKeyDefinition;
}

@property(nonatomic, retain) MeetingCellKeyDefinition* meetingCellKeyDefinition;

- (NSMutableDictionary*)createDefaultIURDict;

@end

