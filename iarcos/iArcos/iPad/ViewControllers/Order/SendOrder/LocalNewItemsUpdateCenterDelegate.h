//
//  LocalNewItemsUpdateCenterDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 20/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalNewItemsUpdateCenterDelegate <NSObject>

- (void)didFinishLocalNewItemsSending;
- (void)startLocalNewItemsSending:(NSString*)anItemName;
- (void)errorOccurredLocalNewItemsSending:(NSString*)anErrorMsg;

@end
