//
//  CustomerIarcosSavedOrderDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 14/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CustomerIarcosSavedOrderTableCell;

@protocol CustomerIarcosSavedOrderDelegate <NSObject>

- (void)sendPressedForCell:(CustomerIarcosSavedOrderTableCell*)cell;

@end
