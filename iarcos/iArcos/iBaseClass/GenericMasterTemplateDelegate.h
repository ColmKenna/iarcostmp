//
//  GenericMasterTemplateDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 22/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericMasterTemplateDelegate <NSObject>
@optional
- (void)processMoveMasterViewController:(CGPoint)velocity;
- (void)rightMoveMasterViewController;
- (void)leftMoveMasterViewController;

@end
