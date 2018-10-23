//
//  MainPresenterTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 30/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainPresenterTableViewCellDelegate <NSObject>

- (void)mainPresenterPressedWithView:(UIView*)aView indexPath:(NSIndexPath*)anIndexPath;

@end
