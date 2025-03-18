//
//  NextCheckoutOrderLineKbFooterView.h
//  iArcos
//
//  Created by Richard on 16/03/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NextCheckoutOrderLineKbFooterView : UIView {
    UILabel* _totalTitleLabel;
    UILabel* _totalLineLabel;
    UILabel* _totalSuffixLabel;
    UILabel* _totalQtyLabel;
    UILabel* _totalBonusLabel;
    UILabel* _totalValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* totalTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalLineLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalSuffixLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalQtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalBonusLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalValueLabel;

@end


