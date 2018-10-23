//
//  CustomerIarcosInvoiceTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 31/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerIarcosInvoiceTableCell : UITableViewCell {
    UILabel* _dateLabel;
    UILabel* _referenceLabel;
    UILabel* _wholesalerLabel;
    UILabel* _typeLabel;
    UILabel* _employeeLabel;
    UILabel* _valueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* referenceLabel;
@property(nonatomic, retain) IBOutlet UILabel* wholesalerLabel;
@property(nonatomic, retain) IBOutlet UILabel* typeLabel;
@property(nonatomic, retain) IBOutlet UILabel* employeeLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;


@end
