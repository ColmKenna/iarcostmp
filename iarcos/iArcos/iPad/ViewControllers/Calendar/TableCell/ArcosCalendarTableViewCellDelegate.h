//
//  ArcosCalendarTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 23/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArcosCalendarTableViewCellDelegate <NSObject>

- (void)inputFinishedWithIndexPath:(NSIndexPath*)anIndexPath labelIndex:(int)aLabelIndex;
- (void)longInputFinishedWithIndexPath:(NSIndexPath*)anIndexPath sourceView:(UIView*)aView;

@end

