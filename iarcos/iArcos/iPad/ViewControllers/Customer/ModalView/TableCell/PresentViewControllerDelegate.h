//
//  PresentViewControllerDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 13/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PresentViewControllerDelegate <NSObject>
@optional
- (void)didDismissPresentView;

@end
