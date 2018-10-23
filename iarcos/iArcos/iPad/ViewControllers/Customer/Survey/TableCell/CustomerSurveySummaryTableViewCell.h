//
//  CustomerSurveySummaryTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerSurveySummaryTableViewCell : UITableViewCell {
    UILabel* _dateLabel;
    UILabel* _surveyTitleLabel;
    UILabel* _contactNameLabel;
    UILabel* _employeeNameLabel;
    UILabel* _scoreLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* surveyTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* contactNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* employeeNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* scoreLabel;

@end
