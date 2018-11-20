//
//  MeetingExpenseDetailsIURTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseDetailsBaseTableViewCell.h"


@interface MeetingExpenseDetailsIURTableViewCell : MeetingExpenseDetailsBaseTableViewCell {
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end

