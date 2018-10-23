//
//  TwoDatePickerWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TwoDatePickerWidgetDelegate<NSObject>

- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate;

@end

@interface TwoDatePickerWidgetViewController : UIViewController {
    NSDate* _startDate;
    NSDate* _endDate;
    UIDatePicker* _startDatePicker;
    UIDatePicker* _endDatePicker;
    UILabel* _startDateLabel;
    UILabel* _endDateLabel;
    id<TwoDatePickerWidgetDelegate> _delegate;
    
    UILabel* _startDateTitleLabel;
    UILabel* _endDateTitleLabel;
    UIButton* _saveButton;
    
}

@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic,retain) IBOutlet UIDatePicker* startDatePicker;
@property(nonatomic,retain) IBOutlet UIDatePicker* endDatePicker;
@property(nonatomic,retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateLabel;
@property(nonatomic,assign) id<TwoDatePickerWidgetDelegate> delegate;

@property(nonatomic,retain) IBOutlet UILabel* startDateTitleLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateTitleLabel;
@property(nonatomic,retain) IBOutlet UIButton* saveButton;


-(IBAction)dateComponentPicked:(id)sender;
-(IBAction)savePressed:(id)sender;

@end
