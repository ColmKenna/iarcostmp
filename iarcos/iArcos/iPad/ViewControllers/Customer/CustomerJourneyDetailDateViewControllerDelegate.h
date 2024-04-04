//
//  CustomerJourneyDetailDateViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CustomerJourneyDetailDateViewControllerDelegate <NSObject>

- (void)cancelButtonPressedFromJourneyDetailDate;
- (void)saveButtonPressedFromJourneyDetailDate;

@end

