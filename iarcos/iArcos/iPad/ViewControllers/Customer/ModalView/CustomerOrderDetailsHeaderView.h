//
//  CustomerOrderDetailsHeaderView.h
//  iArcos
//
//  Created by Apple on 06/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomerOrderDetailsHeaderView : UIView {
    UILabel* _qtyLabel;
    UILabel* _bonusLabel;
    UILabel* _inStockLabel;
    UILabel* _focLabel;
    UILabel* _testersLabel;
    UILabel* _discountPercentLabel;
    UILabel* _descriptionLabel;
    UILabel* _unitPriceLabel;
    UILabel* _lineValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* bonusLabel;
@property(nonatomic, retain) IBOutlet UILabel* inStockLabel;
@property(nonatomic, retain) IBOutlet UILabel* focLabel;
@property(nonatomic, retain) IBOutlet UILabel* testersLabel;
@property(nonatomic, retain) IBOutlet UILabel* discountPercentLabel;
@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel* unitPriceLabel;
@property(nonatomic, retain) IBOutlet UILabel* lineValueLabel;

@end


