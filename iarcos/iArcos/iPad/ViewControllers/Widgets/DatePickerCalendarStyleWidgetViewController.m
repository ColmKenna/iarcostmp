//
//  DatePickerCalendarStyleWidgetViewController.m
//  iArcos
//
//  Created by Richard on 18/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DatePickerCalendarStyleWidgetViewController.h"

@interface DatePickerCalendarStyleWidgetViewController ()

@end

@implementation DatePickerCalendarStyleWidgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(id)initWithType:(DatePickerWidgetType)aType{
    [self initWithNibName:@"DatePickerCalendarStyleWidgetViewController" bundle:nil];
    self.type=aType;
    

    
    self.anyDataSource=YES;
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
