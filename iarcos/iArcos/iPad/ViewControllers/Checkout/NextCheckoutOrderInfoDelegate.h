//
//  NextCheckoutOrderInfoDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 29/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NextCheckoutOrderInfoDelegate <NSObject>

- (UIView*)retrieveOrderInfoHeaderView:(NSInteger)aSection;
- (void)refreshTotalGoods;

@end
