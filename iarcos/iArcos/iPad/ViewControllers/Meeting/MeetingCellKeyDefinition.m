//
//  MeetingCellKeyDefinition.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingCellKeyDefinition.h"

@implementation MeetingCellKeyDefinition
@synthesize dateKey = _dateKey;
@synthesize timeKey= _timeKey;
@synthesize durationKey = _durationKey;
@synthesize codeKey = _codeKey;
@synthesize venueKey = _venueKey;
@synthesize statusKey = _statusKey;
@synthesize typeKey = _typeKey;
@synthesize styleKey = _styleKey;
@synthesize titleKey = _titleKey;
@synthesize operatorKey = _operatorKey;
@synthesize commentsKey = _commentsKey;

@synthesize approvedByKey = _approvedByKey;
@synthesize l4Key = _l4Key;
@synthesize l5Key = _l5Key;
@synthesize speakerAgreementKey = _speakerAgreementKey;
@synthesize speakerAgreementDetailsKey = _speakerAgreementDetailsKey;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateKey = @"Date";
        self.timeKey = @"Time";
        self.durationKey = @"Duration";
        self.codeKey = @"Code";
        self.venueKey = @"Venue";
        self.statusKey = @"Status";
        self.typeKey = @"Type";
        self.styleKey = @"Style";
        self.titleKey = @"Title";
        self.operatorKey = @"Operator";
        self.commentsKey = @"Comments";
        
        self.approvedByKey = @"ApprovedBy";
        self.l4Key = @"L4";
        self.l5Key = @"L5";
        self.speakerAgreementKey = @"SpeakerAgreement";
        self.speakerAgreementDetailsKey = @"SpeakerAgreementDetails";
    }
    
    return self;
}

- (void)dealloc {
    self.dateKey = nil;
    self.timeKey = nil;
    self.durationKey = nil;
    self.codeKey = nil;
    self.venueKey = nil;
    self.statusKey = nil;
    self.typeKey = nil;
    self.styleKey = nil;
    self.titleKey = nil;
    self.operatorKey = nil;
    self.commentsKey = nil;
    
    self.approvedByKey = nil;
    self.l4Key = nil;
    self.l5Key = nil;
    self.speakerAgreementKey = nil;
    self.speakerAgreementDetailsKey = nil;
    
    [super dealloc];
}

@end
