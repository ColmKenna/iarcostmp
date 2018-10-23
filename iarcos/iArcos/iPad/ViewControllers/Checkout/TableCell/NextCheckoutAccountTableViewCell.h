//
//  NextCheckoutAccountTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutBaseTableViewCell.h"
#import "CheckoutDataManager.h"

@interface NextCheckoutAccountTableViewCell : NextCheckoutBaseTableViewCell <WidgetFactoryDelegate> {
    CheckoutDataManager* _checkoutDataManager;
}

@property(nonatomic, retain) CheckoutDataManager* checkoutDataManager;

@end
