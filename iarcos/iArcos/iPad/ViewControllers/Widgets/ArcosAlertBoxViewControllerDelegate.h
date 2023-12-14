//
//  ArcosAlertBoxViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 13/12/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ArcosAlertBoxViewController;

@protocol ArcosAlertBoxViewControllerDelegate <NSObject>

- (void)amendButtonPressed;
- (void)saveButtonPressed:(ArcosAlertBoxViewController*)anAlertBox;

@end

