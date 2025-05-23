//
//  MeetingExpenseDetailsDecimalTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingExpenseDetailsBaseTableViewCell.h"

@interface MeetingExpenseDetailsDecimalTableViewCell : MeetingExpenseDetailsBaseTableViewCell {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end

