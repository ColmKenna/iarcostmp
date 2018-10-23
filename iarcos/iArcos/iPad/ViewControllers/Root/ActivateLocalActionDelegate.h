//
//  ActivateLocalActionDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivateLocalActionDelegate <NSObject>
@optional
- (void)useLocalDataDelegate;
- (void)useEnterpriseEditionDelegate;
- (void)exitActionDelegate;

@end
