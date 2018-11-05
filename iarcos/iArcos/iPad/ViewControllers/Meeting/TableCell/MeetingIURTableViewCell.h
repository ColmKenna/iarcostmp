//
//  MeetingIURTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"


@interface MeetingIURTableViewCell : MeetingBaseTableViewCell {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end

