//
//  OrderlinesIarcosQtyTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosQtyTableViewCell : OrderlinesIarcosBaseTableViewCell {
    UIView* _normalQtyView;
    UILabel* _qtyInNormalQtyView;
}

@property(nonatomic, retain) IBOutlet UIView* normalQtyView;
@property(nonatomic, retain) IBOutlet UILabel* qtyInNormalQtyView;

@end
