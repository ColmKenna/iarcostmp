//
//  ReportOrderHeaderView.h
//  iArcos
//
//  Created by Richard on 05/05/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReportOrderHeaderView : UIView {
    UILabel* _locationLabel;
    UILabel* _employeeLabel;
    UILabel* _orderDateLabel;
    UILabel* _deliveryDateLabel;
    UILabel* _goodsLabel;
    UILabel* _vatLabel;
    UILabel* _totalLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) IBOutlet UILabel* employeeLabel;
@property(nonatomic, retain) IBOutlet UILabel* orderDateLabel;
@property(nonatomic, retain) IBOutlet UILabel* deliveryDateLabel;
@property(nonatomic, retain) IBOutlet UILabel* goodsLabel;
@property(nonatomic, retain) IBOutlet UILabel* vatLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalLabel;

@end

