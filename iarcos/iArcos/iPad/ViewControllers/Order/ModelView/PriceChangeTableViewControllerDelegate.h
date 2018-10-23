//
//  PriceChangeTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 15/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PriceChangeTableViewControllerDelegate <NSObject>

- (void)didDismissPriceChangeView;
- (void)saveButtonWithNewPrice:(NSDecimalNumber*)aNewPrice;
//- (void)actionAfterKeyboardHidden;

@end
