//
//  MeetingDateTimeTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface MeetingDateTimeTableViewCell : MeetingBaseTableViewCell {
    UILabel* _dateFieldNameLabel;
    UILabel* _dateFieldValueLabel;
    UILabel* _timeFieldNameLabel;
    UILabel* _timeFieldValueLabel;
    UILabel* _durationFieldNameLabel;
    UITextField* _durationFieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* dateFieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateFieldValueLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeFieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeFieldValueLabel;
@property(nonatomic, retain) IBOutlet UILabel* durationFieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* durationFieldValueTextField;

@end

