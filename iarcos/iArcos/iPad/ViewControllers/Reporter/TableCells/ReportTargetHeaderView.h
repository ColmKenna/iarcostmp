//
//  ReportTargetHeaderView.h
//  iArcos
//
//  Created by Richard on 23/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportTargetHeaderView : UIView {
    UILabel* _descriptionLabel;
    UILabel* _q1TargetLabel;
    UILabel* _q1ActualLabel;
    UILabel* _q1PercentageLabel;
    UILabel* _q2TargetLabel;
    UILabel* _q2ActualLabel;
    UILabel* _q2PercentageLabel;
    UILabel* _q3TargetLabel;
    UILabel* _q3ActualLabel;
    UILabel* _q3PercentageLabel;
    UILabel* _q4TargetLabel;
    UILabel* _q4ActualLabel;
    UILabel* _q4PercentageLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel* q1TargetLabel;
@property(nonatomic, retain) IBOutlet UILabel* q1ActualLabel;
@property(nonatomic, retain) IBOutlet UILabel* q1PercentageLabel;
@property(nonatomic, retain) IBOutlet UILabel* q2TargetLabel;
@property(nonatomic, retain) IBOutlet UILabel* q2ActualLabel;
@property(nonatomic, retain) IBOutlet UILabel* q2PercentageLabel;
@property(nonatomic, retain) IBOutlet UILabel* q3TargetLabel;
@property(nonatomic, retain) IBOutlet UILabel* q3ActualLabel;
@property(nonatomic, retain) IBOutlet UILabel* q3PercentageLabel;
@property(nonatomic, retain) IBOutlet UILabel* q4TargetLabel;
@property(nonatomic, retain) IBOutlet UILabel* q4ActualLabel;
@property(nonatomic, retain) IBOutlet UILabel* q4PercentageLabel;

@end

