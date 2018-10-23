//
//  OrderDateRangePicker.h
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderDateRangePickerDelegate
-(void)dateSelectedForm:(NSDate*)start To:(NSDate*)end;
@end

@interface OrderDateRangePicker : UIViewController{
    IBOutlet UIDatePicker* startDate;
    IBOutlet UIDatePicker* endDate;
    IBOutlet UILabel* startDateLabel;
    IBOutlet UILabel* endDateLabel;
    id<OrderDateRangePickerDelegate>delegate;
}
@property(nonatomic,retain) IBOutlet UIDatePicker* startDate;
@property(nonatomic,retain) IBOutlet UIDatePicker* endDate;
@property(nonatomic,retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateLabel;
@property(nonatomic,retain) IBOutlet id<OrderDateRangePickerDelegate>delegate;

-(IBAction)datePicked:(id)sender;
-(IBAction)search:(id)sender;
@end
