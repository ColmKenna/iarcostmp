//
//  OrderlinesIarcosQtyBonusTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosQtyBonusTableViewCell : OrderlinesIarcosBaseTableViewCell {
    UIView* _qtyBonusView;
    UIImageView* _qtyBonusImageView;
    UILabel* _qtyInQtyBonusView;

    UILabel* _bonusInQtyBonusView;
}

@property(nonatomic, retain) IBOutlet UIView* qtyBonusView;
@property(nonatomic, retain) IBOutlet UIImageView* qtyBonusImageView;
@property(nonatomic, retain) IBOutlet UILabel* qtyInQtyBonusView;
@property(nonatomic, retain) IBOutlet UILabel* bonusInQtyBonusView;

@end
