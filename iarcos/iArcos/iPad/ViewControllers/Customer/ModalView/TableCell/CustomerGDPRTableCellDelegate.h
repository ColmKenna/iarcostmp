//
//  CustomerGDPRTableCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 11/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerGDPRTableCellDelegate <NSObject>

- (void)radioButtonPressedWithIndexPath:(NSIndexPath*)anIndexPath;

@end
