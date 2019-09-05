//
//  OrderPadFooterViewDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 02/09/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPadFooterViewCell.h"


@interface OrderPadFooterViewDataManager : NSObject {
}



- (OrderPadFooterViewCell*)generateTableFooterView;
- (void)configDataWithTableFooterView:(OrderPadFooterViewCell*)anOrderPadFooterViewCell;

@end

