//
//  GenericSelectionCancelDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericSelectionCancelDelegate <NSObject>

- (void)didDismissSelectionCancelPopover;

@end
