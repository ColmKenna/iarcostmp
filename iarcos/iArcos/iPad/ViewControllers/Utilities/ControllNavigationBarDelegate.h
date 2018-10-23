//
//  ControllNavigationBarDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ControllNavigationBarDelegate <NSObject>

@optional
- (void)showNavigationBar;
- (void)hideNavigationBar;
@end
