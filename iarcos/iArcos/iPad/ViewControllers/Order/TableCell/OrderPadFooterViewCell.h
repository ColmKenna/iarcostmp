//
//  OrderPadFooterViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/09/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderPadFooterViewCell : UIView {
//    UILabel* _totalBonusTitle;
    UILabel* _totalBonusValue;
    UILabel* _totalTradeTitle;
    UILabel* _totalTradeValue;
}

//@property(nonatomic, retain) IBOutlet UILabel* totalBonusTitle;
@property(nonatomic, retain) IBOutlet UILabel* totalBonusValue;
@property(nonatomic, retain) IBOutlet UILabel* totalTradeTitle;
@property(nonatomic, retain) IBOutlet UILabel* totalTradeValue;

@end

