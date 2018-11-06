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

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSMutableDictionary* headOfficeDataObjectDict = [self.actionDelegate retrieveHeadOfficeDataObjectDict];
    NSDate* dateObject = [headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.dateKey];
    self.dateFieldValueLabel.text = [ArcosUtils stringFromDate:dateObject format:[GlobalSharedClass shared].dateFormat];
    NSDate* timeObject = [headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.timeKey];
    self.timeFieldValueLabel.text = [ArcosUtils stringFromDate:timeObject format:[GlobalSharedClass shared].hourMinuteFormat];
    self.durationFieldValueTextField.text = [headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.durationKey];
}



@end
