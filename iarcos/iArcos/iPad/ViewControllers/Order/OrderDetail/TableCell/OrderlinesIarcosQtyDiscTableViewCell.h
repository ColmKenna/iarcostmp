//
//  OrderlinesIarcosQtyDiscTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosQtyDiscTableViewCell : OrderlinesIarcosBaseTableViewCell {
    UIView* _qtyDiscView;
    UIImageView* _qtyDiscImageView;
    UILabel* _qtyInQtyDiscView;
    UILabel* _discInQtyDiscView;
}

@property(nonatomic, retain) IBOutlet UIView* qtyDiscView;
@property(nonatomic, retain) IBOutlet UIImageView* qtyDiscImageView;
@property(nonatomic, retain) IBOutlet UILabel* qtyInQtyDiscView;
@property(nonatomic, retain) IBOutlet UILabel* discInQtyDiscView;

@end
