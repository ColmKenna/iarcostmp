//
//  MeetingStringTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"


@interface MeetingStringTableViewCell : MeetingBaseTableViewCell {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end

