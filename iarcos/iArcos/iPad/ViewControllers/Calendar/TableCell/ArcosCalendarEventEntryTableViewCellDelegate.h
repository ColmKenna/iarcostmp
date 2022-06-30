//
//  ArcosCalendarEventEntryTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 17/06/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarEventEntryTableViewCellDelegate <NSObject>

- (void)eventEntryInputFinishedWithIndexPath:(NSIndexPath*)anIndexPath sourceView:(UIView*)aView;

@end

