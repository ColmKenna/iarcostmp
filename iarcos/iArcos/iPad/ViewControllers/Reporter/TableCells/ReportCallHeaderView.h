//
//  ReportCallHeaderView.h
//  iArcos
//
//  Created by Richard on 18/08/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportCallHeaderView : UIView {
    UILabel* _locationLabel;
    UILabel* _employeeLabel;
    UILabel* _valueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) IBOutlet UILabel* employeeLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;

@end

