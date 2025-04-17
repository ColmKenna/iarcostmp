//
//  FormRowTableHeaderView.h
//  iArcos
//
//  Created by David Kilmartin on 26/09/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormRowTableHeaderView : UIView {
    UILabel* _descLabel;
    UILabel* _rrpLabel;
    UILabel* _priceLabel;
    UILabel* _qtyLabel;
    UILabel* _bonusLabel;
    UILabel* _discountLabel;
    UILabel* _valueLabel;
//    UILabel* _uniLabel;
//    UILabel* _udLabel;
    UILabel* _maxLabel;
    UILabel* _prevLabel;
    UILabel* _prevNormalLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* descLabel;
@property(nonatomic, retain) IBOutlet UILabel* rrpLabel;
@property(nonatomic, retain) IBOutlet UILabel* priceLabel;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* bonusLabel;
@property(nonatomic, retain) IBOutlet UILabel* discountLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;
//@property(nonatomic, retain) IBOutlet UILabel* uniLabel;
//@property(nonatomic, retain) IBOutlet UILabel* udLabel;
@property(nonatomic, retain) IBOutlet UILabel* maxLabel;
@property(nonatomic, retain) IBOutlet UILabel* prevLabel;
@property(nonatomic, retain) IBOutlet UILabel* prevNormalLabel;
@property(nonatomic, retain) IBOutlet UIView* holder;
@end
