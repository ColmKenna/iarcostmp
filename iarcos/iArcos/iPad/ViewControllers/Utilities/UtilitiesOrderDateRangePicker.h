//
//  UtilitiesOrderDateRangePicker.h
//  Arcos
//
//  Created by David Kilmartin on 26/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UtilitiesOrderDateRangePickerDelegate
-(void)utilitiesDateSelectedForm:(NSDate*)start To:(NSDate*)end;
@end

@interface UtilitiesOrderDateRangePicker : UIViewController {
    NSDate* _orderStartDate;
    NSDate* _orderEndDate;
    UIDatePicker* startDatePicker;
    UIDatePicker* endDatePicker;
    UILabel* startDateLabel;
    UILabel* endDateLabel;
    id<UtilitiesOrderDateRangePickerDelegate> delegate;
}

@property(nonatomic,retain) NSDate* orderStartDate;
@property(nonatomic,retain) NSDate* orderEndDate;
@property(nonatomic,retain) IBOutlet UIDatePicker* startDatePicker;
@property(nonatomic,retain) IBOutlet UIDatePicker* endDatePicker;
@property(nonatomic,retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateLabel;
@property(nonatomic,assign) id<UtilitiesOrderDateRangePickerDelegate>delegate;

-(IBAction)datePicked:(id)sender;
-(IBAction)save:(id)sender;

@end
