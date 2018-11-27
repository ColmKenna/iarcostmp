//
//  MeetingExpenseTableViewHeader.h
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeetingExpenseTableViewHeader : UIView {
    UILabel* _dateLabel;
    UILabel* _detailsLabel;
    UILabel* _commentsLabel;
    UILabel* _amountLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* detailsLabel;
@property(nonatomic, retain) IBOutlet UILabel* commentsLabel;
@property(nonatomic, retain) IBOutlet UILabel* amountLabel;

@end

