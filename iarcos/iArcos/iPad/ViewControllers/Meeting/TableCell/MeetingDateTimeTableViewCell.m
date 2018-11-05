//
//  MeetingDateTimeTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingDateTimeTableViewCell.h"

@implementation MeetingDateTimeTableViewCell
@synthesize dateFieldNameLabel = _dateFieldNameLabel;
@synthesize dateFieldValueLabel = _dateFieldValueLabel;
@synthesize timeFieldNameLabel = _timeFieldNameLabel;
@synthesize timeFieldValueLabel = _timeFieldValueLabel;
@synthesize durationFieldNameLabel = _durationFieldNameLabel;
@synthesize durationFieldValueTextField = _durationFieldValueTextField;


- (void)dealloc {
    self.dateFieldNameLabel = nil;
    self.dateFieldValueLabel = nil;
    self.timeFieldNameLabel = nil;
    self.timeFieldValueLabel = nil;
    self.durationFieldNameLabel = nil;
    self.durationFieldValueTextField = nil;
    
    [super dealloc];
}



@end
