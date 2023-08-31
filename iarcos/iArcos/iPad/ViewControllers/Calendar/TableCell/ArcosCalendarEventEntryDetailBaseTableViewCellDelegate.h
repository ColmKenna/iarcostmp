//
//  ArcosCalendarEventEntryDetailBaseTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 25/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarEventEntryDetailBaseTableViewCellDelegate <NSObject>

- (void)detailBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)refreshListWithSwitchReturnValue:(NSString*)aReturnValue;
- (void)detailDeleteButtonPressed;
- (UIViewController*)retrieveCalendarEventEntryDetailParentViewController;

@end

