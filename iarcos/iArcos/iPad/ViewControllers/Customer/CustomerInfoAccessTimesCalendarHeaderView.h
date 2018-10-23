//
//  CustomerInfoAccessTimesCalendarHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoAccessTimesCalendarHeaderView : UIView {
    UILabel* _timeLabel;
    UILabel* _sunLabel;
    UILabel* _monLabel;
    UILabel* _tueLabel;
    UILabel* _wedLabel;
    UILabel* _thuLabel;
    UILabel* _friLabel;
    UILabel* _satLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UILabel* sunLabel;
@property(nonatomic, retain) IBOutlet UILabel* monLabel;
@property(nonatomic, retain) IBOutlet UILabel* tueLabel;
@property(nonatomic, retain) IBOutlet UILabel* wedLabel;
@property(nonatomic, retain) IBOutlet UILabel* thuLabel;
@property(nonatomic, retain) IBOutlet UILabel* friLabel;
@property(nonatomic, retain) IBOutlet UILabel* satLabel;

@end
