//
//  OrderHeaderTotalSetTargetDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 15/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderHeaderTotalSetTargetDelegate <NSObject>

- (void)dismissPopoverController;
- (void)refreshParentContent;

@end
