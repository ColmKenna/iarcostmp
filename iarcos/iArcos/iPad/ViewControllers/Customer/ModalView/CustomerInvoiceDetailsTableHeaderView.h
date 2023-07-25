//
//  CustomerInvoiceDetailsTableHeaderView.h
//  iArcos
//
//  Created by Richard on 25/07/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerInvoiceDetailsTableHeaderView : UIView {
    UILabel* _qtyLabel;
    UILabel* _bonLabel;
    UILabel* _descLabel;
    UILabel* _valueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* bonLabel;
@property(nonatomic, retain) IBOutlet UILabel* descLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;

@end

