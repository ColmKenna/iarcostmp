//
//  OrderlinesIarcosSplitQtyBonusTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosSplitQtyBonusTableViewCell : OrderlinesIarcosBaseTableViewCell {
    UIView* _splitQtyBonusView;
    UIImageView* _splitQtyBonusImageView;
    UILabel* _qtyInSplitQtyBonusView;
    UILabel* _bonusInSplitQtyBonusView;
}

@property(nonatomic, retain) IBOutlet UIView* splitQtyBonusView;
@property(nonatomic, retain) IBOutlet UIImageView* splitQtyBonusImageView;
@property(nonatomic, retain) IBOutlet UILabel* qtyInSplitQtyBonusView;
@property(nonatomic, retain) IBOutlet UILabel* bonusInSplitQtyBonusView;

@end
