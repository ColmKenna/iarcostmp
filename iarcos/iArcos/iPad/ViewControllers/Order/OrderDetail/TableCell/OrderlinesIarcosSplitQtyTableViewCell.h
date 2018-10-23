//
//  OrderlinesIarcosSplitQtyTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosSplitQtyTableViewCell : OrderlinesIarcosBaseTableViewCell {
    UIView* _splitQtyView;
    UILabel* _qtyInSplitQtyView;
}

@property(nonatomic, retain) IBOutlet UIView* splitQtyView;
@property(nonatomic, retain) IBOutlet UILabel* qtyInSplitQtyView;

@end
