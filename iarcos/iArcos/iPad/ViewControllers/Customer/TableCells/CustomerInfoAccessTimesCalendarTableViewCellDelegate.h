//
//  CustomerInfoAccessTimesCalendarTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 22/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerInfoAccessTimesCalendarTableViewCellDelegate <NSObject>

- (void)inputFinishedWithIndexPath:(NSIndexPath*)anIndexPath labelIndex:(int)aLabelIndex colorType:(NSNumber*)aColorType;

@end
