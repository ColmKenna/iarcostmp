//
//  UtilitiesCallDateRangePicker.h
//  Arcos
//
//  Created by David Kilmartin on 27/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UtilitiesCallDateRangePickerDelegate
-(void)utilitiesCallDateSelectedForm:(NSDate*)start To:(NSDate*)end;
@end

@interface UtilitiesCallDateRangePicker : UIViewController {
    NSDate* _callStartDate;
    NSDate* _callEndDate;
    UIDatePicker* startDatePicker;
    UIDatePicker* endDatePicker;
    UILabel* startDateLabel;
    UILabel* endDateLabel;
    id<UtilitiesCallDateRangePickerDelegate> _delegate;
}

@property(nonatomic,retain) NSDate* callStartDate;
@property(nonatomic,retain) NSDate* callEndDate;
@property(nonatomic,retain) IBOutlet UIDatePicker* startDatePicker;
@property(nonatomic,retain) IBOutlet UIDatePicker* endDatePicker;
@property(nonatomic,retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateLabel;
@property(nonatomic,assign) id<UtilitiesCallDateRangePickerDelegate>delegate;

-(IBAction)datePicked:(id)sender;
-(IBAction)save:(id)sender;

@end
