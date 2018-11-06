//
//  MeetingBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseDataManager.h"

@implementation MeetingBaseDataManager
@synthesize meetingCellKeyDefinition = _meetingCellKeyDefinition;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.meetingCellKeyDefinition = [[[MeetingCellKeyDefinition alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.meetingCellKeyDefinition = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createDefaultIURDict {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellData setObject:[NSNumber numberWithInt:0] forKey:@"DescrDetailIUR"];
    [cellData setObject:@"Tap to change" forKey:@"Title"];
    
    return cellData;
}


@end
