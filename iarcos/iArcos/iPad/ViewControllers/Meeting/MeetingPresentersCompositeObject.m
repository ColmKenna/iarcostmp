//
//  MeetingPresentersCompositeObject.m
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersCompositeObject.h"

@implementation MeetingPresentersCompositeObject
@synthesize cellType = _cellType;
@synthesize presenterData = _presenterData;
@synthesize openFlag = _openFlag;

- (instancetype)initHeaderWithData:(ArcosPresenterForMeeting*)aData {
    self = [super init];
    if (self) {
        self.cellType = [NSNumber numberWithInt:1];
        self.presenterData = aData;
        self.openFlag = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (instancetype)initPresenterWithData:(ArcosPresenterForMeeting*)aData {
    self = [super init];
    if (self) {
        self.cellType = [NSNumber numberWithInt:2];
        self.presenterData = aData;
        self.openFlag = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (void)dealloc {
    self.cellType = nil;
    self.presenterData = nil;
    self.openFlag = nil;
    
    [super dealloc];
}

@end
