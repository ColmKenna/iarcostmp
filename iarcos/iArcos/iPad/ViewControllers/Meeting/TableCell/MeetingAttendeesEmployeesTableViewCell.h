//
//  MeetingAttendeesEmployeesTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 24/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingBaseTableViewCell.h"


@interface MeetingAttendeesEmployeesTableViewCell : MeetingBaseTableViewCell {
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end

