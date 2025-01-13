//
//  CustomisePresentViewControllerDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 27/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomisePresentViewControllerDelegate <NSObject>
@optional
- (void)didDismissCustomisePresentView;
- (void)didDismissBuiltInPresentView;

@end
